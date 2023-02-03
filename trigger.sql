Use [Training2]
GO

CREATE TRIGGER TR_Balance
ON Account_Trans
AFTER UPDATE
AS
UPDATE Account 
 SET Balance = inserted.Total_Balance
 FROM Account JOIN INSERTED
	ON Acc_ID = inserted.Account_Id
 WHERE Acc_ID = inserted.Account_Id
GO

ALTER TRIGGER TR_Total_Balance
ON Account_Trans
AFTER INSERT
AS
BEGIN
UPDATE Account_Trans
	SET Total_Balance =( CASE WHEN (acct.Tran_Type = 'd') THEN (A.Balance + acct.Tran_Amount) 
								WHEN (acct.Tran_Type = 'w' AND A.Balance > 0 ) THEN (A.Balance - acct.Tran_Amount) 
								ELSE 'Error' END),
		Remarks = (CASE WHEN (acct.Tran_Type = 'd') THEN ('Deposit')
						WHEN (acct.Tran_Type = 'w') THEN ('Withdraw') END)
	FROM Account_Trans acct JOIN Account A
		ON acct.Account_Id = A.Acc_ID
	JOIN inserted i
		ON acct.Account_Id = i.Account_Id
	WHERE Acc_ID = i.Account_Id AND acct.Tran_Id =  (SELECT TOP 1 i.Tran_Id ORDER BY i.Account_Id DESC)
END


INSERT INTO Account_Trans (Tran_Amount, Tran_Type, Account_Id)
VALUES(500,'w',100)

SELECT * FROM Account
SELECT * FROM Account_Trans ORDER BY Account_Id, Tran_Id
GO 


IF EXISTS(SELECT A.Acc_Full_Name, acct.Total_Balance, acct.Remarks Last_Transaction
		FROM Account_Trans acct JOIN Account A
			ON acct.Account_Id = A.Acc_ID
	WHERE acct.Tran_Type = 'w' AND acct.Total_Balance = 0) 
 PRINT 'ERROR'