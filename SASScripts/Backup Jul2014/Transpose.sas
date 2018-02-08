

proc sql;
create table temp as 
select a.InvView,a.InvQual,a.InvCond,a.InvTopo,a.InvNoise,a.InvSec,a.InvUse,a.InvTla,a.InvNbhd,a.InvGba,a.InvGba,a.InvExt,a.InvPin,
a.InvTotEmv,a.InvX,a.InvY,b.SaleView,b.SaleQual,b.SaleCond,b.SaleTopo,b.SaleNoise,b.SaleSec,b.SaleUse,b.SaleTla,b.SaleNbhd,b.SaleGba,b.SaleGba,b.SaleExt,
b.SalePin,b.SaleTotEmv,b.Sprice,b.SDate,b.SaleX,b.SaleY from batch.inv as a,batch.sales as b where a.InvPin ne b.SalePin
AND a.InvNbhd="Blue Horizon Bay" AND b.SaleNbhd="Blue Horizon Bay";
quit;run;

proc sql;
create table Sales_BWB as 
select * from batch.Sales where SaleNbhd = "BWB";
quit;
run;

/* Transpose */

proc sql outobs=1;
create table batch.Comp1Row81_Inv as
select InvPin as Pin,InvNbhd as Nbhd,InvTla as Tla,InvGar as Gar,InvExt as ErfExt,InvQual as Qual,InvCond as Cond,InvTotEmv as Emv
from Comp1Row81;quit;run;

proc transpose data=batch.Comp1Row81_Inv out=batch.TransInv_Comp1Row81 ;
var Pin Tla Gar Nbhd ErfExt Qual Cond Emv ;
run;

proc sql;
create table batch.Comp1Row81_Sales as
select SalePin as Pin,SaleNbhd as Nbhd,SaleTla as Tla,SaleGar as Gar,SaleExt as ErfExt,SaleQual as Qual,SaleCond as Cond,SaleTotEmv as Emv,
AdjSale,Dist
from Comp1Row81;quit;run;

proc transpose data=batch.Comp1Row81_Sales out=batch.TransSales_Comp1Row81 (rename = (_name_=Variables Col1=COMP1 Col2 = COMP2 Col3 = COMP3 Col4=COMP4 Col5=COMP5));
var _all_;
run;

proc sql;
create table batch.finalList as 
select a.*,b.Col1 
from batch.TransSales_Comp1Row81 as a left join batch.TransInv_Comp1Row81 as b on a.Variables=b._name_;
quit;
run;

data batch.finalList;
retain col1;
set batch.finalList;
run;

data batch.finalList;
retain variables;
label variables = Variables;
set batch.finalList;
run;

proc sort data=batch.finalList;
by  descending Variables;
run;



