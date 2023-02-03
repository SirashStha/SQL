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

-- Customer with multiple address entry in Customer_Address table
SELECT C.Full_Name, C.Phone, Ca.Address1, Ca.City, Ca.State
FROM Customer C  JOIN Customer_Address Ca
	On C.CID = Ca.Customer_ID
WHERE C.CID IN ( 
	SELECT Customer_ID 
	FROM Customer_Address
	GROUP BY Customer_ID
	HAVING COUNT(Customer_ID) >1)
Order By Full_Name


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
SELECT C.Full_Name, C.Phone, A.Acc_Full_Name, A.Balance
FROM Customer C JOIN Account A
	ON C.CID = A.Customer_Id
WHERE A.Balance = 0


-- Account with Balance
SELECT Acc_Full_Name, Balance 
FROM Account
WHERE Balance > 0