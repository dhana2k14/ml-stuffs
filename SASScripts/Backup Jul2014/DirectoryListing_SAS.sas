
options symbolgen;
%macro DIRLISTWIN(PATH      /* Windows path of directory to examine */ 
                 , MAXDATE=  /* [optional] maximum date/time of file to report                   */ 
                 , MINDATE=  /* [optional] minimum date/time of file to report                   */ 
                 , MAXSIZE=  /* [optional] maximum size of file to report (MB)                */ 
                 , MINSIZE=  /* [optional] minimum size of file to report (MB)                */ 
                 , OUT=      /* [optional] name of output file containing results of %DIRLISTWIN */ 
                 , REPORT=Y  /* [optional] flag controlling report creation                      */ 
                 , SUBDIR=Y  /* [optional] include subdirectories in directory processing        */ 
                 , MAXLEVRPT=3 /* [optional] Max Levels of subdirectories summarization Required   */ 
                 ) ;

   /* PURPOSE: create listing of files in specified directory to make evident
    *
    * NOTE:    %DIRLISTWIN is designed to be run on SAS installations using the Windows O/S  *

    * NOTE:    &PATH must contain valid Windows path, e.g., 'c:' or 'c:\documents and settings'  *

    * NOTE:    &MAXDATE and &MINDATE must be SAS date/time constants in one of the following formats:
    *             'ddMONyy:HH:MM'dt *** datetime constant ***
    *             'ddMONyy'd        *** date     constant ***
    *             'HH:MM't          *** time     constant *** *

    * NOTE:    if &SUBDIR = Y then all subdirectories of &PATH will be searched
    *          otherwise, only the path named in &PATH will be searched   *

    * NOTE:    uses Windows pipe option on file reference *

    * NOTE:    if %DIRLISTWIN is used successively in the same job, then
    *             the report will contain the cumulative directory listing of all directories searched
    *             a separate &OUT dataset will be created for each %DIRLISTWIN invocation *

    * USAGE:
    *  %DIRLISTWIN( c:/data1 )
    *  %DIRLISTWIN( c:/data1, MINDATE='01JAN04:00:00:00'dt, MAXDATE='16MAR04:23:59:59'dt )
    *  %DIRLISTWIN( c:/data1, MINDATE='00:00:00't, MAXDATE='23:59:59't, MINSIZE=1000000 )
    *  %DIRLISTWIN( d:/data2, REPORT=Y )
    *  %DIRLISTWIN( d:, OUT=LIBNAME.DSNAME, REPORT=N )
    *  %DIRLISTWIN( d:/documents and settings/robett/my documents/my sas files/v8 )
    *

    * ALGORITHM:
    *  use Windows pipe with file reference to execute 'dir' command to obtain directory contents
    *  parse pipe output as if it were a file to extract file names, other info
    *  [optional] select files that are within the time interval [ &MINDATE, &MAXDATE ]
    *  [optional] select files that are at least as large as &MINSIZE bytes and no larger than &MAXSIZE
    *  sort records by owner, path, filename
    *  [optional] create report of files per owner/path if requested
    *  [optional] create 1-line report of files per owner/path if requested
    */ 

   %let DELIM   = ' ' ;
   %if %upcase( &SUBDIR ) = Y %then %let SUBDIR = /s ; %else %let SUBDIR = ;
   /*============================================================================*/ 
   /* external storage references
   /*============================================================================*/ 
   /* run Windows "dir" DOS command as pipe to get contents of data directory */ 
   filename DIRLIST pipe "dir /-c /q &SUBDIR /t:c ""&PATH""" ;


  /*############################################################################*/ 
   /* begin executable code
   /*############################################################################*/

   /* use Windows pipe to recursively find all files in &PATH
    * parse out extraneous data, including unreadable directory paths
    * process files >= &MINSIZE in size  *
    * directory list structure:
    *    "Directory of" record precedes listing of contents of directory:  *
    *    Directory of <volume:> \ <dir1> [ \ <dir2>\... ]
    *    mm/dd/yy hh:mm:ss [AM|PM] ['<DIR>' | size ] filename.type  *
    *    example:*
    *       Volume in drive C is WXP
    *       Volume Serial Number is 18C2-3BAA *
    *       Directory of C:\Documents and Settings\robett\My Documents\My SAS Files\V8\Test  *
    *       05/21/03  10:58 AM    <DIR>          CARYNT\robett          .
    *       05/21/03  10:58 AM    <DIR>          CARYNT\robett          ..
    *       12/24/03  10:22 AM    <DIR>          CARYNT\robett          Codebook
    *       04/23/01  02:42 PM               387 CARYNT\robett          printCharMat.sas
    *       10/09/03  11:35 AM             20582 CARYNT\robett          test.log
    *       10/28/03  08:02 AM             58682 CARYNT\robett          test.lst
    *       10/09/03  11:35 AM              1575 CARYNT\robett          test.sas
   */ 

  /* drop these datasets if already exists */ 
   proc sql;
         drop table dirlist;
         drop table report;
   quit;
   /*Count the number of the Initial Directory levels in the Rootpath for eg. C:\Temp i.e. 2  */ 

   data _null_;
   initpath="&PATH";
   dirlevels=count(initpath,'\')+1;
   call symputx('lvlsinitpath',dirlevels);
   run;

   /*Count the number of the Initial Directory levels */ 

   data dirlist ;
      length path filename $255 line $1024 owner $17 temp $16 ;
      retain path ;
      infile DIRLIST length=reclen ;
      input line $varying1024. reclen ;
      if reclen = 0 then delete ;
      if scan( line, 1, &DELIM ) = 'Volume'  | /* beginning of listing */ 
         scan( line, 1, &DELIM ) = 'Total'   | /* antepenultimate line */ 
         scan( line, 2, &DELIM ) = 'File(s)' | /* penultimate line     */ 
         scan( line, 2, &DELIM ) = 'Dir(s)'    /* ultimate    line     */ 
      then delete ;
      dir_rec = upcase(scan(line, 1, &DELIM)) = 'DIRECTORY' ;
      /* parse directory     record for directory path
       * parse non-directory record for filename, associated information    */ 
      if dir_rec
      then
         path = left( substr( line, length( "Directory of" ) + 2 )) ;
      else do ;
/*         date = abs(input( scan( line, 1, &DELIM ), mmddyy10. )) ;*/
/*         time = input( scan( line, 2, &DELIM ), time5. ) ;*/
/*         post_meridian = ( scan( line, 3, &DELIM ) = 'PM' ) ;*/
/*         if post_meridian then time = time + '12:00:00'T ; */

		 /* add 12 hours to represent on 24-hour clock */ 
         temp = scan( line, 4, &DELIM ) ;
         if temp = '<DIR>' then size = 0 ; else size = input( temp, best. ) ;
         owner = scan( line, 5, &DELIM ) ;
         /* scan delimiters cause filename parsing to require special treatment */ 
         filename = scan( line, 6, &DELIM ) ;
         if filename in ( '.' '..' ) then delete ;
         ndx = index( line, scan( filename, 1 )) ;
         filename = substr( line, ndx ) ;
      end ;

		/* date/time filter */ 
/*      %if %eval( %length( &MAXDATE ) + %length( &MINDATE ) > 0 )*/
/*      %then %do ;*/
/*         if not dir_rec*/
/*         then do ;*/
/*            datetime = input( put( date, date7. ) || ':' || put( time, time5. ), datetime13. )  ;*/
/*            %if %length( &MAXDATE ) > 0 %then %str( if datetime <= &MAXDATE ; ) ;*/
/*            %if %length( &MINDATE ) > 0 %then %str( if datetime >= &MINDATE ; ) ;*/
/*         end ;*/
/*      %end ;*/
/*        sizeMB=size/(1024*1024); /*Size in MB*/ */
/*        sizeGB=size/(1024*1024*1024); /*Size in GB*/ */
      drop dir_rec line ndx post_meridian temp ;
        dirlevels=count(path,'\')+1;
/*        format sizeMB sizeGB comma10.2 date mmddyy10.;*/
   run ;
   proc sort data=dirlist out=dirlist ; by owner path filename ; run ;
   /*============================================================================*/ 
   /* add data for current directory path to cumulative report dataset
   /*============================================================================*/ 
   proc append base=report data=dirlist ; run ;
   /*============================================================================*/ 
   /* break association to previous path prior to next %DIRLISTWIN invocation
   /*============================================================================*/
   filename DIRLIST clear ;
   /*-------------Code specific to the Requirement --------*/ 
	proc sql;
	select max(dirlevels) into :maxLevels
      from dirlist;
      quit;

      %let maxLevels=&maxLevels;
      %put maxLevels=&maxLevels;
      proc sort data=dirlist; by path; run;

      data dirlistSize;
      length previous $ 100;
      retain previous;
      set dirlist;
      array brklevels{&maxLevels} $100; * _temporary_ ; 
      array levels{&maxLevels} $100 level1-level&maxLevels ;
      previous='';

      do i=1 to dirlevels;
            brklevels(i)=scan(path,i,'\');
            levels(i)=strip(previous)||"\"||strip(brklevels(i));
            if i=1 then levels(i)=strip(substr(levels(i),2));
            previous=levels(i);
      end;
	  
      *if path="&PATH" and compress(filename) eq '' then delete; 

      if compress(filename) eq '' then delete;
      format size sizeMB sizeGB comma16.2 ;
      if size gt 0;
      run;

      %macro levels;
		%do i=&lvlsinitpath. %to %eval(&maxlev -1);
                  select distinct level&i. AS Path, sum(size) as Size format=comma10.2,sum(size)/(1024*1024) as SizeMB format=comma10.2,sum(size)/(1024*1024*1024) as SizeGB format=comma10.2 
                  from dirlistSize
                  where level&i. ne '' 
                  group by level&i. 
                  UNION
            %end;
      %mend levels;

      %if %eval(&lvlsinitpath. + &MAXLEVRPT.) gt &maxLevels %then %do; 
		  %let maxlev=&maxLevels; 
	  %end;
      %else  %let maxlev=%eval(&lvlsinitpath. + &MAXLEVRPT.);
      %put   maxLevels=&maxLevels lvlsinitpath=&lvlsinitpath MAXLEVRPT=&MAXLEVRPT maxlev=&maxlev;

	  proc sql feedback;
      create table prefinal as 
            %levels
            select distinct level&maxlev. AS Path, sum(size) as Size format=comma10.2,sum(size)/(1024*1024) as SizeMB format=comma10.2,sum(size)/(1024*1024*1024) as SizeGB format=comma10.2 
            from dirlistSize
            where level&maxlev. ne '' 
            group by level&maxlev. 
            order by Path,size desc;
      QUIT;

      data final; 
      set prefinal;
      dirlevels=count(path,'\')+1;
      /*Size filter*/ 
	  %if %length( &MAXSIZE ) > 0 %then %str( if sizeMB <= &MAXSIZE ; ) ;
      %if %length( &MINSIZE ) > 0 %then %str( if sizeMB >= &MINSIZE ; ) ;
	  run;

      proc sort data=final out=TopDown; by dirlevels descending size; run;

	  %if &REPORT eq Y  %then %do ;
     		ods listing close;
        	ods html file="&OUT.";
      title1 "Directory Listing and Size greater than &MINSIZE. (MB) " ;
      title2 "at Location: &PATH" ;

      proc report center data=TopDown headskip nowindows spacing=1 split='\' ;
         column path size sizeMB sizeGB; * dirlevels; 
         define path    / display   width=17        'Path' ;
         define size     / display format=comma16.2 'Size in Bytes' ;
         define sizeMB     / display format=comma16.2 'Size in MB' ;
         define sizeGB     / display format=comma16.2  'Size in GB' ;
         *define dirlevels / display  'Sub Directory Levels' ; 
      run ;
      title ;
        ods html close;  ods listing;
   %end ;
%mend DIRLISTWIN ;

%let outxls=C:\DirSpaceListing_&sysdate9..xls;
        %DIRLISTWIN(C:\Users\dhanasekaran\Desktop\                         /* Windows path of directory to examine                             */ 
                 , MAXDATE=                           /* [optional] maximum date/time of file to report                   */ 
                 , MINDATE=                           /* [optional] minimum date/time of file to report                   */ 
                 , MAXSIZE=                           /* [optional] maximum size of file to report (MB)                */ 
                 , MINSIZE=                           /* [optional] minimum size of file to report (MB)                */ 
                 , OUT=&outxls.                       /* [optional] name of output file containing results of %DIRLISTWIN */ 
                 , REPORT=Y                           /* [optional] flag controlling report creation                      */ 
                 , SUBDIR=Y                           /* [optional] include subdirectories in directory processing        */ 
                 , MAXLEVRPT=5                       /* [optional] Max Levels of subdirectories summarization Required   */ 
                 ) ;


/* Read more: http://sastechies.blogspot.com/2010/07/creating-directory-listing-using-sas.html#ixzz2xnoru33k */
