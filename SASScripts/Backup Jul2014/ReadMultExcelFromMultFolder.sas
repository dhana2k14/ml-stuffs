
IMPORT MULTIPLE EXCEL WORKSHEETS

  I. READ THE NAMES OF ALL FOLDERS IN A GIVEN DIRECTORY
 II. IDENTIFY AND EXTRACT ALL EXCEL FILE NAMES IN A SPECIFIED FOLDER
III. IMPORT MULTIPLE WORKSHEETS FROM ONE EXCEL FILE
 IV. IMPORT MULTIPLE EXCEL FILES WITH SAME STRUCTURE

IMPORTANT NOTICE: For the purposes of this section, none of the directory or 
file names should include any spaces. If you need a space within a path or 
file name, enter the underscore at that point, e.g., my_research_data.


I. READ THE NAMES OF ALL FOLDERS IN A GIVEN DIRECTORY

The FILENAME statement with a "pipe" allows you to read all the folder names 
under a given subdirectory. Assume you want to extract all the folder names 
entered into the primary directory with the drive and path name c:\data\grf. 


FileName MyDir Pipe "dir c:\data\grf /AD /B /S";

* /B : return the folder names only;
* /S : list subdirectories below the one specified;

DATA all_dir;
INFORMAT path $55.;
INFILE MyDir lrecl=300 truncover;
INPUT @1 path ;
run;

PROC PRINT DATA =all_dir NOobs; VAR path; run;

  /* Path */

  c:\data\grf\pf1_p1
  c:\data\grf\pf1_p2
  c:\data\grf\pf1_p1\pf1_p1_t1
  c:\data\grf\pf1_p1\pf1_p1_t2
  c:\data\grf\pf1_p1\pf1_p1_t7
  c:\data\grf\pf1_p2\pf1_p2_t1
  c:\data\grf\pf1_p2\pf1_p2_t2


/* Notice that all the path names found with c:\data\grf are listed. However, 
your objective is to read only the folder names directly within one specified 
directory into a SAS dataset, say c:\data\grf\pf1_p1. Notice that the ouput 
shown above for this particular path has 3 path names under it. You also will 
need to extract the final number (trial) always placed as the final one or two 
digits at the end of the folder_name for identification purposes:

Obs   folder_name     trial

 1     pf1_p2_t1        1
 2     pf1_p2_t3        3
 3     pf1_p2_t7        7


First, assign the primary directory path name with a FILENAME:*/

FILENAME mydat pipe "dir c:\data\grf\pf1_p1\*. /b" ;

/* [Note: the *. notation after the path name will list just the folder names in 
 that particular directory, not any file names that have a filetype suffix.]*/

DATA tr;
LENGTH folder_name $12 f1 $2;
INFILE mydat truncover;
INPUT file_name ;
f1 = SUBSTR(scan(folder_name,3,'_'),2,2);
trial = INPUT(f1,2.0);
RUN;

PROC SORT DATA=tr; BY trial;

PROC PRINT DATA=tr;
VAR folder_name trial;
TITLE1 "folders";
run;

/* (Note that the printed output for this dataset is listed above)

At this point you can make two macro variables with PROC SQL
   - trls contains all the trial numbers found separated by commas (or spaces)
   - nm_tr is the number of files found */

PROC SQL NOPRINT;
SELECT count(distinct folder_name) into: nm_tr
       from tr;
SELECT distinct trial
       into: trls separated by " , "
       from tr ;
quit;

/* In summary, SAS read 5 folder names with the trial numbers 1, 3, 7, 18, and 
20. */

%PUT Number of Trials=  &nm_tr   Trials=  &trls. ;

 /* Number of Trials= 3   Trials= 1 , 3 , 7

The second macro variable, &trls, can be entered into a DO statement in a DATA 
step, or the individual trial numbers can be extracted with the %SCAN function 
within a macro.



NOTE: If you absolutely must have spaces in the directory path and you enter 
them into the FILENAME statement above, a "File Not Found" error message appears 
in the log window. One solution to read a path name which includes spaces is as 
follows:*/

FILENAME mydir pipe 'dir "C:\Documents and Settings\data\*." /b';

/* With this statement, you will get the directory listing you expect. The solution 
is to change the double quotes that enclose the entire pipe command to single 
quotes and add the double quotes to the command line passed to Windows, as shown 
above. It's a much more difficult problem if you have any macro variables in the 
path name, so it still is good practice to avoid spaces altogether when 
assigning path or file names.




II. IDENTIFY AND EXTRACT ALL EXCEL FILE NAMES IN A SPECIFIED FOLDER

Assume you have a folder which contains many files of different types and you 
want to extract the file names of one particular type (e.g., Excel workbooks); 
either of the following two DATA steps will extract their file names:*/


DATA xls_files(keep=file_name);
LENGTH file_name $30 ;
rc=filename("dir","c:\data");
  d=dopen("dir");
  n=dnum(d);
  do i=1 to n;
    file_name=dread(d,i);
    if LOWCASE(scan(file_name,2,'.')) EQ 'xls' then output ;
  end;
run;


PROC PRINT DATA=xls_files; run;

