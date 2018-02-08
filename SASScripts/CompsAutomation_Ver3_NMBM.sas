

options mprint mlogic symbolgen;
%macro TakeNbhd (libname=,InvData=,SaleData=,NewData_1=,NewData_2=);

/*proc sql noprint;*/
/*create table Suburb as select distinct(Compress(InvSuburb)) from &libname..&InvData; quit;run;*/

*set log to temp file;
/*proc printto log='c:\mylog.log';*/
/*run;*/

data _null_;
set &libname..Nbhd end = lastrec;
if lastrec then do;
Call Symput ('NbCt',_n_);
end;
run;

%do i=1 %to &NbCt;
%global Nbhd&i;
data _null_;
set &libname..Nbhd;
if &i=_n_;
call symput ("Nbhd&i",InvNbhd);
run;

proc sql noprint;
create table &libname..&NewData_1 as 
select a.InvQual,a.InvCond,a.InvView,a.InvTla,a.InvNbhd,a.InvGba,a.InvGar,a.InvExt,a.InvPin,
a.InvEmv,a.InvX,a.InvY,b.SaleQual,b.SaleCond,b.SaleView,b.SaleTla,b.SaleNbhd,b.SaleGba,b.SaleGar,b.SaleExt,
b.SalePin,b.SaleEmv,b.SPrice,b.SaleX,b.SaleY from &libname..&InvData as a,&libname..&SaleData as b where a.InvPin NE b.SalePin
AND a.InvNbhd="&&Nbhd&i" AND b.SaleNbhd="NewBrighton";
quit;run;

/*proc sql noprint;*/
/*create table &libname..&NewData_2 as */
/*select a.InvQual,a.InvCond,InvView,a.InvTla,a.InvNbhd,a.InvGba,a.InvExt,a.InvPin,*/
/*a.InvEmv,a.InvX,a.InvY,b.SaleQual,b.SaleCond,b.SaleView,b.SaleTla,b.SaleNbhd,b.SaleGba,b.SaleExt,*/
/*b.SalePin,b.SaleEmv,b.SPrice,b.SaleX,b.SaleY from &libname..&InvData as a,&libname..&SaleData as b where a.InvPin EQ b.SalePin*/
/*AND a.InvNbhd="&&Nbhd&i" AND b.SaleNbhd="&&Nbhd&i";*/
/*quit;run;*/
/**/
/*proc append base=&libname..&NewData_1 data=&libname..&NewData_2 force;*/
/*run;*/

data &libname..&NewData_1;
set &libname..&NewData_1;
if ((SaleQual-1)<=InvQual<=(SaleQual+1)) then do;
   if ((SaleCond-1)<=InvCond<=(SaleCond+1)) then do;
      if ((SaleView-1)<=InvView<=(SaleView+1)) then do;
	     if ((.75*SaleTla)<=InvTla<=(1.33*SaleTla)) then do;
		    if((.75*SaleExt)<=InvExt<=(1.33*SaleExt)) then comp=1;
	        else comp=2;
		 end;
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
format InvEmv comma12.;
format SaleEmv comma12.;
format AdjEmv comma12.;
if InvPin=SalePin then InvEmv=SaleEmv;
AdjEmv = ABS(InvEmv-SaleEmv);
Dist = round(SQRT((InvX-SaleX)**2+((InvY-SaleY)**2)));
run;

proc sort data=&libname..Comp1Run1;
by Comp AdjEmv;
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
	create table C1Rw&n as
	select * from &libname..Comp1Run1 
	where InvPin = &&Comp1_Pin&n;
	quit;
	run;

	proc sql outobs=1;
	create table InC1R&n as
	select InvPin as A_Pin,InvNbhd as B_Nbhd,InvTla as C_Tla,InvGar as D_Gar,InvExt as E_ErfExt,InvQual as F_Qual,InvCond as G_Cond,InvView as H_View,InvEmv as L_Emv
	from C1Rw&n;quit;run;

	proc transpose data=InC1R&n out=TrInC1R&n (rename=(Col1=Subject)) ;
	var _all_ ;
	run;

	proc sql;
	create table SC1R&n as
	select SalePin as A_Pin,SaleNbhd as B_Nbhd,SaleTla as C_Tla,SaleGar as D_Gar,SaleExt as E_ErfExt,SaleQual as F_Qual,SaleCond as G_Cond,SaleView as H_View,Dist as I_Dist,SPrice as J_Sale,SaleEmv as L_Emv,
	AdjEmv as K_AdjEmv,Comp as M_CompRating from C1Rw&n;quit;run;

	proc transpose data=SC1R&n out=TrSC1R&n (rename = (_name_=Variables Col1=COMP1 Col2 = COMP2 Col3 = COMP3 Col4=COMP4 Col5=COMP5));
	var _all_;
	run;

	proc sql;
	create table C1R&n&&Nbhd&i as 
	select a.*,b.Subject 
	from TrSC1R&n as a left join TrInC1R&n as b on a.Variables=b._name_;
	quit;
	run;

	data C1R&n&&Nbhd&i;
	retain Subject;
	set C1R&n&&Nbhd&i;
	run;

	data C1R&n&&Nbhd&i;
	retain Variables;
	label Variables = Variables;
	set C1R&n&&Nbhd&i;
	run;

	proc sort data = C1R&n&&Nbhd&i;
	by Variables;
	run;

	data C1Rw1&&Nbhd&i;
	set C1Rw1;

	proc sql noprint;
	create table C1R1 as 
	select * from C1R&n&&Nbhd&i;
   	insert into C1R1 set Variables="";
	quit;
	run;

    data C1R1;
	set C1R1;
	If Variables = "A_Pin" then delete;
	if Variables ="B_Nbhd" then delete;
    if Variables ="C_Tla" then delete;
    if Variables ="D_Gar" then delete;
    if Variables ="E_ErfExt" then delete;
    if Variables ="F_Qual" then delete;
    if Variables ="G_Cond" then delete;
    if Variables ="H_View" then delete;
    if Variables ="J_Sale" then delete;
    if Variables ="K_AdjEmv" then delete;
    if Variables ="M_CompRating" then delete;
    if Variables ="L_Emv" then delete;
    if Variables ="I_Dist" then delete;
	run;

	%end; 

		%do n=2 %to &Obs_1;
        proc append base=C1R1&&Nbhd&i data=C1R1 force;
		run;
    	proc append base=C1R1&&Nbhd&i data=C1R&n&&Nbhd&i force;
		run;
		proc append base=C1Rw1&&Nbhd&i data=C1Rw&n force;
		run;
		%end;

			proc datasets;
			copy in=work out=&&libname move;
			select C1R1&&Nbhd&i;
			quit;

			proc datasets;
			copy in=work out=&&libname move;
			select C1Rw1&&Nbhd&i;
			quit;

			data &&libname..C1Rw1&&Nbhd&i (Keep = InvPin SalePin);
			set &&libname..C1Rw1&&Nbhd&i;
			run;

			proc datasets library=work kill;
			quit;

			
											
%end;

*reset log output;
/*proc printto;*/
/*run;*/

%mend TakeNbhd;
%TakeNbhd (libname=NMBM,InvData=Inv,SaleData=Sales,NewData_1=Comps_1,NewData_2=Comps_2);



