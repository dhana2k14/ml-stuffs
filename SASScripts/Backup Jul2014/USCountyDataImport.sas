
       data WORK.Subject                                ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
       infile 'C:\Users\Public\Documents\subject.txt' delimiter ='|' MISSOVER DSD lrecl=32767 firstobs=2 ;
          informat county_name $50. ;
          informat apn $18. ;
          informat Apn_seq $3. ;
          informat Site_House_Number_Prefix best32. ;
          informat Site_House_Number best32. ;
          informat Site_House_Number_Suffix best32. ;
          informat Site_Direction $1. ;
          informat Site_Street_name $50. ;
          informat Site_Post_Direct $16. ;
          informat Site_Unit $4. ;
          informat Site_City_State $50. ;
          informat Site_Zip $5. ;
          informat Site_Zip4 $4. ;
          informat Municipality_name $50. ;
          informat Latitude best32. ;
          informat Longitude best32. ;
          informat Census_Tract $10. ;
          informat Property_class $5. ;
          informat School_Dist $50. ;
          informat Water_Front_Flag $1. ;
          informat Land_Square_Feet best32. ;
          informat Lot_Area best32. ;
          informat Building_Sqft best32. ;
          informat Gla best32. ;
          informat Half_baths best32. ;
          informat Full_baths best32. ;
          informat Num_Baths best32. ;
          informat Condition $50. ;
          informat Year_built best32. ;
          informat Assd_Total_Val best32. ;
          informat Assd_land_val best32. ;          
		  informat Assd_Imp_Val best32.;
          informat Mkt_Total_Val best32.;
          informat Mkt_Land_Val best32.;
          informat Mkt_Imp_Val best32.;
          informat Sale_Date $100.;
          informat Sale_Amount best32.;
          informat id $20.;
          informat valid $1.;
          informat quality $50.;
          informat fips_code best32.;
          informat zoning best32.;
          informat grid_east best32.;
          informat grid_north best32.;
          informat views best32.;
          informat frontage best32.;
          informat depth best32.;
          informat garage $50.;
          informat garage_sqft best32.;
          informat basement_type best32.;
          informat basement_sqft best32.;
          informat basement_finish best32.;
          informat pool_flag $1.;
          informat stories best32.;
          informat building_style $100.;
          informat ext_wall $100.;
          informat heating $100.;
          informat ac $100.;
          informat fireplace_flag $1.;
          informat num_bedrooms best32.;
          informat total_rooms best32.;
          informat tax_year best32.;
          informat eff_year_built best32.;
          informat const_type $1.;
          informat pool_type $1.;
          informat fireplace_type best32.;
          informat fireplace_num best32.;
          informat stories_type $1.;
          informat improvements best32.;
          informat first_owner_name $100.;
          informat sale_code $10.;
          informat multi_apn $50.;
          informat partial_interest_ind $50.;
          informat ownership_trans_perct best32.;
          informat owner $100.;

		  format county_name $50. ;
          format apn $18. ;
          format Apn_seq $3. ;
          format Site_House_Number_Prefix best12. ;
          format Site_House_Number best12. ;
          format Site_House_Number_Suffix best12. ;
          format Site_Direction $1. ;
          format Site_Street_name $50. ;
          format Site_Post_Direct $16. ;
          format Site_Unit $4. ;
          format Site_City_State $50. ;
          format Site_Zip $5. ;
          format Site_Zip4 $4. ;
          format Municipality_name $50. ;
          format Latitude best12. ;
          format Longitude best12. ;
          format Census_Tract $10. ;
          format Property_class $5. ;
          format School_Dist $50. ;
          format Water_Front_Flag $1. ;
          format Land_Square_Feet best12. ;
          format Lot_Area best12. ;
          format Building_Sqft best12. ;
          format Gla best12. ;
          format Half_baths best12. ;
          format Full_baths best12. ;
          format Num_Baths best12. ;
          format Condition $50. ;
          format Year_built best12. ;
          format Assd_Total_Val best12. ;
          format Assd_land_val best12. ;          
		  format Assd_Imp_Val best12.;
          format Mkt_Total_Val best12.;
          format Mkt_Land_Val best12.;
          format Mkt_Imp_Val best12.;
          format Sale_Date $100.;
          format Sale_Amount best12.;
          format id $20.;
          format valid $1.;
          format quality $50.;
          format fips_code best12.;
          format zoning best12.;
          format grid_east best12.;
          format grid_north best12.;
          format views best12.;
          format frontage best12.;
          format depth best12.;
          format garage $50.;
          format garage_sqft best12.;
          format basement_type best12.;
          format basement_sqft best12.;
          format basement_finish best12.;
          format pool_flag $1.;
          format stories best12.;
          format building_style $100.;
          format ext_wall $100.;
          format heating $100.;
          format ac $100.;
          format fireplace_flag $1.;
          format num_bedrooms best12.;
          format total_rooms best12.;
          format tax_year best12.;
          format eff_year_built best12.;
          format const_type $1.;
          format pool_type $1.;
          format fireplace_type best12.;
          format fireplace_num best12.;
          format stories_type $1.;
          format improvements best12.;
          format first_owner_name $100.;
          format sale_code $10.;
          format multi_apn $50.;
          format partial_interest_ind $50.;
          format ownership_trans_perct best12.;
          format owner $100.;
       input

	       county_name $
           apn $
           Apn_seq $ 
           Site_House_Number_Prefix  
           Site_House_Number 
           Site_House_Number_Suffix  
           Site_Direction $ 
           Site_Street_name $ 
           Site_Post_Direct $
           Site_Unit $
           Site_City_State $ 
           Site_Zip $ 
           Site_Zip4 $
           Municipality_name $ 
           Latitude  
           Longitude  
           Census_Tract $
           Property_class $
           School_Dist $
           Water_Front_Flag $ 
           Land_Square_Feet 
           Lot_Area 
           Building_Sqft  
           Gla  
           Half_baths  
           Full_baths  
           Num_Baths  
           Condition $ 
           Year_built  
           Assd_Total_Val  
           Assd_land_val            
	       Assd_Imp_Val 
           Mkt_Total_Val 
           Mkt_Land_Val 
           Mkt_Imp_Val 
           Sale_Date $
           Sale_Amount 
           id $
           valid $
           quality $ 
           fips_code 
           zoning 
           grid_east 
           grid_north 
           views 
           frontage 
           depth 
           garage $
           garage_sqft 
           basement_type 
           basement_sqft 
           basement_finish 
           pool_flag $
           stories 
           building_style $
           ext_wall $
           heating $
           ac $
           fireplace_flag $
           num_bedrooms 
           total_rooms 
           tax_year 
           eff_year_built 
           const_type $
           pool_type $
           fireplace_type 
           fireplace_num 
           stories_type $
           improvements 
           first_owner_name $
           sale_code $
           multi_apn $
           partial_interest_ind $
           ownership_trans_perct 
           owner $                   
       ;
       if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
       run;
