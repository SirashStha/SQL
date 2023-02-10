Use Training2
GO

SELECT * FROM Account
SELECT * FROM Account_Trans 
GO


-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'usp_GetErrorInfo', 'P' ) IS NOT NULL   
    DROP PROCEDURE usp_GetErrorInfo;  
GO  
  
-- Create procedure to retrieve error information.  
CREATE PROCEDURE usp_GetErrorInfo  
AS  
SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;  
GO  
  
BEGIN TRY  
    -- Generate divide-by-zero error.  
    -- SELECT 1/0;
	DECLARE @a int
	SET @a = 2
	IF @a = 2
		--RAISEERROR('Error',1,1)
		RAISERROR('Error',-1,-1)
END TRY  
BEGIN CATCH  
    -- Execute error retrieval routine.  
    EXECUTE usp_GetErrorInfo;  
END CATCH;  


BEGIN
  DECLARE @Result INT, @No1 INT, @No2 INT
  SET @Result = 0
  SET @No2 = 1
  BEGIN TRY
    IF @No2 = 1
    THROW 50001,'DIVISOR CANNOT BE ONE', 1
    SET @Result = @No1 / @No2
    PRINT 'THE RESULT IS: '+CAST(@Result AS VARCHAR)
  END TRY
  BEGIN CATCH
    PRINT ERROR_NUMBER()
    PRINT ERROR_MESSAGE()
    PRINT ERROR_SEVERITY()
    PRINT ERROR_STATE()
	PRINT RAISEERROR()
  END CATCH
END


 PRINT RAISEERROR()