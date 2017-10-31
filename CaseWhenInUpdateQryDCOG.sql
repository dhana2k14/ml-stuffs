
select * from [dbo].[Kokstad_Res_DataCapture] where REM!='' order by ErfNumber [dbo].[MangaungSQM]
select * from dbo.PrimaryTable where municipality is null pin in (Select Pin from dbo.PrimaryTable group by Pin having count(Pin)>1) order by Pin add r_n int

with cte as
(
select *,row_number() over(partition by Pin order by Usecode desc) rn from dbo.PrimaryTable
)
update cte set r_n=rn


update a set a.REM=b.[REM] from [dbo].[Kokstad_Res_DataCapture] a inner join [dbo].[Kokstad_DeedSales] b on 
a.SG_Code=b.[LPICODE] 


select * from [dbo].[Umhl_DataCollection_Batch] where Ptn!=0 [dbo].[DitsobotlaSample][dbo].[DitsobotlaSample]

/* [dbo].[KarooHooglandSample]
[dbo].[UmhlathuzeSample]
[dbo].[KokstadSample]
[dbo].[NgqushwaSample]
[dbo].[DihlabengSample]
[dbo].[DihlabengGIS] where min_region=''*/


alter table [dbo].[Umhl_DataCollection_Batch] add Municipality varchar(255),[Description] varchar(255)

update [dbo].[DitsobotlaSample] set Ptn=Portion

alter table [dbo].[DitsobotlaSample] alter column Ptn float

/* update [dbo].[GovanmbekiSample] set  Municipality='Karoohoogland local municipality',
								    Description=case when (Ptn=0 and ltrim(rtrim(min_region))!='') then 'ERF OF '+ltrim(rtrim(Erf_no))+ ' OF '+ltrim(rtrim(min_region))
												 when (ptn>0 and ltrim(rtrim(min_region))!='') then 'PTN '+cast(Ptn as varchar)+' OF '+' ERF OF '+ltrim(rtrim(Erf_no))+ ' OF '+min_region
												 when ((Ptn=0 or Ptn is null) and ltrim(rtrim(min_region))='') then 'ERF OF '+ltrim(rtrim(Erf_no))+ ' OF '+ltrim(rtrim(maj_region))
												 when (Ptn>0 and ltrim(rtrim(min_region))='') then 'PTN '+cast(Ptn as varchar)+' OF '+' ERF OF '+ltrim(rtrim(Erf_no))+ ' OF '+ltrim(rtrim(maj_region))
											else ''
											


end */



select * from dcog.[dbo].[GreaterTubatse_Deed_Sales_0814] add Municipality varchar(255),[Desc] varchar(255)

select * from [dbo].[DihlabengSample][dbo].[Dihlabeng_DC_Batch_1] add Munic varchar(255), [Desc] varchar(255)

update dcog.[dbo].[Dihlabeng_DC_Batch_1] set  Munic='Dihlabeng Local Municipality',
[Desc]=case  when (REM='R/E') then 'REM OF ERF '+ltrim(rtrim(Erf))+ ' OF '+township
				  when (Portion=0 and ltrim(rtrim(township))!='') then 'ERF '+ltrim(rtrim(Erf))+ ' OF '+ltrim(rtrim(township))
				  when (Portion>0 and ltrim(rtrim(township))!='') then 'PTN '+cast(Portion as varchar)+' OF '+' ERF '+ltrim(rtrim(Erf))+ ' OF '+township
				  else ''
end


Select * from [dbo].[MafikengFinalValRol][dbo].[Maruleng_FTValRoll] where CHARINDEX('AGRI',LandUse)>0 or  CHARINDEX('FARM',LandUse)>0   [dbo].[MatjhabengSuburb] where Suburb in (select distinct(Suburb) from [dbo].[MatjhabengValRoll])

Select FARMNAME,REGDIV from [dbo].[RSAFarmPortionsREGDIV] where (Province='LIM' and MAJORREGION='KT') and FARMNAME in (select distinct(TownFarmName) from [dbo].[Maruleng_FTValRoll] where CHARINDEX('AGRI',LandUse)>0 or  CHARINDEX('FARM',LandUse)>0)
group by FARMNAME,REGDIV


Select TOWNSHIP,REGDIV from [dbo].[RSATownshipREGDIV] where (Province='LIM' and MAJORREGION='KT') and TOWNSHIP in (select distinct(TownFarmName) from [dbo].[Maruleng_FTValRoll] where CHARINDEX('AGRI',LandUse)>0 or  CHARINDEX('FARM',LandUse)>0)
group by TOWNSHIP,REGDIV



with cte as
(
select *,row_number() over (partition by Pin order by Pin ) rk from [dbo].[GreaterTubatse_DC_Batch1] 
)
delete from cte where rk>1


select distinct(region_name) from [dbo].[Dihlabeng_Deeds_FT]