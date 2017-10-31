
select * from [dbo].[Ditsobotla_GV_Roll_Final] where SG_Code!='' and len(erfnumber)=2

select distinct(Sg_code),SubExt from [dbo].[Ditsobotla_GV_Roll_Final] where SubExt in (Select distinct(SubExt) from [dbo].[Ditsobotla_GV_Roll_Final] where SubExt!='') 

select distinct(SG_Code) from [dbo].[Ditsobotla_GV_Roll_Final] where SubExt like 'M C VAN NIEKERKPARK%'

select min(len(portion)),max(len(portion)) from [dbo].[Ditsobotla_GV_Roll_Final] where SG_Code_1!=''


update [dbo].[Ditsobotla_GV_Roll_Final] set SG_Code_1= case when (SubExt='LICHTENBURG' and len(ErfNumber)=1) then 'T0IP00260000000'+cast(erfnumber as char)
													   when (SubExt='LICHTENBURG' and len(ErfNumber)=2) then 'T0IP0026000000'+cast(erfnumber as char)
													   when (SubExt='LICHTENBURG' and len(ErfNumber)=3) then 'T0IP002600000'+cast(erfnumber as char)
													   when (SubExt='LICHTENBURG' and len(ErfNumber)=4) then 'T0IP00260000'+cast(erfnumber as char)

													   when (SubExt='THLABOLOGANG Ext 6' and len(ErfNumber)=1) then 'T0IP00670000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 6' and len(ErfNumber)=2) then 'T0IP0067000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 6' and len(ErfNumber)=3) then 'T0IP006700000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 6' and len(ErfNumber)=4) then 'T0IP00670000'+cast(erfnumber as char)

													   when (SubExt='ITSOSENG UNIT 2' and len(ErfNumber)=1) then 'T0IO00120000000'+cast(erfnumber as char)
													   when (SubExt='ITSOSENG UNIT 2' and len(ErfNumber)=2) then 'T0IO0012000000'+cast(erfnumber as char)
													   when (SubExt='ITSOSENG UNIT 2' and len(ErfNumber)=3) then 'T0IO001200000'+cast(erfnumber as char)
													   when (SubExt='ITSOSENG UNIT 2' and len(ErfNumber)=4) then 'T0IO00120000'+cast(erfnumber as char)

													   when (SubExt='ITSOSENG UNIT 1' and len(ErfNumber)=1) then 'T0IO00110000000'+cast(erfnumber as char)
													   when (SubExt='ITSOSENG UNIT 1' and len(ErfNumber)=2) then 'T0IO0011000000'+cast(erfnumber as char)
													   when (SubExt='ITSOSENG UNIT 1' and len(ErfNumber)=3) then 'T0IO001100000'+cast(erfnumber as char)
													   when (SubExt='ITSOSENG UNIT 1' and len(ErfNumber)=4) then 'T0IO00110000'+cast(erfnumber as char)

													   when (SubExt='BLYDEVILLE EXT 3' and len(ErfNumber)=1) then 'T0IP00040000000'+cast(erfnumber as char)
													   when (SubExt='BLYDEVILLE EXT 3' and len(ErfNumber)=2) then 'T0IP0004000000'+cast(erfnumber as char)
													   when (SubExt='BLYDEVILLE EXT 3' and len(ErfNumber)=3) then 'T0IP000400000'+cast(erfnumber as char)
													   when (SubExt='BLYDEVILLE EXT 3' and len(ErfNumber)=4) then 'T0IP00040000'+cast(erfnumber as char)

													   when (SubExt='M C VAN NIEKERKPARK' and len(ErfNumber)=1) then 'T0IP00300000000'+cast(erfnumber as char)
													   when (SubExt='M C VAN NIEKERKPARK' and len(ErfNumber)=2) then 'T0IP0030000000'+cast(erfnumber as char)
													   when (SubExt='M C VAN NIEKERKPARK' and len(ErfNumber)=3) then 'T0IP003000000'+cast(erfnumber as char)
													   when (SubExt='M C VAN NIEKERKPARK' and len(ErfNumber)=4) then 'T0IP00300000'+cast(erfnumber as char)

													   when (SubExt='BOIKHUTSO EXT 2' and len(ErfNumber)=1) then 'T0IP00640000000'+cast(erfnumber as char)
													   when (SubExt='BOIKHUTSO EXT 2' and len(ErfNumber)=2) then 'T0IP0064000000'+cast(erfnumber as char)
													   when (SubExt='BOIKHUTSO EXT 2' and len(ErfNumber)=3) then 'T0IP006400000'+cast(erfnumber as char)
													   when (SubExt='BOIKHUTSO EXT 2' and len(ErfNumber)=4) then 'T0IP00640000'+cast(erfnumber as char)

													   when (SubExt='RETIEFS PARK 1497' and len(ErfNumber)=1) then 'T0IP00380000000'+cast(erfnumber as char)
													   when (SubExt='RETIEFS PARK 1497' and len(ErfNumber)=2) then 'T0IP0038000000'+cast(erfnumber as char)
													   when (SubExt='RETIEFS PARK 1497' and len(ErfNumber)=3) then 'T0IP003800000'+cast(erfnumber as char)
													   when (SubExt='RETIEFS PARK 1497' and len(ErfNumber)=4) then 'T0IP00380000'+cast(erfnumber as char)

													   when (SubExt='SHUKRAN' and len(ErfNumber)=1) then 'T0IP00410000000'+cast(erfnumber as char)
													   when (SubExt='SHUKRAN' and len(ErfNumber)=2) then 'T0IP0041000000'+cast(erfnumber as char)
													   when (SubExt='SHUKRAN' and len(ErfNumber)=3) then 'T0IP004100000'+cast(erfnumber as char)
													   when (SubExt='SHUKRAN' and len(ErfNumber)=4) then 'T0IP00410000'+cast(erfnumber as char)

													   when (SubExt='VERDOORNPARK' and len(ErfNumber)=1) then 'T0IP00530000000'+cast(erfnumber as char)
													   when (SubExt='VERDOORNPARK' and len(ErfNumber)=2) then 'T0IP0053000000'+cast(erfnumber as char)
													   when (SubExt='VERDOORNPARK' and len(ErfNumber)=3) then 'T0IP005300000'+cast(erfnumber as char)
													   when (SubExt='VERDOORNPARK' and len(ErfNumber)=4) then 'T0IP00530000'+cast(erfnumber as char)

													   when (SubExt='AMANABAD' and len(ErfNumber)=1) then 'T0IP00030000000'+cast(erfnumber as char)
													   when (SubExt='AMANABAD' and len(ErfNumber)=2) then 'T0IP0003000000'+cast(erfnumber as char)
													   when (SubExt='AMANABAD' and len(ErfNumber)=3) then 'T0IP000300000'+cast(erfnumber as char)
													   when (SubExt='AMANABAD' and len(ErfNumber)=4) then 'T0IP00030000'+cast(erfnumber as char)

													   when (SubExt='THLABOLOGANG' and len(ErfNumber)=1) then 'T0IP00670000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG' and len(ErfNumber)=2) then 'T0IP0067000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG' and len(ErfNumber)=3) then 'T0IP006700000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG' and len(ErfNumber)=4) then 'T0IP00670000'+cast(erfnumber as char)

													   when (SubExt='BOIKHUTSO EXT 1' and len(ErfNumber)=1) then 'T0IP00640000000'+cast(erfnumber as char)
													   when (SubExt='BOIKHUTSO EXT 1' and len(ErfNumber)=2) then 'T0IP0064000000'+cast(erfnumber as char)
													   when (SubExt='BOIKHUTSO EXT 1' and len(ErfNumber)=3) then 'T0IP006400000'+cast(erfnumber as char)
													   when (SubExt='BOIKHUTSO EXT 1' and len(ErfNumber)=4) then 'T0IP00640000'+cast(erfnumber as char)

													   when (SubExt='THLABOLOGANG Ext 5' and len(ErfNumber)=1) then 'T0IP006700000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 5' and len(ErfNumber)=2) then 'T0IP0067000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 5' and len(ErfNumber)=3) then 'T0IP006700000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 5' and len(ErfNumber)=4) then 'T0IP00670000'+cast(erfnumber as char)

													   when (SubExt='ITSOSENG UNIT 3' and len(ErfNumber)=1) then 'T0IO00130000000'+cast(erfnumber as char)
													   when (SubExt='ITSOSENG UNIT 3' and len(ErfNumber)=2) then 'T0IO0013000000'+cast(erfnumber as char)
													   when (SubExt='ITSOSENG UNIT 3' and len(ErfNumber)=3) then 'T0IO001300000'+cast(erfnumber as char)
													   when (SubExt='ITSOSENG UNIT 3' and len(ErfNumber)=4) then 'T0IO00130000'+cast(erfnumber as char)

													   when (SubExt='THLABOLOGANG Ext 4' and len(ErfNumber)=1) then 'T0IP00670000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 4' and len(ErfNumber)=2) then 'T0IP0067000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 4' and len(ErfNumber)=3) then 'T0IP006700000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 4' and len(ErfNumber)=4) then 'T0IP00670000'+cast(erfnumber as char)

													   when (SubExt='THLABOLOGANG Ext 3' and len(ErfNumber)=1) then 'T0IP00670000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 3' and len(ErfNumber)=2) then 'T0IP0067000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 3' and len(ErfNumber)=3) then 'T0IP006700000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG Ext 3' and len(ErfNumber)=4) then 'T0IP00670000'+cast(erfnumber as char)

													   when (SubExt='RETIEFS PARK' and len(ErfNumber)=1) then 'T0IP00380000000'+cast(erfnumber as char)
													   when (SubExt='RETIEFS PARK' and len(ErfNumber)=2) then 'T0IP0038000000'+cast(erfnumber as char)
													   when (SubExt='RETIEFS PARK' and len(ErfNumber)=3) then 'T0IP003800000'+cast(erfnumber as char)
													   when (SubExt='RETIEFS PARK' and len(ErfNumber)=4) then 'T0IP00380000'+cast(erfnumber as char)

													   when (SubExt='COLIGNY EXT 2' and len(ErfNumber)=1) then 'T0IP00050000000'+cast(erfnumber as char)
													   when (SubExt='COLIGNY EXT 2' and len(ErfNumber)=2) then 'T0IP0005000000'+cast(erfnumber as char)
													   when (SubExt='COLIGNY EXT 2' and len(ErfNumber)=3) then 'T0IP000500000'+cast(erfnumber as char)
													   when (SubExt='COLIGNY EXT 2' and len(ErfNumber)=4) then 'T0IP00050000'+cast(erfnumber as char)

													   when (SubExt='STEWARTBY' and len(ErfNumber)=1) then 'T0IP00430000000'+cast(erfnumber as char)
													   when (SubExt='STEWARTBY' and len(ErfNumber)=2) then 'T0IP0043000000'+cast(erfnumber as char)
													   when (SubExt='STEWARTBY' and len(ErfNumber)=3) then 'T0IP004300000'+cast(erfnumber as char)
													   when (SubExt='STEWARTBY' and len(ErfNumber)=4) then 'T0IP00430000'+cast(erfnumber as char)

													   when (SubExt='ITEKENG EXT 1' and len(ErfNumber)=1) then 'T0IO00070000000'+cast(erfnumber as char)
													   when (SubExt='ITEKENG EXT 1' and len(ErfNumber)=2) then 'T0IO0007000000'+cast(erfnumber as char)
													   when (SubExt='ITEKENG EXT 1' and len(ErfNumber)=3) then 'T0IO000700000'+cast(erfnumber as char)
													   when (SubExt='ITEKENG EXT 1' and len(ErfNumber)=4) then 'T0IO00070000'+cast(erfnumber as char)

													   when (SubExt='RETIEFS PARK EXT 3' and len(ErfNumber)=1) then 'T0IP00380000000'+cast(erfnumber as char)
													   when (SubExt='RETIEFS PARK EXT 3' and len(ErfNumber)=2) then 'T0IP0038000000'+cast(erfnumber as char)
													   when (SubExt='RETIEFS PARK EXT 3' and len(ErfNumber)=3) then 'T0IP003800000'+cast(erfnumber as char)
													   when (SubExt='RETIEFS PARK EXT 3' and len(ErfNumber)=4) then 'T0IP00380000'+cast(erfnumber as char)

													   when (SubExt='THLABOLOGANG EXT3' and len(ErfNumber)=1) then 'T0IP00670000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG EXT3' and len(ErfNumber)=2) then 'T0IP0067000000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG EXT3' and len(ErfNumber)=3) then 'T0IP006700000'+cast(erfnumber as char)
													   when (SubExt='THLABOLOGANG EXT3' and len(ErfNumber)=4) then 'T0IP00670000'+cast(erfnumber as char)

													   else SG_Code
end


update [dbo].[Ditsobotla_GV_Roll_Final] set SG_Code_2=case when len(portion)=1 then sg_code_1+portion+'0000'
														   when len(portion)=2 then sg_code_1+portion+'000'
														   when len(portion)=3 then sg_code_1+portion+'00'														   
													  else sg_code_1
end


select StandNo,StandDescrip,Erf,Portion from [dbo].[SolPlaatijieValRoll] where PATINDEX('%[^0-9]%',Portion)>0
				   
update [dbo].[SolPlaatijieValRoll] set Erf=substring(StandDescrip,CAST(CHARINDEX('STAND',StandDescrip) as int)+7,len(StandDescrip))
where CHARINDEX('STAND',StandDescrip)>=1 and Erf is null

update [dbo].[SolPlaatijieValRoll] set Erf=substring(Erf,1,CAST(CHARINDEX(' ',Erf) as int)) where PATINDEX('%[^0-9]%',Erf)!=0

select * from [dbo].[ST$]