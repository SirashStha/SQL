CREATE or ALTER PROC USP_Total_Balance
(@Tran_Amount DECIMAL(18,2), @Tran_Type varchar(1), @Acc_Id int)
AS
BEGIN
	BEGIN TRY
	BEGIN TRAN
		INSERT INTO Account_Trans(Tran_Amount,Tran_Type, Account_Id)
			VALUES(@Tran_Amount, @Tran_Type, @Acc_Id)
	
		DECLARE @id int 
		SET @id = (SELECT TOP 1 Tran_Id FROM Account_Trans WHERE Account_Id = @Acc_Id ORDER BY Tran_Id DESC)

		UPDATE Account_Trans
		SET Total_Balance =(CASE WHEN (@Tran_Type = 'd') 
								THEN (A.Balance + @Tran_Amount) 
							 WHEN (@Tran_Type = 'w' AND A.Balance >= @Tran_Amount ) 
								THEN (A.Balance - @Tran_Amount) 
							 ELSE A.Balance 
						END),
			Remarks = (CASE WHEN (@Tran_Type = 'd') 
							THEN ('Deposit')
						WHEN (@Tran_Type = 'w' AND A.Balance >= @Tran_Amount) 
							THEN ('Withdraw')
						WHEN(A.Balance < @Tran_Amount)
							THEN ('Not Enough Balance')
						ELSE 'Error'
					END)
		FROM Account_Trans acct LEFT JOIN Account A
			ON acct.Account_Id = A.Acc_ID
		WHERE Tran_Id = @id 

		IF(SELECT Remarks FROM Account_Trans WHERE Tran_Id = @id) = 'Not Enough Balance'
			RAISERROR('NOT ENOUGH BALANCE',16,1)
		ELSE
			COMMIT
	END TRY
	
	BEGIN CATCH
		EXECUTE usp_GetErrorInfo;
		ROLLBACK
	END CATCH

END

EXEC USP_Total_Balance 30000, 'w', 101


SELECT * FROM Account_Trans  ORDER BY Account_Id, Tran_Id
SELECT * FROM Account 

TRUNCATE TABLE Account_Trans