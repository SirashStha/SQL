--INSERTING INTO ACCOUNT TABLE

INSERT INTO Account (Acc_Fname,Acc_Lname,Customer_Id)
VALUES('Aayush','Ranjit',1)
GO

INSERT INTO Account
VALUES ('Shirash', 'Shrestha', 2),
		('Soni', 'Manandhar', 3);
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