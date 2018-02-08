
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

data &libout..C1rNb&i;
set &libin..C1r&&Nbhd&i;
run;

data &libout..C2rNb&i;
set &libin..C2r&&Nbhd&i;
run;
%end;

   %do n=2 %to &Nb;
   proc append base = &libout..C1rNb1 data=&libout..C1rNb&n force;
   run;
   proc append base = &libout..C2rNb1 data=&libout..C2rNb&n force;
   run;
   %end;

           proc datasets library=&libout;
           save C1rNb1 C2rNb1;
           quit;

%mend combine;
%combine (LibIn=NMBM,LibOut=Batch1);


proc append base=batch1.C2rnb1 data=nmbm.C2rsrfront force;
run;
