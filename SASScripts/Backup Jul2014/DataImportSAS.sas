
 data WORK.Newcastlevalroll                       ;
 %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
 infile 'C:\Users\dhanasekaran\Desktop\Part A Valuation Roll 30 June 2013-.txt' delimiter='20'x MISSOVER DSD lrecl=32767 firstobs=2 ;
 	informat ErfNumber $5.; 
 	informat Portion $14.;
	informat AllotmentTownship $100.;
	informat Owner $50.;
	informat SGNumber $50.;
	informat StreetName $50.;	
	informat DeedsExtent $50.; 
	informat STUnitExtent $50.;
	informat RatesCategory $50.;
	informat UseCategory $50.;
	informat STScheme $50.;
	informat SchemeNumber $50.;
	informat MarketValue $50. ;
 	format ErfNumber $5.; 
 	format Portion $14.;
	format AllotmentTownship $100.;
	format Owner $50.;
	format SGNumber $50.;
	format StreetName $50.;	
	format DeedsExtent $50.; 
	format STUnitExtent $50.;
	format RatesCategory $50.;
	format UseCategory $50.;
	format STScheme $50.;
	format SchemeNumber $50.;
	format MarketValue $50. ; 
       input
     ErfNumber $
 	 Portion $
	 AllotmentTownship $
	 Owner $
	 SGNumber $
	 StreetName $	
	 DeedsExtent $
	 STUnitExtent $
	 RatesCategory $
	 UseCategory $
	 STScheme $
	 SchemeNumber $
	 MarketValue $
       ;
       if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
       run;
