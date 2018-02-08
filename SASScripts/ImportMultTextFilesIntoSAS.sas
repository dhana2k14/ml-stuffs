
options mprint mlogic symbolgen;
filename indata pipe 'dir C:\eValuations\NMBM13\Sales\NMNM_DeedsNov2012 /b';
data file_list;
length fname $20;
infile indata truncover; /* infile statement for file names */
input fname $20.; /* read the file names from the directory */
call symput ('num_files',_n_); /* store the record number in a macro variable */
run;

%macro fileread;
%do j=1 %to &num_files;
data _null_;
set file_list;
if _n_=&j;
call symput ('filein',fname);
run;

data var_names;
length x1-x17 $50;
infile 'C:\eValuations\NMBM13\Sales\NMNM_DeedsNov2012\&filein'  delimiter=',' obs=1 missover;
input (x1-x17) ($) ;
run;

%macro varnames;
%do i=1 %to 17;
%global v&i;
data _null_;
set var_names;
call symput("v&i",x&i);
run;
%end;
%mend varnames;
%varnames;

/* read the data lines into a temporary file */
data temp;
infile 'C:\eValuations\NMBM13\Sales\NMNM_DeedsNov2012\&filein' delimiter=',' obs=7 missover;
input (&v1 &v2 &v3 &v4 &v5 &v6 &v7 &v8 &v9 &v10 &v11 &v12 &v13 &v14 &v15 &v16 &v17) ($);
run;

/* assemble the individual files */
%if &j=1 %then %do;
data data_all;
set temp;
run;
%end;
%else %do;
data data_all;
set data_all
temp;
run;
%end;
%end; /* end of do-loop with index j */
%mend fileread;
%fileread;
