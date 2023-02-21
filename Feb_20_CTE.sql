--Common Table Expression

Declare @RowNo int =1;
;with ROWCTE as  
   (  
      SELECT @RowNo as ROWNO    
		UNION ALL  
      SELECT  ROWNO+1  
  FROM  ROWCTE  
  WHERE RowNo < 10
    )  
SELECT * FROM ROWCTE 
GO
------------------------------------------------------------------------------------------
-- CTE to get current week and date from cuurent date 
declare @startDate datetime,  
        @endDate datetime;  
  
select  @startDate = getdate(),  
        @endDate = getdate()+30;  
-- select @sDate StartDate,@eDate EndDate  
;with myCTE as  
   (  
      select 1 as ROWNO,@startDate StartDate,'W - '+convert(varchar(2),  
            DATEPART( wk, @startDate))+' / D ('+convert(varchar(2),@startDate,106)+')' as 'WeekNumber'  
    )  
select ROWNO,Convert(varchar(10),StartDate,105)  as StartDate ,WeekNumber from myCTE ;
GO
-----------------------------------------------------------------------------------------------------------

declare @startDate datetime,  
        @endDate datetime;  
  
select  @startDate = getdate(),  
        @endDate = getdate()+30;  
-- select @sDate StartDate,@eDate EndDate  
;with myCTE as  
   (  
      select 1 as ROWNO, @startDate StartDate, 'W - '+convert(varchar(2),  
            DATEPART( wk, @startDate))+' / D ('+convert(varchar(2),@startDate,106)+')' as 'WeekNumber'       
  union all  
       select  ROWNO+1 ,dateadd(DAY, 1, StartDate) ,  
              'W - '+convert(varchar(2),DATEPART( wk, StartDate))+' / D ('+convert(varchar(2),  
               dateadd(DAY, 1, StartDate),106)+')' as 'WeekNumber'     
  FROM  myCTE  
  WHERE dateadd(DAY, 1, StartDate)<=  @endDate    
    )  
select ROWNO,Convert(varchar(10),StartDate,105)  as StartDate ,WeekNumber from myCTE  
GO
--------------------------------------------------------------------------------------------------
-- CTE to Find Manager of Employees
USE Office_Training
GO
;WITH cte_recursion (EmpID, FirstName, LastName, MgrID, EmpLevel)  
  AS  
  (  
    SELECT Employee_ID, First_Name, Last_Name, Manager_ID, 1  
    FROM Employees WHERE Manager_ID = 0  
    UNION ALL  
    SELECT emp.Employee_ID, emp.First_Name, emp.Last_Name, emp.Manager_ID, r.EmpLevel + 1  
    FROM Employees emp INNER JOIN cte_recursion r ON emp.Manager_ID = r.EmpID  
  ) 
SELECT  
  FirstName + LastName AS FullName,  
  (SELECT First_Name + Last_Name FROM Employees   
    WHERE Employee_ID = cte_recursion.MgrID) AS Manager,
	EmpLevel
    FROM cte_recursion ORDER BY EmpLevel, MgrID  

---------------------------------------------------------------------------------------------

