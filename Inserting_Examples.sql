INSERT INTO Customer (CUST_FIRST_NAME, CUST_LAST_NAME, CUST_PHONE, TRAN_DATE) 
SELECT 'SONI','MANANDHAR','9841256320',GETDATE()

SELECT 'SUDIP', 'SHRESTHA','9874563210',GETDATE()  INTO Customer 


IF (SELECT Tran_Type FROM Account_Trans WHERE Account_Id = 100 AND Tran_Id=1001) = 'w'
BEGIN
	UPDATE Account_Trans
	SET Total_Balance = (SELECT Total_Balance FROM Account_Trans WHERE Account_Id = 100 AND Tran_ID = 1000) - Tran_Amount,
	 Remarks = 'Withdraw'
	 Where Tran_Id=1001
END

INSERT INTO Account(Acc_Fname,Acc_Lname)
VALUES('SIRASH','SHRESTHA')

SELECT * FROM Account
SELECT * FROM Account_Trans

SELECT * FROM Customer
SELECT * FROM Customer_Address

