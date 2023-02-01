--Inserting values into Customer_Address Table
SELECT * FROM Customer_Address

INSERT INTO Customer_Address(Customer_ID, Permanent_Address, Temporary_Address, TRAN_DATE, TRAN_USER_ID, STATUS)
VALUES('1', 'Kalanki', 'Kalanki','','','')

INSERT INTO Customer_Address(Customer_ID, Permanent_Address, Temporary_Address, TRAN_DATE, TRAN_USER_ID, STATUS)
VALUES('2', 'Chhauni', 'Chhauni','','',''),
		('3','Chamati','Chamati','','','');

--Updating values of Customer_Address Table
UPDATE Customer_Address
	SET TRAN_DATE = CONVERT(VARCHAR(10),GETDATE(),111)
	WHERE Customer_ID = 1

UPDATE Customer_Address
	SET STATUS = '0'
	WHERE STATUS IS NULL

UPDATE Customer_Address
	SET STATUS = '0'
	WHERE STATUS = ''

--Deleting from Customer_Address Table
DELETE Customer_Address
	WHERE Customer_ID = 1

DELETE Customer_Address
	WHERE STATUS = '0'