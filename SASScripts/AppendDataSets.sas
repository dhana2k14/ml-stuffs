

options mprint mlogic symbolgen;
%macro Merge (Libname=);

data _null_;
set &libname..Suburb end = lastrec;
if lastrec then do;
Call Symput ('NbCt',_n_);
end;
run;

%do i=1 %to &NbCt;
%global Suburb&i;
data _null_;
set &libname..Suburb;
if &i=_n_;
call symput ("Suburb&i",InvSuburb);
run;

		data _null_;
		set &libname..InvPin_1 end = lastrec;
		if lastrec then do;
		Call Symput ('Obs_1',_n_);
		end;
		run;

	%do n=1 %to &Obs_1;
	data _null;
	set &libname..InvPin_1;
	if &n=_n_;
	call symput ("Comp1_Pin&n",InvPin);
	run;

	    %do n=2 %to &Obs_1;
		proc append base=C1R1&&Suburb&i data=C1R&n&&Suburb&i force;
		run;
		proc append base=WGC1R1&&Suburb&i data=WGC1R&n&&Suburb&i force;
		run;
		proc append base=DWC1R1&&Suburb&i data=DWC1R&n&&Suburb&i force;
		run;
		%end;
   %end;
%end;
%mend Merge;

%Merge(Libname=coj);
