SELECT * FROM USERS ORDER BY email

INSERT INTO USERS (email)
VALUES(
	CONCAT('user',(CEILING(RAND() * (1000-1+1))+1 ),'@gmail.com')
)

DECLARE @counter int = 0
WHILE(@counter <100)
BEGIN
	DECLARE @email varchar(50) = CONCAT('user',(CEILING(RAND() * (1000-1+1))+1 ),'@gmail.com')
	DECLARE @email_count int = 0
	IF (@email = (SELECT email FROM USERS WHERE email = @email))
		SET @email_count = 1
	ELSE
	BEGIN
		INSERT INTO USERS(email) VALUES (@email)
		SET @counter = @counter+1
	END
END

TRUNCATE TABLE USERS

SET CONCAT_NULL_YIELDS_NULL OFF
DECLARE @alphabet varchar(26) = 'abcdefghijklmnopqrstuvwxyz'
DECLARE @len int = 0
DECLARE @var varchar(10)
WHILE(@len < 5)
BEGIN
	SET @var = @var + SUBSTRING(@alphabet,CAST(CEILING(RAND() * 26) as int), 1)
	SET @len = @len+1
END
SELECT @var