
options mprint mlogic symbolgen;
%macro combine (LibIn=,LibOut=);

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

data &libout..C1RSub&i;
set &libin..C1R1&&Sub&i;
run;

data &libout..C2RSub&i;
set &libin..C2R1&&Sub&i;
run;
%end;

   %do n=2 %to &Sub;
   proc append base = &libout..C1RSub1 data=&libout..C1RSub&n force;
   run;
   proc append base = &libout..C2RSub1 data=&libout..C2RSub&n force;
   run;
   %end;

           proc datasets library=&libout;
           save C1RSub1 C2RSub1;
           quit;

%mend combine;
%combine (LibIn=Coj,LibOut=Batch);


