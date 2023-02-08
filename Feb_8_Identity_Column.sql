CREATE TABLE IDENTITY_DEMO
(
	id int identity(1,1),
	name varchar(50),
	CONSTRAINT PK_IDENTITY_DEMO_ID PRIMARY KEY (id)
);
GO

SELECT * FROM IDENTITY_DEMO

INSERT INTO IDENTITY_DEMO(name)
VALUES	('Sirash'),
		('Soni'),
		('Sudip'),
		('Shyam'),
		('Ram'),
		('Hari'),
		('Aayush'),
		('Anil'),
		('Rahul')

INSERT INTO IDENTITY_DEMO( name)
Values('Krishna')
GO

-- Removing Identity Column From Table 
-- Make new table with no identity column and copy its values from old table

BEGIN TRANSACTION 
SET QUOTED_IDENTIFIER ON 
SET ARITHABORT ON 
SET NUMERIC_ROUNDABORT OFF 
SET CONCAT_NULL_YIELDS_NULL ON 
SET ANSI_NULLS ON 
SET ANSI_PADDING ON 
SET ANSI_WARNINGS ON 
COMMIT 
BEGIN TRANSACTION 
GO 
CREATE TABLE dbo.Tmp_Test1 
   (
   id int,
   name NCHAR(10) NULL 
   )  ON [PRIMARY] 
GO 


IF EXISTS(SELECT * FROM IDENTITY_DEMO) 
    EXEC('INSERT INTO dbo.Tmp_Test1  (id, name) 
      SELECT id, name FROM IDENTITY_DEMO WITH (HOLDLOCK TABLOCKX)') 
GO

DROP TABLE IDENTITY_DEMO
GO

EXECUTE sp_rename N'dbo.Tmp_Test1', N'IDENTITY_DEMO', 'OBJECT'  
Go
