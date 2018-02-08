* Drop Unrequired variables using GET Command.

GET FILE = 
'C:\eValuations\COJ\Gv13\Residential\ModelReapp\ModReappForObjections\Exception List\SR\Jan14\Untitled6.sav'
/DROP ERF,Portion,ValuationType,Status,Address,Cluster,VersionDate,prevlandval,ClusterID,Neighbourhood,gatedcommunity,Micro_Neighbourhood,SalePrice,SaleDate,TitleDeed,BatchNumber.
CACHE.
EXECUTE.

* Rename Variable names Dynamically.

define !rename1 (olist = !charend('/')
                        /nlist=!cmdend )
!let !rest = !nlist
!do !vname !in (!olist) 
!let !nname=!head(!rest)
!let !rest = !tail(!rest)
rename variables (!vname = !nname).
!doend
!enddefine.
!rename1 olist = PIN Extent CAMA_Extent Suburb Zone Usecode Propertyview Quality Condition Topography Noise TLA TLA2 TLA3 TLA4 Pool Unfinished Security Garage ServentsQuaters GrannyFlat NumStoreys Carport Xcord Ycord prevtotval ParentPIN 
              /nlist = Pin ErfExt CamaExt Suburb Zone PrUse View Qual Cond Topo Noise Tla Tla2 Tla3 Tla4 Pool Unfin Sec Gar Sq Gf Stor Cp X Y Tot08 ParPin .

* Re-Order variables. 

GET FILE = 
'C:\eValuations\COJ\Gv13\Residential\ModelReapp\ModReappForObjections\Exception List\SR\Jan14\Untitled10.sav' / keep Pin ParPin ErfExt CamaExt Suburb Zone PrUse Qual Cond View Topo Noise Sec Tla Tla2 Tla3 Tla4 Gar Cp Gf Sq Pool Unfin Stor X Y Tot08.
SAVE outfile ='SRVL527_REApp_Jan14'.
EXECUTE.

* Read data from XLSX file and Save as SPSS file.

GET DATA   /TYPE   =XLSX
/FILE = 'C:\eValuations\Newcastle\SR&VL\Extracts\NewCastle_Cama_Sr_Extract_16Jan2014.xlsx'
/SHEET   =NAME   'Data_Sr_extract_16Jan2014_balan'
/CELLRANGE   =FULL   
/READNAMES=ON   
/ASSUMEDSTRWIDTH   =32767.
SAVE OUTFILE = 'C:\eValuations\Newcastle\SR&VL\Extracts\SRVLExt_16Jan14_Balance.sav' /COMPRESSED.
DATASET CLOSE  SRVLExt_16Jan14_Balance.sav.


