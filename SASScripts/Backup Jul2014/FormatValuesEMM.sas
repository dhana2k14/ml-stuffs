



/*data coj.Inv;*/
/*set coj.Inv;*/
/*label InvSuburb = InvSuburb;*/
/*run;*/
/**/
/**/
/*data coj.Suburb;*/
/*set coj.temp (firstobs=312 obs=411);  */
/*run;*/
/**/
/**/
/*data coj.Suburb;*/
/*set coj.Suburb;  */
/*where InvSuburb not in ("Armadale","BlueHeaven","BooysensReserve","DiepslootWest3","DiepslootWest6","DiepslootWest7",	*/
/*"Doornfontein","Eagle sNest","EnnerdaleSouth","FarEastBank","Finetown","Fordsburg",	*/
/*"Gleniffer","Glenkay","Hartbeesfontein312Iq","Highlands","Hillbrow","Johannesburg",	*/
/*"KimbultAH","KlipriviersoogEstate","Klipspruit298Iq","LawleyEstate","LinbroPark", 	*/
/*"Nasrec","NewDoornfontein","Ophirton","Paarlshoop","Racecourse", "Roodekrans183Iq",*/
/*"Roodepoort302Iq","Turffontein100Ir","Waterval5Ir");*/
/*run;*/

/* Format Value */

data NMBM.sales;
set NMBM.sales;
format SPrice comma12.;
run;

 /* Remove Blanks, Special Characters */

data NMBM.Sales;
set NMBM.Sales;
SaleNbhd=translate(SaleNbhd," ","'");
run;

data NMBM.Sales;
set NMBM.Sales;
SaleNbhd=Compress(SaleNbhd,'-');
run;

data NMBM.Sales;
set NMBM.Sales;
SaleNbhd = Compress(SaleNbhd);
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
create table EMM.temp as select distinct(InvNbhd) as InvNbhd from EMM.Inv;quit;run;

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
create table EMM.Nbhd as select distinct(InvNbhd) as InvNbhd from EMM.temp 
where InvNbhd eq 1;
quit;run;

proc freq data=batch.Crnb1;
tables variables;
run;

data emm.Sales;
set emm.Sales;
/*label InvQual=InvQual;*/
/*label InvCond=InvCond;*/
/*label InvPin=InvPin;*/
/*label InvX =InvX;*/
/*label InvY=InvY;*/
/*label InvGar=InvGar;*/
label SaleTla=SaleTla;
run;
