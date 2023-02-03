--Creating Database
Create Database Training2
GO 

Use Training2;
GO

-- Creating Customer Table
CREATE TABLE Customer (
	CID INT IDENTITY(1,1),
	First_Name VARCHAR(50),
	Last_Name VARCHAR(50),
	Full_Name AS CONCAT(First_Name, ' ', Last_Name),
	Phone VARCHAR(10),
	TRAN_DATE DATE,
	TRAN_USER_ID VARCHAR(50),
	STATUS VARCHAR(10) NULL,
	CONSTRAINT PK_cid PRIMARY KEY (CID)
);
GO

--Creating Customer_Address Table
CREATE TABLE Customer_Address (
	Customer_ID INT,
	Address1 VARCHAR(50),
	Address2 VARCHAR(50),
	City VARCHAR(50),
	State VARCHAR(50),
	TRAN_DATE DATE,
	TRAN_USER_ID VARCHAR(50),
	STATUS VARCHAR(10),
	CONSTRAINT FK_cid FOREIGN KEY (Customer_ID) REFERENCES Customer(CID) 
);
GO

--Creating Account Table
CREATE TABLE Account (
	Acc_ID INT IDENTITY(100,1),
	Acc_Fname VARCHAR(50),
	Acc_Lname VARCHAR(50),
	Acc_Full_Name AS CONCAT(Acc_Fname, ' ', Acc_Lname),
	Balance DECIMAL(18,2) DEFAULT 0.00,
	Customer_Id INT,
	CONSTRAINT PK_AccId PRIMARY KEY (Acc_ID),
	CONSTRAINT FK_Acc_Cid FOREIGN KEY (Customer_Id) REFERENCES Customer(CID)
);
GO

--Creating Account_Trans Table
CREATE TABLE Account_Trans (
	Tran_Id INT IDENTITY (1000,1),
	Tran_Amount DECIMAL(18,2),
	Tran_Type VARCHAR(1),
	Total_Balance DECIMAL(18,2) DEFAULT 0,
	Account_Id INT,
	Remarks VARCHAR(50),
	CONSTRAINT PK_Tran_ID PRIMARY KEY (Tran_Id),
	CONSTRAINT FK_Acc_ID FOREIGN KEY (Account_Id) REFERENCES Account(Acc_ID)
);
GO



