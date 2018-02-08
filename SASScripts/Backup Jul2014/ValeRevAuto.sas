
/*options mprint mlogic symbolgen;*/
/*%macro Suburb (libname=,SubData=,);*/
/**/
/*data _null_;*/
/*set &libname..&SubData end = lastrec;*/
/*if lastrec then do;*/
/*Call Symput ('SubCt',_n_);*/
/*end;*/
/*run;*/
/**/
/*%do i=1 %to &SubCt;*/
/*data _null_;*/
/*set &libname..&SubData;*/
/*if &i=_n_;*/
/*call symput ("S&i",Suburb);*/
/*run;*/
/*	*/
/*	data _null_;*/
/*	set &libname..SaleStat;*/
/*	if &i=_n_;*/
/*	call symput ("p10S&i",Pctl10);*/
/*	call symput ("p25S&i",Pctl25);*/
/*	call symput ("p50S&i",Pctl50);*/
/*	call symput ("p90S&i",Pctl90);*/
/*    run;*/
/**/
/*	proc sql noprint;*/
/*	create table T&&S&i as */
/*	select * from Sup9Rev */
/*	where Suburb="&S&i";*/
/*	quit;*/
/*	run;*/
/*%end;*/
/**/
/*%mend Suburb;*/
/*%Suburb (libname=Work,SubData=Suburb);*/


proc sql noprint;
create table Merge_Stat as
select a.*,b.Pctl10,b.Pctl25,b.Pctl50,b.Pctl90 from Sup9Rev as a left join SaleStat as b on a.Suburb=b.Suburb;
quit;
run;

data Merge_Stat_1;
set Merge_Stat;
if Pctl10<=EmvTla<=Pctl90 then RevFlag=1;
else RevFlag=2;
run;

proc sql;select count(Pin) from Merge_Stat_1 where RevFlag=2;quit;run;





