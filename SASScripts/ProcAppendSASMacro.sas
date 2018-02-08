
/* Add Columns to the SAS Data Set */

proc sql;
alter table drive.pinrow50 add AGL_ELEC_2 char(255);
alter table drive.pinrow50 add AGL_EXTENT_2 char(255);
alter table drive.pinrow50 add AGL_RSA_2 char(255);
alter table drive.pinrow50 add AGL_SUMEXTENT_2 char(255);
alter table drive.pinrow50 add AGL_TOPO_2 char(255);
alter table drive.pinrow50 add AGL_TYPE_2 char(255);
alter table drive.pinrow50 add AGL_USECODE_2 char(255);
alter table drive.pinrow50 add AGL_WATER_2 char(255);
run;

/* Proc Append Data Sets Macro */

options mprint mlogic symbolgen;
%macro pivottable;
proc sql noprint;
create table trans_1 as 
select distinct(ID) 
from Trans1
quit;
run;

data _null_;
set trans_1 end = lastrec;
if lastrec then do;
Call Symput ('Obs_1',_n_);
end;
run;

%do n=1 %to &Obs_1;
proc append base=drive.PINROW40 data=drive.pinrow&n force;
run;
%end;
%mend pivottable;

%pivottable;

proc sort data=drive.pinrow40 nodupkey;
by id;
run;
