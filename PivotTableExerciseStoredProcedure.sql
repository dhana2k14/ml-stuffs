
--===== Declare the I/O parameters        

create procedure dbo.Pivottable 
			@StartDate DATETIME,
			@EndDate   DATETIME
AS
DECLARE		@SwapDate  DATETIME
DECLARE		@SQL1 NVARCHAR(4000),        
			@SQL2 NVARCHAR(4000),        
			@SQL3 NVARCHAR(4000)

SET NOCOUNT ON

SELECT		@SwapDate  = @EndDate,        
			@EndDate   = @StartDate,        
			@StartDate = @SwapDate  WHERE @EndDate   < @StartDate 
SELECT		@StartDate = DATEADD(mm,DATEDIFF(mm,0,@StartDate),0),        
			@EndDate   = DATEADD(mm,DATEDIFF(mm,0,@EndDate)+1,0)
SELECT		@SQL1 = 'SELECT CASE WHEN GROUPING(SomeLetters2) = 1 THEN ''Total'' ELSE SomeLetters2 END AS SomeLetters2,'+CHAR(10)
SELECT		@SQL3 = 'SUM(Total) AS Total  FROM (SELECT DATEADD(mm,DATEDIFF(mm,0,SomeDate),0) AS MonthDate,SomeLetters2,SUM(SomeMoney) AS Total FROM dbo.JBMTest WHERE SomeDate >= ' + QUOTENAME(@StartDate,'''') + 'AND SomeDate  < ' + QUOTENAME(@EndDate,'''') + '         
					 GROUP BY DATEADD(mm,DATEDIFF(mm,0,SomeDate),0), SomeLetters2) d GROUP BY SomeLetters2 WITH ROLLUP'

SELECT		@SQL2 = COALESCE(@SQL2,'')+'SUM(CASE WHEN MonthDate = ' + QUOTENAME(d.MonthName,'''')+'THEN Total ELSE 0 END) AS ['+ d.MonthName +'],' + CHAR(10)   
FROM        (SELECT N,STUFF(CONVERT(CHAR(11),DATEADD(mm, N-1, @StartDate),100),4,3,'') AS MonthName FROM dbo.Tally WHERE N <= DATEDIFF(mm,@StartDate,@EndDate)) d  
ORDER BY d.N

EXEC (@SQL1 + @SQL2 + @SQL3)
GO


EXEC dbo.PivotTable 'Jul 2008','Jan 2009'
GO


/*DECLARE		@StartDate DATETIME
DECLARE		@EndDate DATETIME
SET			@StartDate ='Jan 2000'
SET			@EndDate = 'Feb 2009'*/

/* PRINT (@SQL1+@SQL2+@SQL3) */