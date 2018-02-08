
options mprint mlogic symbolgen;
%macro TakeSuburb (libname=,InvData=,SaleData=,NewData_1=,NewData_2=);

/*proc sql noprint;*/
/*create table Suburb as select distinct(Compress(InvSuburb)) from &libname..&InvData; quit;run;*/

*set log to temp file;
/*proc printto log='c:\mylog.log';*/
/*run;*/

data _null_;
set &libname..Suburb end = lastrec;
if lastrec then do;
Call Symput ('NbCt',_n_);
end;
run;

%do i=1 %to &NbCt;
%global Suburb&i;
data _null_;
set &libname..Suburb;
if &i=_n_;
call symput ("Suburb&i",InvSuburb);
run;

proc sql noprint;
create table &libname..&NewData_1 as 
select a.InvQual,a.InvCond,a.InvTla,a.InvSuburb,a.InvGba,a.InvGar,a.InvGba,a.InvExt,a.InvPin,
a.InvTotEmv,a.InvX,a.InvY,b.SaleQual,b.SaleCond,b.SaleTla,b.SaleSuburb,b.SaleGba,b.SaleGar,b.SaleExt,
b.SalePin,b.SaleTotEmv,b.Sprice,b.SaleX,b.SaleY from &libname..&InvData as a,&libname..&SaleData as b where a.InvPin NE b.SalePin
AND a.InvSuburb="&&Suburb&i" AND b.SaleSuburb="&&Suburb&i";
quit;run;

proc sql noprint;
create table &libname..&NewData_2 as 
select a.InvQual,a.InvCond,a.InvTla,a.InvSuburb,a.InvGba,a.InvGba,a.InvExt,a.InvPin,
a.InvTotEmv,a.InvX,a.InvY,b.SaleQual,b.SaleCond,b.SaleTla,b.SaleSuburb,b.SaleGba,b.SaleExt,
b.SalePin,b.SaleTotEmv,b.Sprice,b.SaleX,b.SaleY from &libname..&InvData as a,&libname..&SaleData as b where a.InvPin EQ b.SalePin
AND a.InvSuburb="&&Suburb&i" AND b.SaleSuburb="&&Suburb&i";
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

proc append base=&libname..Comp1Run1 data=&libname..Comp2Run1 force;
run;

data &libname..Comp1Run1;
set &libname..Comp1Run1;
format InvTotEmv comma12.;
format SaleTotEmv comma12.;
format AdjEmv comma12.;
AdjEmv = ABS(InvTotEmv-SaleTotEmv);
Dist = round(SQRT((InvX-SaleX)**2+((InvY-SaleY)**2)));
if InvPin=SalePin then AdjSale=Sprice;
run;

proc sort data=&libname..Comp1Run1;
by AdjEmv;
run;

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

	proc transpose data=SalesComp1Row&n out=TransSales_Comp1Row&n (rename = (_name_=Variables Col1=COMP1 Col2 = COMP2 Col3 = COMP3 Col4=COMP4 Col5=COMP5)drop=_label_);
	var _all_;
	run;

	proc sql;
	create table C&n&&Suburb&i as 
	select a.*,b.Subject 
	from TransSales_Comp1Row&n as a left join TransInv_Comp1Row&n as b on a.Variables=b._name_;
	quit;
	run;

	data C&n&&Suburb&i;
	retain Subject;
	set C&n&&Suburb&i;
	run;

	data C&n&&Suburb&i;
	retain Variables;
	label Variables = Variables;
	set C&n&&Suburb&i;
	run;

	proc sort data = C&n&&Suburb&i;
	by Variables;
	run;

	data G&n&&Suburb&i;
	set C&n&&Suburb&i;
	if Variables = "I_Sale" then delete;
	if Variables = "J_AdjEmv" then delete;
	if Variables = "K_Emv" then delete;
	if Variables = "H_Dist" then delete;
	if Variables = "G_Cond" then delete;
	if Variables = "F_Qual" then delete;
	run;

	data D&n&&Suburb&i;
	set C&n&&Suburb&i;
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
		proc append base=C1&&Suburb&i data=C&n&&Suburb&i force;
		run;
		proc append base=G1&&Suburb&i data=G&n&&Suburb&i force;
		run;
		proc append base=D1&&Suburb&i data=D&n&&Suburb&i force;
		run;
		%end;

			proc datasets;
			copy in=work out=coj move;
			select C1&&Suburb&i;
			quit;

			proc datasets;
			copy in=work out=coj move;
			select G1&&Suburb&i;
			quit;

			proc datasets;
			copy in=work out=coj move;
			select D1&&Suburb&i;
			quit;

						
%end;

*reset log output;
/*proc printto;*/
/*run;*/

%mend TakeSuburb;
%TakeSuburb (libname=coj,InvData=Inv,SaleData=Sales,NewData_1=Comps_1,NewData_2=Comps_2);



