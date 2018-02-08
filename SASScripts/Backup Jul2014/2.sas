
data WGSub1;
set Coj.WGSub1;
where variables="A_Pin" or variables="L_CompRating";
run;

data WGSub1;
set WGSub1;
Subject=Compress(Subject);
Comp1=Compress(Comp1);
Comp2 = Compress(Comp2);
Comp3 = Compress(Comp3);
Comp4 = Compress(Comp4);
Comp5 = Compress(Comp5);
Subject=Compress(Subject);
run;

data WGSub1;
set WGSub1;
CompSum=Comp1+comp2+Comp3+Comp4+Comp5;
run;

data WGSub1;
set batch.WGSub1;
format flag $2.;
if compsum eq 10 then subject=Subject;
run;


proc sql;
create table WgSub1_2 as select * from WGSub1
where CompSum eq 10;
quit;run;

proc sql;
create table t as select distinct(InvPin) as Invp1 from coj.C1r1albertskroon;quit;run;

proc sql;
create table t1 as select distinct(InvPin) as Invp2 from coj.C2r1albertskroon;quit;run;

proc sql;
create table t2 as select a.InvP2,b.InvP1 from t1 as a left join t as b on a.InvP2=b.Invp1 where b.InvP1 eq .;quit;run;