/* < see below > */



FILENAME lst pipe 'dir c:\data /B';

DATA xls_names;
INFILE lst lrecl=256 pad;
INPUT @;
put _infile_;
input file_name $256.;
if SCAN(LOWCASE(file_name),2,'.')='xls' then output;
run ;

proc print DATA=xls_names; run;


/* Both DATA steps listed above produce a dataset containing the excel file names 
stored in the c:\data subdirectory:

Obs file_name

  1  file_name1.xls
  2  file_name2.xls




III. IMPORT MULTIPLE WORKSHEETS FROM ONE EXCEL FILE

Suppose you need to import two or more Excel worksheets with worksheet names 
such as x_y, cop, and ml_avg into three SAS datasets. It is assumed their 
structure and format are such that they are ready to be read into SAS as 
described on the previous pages. The objective is to read these worksheets 
without writing their prefix names directly into multiple statements of the PROC 
IMPORT or the DATA step. The resulting SAS datasets will be assigned the same 
names as found on the worksheet tabs.

First, if you know the worksheet names of each workbook. With Version 9, here is 
a slick way to determine these names with SQL:*/

LIBNAME exbk excel 'c:\sas\excel\test.xls' ;

PROC SQL;
  CREATE TABLE sheets AS 
  SELECT distinct memname 
  FROM DICTIONARY.COLUMNS 
  WHERE libname='EXBK' AND memtype='DATA' and index(memname,'$'); 
QUIT;

LIBNAME exbk clear;

DATA sheets; SET sheets;

/* need to produce values that don't have a single quote or the $ in
  the contents of each sheet name;*/

sheet_name = compress(memname,"'$"); * remove the $ and quotation marks ;

PROC PRINT DATA=sheets NOobs n; run;

/*The output identifies this excel file contains three worksheets with names:

memname        sheet_name

'error$'          error
'mmseq$'          mmseq
'test_data$'      test_data

N = 3

Excel worksheet names are seen as special cases of named ranges, so SAS appends 
a $ to the end of the sheet names it identifies. This allows you to distinguish 
named ranges from worksheet names. In this example, the Excel sheet names have 
now been placed in a dataset called sheets identified with the variable 
sheet_name. This section shows how to read the contents of these worksheets into 
SAS datasets.


Enter work sheet names into a macro variable

One solution is to enter the individual worksheet names into a space delimited 
macro variable called "list". Returning to the example from the previous 
section, you can do this manually:*/

%LET files = error mmseq test_data;

/* You can take the worksheet names generated by PROC SQL and have a DATA _null_ 
step place these names in a macro variable for you:*/

DATA _null_;
SET sheets END=eof;
LENGTH name $99 ; /* length needs to be at least as long as the number
                    of characters in worksheet names plus a space for
                    each worksheet name;*/
RETAIN name ' ';
NAME=CATX(' ',name,sheet_name);
IF eof THEN CALL SYMPUT("files",name);
run;

%PUT file list = &files. ;

file list = error mmseq test_data


/* You can then invoke a %DO loop nested within a SAS macro which will read each 
Excel worksheet into a SAS dataset with the excel worksheet name extracted from 
the macro variable &list in the order they appear.*/

%MACRO _import(book,list);

%LET num=1;
%LET sheet_name=%SCAN(&list.,&num.);
%PUT file &num = &sheet_name.;

%DO %WHILE(&sheet_name. NE  );

PROC IMPORT DATAFILE= "c:\data\&book..xls"
     OUT = &sheet_name.(DROP= F:) DBMS=excel2000 REPLACE;
GETNAMES=yes;
SHEET="&sheet_name";
RUN;


DATA &sheet_name;
SET &sheet_name;
dataset = "&sheet_name" ;
Run;

%LET num=%eval(&num.+1);
%LET sheet_name=%scan(&list,&num.);

%END;

%MEND _import;


/* assume your data have been saved in an Excel workbook called test.xls
  with the extracted worksheet names:*/
;   

%LET ex_wkbk=test ;                   /* enter the prefix of the file name only;*/
%LET files = error mmseq test_data;   /* enter the list of worksheet names;*/

%_import(&ex_wkbk.,&files.)

PROC PRINT DATA=error(OBS=10) NOobs; RUN;
PROC PRINT DATA=mmseq(OBS=10) NOobs; RUN;
PROC PRINT DATA=test_data(OBS=10) NOobs; RUN;


/*IV. IMPORT MULTIPLE EXCEL FILES WITH SAME WORKSHEET STRUCTURE

Suppose you want to import two or more Excel workbooks (each containing one 
spreadsheet) with file names such as data1.xls, data2.xls, data3.xls, etc. into 
separate SAS datasets. The objective is to import these files without writing 
their prefix names directly into the PROC IMPORT step. The output datasets are 
assigned to have the same names as the prefix of the excel files.

With many Excel files, one solution is to make a list of file prefix names 
(space delimited) in a macro variable and then have a macro read each Excel file 
listed in the macro variable.*/

%MACRO _import(list);

%LET num=1;
%LET wkbnm=%SCAN(&list,&num);
%PUT file &num = &wkbnm;

