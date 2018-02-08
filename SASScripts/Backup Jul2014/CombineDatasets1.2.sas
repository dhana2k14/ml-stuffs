
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

data batch.C1Sub&i;
set &libname..C1&&Suburb&i;
run;

data batch.D1Sub&i;
set &libname..D1&&Suburb&i;
run;

data batch.G1Sub&i;
set &libname..G1&&Suburb&i;
run;

%end;

   %do n=2 %to &Nb;

   proc append base = batch.C1Sub1 data=batch.C1Sub&n force;
   run;
   proc append base = batch.G1Sub1 data=batch.G1Sub&n force;
   run;
   proc append base = batch.D1Sub1 data=batch.D1Sub&n force;
   run;


   %end;

%mend combine;
%combine (Libname=Coj);



