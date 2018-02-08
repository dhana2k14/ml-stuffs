
proc sql noprint;
create table Merge_Stat as
select a.*,b.SaleP10,b.SaleP90,b.SaleTlaP10,b.SaleTlaP90 from coj.Srsupr3_6may as a left join coj.Use1Stat as b on a.Suburb=b.Suburb;
quit;
run;

data Merge_Stat_Out;
set Merge_Stat;
if (SaleTlaP10<=EmvTla<=SaleTlaP90) and (SaleP10<=Emv<=SaleP90) then RevFlag=0;
else RevFlag=1;
run;

proc sql;select count(Pin) from Merge_Stat_1 where RevFlag=2;quit;run;

/*COMPRESS SPACES in SUBURB NAMES */

data Coj.Srsupr3_6may;
set Coj.Srsupr3_6may;
Suburb=translate(Suburb," ","'");
run;

data Coj.Srsupr3_6may;
set Coj.Srsupr3_6may;
Suburb=Compress(Suburb,'-');
run;

data Coj.Srsupr3_6may;
set Coj.Srsupr3_6may;
Suburb = Compress(Suburb);
run;

/*Round off EMVTLA Values */

data Merge_stat;
set Merge_stat;
EmvTla1=Round(EmvTla);
run;

data Merge_stat;
set Merge_stat;
drop EmvTla;
rename EmvTla1=EmvTla;
run;

/* Select Parcels with no Stats */

proc sql;
create table sub_rev_manual as select * from Merge_stat_out where SaleP10 eq . and SaleP90 eq . and SaleTlaP10 eq . and SaleTlaP90 eq .;quit;run;
 

