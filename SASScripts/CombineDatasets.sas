
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

data batch.Sub&i;
set &libname..Comp1Repo1&&Suburb&i;
run;

data batch.WGSub&i;
set &libname..WGComp1Repo1&&Suburb&i;
run;

data batch.DWSub&i;
set &libname..DWComp1Repo1&&Suburb&i;
run;

%end;

   %do n=2 %to &Nb;

   proc append base = batch.Sub1 data=batch.Sub&n force;
   run;
   proc append base = batch.WGSub1 data=batch.WGSub&n force;
   run;
   proc append base = batch.DWSub1 data=batch.DWSub&n force;
   run;


   %end;

%mend combine;
%combine (Libname=Coj);

/**/
/*proc append base = batch.sub1 data=batch.C1Sub1 force;*/
/*run;*/
/**/
/*proc append base = batch.WGsub1 data=batch.GC1Sub1 force;*/
/*run;*/
/**/
/*proc append base = batch.DWsub1 data=batch.DC1Sub1 force;*/
/*run;*/
/**/
/**/
/*data DWsub1;*/
/*set batch.DWsub1;*/
/*if Variables ="I_Sale" then delete;*/
/*run;*/
/**/
/*data Sub1;*/
/*set batch.Sub1;*/
/*if Variables ="B_Suburb" then delete;*/
/*if Variables ="C_Tla" then delete;*/
/*if Variables ="D_Gar" then delete;*/
/*if Variables ="E_ErfExt" then delete;*/
/*if Variables ="F_Qual" then delete;*/
/*if Variables ="G_Cond" then delete;*/
/*if Variables ="I_Sale" then delete;*/
/*if Variables ="J_AdjEmv" then delete;*/
/*if Variables ="L_CompRating" then delete;*/
/*if Variables ="K_Emv" then delete;*/
/*if Variables ="H_Dist" then delete;*/
/*run;*/



