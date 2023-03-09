CREATE TABLE dbo.Commercials
(
    StartedAt DATETIME NOT NULL
        CONSTRAINT PK_Commercials PRIMARY KEY,
    EndedAt DATETIME NOT NULL,
    CommercialName VARCHAR(30) NOT NULL
);

CREATE TABLE dbo.Calls
(
    CallID INT
        CONSTRAINT PK_Calls NOT NULL PRIMARY KEY,
    AirTime DATETIME NOT NULL,
    SomeInfo CHAR(300) NOT NULL
);

CREATE UNIQUE NONCLUSTERED INDEX Calls_AirTime
ON dbo.Calls (AirTime)
INCLUDE (SomeInfo);

CREATE TABLE dbo.Numbers
(
    n INT NOT NULL PRIMARY KEY
);


DECLARE @i INT;
SET @i = 1;
INSERT INTO dbo.Numbers
(
    n
)
SELECT 1;
WHILE @i < 1024000
BEGIN

    INSERT INTO dbo.Numbers
    (
        n
    )
    SELECT n + @i
    FROM dbo.Numbers;
    SET @i = @i * 2;
END;

INSERT INTO dbo.Commercials
(
    StartedAt,
    EndedAt,
    CommercialName
)
SELECT DATEADD(MINUTE, n - 1, '20080101'),
       DATEADD(MINUTE, n, '20080101'),
       'Show #' + CAST(n AS VARCHAR(6))
FROM dbo.Numbers
WHERE n <= 24 * 365 * 60;

INSERT INTO dbo.Calls
(
    CallID,
    AirTime,
    SomeInfo
)
SELECT n,
       DATEADD(MINUTE, n - 1, '20080101'),
       'Call during Commercial #' + CAST(n AS VARCHAR(6))
FROM dbo.Numbers
WHERE n <= 24 * 365 * 60;

SET STATISTICS TIME ON

-------------------------------------------------------------------------

SELECT s.StartedAt, s.EndedAt, c.AirTime
FROM dbo.Commercials s
    INNER JOIN dbo.Calls c
        ON c.AirTime >= s.StartedAt
           AND c.AirTime < s.EndedAt
WHERE c.AirTime
		BETWEEN '20080701' AND '20080701 03:00';

SELECT s.StartedAt, s.EndedAt, c.AirTime
FROM dbo.Calls c
    CROSS APPLY
(
    SELECT TOP 1 s.StartedAt, s.EndedAt
    FROM dbo.Commercials s
    WHERE c.AirTime >= s.StartedAt
          AND c.AirTime < s.EndedAt
    ORDER BY s.StartedAt DESC
) AS s
WHERE c.AirTime
BETWEEN '20080701' AND '20080701 03:00'

--------------------------------------------------------------------------

SELECT s.StartedAt, s.EndedAt, c.AirTime
FROM dbo.Commercials s
    JOIN dbo.Calls c
        ON c.AirTime >= s.StartedAt
           AND c.AirTime < s.EndedAt
WHERE c.AirTime
      BETWEEN '20080701' AND '20080701 03:00'
      AND s.StartedAt
      BETWEEN '20080630 23:45' AND '20080701 03:00';
