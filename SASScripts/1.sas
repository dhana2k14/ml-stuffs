
options mprint mlogic symbolgen;
%macro Genc (libname=,InvData=,SaleData=,Suburb=,NewData_1=,NewData_2=);
proc sql noprint;
create table &libname..&NewData_1 as 
select a.InvSuburb,a.InvQual,a.InvCond,a.InvTla,a.InvGba,a.InvGar,a.InvExt,a.InvPin,
a.InvTotEmv,a.InvX,a.InvY,b.SaleSuburb,b.SaleQual,b.SaleCond,b.SaleTla,b.SaleGba,b.SaleGar,b.SaleExt,
b.SalePin,b.SaleTotEmv,b.Sprice,b.SaleX,b.SaleY from &libname..&InvData as a,&libname..&SaleData as b where a.InvPin NE b.SalePin
AND a.InvSuburb=&Suburb AND b.SaleSuburb=&Suburb;
quit;run;

proc sql noprint;
create table &libname..&NewData_2 as 
select a.InvSuburb,a.InvQual,a.InvCond,a.InvTla,a.InvGba,a.InvGar,a.InvExt,a.InvPin,
a.InvTotEmv,a.InvX,a.InvY,b.SaleSuburb,b.SaleQual,b.SaleCond,b.SaleTla,b.SaleGba,b.SaleGar,b.SaleExt,
b.SalePin,b.SaleTotEmv,b.Sprice,b.SaleX,b.SaleY from &libname..&InvData as a,&libname..&SaleData as b where a.InvPin EQ b.SalePin
AND a.InvSuburb=&Suburb AND b.SaleSuburb=&Suburb;
quit;run;

proc append base=&libname..&NewData_1 data=&libname..&NewData_2 force;
run;

data &libname..&NewData_1;
set &libname..&NewData_1;
if ((SaleQual-1)<=InvQual<=(SaleQual+1)) then do;
   if ((SaleCond-1)<=InvCond<=(SaleCond+1)) then do;
	  if ((.75*SaleTla)<=InvTla<=(1.33*SaleTla)) then do;
		  if((.75*SaleExt)<=InvExt<=(1.33*SaleExt)) then comp=1;
	         else comp=2;
      end;
   end; 
end;
run;

data &libname..Comp1Run1 &libname..Comp2Run1;
set &libname..&NewData_1;
if comp=. or comp=2 then comp=2;
if comp=1 then output &libname..Comp1Run1;
if comp=2 then output &libname..Comp2Run1;
run;

/*proc sql noprint;*/
/*create table batch.PinLeComp as select InvPin,Count(InvPin)as Count from &libname..Comps_1 group by InvPin;*/
/*quit;*/
/*run;*/
/**/
/*data _null_;*/
/*set batch.PinLeComp end=lastrec;*/
/*if lastrec then do;*/
/*call symput ('C',_n_);*/
/*end;*/
/*run;*/
/**/
/*%macro Comp2Run (i=);*/
/*    data _null_;*/
/*	set batch.PinLeComp;*/
/*	do i=1 %to &C;*/
/*	   %if (&i=_n_ and Count>=5) %then %do;*/
/*       %Goto ENDMacro;*/
/*	   %end;*/
/*	   %ENDMacro;*/
/*%mend Comp2Run;*/
/**/
/*data _null;*/
/*set &libname..PinLeComp;*/
/*if &i=_n_;*/
/*call symput ("Pin&n",InvPin);*/
/*run;*/
/*proc sql noprint;*/
/*create table LC&n as select * from &libname..&NewData_1 where InvPin=&&Pin&n;*/
/*quit;*/
/*run;*/
/*data LC&n (Drop = Comp);*/
/*set LC&n;*/
/*run;*/
/*%end;*/
/**/
/*%do n=2 %to &C;*/
/*proc append base = LC1 data=LC&n force;*/
/*run;*/
/*proc datasets library=work;*/
/*delete LC&n;*/
/*run;*/
/*%end;*/
/**/
/*data Lc1;*/
/*set Lc1;*/
/*if ((.75*SaleTla)<=InvTla<=(1.33*SaleTla)) then do;*/
/*   if((.73*SaleExt)<=InvExt<=(1.33**SaleExt)) then comp=0;*/
/*     else comp=1;*/
/*end;*/
/*run;*/
/**/
/*data Lc1;*/
/*set Lc1;*/
/*where comp=1;*/
/*run;*/
/**/
/*proc append base=&libname..Comp1Run1 data=Lc1 force;*/
/*run;*/
/**/
/*%mend Genc;*/
/**/
/*%Genc (libname=batch,InvData=INV,SaleData=Sales,Nbhd="BWB",NewData_1=COMPS_1,NewData_2=COMPS_2);*/

proc append base=&libname..Comp1Run1 data=&libname..Comp2Run1 force;
run;

data &libname..Comp1Run1;
set &libname..Comp1Run1;
AdjEmv = InvTotEmv-SaleTotEmv;
Dist = SQRT((InvX-SaleX)**2+((InvY-SaleY)**2));
if InvPin=SalePin then AdjSale=Sprice;
run;

