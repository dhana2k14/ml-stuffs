
proc transpose data=Drive.Ago_Calcstep out=Trans1;
var VariableName VariableValue;
by ID;
run;

options mprint mlogic symbolgen;
%macro pivottable;
proc sql noprint;
create table trans_1 as 
select distinct(ID) 
from Trans1
quit;
run;

data _null_;
set trans_1 end = lastrec;
if lastrec then do;
Call Symput ('Obs_1',_n_);
end;
run;

	%do n=1 %to &Obs_1;
	data _null;
	set trans_1;
	if &n=_n_;
	call symput ("Pin&n",ID);
	run;
	proc sql outobs=2;
	create table PinRow&n as
	select * from Trans1 
	where ID = &&Pin&n;
	quit;
	run;

proc transpose data=pinrow&n(obs=1) out=temp;
var _all_;
run;

data temp;
set temp (firstobs=3);
where variablename ne ' '; 
run;

proc sql ;
select catx('=',_name_,variablename)
into :rename separated by ' '
from temp;
quit;

data drive.pinrow&n;
set pinrow&n(firstobs=2 rename=(&rename));
run;

%end;
%mend pivottable;

%pivottable;



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
	create table C1R&n&&Suburb&i as 
	select a.*,b.Subject 
	from TransSales_Comp1Row&n as a left join TransInv_Comp1Row&n as b on a.Variables=b._name_;
	quit;
	run;
	%mend pivottable;

	%macro pivottable(libname=work);

