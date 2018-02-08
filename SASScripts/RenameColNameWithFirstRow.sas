

%macro Columnname;

proc transpose data=pinrow151(obs=1) out=temp;
var _all_;
run;

data temp;
set temp (firstobs=3);
where variablename ne ' '; 
run;

proc sql ;
select catx('=',_name_,variablename)
into :rename separated by ' '
from temp;
quit;

data pinrow149;
set pinrow149(firstobs=2 rename=(&rename));
run;


%mend columnname;





data drive.have;
input (ABC F1 F2 FDG)($);
cards; 

ID Name Sex Country 

1 ABC M IND 

2 BCD F USA 

3 CDE M GER 

4 DGE M UK 

;
run;

proc append base=drive.pinrow50 data=drive.pinrow48 force;
run;










