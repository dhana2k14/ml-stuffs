
Proc sql;
create table NMBM.Temp as select distinct(InvNbhd) from NMBM.Inv;quit;run;

data nmbm.Nbhd;
set nmbm.temp;
where InvNbhd eq "AlgoaLow";
run;

data nmbm.Inv;
set nmbm.Inv1 (firstobs=1 obs=20);
where InvNbhd eq "AlgoaLow";
run;

    data list.t;
	input Variables $ Subject $ Comp1 $ Comp2 $ Comp3 $ Comp4 $ Comp5 $;
	datalines;
    Dummy 1 1 1 1 1 1
    ;
	run;

    data list.t;
    infile "C:\Users\dhanasekaran\Desktop\CompList.csv" delimiter=',' firstobs=2;
    input Variables $ Subject $ Comp1 $ Comp2 $ Comp3 $ Comp4 $ Comp5 $;
    run;

	data list.t;
	set list.t;
	drop Variables Subject Comp1 Comp2 Comp3 Comp4 Comp5;
	rename Var=Variables;
	rename Sub=Subject;
	rename C1=Comp1;
	rename C2=Comp2;
	rename C3=Comp3;
	rename C4=Comp4;
	rename C5=Comp5;
	keep _all_;
	Var=put(Variables,$10.);
	Sub=input(Subject,best12.);
	C1=input(Comp1,best12.);
	C2=input(Comp2,best12.);
	C3=input(Comp3,best12.);
	C4=input(Comp4,best12.);
	C5=input(Comp5,best12.);
	run;

	