%DO %WHILE(&wkbnm NE );

PROC IMPORT DATAFILE= "c:\data\&wkbnm..xls"
     OUT = &wkbnm DBMS=excel2000 REPLACE;
     GETNAMES=yes;
RUN;

%LET num=%eval(&num+1);
%LET wkbnm=%scan(&list,&num);


%END;

%MEND _import;


/* assume your data have been saved in Excel files in one subdirectory
  with the workbook names: dat1.xls dat2.xls dat3.xls ;*/ 

%LET files= data1 data2 data3 ;

%_import(&files)

PROC PRINT DATA=data1(OBS=10) NOobs; RUN;
PROC PRINT DATA=data2(OBS=10) NOobs; RUN;
PROC PRINT DATA=data3(OBS=10) NOobs; RUN;

/*If all files have exactly the same data structure and thus could be appended to 
one another, this can be accomplished in one DATA step entering a SET statement 
which has the macro variable which contains the names of the SAS datasets read 
from Excel files:*/

DATA all;
SET &files;
RUN;



/* Read Multiple Data Files with the FILENAME statement and pipe option

Another method to read one worksheet from many Excel workbooks or many text 
files all placed into one subdirectory without entering their file names is to 
apply the pipe option with the FILENAME statement.*/

* format for path and file with no spaces;

FILENAME excl pipe "dir/b C:\sas\excel\dat*.xls" ;  * for excel files;
FILENAME txt  pipe "dir/b C:\sas\excel\LogK*.txt" ; * for txt files;

* if path or file names contain spaces, surround them with double quotes;

FILENAME mydat pipe "dir/b ""C:\data\new data from summer\*.xls"" " ;


DATA all_files;
LENGTH fl_nm $15 file_name $10 ;
DROP fl_nm ;
INFILE excl truncover END=last;
INPUT fl_nm ;
file_name=scan(fl_nm,1,'.');
IF last=1 THEN CALL SYMPUT("nfiles",put(_n_,4.));
RUN;

%PUT &nfiles;

PROC PRINT DATA=all_files NOobs n; run;

* place file names on a single record ;

PROC TRANSPOSE DATA=all_fls OUT=tr_fls(drop=_name_) prefix=_;
VAR file_name; id file_name; run;

proc print DATA=tr_fls NOobs; options ls=76; run;

* Put all file names in a macro variable;

PROC SQL NOPRINT;
  SELECT DISTINCT NAME INTO :VarList SEPARATED BY " "
  FROM Dictionary.Columns
  WHERE UPCASE(Libname)="WORK" AND UPCASE(Memname)="TR_FLS";
QUIT;

%PUT Varlist=&VarList;


%macro _imprt;

%DO i=1 %to &nfiles;

/* put file name into a macro variable (one step);*/

DATA _null_; rec = &i;
SET all_files point=rec;
CALL SYMPUT ("dsn",TRIM(file_name));
STOP;

RUN;

%put "Reading file &i. -----> " &dsn. ;

* Read designated excel file;

PROC IMPORT DATAFILE="c:\sas\excel\&dsn..xls"
                OUT = work.&dsn. DBMS=EXCEL2000 REPLACE;
GETNAMES=YES;
RUN;

* add the file name to dataset;

DATA &dsn. ; SET &dsn. ; 
LENGTH file $8 ;
file = "&dsn.";
RUN;

* Read text files with a DATA step;

DATA &dsn. ;
INFILE "c:\sas\intro\data\&dsn..txt" END=lastrec firstobs=2 missover;
LENGTH mineral $6 ;
File = "&dsn.";
DO until (lastrec);
  INPUT TEMP_Cent TEMP_Kelv Press_bar LOG_K;
  mineral = SCAN(SUBSTR("&dsn.",6,11),1,'.');
  OUTPUT ;
END;
RUN;

PROC CONTENTS DATA=&dsn. ; run;
PROC PRINT DATA=&dsn.(obs=4) n NOobs; run;

* at this point calculate stats from the file
  and append them rather than append the entire dataset / 
  when you save;

PROC APPEND BASE=master DATA=&dsn. force; run;

%END;
%MEND;  

%_imprt
;

PROC CONTENTS DATA=master; run;
PROC PRINT DATA=master; run;

/*When you append datasets with PROC APPEND the same variable names should exist 
on both files (there is a 'force' option, though its presence is generally not 
recommended). The lengths of all character data are expected to be the same 
across all the files involved. The force option relaxes these constraints. 
However, even with the force option the APPEND procedure won't add a variable 
that doesn't already exist on the master dataset; not all variable names on the 
master dataset need to exist on appended file - they will be set to missing.

PROC IMPORT sets character variable lengths by what it finds in the spreadsheet 
and the format assigned to a non-existent master is the length from the first 
dataset appended to a non-existent master dataset.

The FORCE option in PROC APPEND (in that case or you can create an empty data 
set first with the variable attributes all defined, replacing the proc datasets 
portion of the macro)....

Source code can be found at http://rfd.uoregon.edu/files/rfd/StatisticalResources/dt09_mult_files.txt */



