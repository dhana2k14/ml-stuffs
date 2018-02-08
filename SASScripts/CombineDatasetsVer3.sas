
options mprint mlogic symbolgen;
%macro combine (LibIn=,LibOut=);

data _null_;
set &libin..Nbhd end = lastrec;
if lastrec then do;
Call Symput ('Nb',_n_);
end;
run;

%do i=1 %to &Nb;
%global Nbhd&i;
data _null_;
set &libin..Nbhd;
if &i=_n_;
call symput ("Nbhd&i",InvNbhd);
run;

data &libout..CRNb&i;
set &libin..C1R1&&Nbhd&i;
run;

data &libout..CLNb&i;
set &libin..C1Rw1&&Nbhd&i;
run;
%end;

   %do n=2 %to &Nb;
   proc append base = &libout..CRNb1 data=&libout..CRNb&n force;
   run;
   proc append base = &libout..CLNb1 data=&libout..CLNb&n force;
   run;
   %end;

           proc datasets library=&libout;
           save CRNb1 CLNb1;
           quit;

%mend combine;
%combine (LibIn=NMBM,LibOut=Batch);


