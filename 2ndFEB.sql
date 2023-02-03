-- Inserting values into Customer
INSERT INTO Customer(First_Name, Last_Name, Phone)
VALUES ('Sirash', 'Shrestha', '9860282085'),
		('Soni', 'Manandhar', '9841256307'),
		('Sudip', 'Shrestha', '9813452670'),
		('Aayush', 'Ranjit', '9843125607'),
		('Anil', 'Kumal', '9801236547'),
		('Ram','Bahadur','9861223358');

SELECT * FROM Customer
SELECT * FROM Customer_Address

--Inserting values in Customer_Address
INSERT INTO Customer_Address(Customer_ID, Address1, City, State)
VALUES (2,'Chamati','Kathmandu','Bagmati'),
		(3,'Manamaiju','Kathmandu','Bagmati'),
		(4,'Kalanki','Kathmandu','Bagmati'),
		(6,'New Road','Pokhara','Gandaki'),
		(6,'New Road','Kathmandu','Bagmati');

INSERT INTO Customer_Address(Customer_ID, Address1, City, State)
VALUES (3,'Balaju','Kathmandu','Bagmati')

--Inserting values in Account table
INSERT INTO Account (Acc_Fname, Acc_Lname, Customer_Id)
VALUES ('Sirash', 'Shrestha', 1),
		('Soni', 'Manandhar', 2),
		('Sudip', 'Shrestha', 3);

--Inserting values into Account_Trans table
INSERT INTO Account_Trans (Tran_Amount, Tran_Type, Account_Id)
VALUES(500,'w',101)

SELECT * FROM Account
SELECT * FROM Account_Trans ORDER BY Account_Id, Tran_Id

IF (SELECT Tran_Type FROM Account_Trans WHERE Account_id = 100) = 'd'
UPDATE 
	Account_Trans
	SET Total_Balance = Tran_Amount + Total_Balance,
	Remarks = 'Deposit'
	WHERE Account_id = 100 and Tran_Id = (SELECT TOP 1 Tran_Id FROM Account_Trans Order by Tran_Id desc)

UPDATE Account
	SET Balance = 
		(	SELECT TOP 1 Total_Balance
			FROM Account_Trans 
			Where Account_Id = 101
			ORDER BY Tran_Id DESC
		)
	WHERE Acc_ID = 101
	

IF (SELECT TOP 1 Tran_Type FROM Account_Trans WHERE Account_id = 100 ORDER BY Tran_Type DESC) = 'w'
UPDATE 
	Account_Trans
	SET Total_Balance = (SELECT Balance FROM Account WHERE Acc_ID = 100) - Tran_Amount,
	Remarks = 'Withdraw'
	WHERE Account_id = 100 and Tran_Id = (SELECT TOP 1 Tran_Id FROM Account_Trans Order by Tran_Id desc)

