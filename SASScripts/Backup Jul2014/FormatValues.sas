


data coj.Inv;
set coj.Inv;
label InvSuburb = InvSuburb;
run;


data coj.Suburb;
set coj.temp (firstobs=351 obs=550);  
run;


data coj.Suburb;
set coj.Suburb;  
where InvSuburb not in ("Armadale","BlueHeaven","BooysensReserve","DiepslootWest3","DiepslootWest6","DiepslootWest7",	
"Doornfontein","EaglesNest","EnnerdaleSouth","FarEastBank","Finetown","Fordsburg",	
"Gleniffer","Glenkay","Hartbeesfontein312Iq","Highlands","Hillbrow","Johannesburg",	
"KimbultAH","KlipriviersoogEstate","Klipspruit298Iq","LawleyEstate","LinbroPark", 	
"Nasrec","NewDoornfontein","Ophirton","Paarlshoop","Racecourse", "Roodekrans183Iq",
"Roodepoort302Iq","Turffontein100Ir","Waterval5Ir");
run;

data coj.Suburb;
set coj.Temp;  
where InvSuburb not in ("KimbultAH");
run;



/* Format Value */

data NMBM.sales;
set NMBM.sales;
format SPrice comma12.;
run;

 /* Remove Blanks, Special Characters */

data Sup9rev;
set Sup9rev;
Suburb=translate(Suburb," ","'");
run;

data Sup9rev;
set Sup9rev;
Suburb=Compress(Suburb,'-');
run;

data Sup9rev;
set Sup9rev;
Suburb = Compress(Suburb);
run;

 /* Inventory */

data NMBM.Inv;
set NMBM.Inv;
InvNbhd=translate(InvNbhd," ","'");
run;

data NMBM.Inv;
set NMBM.Inv;
InvNbhd=Compress(InvNbhd,'-');
run;

data NMBM.Inv;
set NMBM.Inv;
InvNbhd = Compress(InvNbhd);
run;


proc sql noprint;
create table NMBM.temp as select distinct(InvNbhd) as InvNbhd from NMBM.Inv;quit;run;

data NMBM.Nbhd;
set NMBM.temp (firstobs=120 obs=145);
run;

data NMBM.Nbhd;
set NMBM.Nbhd;
where InvNbhd not in ("BooysenPark","BlueHorizonBay","BenKamma","Beachview","Barcelona",
"AsaliaPark","ArcadiaHigh","Arcadia","AlgoaPark","AlgoaLow","BWB","Helenvale","ParsonsVlei","FrancisEvattPark","SaltPan","BarcelonaLC",
"HumeRail","Seaviewdistant","ColleenGlen","GreenRdp","PortElizabethNU",
"Srfront","LovemorePark","Daleview","Masibulele","Tiryville","Blikkiesdorp",
"Kabah1","Uitenhage","Theescombe","Tjoksville","PV1");
run;


proc sql;
create table NMBM.Nbhd as select * from NMBM.temp 
where InvNbhd not in ("BarcelonaLC","ColleenGlen");
quit;run;

proc freq data=batch.Crnb1;
tables variables;
run;

data t;
set batch.Crnb1;
where Variables="A_Pin";
run;

data t;
set t;
subject=compress(Subject);
drop subject;
rename sub=subject;
keep _all_;
sub=input(subject,best32.);
run;

proc sql;
create table uni as select distinct(InvPin) from nmbm.Inv;quit;run;

proc sql;
create table t1 as select a.InvPin,b.Subject from uni as a left join t as b on a.InvPin=b.Subject where b.Subject eq .;quit;run;
