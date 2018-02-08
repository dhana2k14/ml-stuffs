
 data comb.SR_Sales                       ;
 %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
 infile 'D:\final_comps\SR_SALES.txt' delimiter=',' MISSOVER DSD lrecl=32767 firstobs=2 ;
 	
 	
 	informat VA3_PIN $50.;
  	informat NBHDNO $50.;
 	informat ErfExt best32.;
 	informat Total_TLA best32.;
 	format VA3_PIN $50.;
 	format NBHDNO $50.;
 	format ErfExt best12.;
 	format Total_TLA best12.;
 	
       input
     VA3_PIN $
     NBHDNO $
     ErfExt
     Total_TLA
     ;
       if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
       run;


data comb.SR_Inv_Data                      ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
 infile 'D:\final_comps\SR_Inv_Data.txt' delimiter=',' MISSOVER DSD lrecl=32767 firstobs=2 ;
 	
 	
 	informat PIN $50.;
  	informat Extent best32.;
  	informat NbhdID $50.;
 	informat Total_TLA best32.;
 	format PIN $50.;
 	format Extent best12.;
 	format NbhdID $50.;
 	format Total_TLA best12.;
 	
       input
     PIN $
     EXTENT 
     NbhdID $
     Total_TLA
     ;
       if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
       run;


data comb.Nbhd;
 %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
 infile 'D:\final_comps\Nbhd_Lst.txt' delimiter=',' MISSOVER DSD lrecl=32767 firstobs=2 ;
 	
 	
 	informat Nbhd $50.;
 	format Nbhd $50.;

     input
     Nbhd $
       ;
       if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
       run;





