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

declare @startDate datetime,  
        @endDate datetime;  
  
select  @startDate = getdate(),  
        @endDate = getdate()+16;  
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