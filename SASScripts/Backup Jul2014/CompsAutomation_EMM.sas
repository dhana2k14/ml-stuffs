
options mprint mlogic symbolgen;
%macro TakeNbhd (libname=,InvData=,SaleData=,NewData_1=,NewData_2=);

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
%global Nb&i;
data _null_;
set &libname..Nbhd;
if &i=_n_;
call symput ("Nbhd&i",InvNbhd);
run;

proc sql noprint;
create table &libname..&NewData_1 as 
select a.InvQual,a.InvCond,a.InvTla,a.InvNbhd,a.InvGba,a.InvGar,a.InvExt,a.InvPin,
a.InvEmv,a.InvX,a.InvY,b.SaleQual,b.SaleCond,b.SaleTla,b.SaleNbhd,b.SaleGba,b.SaleGar,b.SaleExt,
b.SalePin,b.SaleEmv,b.SPrice,b.SaleX,b.SaleY from &libname..&InvData as a,&libname..&SaleData as b where a.InvPin NE b.SalePin
AND a.InvNbhd="&&Nbhd&i" AND b.SaleNbhd="&&Nbhd&i";
quit;run;

proc sql noprint;
create table &libname..&NewData_2 as 
select a.InvQual,a.InvCond,a.InvTla,a.InvNbhd,a.InvGba,a.InvExt,a.InvPin,
a.InvEmv,a.InvX,a.InvY,b.SaleQual,b.SaleCond,b.SaleTla,b.SaleNbhd,b.SaleGba,b.SaleExt,
b.SalePin,b.SaleEmv,b.SPrice,b.SaleX,b.SaleY from &libname..&InvData as a,&libname..&SaleData as b where a.InvPin EQ b.SalePin
AND a.InvNbhd="&&Nbhd&i" AND b.SaleNbhd="&&Nbhd&i";
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

data &libname..Comp1Run1;
set &libname..Comp1Run1;
format InvEmv comma12.;
format SaleEmv comma12.;
format AdjEmv comma12.;
AdjEmv = ABS(InvEmv-SaleEmv);
If InvPin=SalePin then AdjEmv=0;
Dist = round(SQRT((InvX-SaleX)**2+((InvY-SaleY)**2)));
run;

proc sort data=&libname..Comp1Run1;
by AdjEmv;
run;

data &libname..Comp2Run1;
set &libname..Comp2Run1;
format InvEmv comma12.;
format SaleEmv comma12.;
format AdjEmv comma12.;
AdjEmv = ABS(InvEmv-SaleEmv);
If InvPin=SalePin then AdjEmv=0;
Dist = round(SQRT((InvX-SaleX)**2+((InvY-SaleY)**2)));
run;

proc sort data=&libname..Comp2Run1;
by AdjEmv;
run;

proc sql noprint;
create table &libname..InvPin_1 as 
select distinct(InvPin) 
from &libname..Comp1Run1
quit;
run;

proc sql noprint;
create table &libname..InvPin_2 as 
select distinct(InvPin) 
from &libname..Comp2Run1
quit;
run;


data _null_;
set &libname..InvPin_1 end = lastrec;
if lastrec then do;
Call Symput ('Obs_1',_n_);
end;
run;

data _null_;
set &libname..InvPin_2 end = lastrec;
if lastrec then do;
Call Symput ('Obs_2',_n_);
end;
run;

	%do n=1 %to &Obs_1;
	data _null;
	set &libname..InvPin_1;
	if &n=_n_;
	call symput ("Comp1_Pin&n",InvPin);
	run;
	proc sql outobs=5;
	create table C1R&n as
	select * from &libname..Comp1Run1 
	where InvPin = &&Comp1_Pin&n;
	quit;
	run;

	data C1R&&Nbhd&i;
	set C1R1;

	%end; 

   %do n=1 %to &Obs_2;
	data _null;
	set &libname..InvPin_2;
	if &n=_n_;
	call symput ("Comp2_Pin&n",InvPin);
	run;
	proc sql outobs=5;
	create table C2R&n as
	select * from &libname..Comp2Run1 
	where InvPin = &&Comp2_Pin&n;
	quit;
	run;

	data C2R&&Nbhd&i;
	set C2R1;

	%end; 

		%do n=2 %to &Obs_1;
        proc append base=C1R&&Nbhd&i data=C1R&n force;
		run;
		%end;

        %do n=2 %to &Obs_2;
        proc append base= C2R&&Nbhd&i data=C2R&n force;
		run;
		%end;

			proc datasets;
			copy in=work out=&libname move;
			select C1R&&Nbhd&i C2R&&Nbhd&i ;
			quit;

			data &libname..C1R&&Nbhd&i (Keep = InvPin SalePin Comp);
			set &libname..C1R&&Nbhd&i;
			run;

			data &libname..C2R&&Nbhd&i (Keep = InvPin SalePin Comp);
			set &libname..C2R&&Nbhd&i;
			run;
/**/
/*			proc datasets library=work kill;*/
/*			quit;*/
/*		*/
											
%end;

*reset log output;
/*proc printto;*/
/*run;*/

%mend TakeNbhd;
%TakeNbhd (libname=EMM,InvData=Inv,SaleData=Sales,NewData_1=Comps_1,NewData_2=Comps_2);



