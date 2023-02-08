CREATE DATABASE SubQuery_Examples
GO

USE SubQuery_Examples
GO

CREATE TABLE artists (
	id int,
	first_name varchar(50),
	last_name varchar(50),
	CONSTRAINT PK_artist_id PRIMARY KEY (id)
)
GO

CREATE TABLE collectors (
	id int,
	first_name varchar(50),
	last_name varchar(50),
	CONSTRAINT PK_collectors_id PRIMARY KEY(id)
)
GO

CREATE TABLE paintings (
	id int,
	name varchar(50),
	artist_id int,
	listed_price DECIMAL(18,2),
	CONSTRAINT PK_paintings_id PRIMARY KEY (id),
	CONSTRAINT FK_paintings_artist_id FOREIGN KEY (artist_id) 
	REFERENCES artists(id)
)
GO

CREATE TABLE Sales (
	id int,
	date date,
	painting_id int,
	artist_id int,
	collector_id int,
	sales_price DECIMAL(18,2),
	CONSTRAINT PK_sales_id PRIMARY KEY (id),
	CONSTRAINT FK_sales_paintig_id FOREIGN KEY (painting_id) REFERENCES paintings(id),
	CONSTRAINT FK_sales_artist_id FOREIGN KEY (artist_id) REFERENCES artists(id)
)
GO
ALTER TABLE Sales
ADD CONSTRAINT FK_sales_collector_id FOREIGN KEY(collector_id) REFERENCES collectors(id)

INSERT INTO artists
VALUES(1, 'Thomas', 'Black'),
		(2, 'Kate', 'Smith'),
		(3, 'Natali', 'Wein'),
		(4, 'Francesco', 'Benelli')
GO

INSERT INTO collectors
VALUES (101, 'Brandon', 'Cooper'),
		(102, 'Laura', 'Fisher'),
		(103, 'Christina', 'Buffet'),
		(104, 'Steve', 'Stevenson')
GO

INSERT INTO paintings
VALUES (11, 'Miracle', 1, 300),
		(12, 'Sushine', 1, 700),
		(13, 'Pretty Woman', 2, 2800),
		(14, 'Handsome Man', 2, 2300),
		(15, 'Barbie', 3, 250),
		(16, 'Cool Painting', 3, 5000),
		(17, 'Black Square #1000', 3, 50),
		(18, 'Mountains', 4, 1300)
GO

INSERT INTO Sales
VALUES (1001, '2021-11-01', 13, 2, 104, 2500),
		(1002, '2021-11-01', 14, 2, 102, 2300),
		(1003, '2021-11-01', 11, 1, 102, 300),
		(1004, '2021-11-01', 16, 3, 103, 4000),
		(1005, '2021-11-01', 15, 3, 103, 200),
		(1006, '2021-11-01', 17, 3, 103, 50)
GO

-- Scalar Subquery
-- paintings higher than the average
SELECT name, listed_price
FROM paintings 
WHERE listed_price > (
	SELECT AVG(listed_price) FROM paintings
);
GO

-- Multirow Subquery
-- all collectors that purchased paintings
SELECT first_name, last_name 
FROM collectors
WHERE id IN (SELECT collector_id FROM Sales)
GO

-- Multirow Subquery with Multiple Columns
-- total amt of sales for each artist , sold at least one painting
SELECT a.first_name, a.last_name, artist_sales.sales
FROM artists a INNER JOIN (
    SELECT artist_id, SUM(sales_price) AS sales
    FROM sales
    GROUP BY artist_id
  ) artist_sales
 ON a.id = artist_sales.artist_id;
 GO

-- Correlated Subquery
-- total number of paintings purchased
SELECT collector_id, COUNT(painting_id) Painting_Purchased
FROM Sales
GROUP BY collector_id

SELECT first_name, last_name,
	(	SELECT COUNT(*)
		FROM Sales s
		WHERE s.collector_id = c.id
	) Paintings_Purchased
FROM collectors c
GO

-- Correlated Subquery
-- show artists who had zero sales
SELECT a.id, a.first_name, a.last_name 
FROM artists a
WHERE NOT EXISTS (
		SELECT 1 FROM Sales s
		WHERE a.id = s.artist_id
	)
GO