SELECT * FROM Account_Trans;

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

IF (SELECT Tran_Type FROM Account_Trans WHERE Tran_Id=1001) = 'w'
BEGIN
	UPDATE Account_Trans
	SET Total_Balance = (SELECT Total_Balance FROM Account_Trans WHERE Tran_ID = 1000) - Tran_Amount,
	 Remarks = 'Withdraw'
	 Where Tran_Id=1001
END
GO
