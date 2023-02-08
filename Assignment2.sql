-- Customer that donot have address in Customer_Address table
SELECT C.Full_Name Customer_Name, Ca.Address1, Ca.City
FROM Customer C LEFT JOIN Customer_Address Ca
	ON C.CID = Ca.Customer_ID
WHERE C.CID NOT IN (Select Customer_ID FROM Customer_Address)
ORDER BY C.Full_Name

SELECT C.Full_Name Customer_Name, Ca.Address1, Ca.City
FROM Customer C LEFT JOIN Customer_Address Ca
	ON C.CID = Ca.Customer_ID
WHERE Ca.Customer_ID IS NULL
ORDER BY C.Full_Name

SELECT C.Full_Name Customer_Name
FROM Customer C
WHERE NOT EXISTS (SELECT Customer_Id FROM Customer_Address  WHERE CID = Customer_Id)

-- Customer with multiple address entry in Customer_Address table
SELECT C.Full_Name, C.Phone
FROM Customer C LEFT JOIN Customer_Address Ca
	On C.CID = Ca.Customer_ID
WHERE C.CID IN ( 
	SELECT Customer_ID
	FROM Customer_Address
	GROUP BY Customer_ID
	HAVING COUNT(Customer_ID) >1)
Order By Full_Name

SELECT * FROM Customer_Address
----------------------------------------- Efficient
SELECT C.Full_Name, C.Phone, counts.cnt
FROM Customer C INNER JOIN (
		SELECT Ca.Customer_ID, COUNT(Ca.Customer_ID) cnt FROM Customer_Address Ca
		GROUP BY Customer_ID
	HAVING COUNT(Customer_ID) >1
	)counts
	ON counts.Customer_ID = C.CID
GO
--------------------------------------------
WITH Customer_Multi(Customer_Id, Counts)
AS
(
	SELECT Ca.Customer_ID, COUNT(Ca.Customer_ID) cnt 
	FROM Customer_Address Ca
	GROUP BY Customer_ID
	HAVING COUNT(Customer_ID) >1
)
SELECT C.Full_Name, C.Phone, Cm.Counts 
FROM Customer C INNER JOIN Customer_Multi Cm
	ON C.CID = Cm.Customer_Id
GO

-- Customer with account on Account table
SELECT C.Full_name Customer_Name, A.Acc_Full_Name Acc_Name, A.Balance
FROM Customer C LEFT JOIN Account A
	ON C.CID = A.Customer_Id
WHERE A.Customer_Id IS NOT NULL

SELECT C.Full_name Customer_Name, A.Acc_Full_Name Acc_Name, A.Balance
FROM Customer C LEFT JOIN Account A
	ON C.CID = A.Customer_Id
WHERE C.CID IN (Select Customer_Id FROM Account)


-- Customer with account and Balance
SELECT C.Full_Name, A.Balance Remainig_Balance,
		AccT.Tran_Amount Transaction_Amount, AccT.Remarks
FROM Customer C JOIN Account A
	ON C.CID = A.Customer_Id AND A.Balance > 0
	 JOIN Account_Trans AccT
	ON A.Acc_ID = AccT.Account_ID AND AccT.Remarks = 'Deposit'

SELECT C.Full_Name, A.Balance Remainig_Balance,
		AccT.Tran_Amount Transaction_Amount, AccT.Remarks
FROM Customer C JOIN Account A
	ON C.CID = A.Customer_Id AND A.Balance > 0
	JOIN Account_Trans AccT
	ON A.Acc_ID = AccT.Account_ID AND AccT.Remarks = 'Withdraw'


-- Customer with account having 0 balance
SELECT DISTINCT C.Full_Name, A.Balance
FROM Customer C INNER JOIN Account A
	ON C.CID = A.Customer_Id
WHERE A.Balance = 0
----------------------------------------
SELECT  C.Full_Name, A.Balance
FROM Customer C INNER JOIN Account A
	ON C.CID = A.Customer_Id
WHERE A.Balance = 0
Group By C.Full_Name, A.Balance
-----------------------------------------
SELECT A.Acc_Full_Name, A.Balance, MAX(acc.Dense) 'RANK'
From (SELECT C.CID, C.Full_Name, ROW_NUMBER()OVER (ORDER BY C.Full_Name) Dense From Customer C) AS acc
		JOIN Account A
		ON acc.CID = A.Customer_Id
		WHERE A.Balance = 0
		GROUP BY A.Acc_Full_Name, A.Balance
-------------------------------------
SELECT A.Acc_Full_Name, A.Balance, MAX(acc.Dense)
From (SELECT C.CID, DENSE_RANK()OVER (PARTITION BY C.CID ORDER BY C.Full_Name) Dense From Customer C) AS acc
		JOIN Account A
		ON acc.CID = A.Customer_Id
		WHERE A.Balance = 0
		GROUP BY A.Acc_Full_Name, A.Balance
-----------------------------------------------------
--Creating Temporary Table
SELECT A.Customer_Id, 
		A.Acc_ID, A.Acc_Full_Name, A.Balance,
		ROW_NUMBER()OVER (PARTITION BY A.Customer_Id ORDER BY A.Acc_Id) Rank1 
	INTO #ACCOUNT	
	From Account A
SELECT * FROm #ACCOUNT WHERE Rank1 = 1
----------------------------------------------
---- Account with 
SELECT R.Customer_Id, 
		R.Acc_ID, R.Acc_Full_Name,R.Balance
		FROM 
		(SELECT A.Customer_Id, 
		A.Acc_ID, A.Acc_Full_Name,A.Balance,ROW_NUMBER()OVER (PARTITION BY A.Customer_Id ORDER BY A.Acc_Id) Rank1 FROM Account A) R
		Where R.Rank1 = 2
		

ORDER BY Dense
SELECT * FROM Customer C JOIN Account A On C.CID =  A.Customer_Id ORDER BY A.Balance
SELECT * FROM Account

INSERT INTO Account(Acc_Fname,Acc_Lname,Customer_Id)
VALUES ('Sirash','Shrestha', 1),
		('Sirash','Shrestha',1)
-- Account with Balance
SELECT Acc_Full_Name, Balance 
FROM Account
WHERE Balance > 0