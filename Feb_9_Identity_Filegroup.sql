-- Set Identity column off and on
use SubQuery_Examples
go
-- insert data explicitly in identity column
set identity_insert [identity_demo] on
INSERT INTO IDENTITY_DEMO(id, name)
VALUES (100, 'NEWAR')

SELECT * FROM IDENTITY_DEMO

-- turn on automatic insertion in identity column
set identity_insert [identity_demo] off
INSERT INTO IDENTITY_DEMO VALUES('Uruna')
GO


-- SHOW File group, data file name, location and size
USE [master] 
go 
-- use database where you want to view 
SELECT fg.NAME       AS [File Group Name], 
        sdf.NAME      AS [Data File Name], 
        physical_name AS [Data file location], 
        size / 128    AS [File Size in MB] 
FROM   sys.database_files sdf 
        INNER JOIN sys.filegroups fg 
                ON sdf.data_space_id = fg.data_space_id 


-- create filegroup and file in resp database
USE master
GO
Alter database SubQuery_Examples
Add Filegroup Test
GO
Alter database SubQuery_Examples
ADD FILE (
	NAME = test1dat3,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\testdat3.ndf' ,
	SIZE = 5MB,
	MAXSIZE = 100MB,
	FILEGROWTH = 5MB
)
TO FILEGROUP Test
GO

-- creating table in created filegroup(Test)
USE SubQuery_Examples
GO
CREATE TABLE Number (
	id int identity(1,1), 
	name varchar(50), 
	constraint pk_number_id primary key (id)
) ON Test 
GO


