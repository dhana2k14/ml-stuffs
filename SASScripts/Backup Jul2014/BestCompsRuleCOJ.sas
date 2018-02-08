
options mprint mlogic symbolgen;
%macro newComps (libin=,LibOut=);

*set log to temp file;
proc printto log='c:\mylog.log';
run;

data _null_;
set &libin..Suburb end = lastrec;
if lastrec then do;
Call Symput ('Sub',_n_);
end;
run;

%do i=1 %to &Sub;
%global Sub&i;
data _null_;
set &libin..Suburb;
if &i=_n_;
call symput ("Sub&i",InvSuburb);
run;

proc sql noprint;
create table &libin..InvPin_1 as 
select distinct(InvPin) 
from &libin..C1r1&&Sub&i
quit;
run;

data _null_;
set &libin..InvPin_1 end = lastrec;
if lastrec then do;
Call Symput ('Obs_1',_n_);
end;
run;

	%do n=1 %to &Obs_1;
	data _null;
	set &libin..InvPin_1;
	if &n=_n_;
	call symput ("Comp1_Pin&n",InvPin);
	run;
	proc sql;
	create table C1Rw&n as
	select InvPin,SalePin from &libin..C1r1&&sub&i 
	where InvPin = &&Comp1_Pin&n;
	quit;
	run;

	proc sql outobs=1;
	create table InC1R&n as
	select InvPin as A_Pin from C1Rw&n;quit;run;

	proc transpose data=InC1R&n out=TrInC1R&n (rename=(Col1=Subject)) ;
	var _all_ ;
	run;

	proc sql;
	create table SC1R&n as
	select SalePin as A_Pin from C1Rw&n;quit;run;

	proc transpose data=SC1R&n out=TrSC1R&n (rename = (_name_=Variables Col1=COMP1 Col2 = COMP2 Col3 = COMP3 Col4=COMP4 Col5=COMP5));
	var _all_;
	run;

	proc sql;
	create table C1R&n as 
	select a.*,b.Subject 
	from TrSC1R&n as a left join TrInC1R&n as b on a.Variables=b._name_;
	quit;
	run;

	data C1R&n;
	retain Subject;
	set C1R&n;
	run;

	data C1R&n;
	retain Variables;
	label Variables = Variables;
	set C1R&n;
	run;

	proc sort data = C1R&n;
	by Variables;
	run;   

    proc append base=&&libout..Comp2 data=c1r&n force;
    run;
    %end;		

	proc datasets library=work kill;
	quit;

%end;
*reset log output;
proc printto;
run;

%mend NewComps;

%NewComps(libin=Coj,LibOut=Batch);
