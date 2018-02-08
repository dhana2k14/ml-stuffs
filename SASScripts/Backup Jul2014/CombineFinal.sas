

%macro combine (Libin=,Libout=);

data _null_;
set &libin..Suburb end = lastrec;
if lastrec then do;
Call Symput ('Nb',_n_);
end;
run;

%do i=1 %to &Nb;
%global Suburb&i;
data _null_;
set &libin..Suburb;
if &i=_n_;
call symput ("Suburb&i",InvSuburb);
run;

data &&Libout..Comp1Repo1Sub&i;
set &libin..Comp1Repo1&&Suburb&i;
run;

data &&Libout..DWComp1Repo1Sub&i;
set &libin..DWComp1Repo1&&Suburb&i;
run;

data &&Libout..WGComp1Repo1Sub&i;
set &libin..WGComp1Repo1&&Suburb&i;
run;

%end;

    %do n=2 %to &Nb;

   proc append base = &&Libout..Comp1Repo1Sub&i data=&&Libout..Comp1Repo1Sub&n force;
   run;
   proc append base = &&Libout..WGComp1Repo1Sub&i data=&&Libout..WGComp1Repo1Sub&n force;
   run;
     proc append base = &&Libout..DWComp1Repo1Sub&i data=&&Libout..DWComp1Repo1Sub&n force;
     run;

   %end;

%mend combine;
%combine (Libin=Coj,Libout=batch);


