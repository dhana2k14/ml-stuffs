
/* Here's another way of achieving the same result without needing to use a PIPE */

%macro get_filenames(location);
filename _dir_ "%bquote(&location.)";
data filenames(keep=memname);
  handle=dopen( '_dir_' );
  if handle > 0 then do;
    count=dnum(handle);
    do i=1 to count;
      memname=dread(handle,i);
      output filenames;
    end;
  end;
  rc=dclose(handle);
run;
filename _dir_ clear;
%mend;

%get_filenames(C:\temp\);           
%get_filenames(C:\temp\with space);
%get_filenames(%bquote(C:\temp\with'singlequote));
