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

-- Inserting values into Customer Table
INSERT INTO Customer VALUES 
	('Aayush','Ranjit','9801236547', CONVERT(VARCHAR(10),GETDATE(),111), '','');
GO

INSERT INTO Customer(CUST_FIRST_NAME, CUST_LAST_NAME, CUST_PHONE)
VALUES('Shirash','Shrestha','9860282085'),
		('Soni','Manandhar','9865321475');
GO

INSERT INTO Customer (CUST_FIRST_NAME, CUST_LAST_NAME, CUST_PHONE, TRAN_DATE) VALUES
	('Pukar','Khanal','9841256370', CAST(GETDATE() as DATE));
GO

INSERT INTO Customer VALUES 
	('Anil','Kumal','9801472536', CONVERT(VARCHAR(10),GETDATE(),111), '','');
GO

-- Updating Values in Customer Table
UPDATE Customer 
	SET TRAN_DATE = CONVERT(VARCHAR(10),GETDATE(),111)
	WHERE CID = 2
GO

UPDATE Customer
	SET STATUS = '0'
	WHERE STATUS IS NULL

UPDATE Customer
	SET STATUS = '0'
	WHERE STATUS = ''
GO

--Deleting Values from Customer Table
Delete Customer 
	Where CID = 4
GO

--Inserting values into Customer_Address Table
INSERT INTO Customer_Address(Customer_ID, Permanent_Address, Temporary_Address, TRAN_DATE, TRAN_USER_ID, STATUS)
VALUES('1', 'Kalanki', 'Kalanki','','','')
GO

INSERT INTO Customer_Address(Customer_ID, Permanent_Address, Temporary_Address, TRAN_DATE, TRAN_USER_ID, STATUS)
VALUES('2', 'Chhauni', 'Chhauni','','',''),
		('3','Chamati','Chamati','','','');
GO

--Updating values of Customer_Address Table
UPDATE Customer_Address
	SET TRAN_DATE = CONVERT(VARCHAR(10),GETDATE(),111)
	WHERE Customer_ID = 1
GO

UPDATE Customer_Address
	SET STATUS = '0'
	WHERE STATUS IS NULL
GO

UPDATE Customer_Address
	SET STATUS = '0'
	WHERE STATUS = ''
GO

--Deleting from Customer_Address Table
DELETE Customer_Address
	WHERE Customer_ID = 1
GO


--INSERTING INTO ACCOUNT TABLE
INSERT INTO Account (Acc_Fname,Acc_Lname,Customer_Id)
VALUES('Aayush','Ranjit',1)
GO

INSERT INTO Account
VALUES ('Shirash', 'Shrestha', 2),
		('Soni', 'Manandhar', 3);
GO

INSERT INTO Account
VALUES ((SELECT CUST_FIRST_NAME FROM dbo.Customer WHERE CID = 5),
		(SELECT CUST_LAST_NAME FROM dbo.Customer WHERE CID = 5),
		5)
GO

--Updating values in Account Table
UPDATE  Account	
	SET Acc_Fname = 'Aabhash'
	WHERE Acc_ID = 100
GO

--Deleting values in Account Table
DELETE Account
	Where Acc_ID = 102
GO


--Inserting into Account_Trans
INSERT INTO Account_Trans(Tran_Amount, Tran_Type, Account_Id) 
VALUES(1000,'d',100)
--Updating
IF (SELECT Tran_Type FROM Account_Trans WHERE Tran_Id=1000) = 'd'
BEGIN
	UPDATE Account_Trans
	SET Total_Balance = Tran_Amount,
	 Remarks = 'Deposit'
	 WHERE Tran_Id=1000
END
GO

--WITHDRAW AMOUNT
INSERT INTO Account_Trans(Tran_Amount, Tran_Type, Account_Id) 
VALUES(500,'w',100)

IF (SELECT Tran_Type FROM Account_Trans WHERE Account_Id = 100 AND Tran_Id=1001) = 'w'
BEGIN
	UPDATE Account_Trans
	SET Total_Balance = (SELECT Total_Balance FROM Account_Trans WHERE Account_Id = 100 AND Tran_ID = 1000) - Tran_Amount,
	 Remarks = 'Withdraw'
	 Where Tran_Id=1001
END
GO

INSERT INTO Account_Trans(Tran_Amount, Tran_Type, Account_Id) 
VALUES(500,'w',100)

IF (SELECT Tran_Type FROM Account_Trans WHERE Account_Id = 100 AND Tran_Id=1002) = 'w'
BEGIN
	UPDATE Account_Trans
	SET Total_Balance = (SELECT Total_Balance FROM Account_Trans WHERE Account_Id = 100 AND Tran_ID = 1001) - Tran_Amount,
	 Remarks = 'Withdraw'
	 Where Tran_Id=1002
END
GO

INSERT INTO Account_Trans(Tran_Amount, Tran_Type, Account_Id) 
VALUES(500,'w',100)

IF(SELECT Tran_Type FROM Account_Trans WHERE Tran_Id = 1003) = 'w' 
	AND (SELECT Total_Balance FROM Account_Trans WHERE Tran_ID = 1002) = 0.00
	BEGIN
	UPDATE Account_Trans
	Set Remarks = 'Error',
	Total_Balance = 0.00
	WHERE Tran_Id = 1003
END
GO

SELECT * FROM Customer
SELECT * FROM Customer_Address
SELECT * FROM Account
SELECT * FROM Account_Trans

