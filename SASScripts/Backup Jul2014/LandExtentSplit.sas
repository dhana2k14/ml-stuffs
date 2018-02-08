
data BB.Bbagext14sep13;
set BB.Bbagext14sep13;
drop LandExtHect;
run;

data BB.Bbagext14sep13;
set BB.Bbagext14sep13;
format LandExtHect $50.;
if LandExtent=. then LandExtHect=".";
else if LandExtent<=8000 then LandExtHect="<8000 Sqm";
else if LandExtent<=10000 then LandExtHect="<1 Ha";
else if LandExtent<=15000 then LandExtHect="<1.5 Ha";
else if LandExtent<=20000 then LandExtHect="<2 Ha";
else if LandExtent<=25000 then LandExtHect="<2.5 Ha";
else if LandExtent<=30000 then LandExtHect="<3 Ha";
else if LandExtent<=35000 then LandExtHect="<3.5 Ha";
else if LandExtent<=40000 then LandExtHect="<4 Ha";
else if LandExtent<=45000 then LandExtHect="<4.5 Ha";
else if LandExtent<=50000 then LandExtHect="5 Ha";
else if LandExtent<=60000 then LandExtHect="6 Ha";
else if LandExtent<=70000 then LandExtHect="7 Ha";
else if LandExtent<=80000 then LandExtHect="8 Ha";
else if LandExtent<=90000 then LandExtHect="9 Ha";
else if LandExtent<=100000 then LandExtHect="10 Ha";
else if LandExtent<=110000 then LandExtHect="11 Ha";
else if LandExtent<=120000 then LandExtHect="12 Ha";
else if LandExtent<=130000 then LandExtHect="13 Ha";
else if LandExtent<=140000 then LandExtHect="14 Ha";
else if LandExtent<=150000 then LandExtHect="15 Ha";
else if LandExtent<=200000 then LandExtHect=">15<20 Ha";
else if LandExtent<=500000 then LandExtHect=">20<50 Ha";
else if LandExtent<=750000 then LandExtHect=">50<75 Ha";
else if LandExtent<=1000000 then LandExtHect=">75<100 Ha";
else if LandExtent<=1500000 then LandExtHect=">100<150 Ha";
else if LandExtent<=5000000 then LandExtHect=">150<500 Ha";
else if LandExtent<=10000000 then LandExtHect=">500<1000 Ha";
else if LandExtent>10000000 then LandExtHect=">1000 Ha";
run;


proc sql;create table ld.temp as select * from Ld.Ldcode where LandHect1 not in ("<0.8","<1","<1.5","<2","<2.5","<3","<3.5","<4","<4.5","<5");
quit;run;
