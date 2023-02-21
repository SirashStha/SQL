SELECT * FROM USERS ORDER BY email

INSERT INTO USERS (email)
VALUES(
	CONCAT('user',(CEILING(RAND() * (1000-1+1))+1 ),'@gmail.com')
)

DECLARE @counter int = 0
WHILE(@counter <100)
BEGIN
	DECLARE @email varchar(50) = CONCAT('user',(CEILING(RAND() * (1000-1+1))+1 ),'@gmail.com')
	DECLARE @email_count int = 0
	IF (@email = (SELECT email FROM USERS WHERE email = @email))
		SET @email_count = 1
	ELSE
	BEGIN
		INSERT INTO USERS(email) VALUES (@email)
		SET @counter = @counter+1
	END
END

TRUNCATE TABLE USERS

SET STATISTICS TIME ON
SET STATISTICS IO ON

SET CONCAT_NULL_YIELDS_NULL OFF
DECLARE @alphabet varchar(26) = 'abcdefghijklmnopqrstuvwxyz'
DECLARE @len int = 0
DECLARE @var varchar(10)
WHILE(@len < 5)
BEGIN
	SET @var = @var + SUBSTRING(@alphabet,CAST(CEILING(RAND() * 26) as int), 1)
	SET @len = @len+1
END
SELECT @var NAMES


SELECT TRANSLATE('3*[2+1]/{8-4}', '[]{}', '()()'); 

SELECT STUFF('SQL Tutorial!', 4, 0, ' Query!');
SELECT CONCAT('SQL Tutorial!', ' is fun!')

SELECT SESSIONPROPERTY('CONCAT_NULL_YIELDS_NULL');

SELECT SYSTEM_USER;
SELECT USER_NAME();

CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255) NOT NULL,
    Age int,
	CONSTRAINT CK_Persons_Age CHECK (Age>=18)
);

INSERT INTO Persons(ID, LastName, FirstName, Age) 
VALUES(1, 'Shrestha', 'Sirash', 17)

SELECT * FROM Persons

DROP TABLE Persons