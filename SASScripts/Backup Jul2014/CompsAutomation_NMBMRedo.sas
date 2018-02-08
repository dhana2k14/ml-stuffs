
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
call symput ("Nb&i",InvNbhd);
run;

proc sql noprint;
create table &libname..&NewData_1 as 
select a.InvQual,a.InvCond,a.InvView,a.InvTla,a.InvNbhd,a.InvGba,a.InvGar,a.InvExt,a.InvPin,
a.InvEmv,a.InvX,a.InvY,b.SaleQual,b.SaleCond,b.SaleTla,b.SaleView,b.SaleNbhd,b.SaleGba,b.SaleGar,b.SaleExt,
b.SalePin,b.SaleEmv,b.SPrice,b.SaleX,b.SaleY from &libname..&InvData as a,&libname..&SaleData as b where a.InvPin NE b.SalePin
AND a.InvNbhd="&&Nb&i" AND b.SaleNbhd="&&Nb&i";
quit;run;

proc sql noprint;
create table &libname..&NewData_2 as 
select a.InvQual,a.InvCond,a.InvView,a.InvTla,a.InvNbhd,a.InvGba,a.InvExt,a.InvPin,
a.InvEmv,a.InvX,a.InvY,b.SaleQual,b.SaleCond,b.SaleView,b.SaleTla,b.SaleNbhd,b.SaleGba,b.SaleExt,
b.SalePin,b.SaleEmv,b.SPrice,b.SaleX,b.SaleY from &libname..&InvData as a,&libname..&SaleData as b where a.InvPin EQ b.SalePin
AND a.InvNbhd="&&Nb&i" AND b.SaleNbhd="&&Nb&i";
quit;run;

proc append base=&libname..&NewData_1 data=&libname..&NewData_2 force;
run;

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

	proc sql outobs=1;create table C1S&n as select InvPin as A_Pin from C1R&n where InvPin=&&Comp1_Pin&n;quit;run;

	proc transpose data=C1S&n out=TC1S&n (rename=(Col1=Subject));
	var _all_;
	run;

    proc sql;create table C1C&n as select SalePin as A_Pin from C1R&n where InvPin=&&Comp1_Pin&n;quit;run;

	proc transpose data=C1C&n out=TC1C&n (rename=(_name_=Variables Col1=Comp1 Col2=Comp2 Col3=Comp3 Col4=Comp4 Col5=Comp5));
	var _all_;
	run;

    proc sql;
	create table C1L&n as 
	select a.*,b.Subject 
	from TC1C&n as a left join TC1S&n as b on a.Variables=b._name_;
	quit;
	run;

	data C1L&n;
	retain Subject;
	set C1L&n;
	run;

	data C1L&n;
	retain Variables;
	label Variables = Variables;
	set C1L&n;
	run;

	data C1R&&Nb&i;
	set C1R1;
	run;

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

	proc sql outobs=1;create table C2S&n as select InvPin as A_Pin from C2R&n where InvPin=&&Comp2_Pin&n;quit;run;

	proc transpose data=C2S&n out=TC2S&n (rename=(Col1=Subject));
	var _all_;
	run;

    proc sql;create table C2C&n as select SalePin as A_Pin from C2R&n where InvPin=&&Comp2_Pin&n;quit;run;

	proc transpose data=C2C&n out=TC2C&n (rename=(_name_=Variables Col1=Comp1 Col2=Comp2 Col3=Comp3 Col4=Comp4 Col5=Comp5));
	var _all_;
	run;

	proc sql;
	create table C2L&n as 
	select a.*,b.Subject 
	from TC2C&n as a left join TC2S&n as b on a.Variables=b._name_;
	quit;
	run;

	data C2L&n;
	retain Subject;
	set C2L&n;
	run;

	data C2L&n;
	retain Variables;
	label Variables = Variables;
	set C2L&n;
	run;

	data C2R&&Nb&i;
	set C2R1;
	run;
   	
	%end; 

		filename complist "C:\Users\dhanasekaran\Desktop\CompList.csv";
		data C1L_&&Nb&i;
		infile complist delimiter=',' firstobs=2;
		input Variables $ Subject $ Comp1 $ Comp2 $ Comp3 $ Comp4 $ Comp5 $;
		run;

		filename complist "C:\Users\dhanasekaran\Desktop\CompList.csv";
		data C2L_&&Nb&i;
		infile complist delimiter=',' firstobs=2;
		input Variables $ Subject $ Comp1 $ Comp2 $ Comp3 $ Comp4 $ Comp5 $;
		run;

		data C1L_&&Nb&i;
		set C1L_&&Nb&i;
		drop Variables Subject Comp1 Comp2 Comp3 Comp4 Comp5;
		rename Var=Variables;
		rename Sub=Subject;
		rename C1=Comp1;
		rename C2=Comp2;
		rename C3=Comp3;
		rename C4=Comp4;
		rename C5=Comp5;
		keep _all_;
		Var=put(Variables,$10.);
		Sub=input(Subject,best12.);
		C1=input(Comp1,best12.);
		C2=input(Comp2,best12.);
		C3=input(Comp3,best12.);
		C4=input(Comp4,best12.);
		C5=input(Comp5,best12.);
		run;

		data C2L_&&Nb&i;
		set C2L_&&Nb&i;
		drop Variables Subject Comp1 Comp2 Comp3 Comp4 Comp5;
		rename Var=Variables;
		rename Sub=Subject;
		rename C1=Comp1;
		rename C2=Comp2;
		rename C3=Comp3;
		rename C4=Comp4;
		rename C5=Comp5;
		keep _all_;
		Var=put(Variables,$10.);
		Sub=input(Subject,best12.);
		C1=input(Comp1,best12.);
		C2=input(Comp2,best12.);
		C3=input(Comp3,best12.);
		C4=input(Comp4,best12.);
		C5=input(Comp5,best12.);
		run;	
	
		%do n=1 %to &Obs_1;		
		proc append base=C1L_&&Nb&i data=C1L&n force;
	    run;
		%end;
	
		%do n=1 %to &Obs_2;
		proc append base=C2L_&&Nb&i data=C2L&n force;
	    run;
		%end;

		%do n=2 %to &Obs_1;
		proc append base=C1R&&Nb&i data=C1R&n force;
	    run;
		%end;

        %do n=2 %to &Obs_2;
        proc append base= C2R&&Nb&i data=C2R&n force;
		run;
		%end;

			proc datasets;
			copy in=work out=&libname move;
			select C1R&&Nb&i C2R&&Nb&i;
			quit;

			data C1L_&&Nb&i;
			set  C1L_&&Nb&i;
			if Variables="Dummy" then delete;
			run;

			data C2L_&&Nb&i;
			set  C2L_&&Nb&i;
			if Variables="Dummy" then delete;
			run;

			proc datasets;
			copy in=work out=list move;
			select C1L_&&Nb&i C2L_&&Nb&i;
			quit;

			data &libname..C1R&&Nb&i (Keep = InvPin SalePin Comp);
			set &libname..C1R&&Nb&i;
			run;

			data &libname..C2R&&Nb&i (Keep = InvPin SalePin Comp);
			set &libname..C2R&&Nb&i;
			run;

			proc datasets library=work kill;
			quit;
											
%end;

*reset log output;
/*proc printto;*/
/*run;*/

%mend TakeNbhd;
%TakeNbhd (libname=NMBM,InvData=Inv,SaleData=Sales,NewData_1=Comps_1,NewData_2=Comps_2);



