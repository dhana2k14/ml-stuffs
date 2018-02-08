
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

data &libout..C1RNbhd&i;
set &libin..C1R&&Nbhd&i;
run;

data &libout..C2RNbhd&i;
set &libin..C2R&&Nbhd&i;
run;
%end;

   %do n=2 %to &Nb;
   proc append base = &libout..C1RNbhd1 data=&libout..C1RNbhd&n force;
   run;
   proc append base = &libout..C2RNbhd1 data=&libout..C2RNbhd&n force;
   run;
   %end;

           proc datasets library=&libout;
           save C1RNbhd1 C2RNbhd1 C1rNb1 C2rNb1 T5;
           quit;

%mend combine;
%combine (LibIn=Emm,LibOut=Batch);


