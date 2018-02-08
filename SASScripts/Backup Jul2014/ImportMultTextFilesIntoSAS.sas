
options mprint mlogic symbolgen;
filename indata pipe 'dir C:\Users\dhanasekaran\Desktop\Sales2012\Nov11Dec11Jan12 /b';
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
length x1-x42 $50;
infile 'C:\Users\dhanasekaran\Desktop\Sales2012\Nov11Dec11Jan12\&filein'  delimiter=',' obs=1 missover;
input (x1-x42) ($) ;
run;
%end;

%mend fileread;
%fileread;

%macro varnames;
%do i=1 %to 42;
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
infile 'C:\Users\dhanasekaran\Desktop\Sales2012\Nov11Dec11Jan12\&filein' delimiter=',' obs=7 missover;
input (&v1 &v2 &v3 &v4 &v5 &v6 &v7 &v8 &v9 &v10 &v11 &v12 &v13 &v14 &v15 &v16 &v17 &v18 &v19 &v20 &v21 &v22 &v23 &v24 &v25 &v26 &v27 &v28 &v29 &v30 &v31 &v32 &v33 &v34 &v35 
&v36 &v37 &v38 &v39 &v40 &v41 &v42) ($);
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
