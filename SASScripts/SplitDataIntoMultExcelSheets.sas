

options mprint mlogic symbolgen;

%macro Send_to_Excel( libname =,SAS_data=,output_name = ,Sheet_category = );
proc sql noprint;
select type
into :cat_type
from DICTIONARY.COLUMNS
where upcase(name) = upcase("&Sheet_category.")
and upcase(libname) = upcase("&libname.")
and upcase(memname) = upcase("&SAS_data.");
quit;

proc sql noprint;

/* determine total no of sheets required to be created */ 

select strip(put(count(distinct(&Sheet_category)),best2.))
into :tot_cat_cnt
from &libname..&sas_data;
select distinct &Sheet_category 
into :idcat1 - :idcat&tot_cat_cnt
from &libname..&sas_data;
%let catcnt = &sqlobs;
quit; 

/* Create Excel file in DMM_TEMP Folder */ 

%do i = 1 %to &tot_cat_cnt;
proc export data=&libname..&sas_data (where=(&Sheet_category = 
%if &cat_type = char %then "&&idcat&i";
%else &&idcat&i;

))

OUTFILE="&output_name..xls" REPLACE;
sheet = "&&idcat&i";
RUN;
%end;
%mend Send_to_Excel;

%Send_to_Excel(libname =Lib,SAS_data=Untitled17,output_name = C:\eValuations\VRSheet,Sheet_category = Allotment);


