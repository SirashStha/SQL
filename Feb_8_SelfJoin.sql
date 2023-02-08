USE Training2

SELECT *
FROM Customer_Address Ca1 
	 JOIN Customer_Address Ca2
	ON Ca1.Customer_ID = Ca2.Customer_ID
WHERE Ca1.Address1 = Ca2.Address1

SELECT Acc_Full_Name, COUNT(Acc_Full_Name) FROM Account
Group BY Acc_Full_Name

SELECT DISTINCT a.Acc_Full_Name, COUNT(a.Acc_ID)  FROM Account a
JOIN Account b
ON a.Acc_Full_Name = b.Acc_Full_Name
WHERE a.Acc_ID <> b.Acc_ID
GROUP BY a.Acc_Full_Name, a.Acc_ID