/*data &libname..Comp2Run1;*/
/*set &libname..Comp2Run1;*/
/*AdjEmv = InvTotEmv-SaleTotEmv;*/
/*Dist = SQRT((InvX-SaleX)**2+((InvY-SaleY)**2));*/
/*if InvPin=SalePin then AdjSale=Sprice;*/
/*run;*/

proc sort data=&libname..Comp1Run1;
by Comp AdjEmv;
run;

/*proc sort data=&libname..Comp2Run1;*/
/*by AdjEmv Dist;*/
/*run;*/

proc sql noprint;
create table &libname..InvPin_1 as 
select distinct(InvPin) 
from &libname..Comp1Run1
quit;
run;

data _null_;
set &libname..InvPin_1 end = lastrec;
if lastrec then do;
Call Symput ('Obs_1',_n_);
end;
run;

%do n=1 %to &Obs_1;
data _null;
set &libname..InvPin_1;
if &n=_n_;
call symput ("Comp1_Pin&n",InvPin);
run;
proc sql outobs=5;
create table Comp1Row&n as
select * from &libname..Comp1Run1 
where InvPin = &&Comp1_Pin&n;
quit;
run;

proc sql outobs=1;
create table InvComp1Row&n as
select InvPin as A_Pin,InvSuburb as B_Suburb,InvTla as C_Tla,InvGar as D_Gar,InvExt as E_ErfExt,InvQual as F_Qual,InvCond as G_Cond,InvTotEmv as K_Emv
from Comp1Row&n;quit;run;

proc transpose data=InvComp1Row&n out=TransInv_Comp1Row&n (rename=(Col1=Subject)) ;
var _all_ ;
run;

proc sql;
create table SalesComp1Row&n as
select SalePin as A_Pin,SaleSuburb as B_Suburb,SaleTla as C_Tla,SaleGar as D_Gar,SaleExt as E_ErfExt,SaleQual as F_Qual,SaleCond as G_Cond,Dist as H_Dist,SPrice as I_Sale,SaleTotEmv as K_Emv,
AdjEmv as J_AdjEmv,Comp as L_CompRating from Comp1Row&n;quit;run;

proc transpose data=SalesComp1Row&n out=TransSales_Comp1Row&n (rename = (_name_=Variables Col1=COMP1 Col2 = COMP2 Col3 = COMP3 Col4=COMP4 Col5=COMP5) drop=_label_);
var _all_;
run;

proc sql;
create table Comp1Repo&n as 
select a.*,b.Subject 
from TransSales_Comp1Row&n as a left join TransInv_Comp1Row&n as b on a.Variables=b._name_;
quit;
run;

data Comp1Repo&n;
retain Subject;
set Comp1Repo&n;
run;

data Comp1Repo&n;
retain Variables;
label Variables = Variables;
set Comp1Repo&n;
run;

proc sort data = Comp1Repo&n;
by Variables;
run;

data WGComp1Repo&n;
set Comp1Repo&n;
if Variables = "I_Sale" then delete;
if Variables = "J_AdjEmv" then delete;
if Variables = "K_Emv" then delete;
if Variables = "H_Dist" then delete;
if Variables = "G_Cond" then delete;
if Variables = "F_Qual" then delete;
run;

data DWComp1Repo&n;
set Comp1Repo&n;
if Variables = "B_Suburb" then delete;
if Variables = "C_Tla" then delete;
if Variables = "D_Gar" then delete;
if Variables = "E_ErfExt" then delete;
if Variables = "L_CompRating" then delete;
if Variables = "J_AdjEmv" then delete;
if Variables = "K_Emv" then delete;
if Variables = "H_Dist" then delete;
if Variables = "G_Cond" then delete;
if Variables = "F_Qual" then delete;
run;

%end;

%do n=2 %to &Obs_1;
proc append base=Comp1Repo1 data=Comp1Repo&n force;
run;
proc append base=WGComp1Repo1 data=WGComp1Repo&n force;
run;
proc append base=DWComp1Repo1 data=DWComp1Repo&n force;
run;
%end;

proc datasets;
copy in=work out=coj move;
select Comp1Repo1;
quit;

proc datasets;
copy in=work out=coj move;
select WGComp1Repo1;
quit;

proc datasets;
copy in=work out=coj move;
select DWComp1Repo1;
quit;


/*%do n=2 %to &obs_1;
proc append base=Comp1Row1 data=Comp1Row&n force;
run;
%end;/*

/* COMPARABLES NOT MATCHING SELECTION CRETERIA */

/*proc sql noprint;
create table &libname..InvPin_2 as 
select distinct(InvPin) 
from &libname..Comp2Run1
quit;
run;

data _null_;
set &libname..InvPin_2 end=lastrec;
if lastrec then do;
Call Symput ('Obs_2',_n_);
end;
run;

%do n=1 %to &Obs_2;
data _null;
set &libname..InvPin_2;
if &n=_n_;
call symput ("Comp2_Pin&n",InvPin);
run;
proc sql outobs=5;
create table Comp2Row&n as
select * from &libname..Comp2Run1 
where InvPin = &&Comp2_Pin&n;
quit;
run;
%end;

%do n=2 %to &obs_1;
proc append base=Comp2Row1 data=Comp2Row&n force;
run;
%end;*/

%mend Genc;

%Genc (libname=Coj,InvData=INV,SaleData=Sales,Suburb="Albertville",NewData_1=COMPS_1,NewData_2=COMPS_2);







