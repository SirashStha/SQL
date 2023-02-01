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

