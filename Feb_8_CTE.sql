USE SubQuery_Examples 
GO

CREATE TABLE Employees
(
  EmployeeID int NOT NULL PRIMARY KEY,
  FirstName varchar(50) NOT NULL,
  LastName varchar(50) NOT NULL,
  ManagerID int NULL
)
GO

INSERT INTO Employees(EmployeeID, FirstName, LastName, ManagerID) 
VALUES	(1, 'Ken', 'Thompson', NULL),
		(2, 'Terri', 'Ryan', 1),
		(3, 'Robert', 'Durello', 1),
		(4, 'Rob', 'Bailey', 2),
		(5, 'Kent', 'Erickson', 2),
		(6, 'Bill', 'Goldberg', 3),
		(7, 'Ryan', 'Miller', 3),
		(10, 'Michael', 'Jhonson', 6) 
GO

WITH CTE_Name
AS
(
	SELECT  ManagerID FROM Employees Group BY ManagerID
)
SELECT * FROm CTE_Name

GO

-- RECURSIVE CTE
WITH
  cteReports (EmpID, FirstName, LastName, MgrID, EmpLevel)
  AS
  (
    SELECT EmployeeID, FirstName, LastName, ManagerID, 1
    FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.ManagerID, 
      r.EmpLevel + 1
    FROM Employees e
      INNER JOIN cteReports r
        ON e.ManagerID = r.EmpID
  )
SELECT
  FirstName + ' ' + LastName AS FullName, 
  EmpLevel,
  (SELECT FirstName + ' ' + LastName FROM Employees 
    WHERE EmployeeID = cteReports.MgrID) AS Manager
FROM cteReports 
ORDER BY EmpLevel, MgrID