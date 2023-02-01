--Creating Database
Create Database Training
GO 

Use Training;
GO

-- Creating Customer Table
CREATE TABLE Customer (
	CID INT IDENTITY(1,1),
	CUST_FIRST_NAME VARCHAR(50),
	CUST_LAST_NAME VARCHAR(50),
	CUST_FULL_NAME AS CONCAT(CUST_FIRST_NAME, ' ', CUST_LAST_NAME),
	CUST_PHONE VARCHAR(10),
	TRAN_DATE VARCHAR(50) NULL,
	TRAN_USER_ID VARCHAR(50) NULL,
	STATUS VARCHAR(10) NULL,
	CONSTRAINT PK_cid PRIMARY KEY (CID)
);
GO

--Creating Customer_Address Table
CREATE TABLE Customer_Address (
	Customer_ID INT,
	Permanent_Address VARCHAR(50),
	Temporary_Address VARCHAR(50),
	TRAN_DATE VARCHAR(50),
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
	Customer_Id INT,
	CONSTRAINT PK_AccId PRIMARY KEY (Acc_ID),
	CONSTRAINT FK_Acc_Cid FOREIGN KEY (Customer_Id) REFERENCES Customer(CID)
);
GO

--Creating Account_Trans Table
CREATE TABLE Account_Trans (
	Tran_Id INT IDENTITY (1000,1),
	Tran_Amount MONEY,
	Tran_Type char(1),
	Total_Balance MONEY,
	Account_Id INT,
	Remarks VARCHAR(50),
	CONSTRAINT PK_Tran_ID PRIMARY KEY (Tran_Id),
	CONSTRAINT FK_Acc_ID FOREIGN KEY (Account_Id) REFERENCES Account(Acc_ID)
);
GO



