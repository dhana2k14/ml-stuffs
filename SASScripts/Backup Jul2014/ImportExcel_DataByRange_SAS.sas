
%macro OpenExcelWorkbook(WorkBook);

	options noxwait noxsync nomprint nomlogic nosymbolgen;

	/* start excel 2007 */
	data _null_;
	 rc=system('start /min excel');
	 /* talk to DDE, no output data */
	 x=sleep(4); /*sleep for 4 secs*/
	run;

	data _null_; 
	x=sleep(2); /* wait 3 seconds for it to open */
	run;

	filename DDEcmds dde "excel|system";
	data _null_; /* talk to DDE, no output data */
	x=sleep(5); /* wait 3 seconds for it to open */
	file DDEcmds;
	put %unquote(%str(%'[open("&WorkBook.")]%'));
	/*put %unquote(%str(%'[workbook.activate("&WorkSheet.")]%'));*/
	x=sleep(5); /* wait 3 seconds for it to open */
	run;


	filename DDEcmds clear;
  
options mprint mlogic symbolgen;
%mend OpenExcelWorkbook;



%macro ReadFromExcelTemplate(dsn,WorkBook,WorkSheet,StartRow,StartCol,EndRow,EndCol,header,maxcolwidth);

options noxwait noxsync; /* nomprint nomlogic nosymbolgen;*/

%let dlmr='09'x;

%let numvars=%eval(&EndCol. - &StartCol. + 1);


%if %lowcase(&header.) eq yes %then 
%do;
	/* Read the Header Info First */
	  FILENAME ReadHdr DDE "EXCEL|&WorkSheet.!R&StartRow.C&StartCol.:R&StartRow.C&EndCol." notab;
	  DATA _null_;
	  /* read in the name of the columns with the maxcolwidth */
	   length
	     %do r=1 %to &numvars;
	          ColName&r. $ &maxcolwidth.
             %end;
             ;;
             
	   INFILE ReadHdr dlm=&dlmr. dsd missover;	
	   
           input 
                %do s=1 %to &numvars;
                  ColName&s.
                %end;
		      ;; 
		   /* assign the colname1, colname2 etc macrovariables with the column names read from the file*/   
          %do t=1 %to &numvars;		      
	  		Call symput(compress('ColName'||&t),compress(ColName&t.));
	  	  %end;
	  RUN;

	  filename ReadHdr clear;
%end;	
%else
%do;
      /* assign the colname1, colname2 etc macrovariables with the col1 col2 names*/   
	  DATA _null_;
          %do t=1 %to &numvars;		      
	  		Call symput(compress('ColName'||&t),compress("Col&t."));
	  	  %end;
	  RUN;

%end;



%if %lowcase(&header.) eq yes %then 
%do;
	/* Build DDE FileName Statement to Point to the Right Location on the Excel Spreadsheet */ 
  	FILENAME ReadData DDE "EXCEL|&WorkSheet.!R%eval(&StartRow. + 1)C&StartCol.:R&EndRow.C&EndCol." notab;
%end;
%else 
%do;
	FILENAME ReadData DDE "EXCEL|&WorkSheet.!R&StartRow.C&StartCol.:R&EndRow.C&EndCol." notab;
%end;


DATA &dsn.;
   length
     %do p=1 %to &numvars;
          &&&ColName&p. $ &maxcolwidth.
      %end;
           ;;
             
   INFILE ReadData dlm=&dlmr. dsd missover;	
     input 
        %do q=1 %to &numvars;
             &&&ColName&q.
         %end;
      ;; 
run;
  
filename ReadData clear;

%mend ReadFromExcelTemplate;

%macro JustCloseExcel;

options noxwait noxsync nomprint nomlogic nosymbolgen;

filename DDEcmds dde "excel|system";

/* Save the Excel file and Quit Excel */ 

data _null_;
	file DDEcmds;	
	x=sleep(5); 
	put '[Quit()]';
run;

  filename DDEcmds clear;
  
options mprint mlogic symbolgen;

%mend JustCloseExcel;

%OpenExcelWorkbook(C:\eValuations\BelaBelaGv13\AG\BelaBela_AG_CamaExtract_FlatTable_02Sep2013.xlsx);
%ReadFromExcelTemplate(dsn3,C:\eValuations\BelaBelaGv13\AG\BelaBela_AG_CamaExtract_FlatTable_02Sep2013.xlsx,Sheet1,1,1,15954,52,yes,25);
%JustCloseExcel;
