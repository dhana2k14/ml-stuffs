
options mprint mlogic symbolgen;
%macro combine (Libname=);

data _null_;
set &libname..Suburb end = lastrec;
if lastrec then do;
Call Symput ('Nb',_n_);
end;
run;

%do i=1 %to &Nb;
%global Suburb&i;
data _null_;
set &libname..Suburb;
if &i=_n_;
call symput ("Suburb&i",InvSuburb);
run;

data batch.CSub&i;
set &libname..C1R1&&Suburb&i;
run;

data batch.DSub&i;
set &libname..DC1R1&&Suburb&i;
run;

data batch.GSub&i;
set &libname..GC1R1&&Suburb&i;
run;

%end;

   %do n=2 %to &Nb;

   proc append base = batch.CSub1 data=batch.CSub&n force;
   run;
   proc append base = batch.GSub1 data=batch.GSub&n force;
   run;
   proc append base = batch.DSub1 data=batch.DSub&n force;
   run;


   %end;

%mend combine;
%combine (Libname=Coj);


