
data WORK.Final_Comps                                ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
       infile 'C:\Users\Public\Documents\finalcomps.txt' delimiter ='|' MISSOVER DSD lrecl=32767 firstobs=2 ;

	   informat county_name $50.;
informat apn $18.;
informat Apn_Seq $3.;
informat Site_House_Number_Prefix best32.;
informat Site_House_Number best32.;
informat Site_House_Number_Suffix best32.;
informat Site_Direction $1.;
informat Site_Street_Name $50.;
informat Site_Post_Direct $16.;
informat Site_Unit $4.;
informat Site_city_State $50.;
informat Site_Zip $5.;
informat Site_Zip4 $4.;
informat Municipality_Name $50.;
informat Latitude best32.;
informat Longitude best32.;
informat Census_Tract $10.;
informat Property_Class $3.;
informat School_Dist best32.;
informat Water_Front_Flag $1.;
informat Land_Square_Feet best32.;
informat Lot_Area best32.;
informat Building_Sqft best32.;
informat Gla best32.;
informat half_baths best32.;
informat full_baths best32.;
informat Num_Baths best32.;
informat Condition $50.;
informat Year_Built best32.;
informat Assd_Total_Val best32.;
informat Assd_Land_Val best32.;
informat Assd_Imp_Val best32.;
informat Mkt_Total_Val best32.;
informat Mkt_Land_Val best32.;
informat Mkt_Imp_Val best32.;
informat Sale_Date $50.;
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
informat const_type best32.;
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
informat county_name1 $50.;
informat apn1 $18.;
informat apn_seq1 $3.;
informat site_house_number_prefix1 best32.;
informat site_house_number1 best32.;
informat site_house_number_suffix1 best32.;
informat site_direction1 $1.;
informat site_street_name1 $50.;
informat site_post_direct1 $16.;
informat site_unit1 $4.;
informat site_city_state1 $50.;
informat site_zip1 $5.;
informat site_zip4_1 $4.;
informat municipality_name1 $50.;
informat latitude1 best32.;
informat longitude1 best32.;
informat census_tract1 $10.;
informat property_class1 $3.;
informat school_dist1 best32.;
informat water_front_flag1 $1.;
informat land_square_feet1 best32.;
informat lot_area1 best32.;
informat building_sqft1 best32.;
informat gla1 best32.;
informat half_baths1 best32.;
informat full_baths1 best32.;
informat num_baths1 best32.;
informat condition1 $50.;
informat year_built1 best32.;
informat assd_total_val1 best32.;
informat Assd_Land_Val1 best32.;
informat Assd_Imp_Val1 best32.;
informat Mkt_Total_Val1 best32.;
informat Mkt_Land_Val1 best32.;
informat Mkt_Imp_Val1 best32.;
informat sale_dATE1 $50.;
informat sale_amount1 best32.;
informat id1 $20.;
informat quality1 $50.;
informat fips_code1 best32.;
informat zoning1 best32.;
informat grid_east1 best32.;
informat grid_north1 best32.;
informat views1 best32.;
informat frontage1 best32.;
informat depth1 best32.;
informat garage1 $50.;
informat garage_sqft1 best32.;
informat basement_type1 best32.;
informat basement_sqft1 best32.;
informat basement_finish1 best32.;
informat pool_flag1 $1.;
informat stories1 best32.;
informat building_style1 $100.;
informat ext_wall1 $100.;
informat heating1 $100.;
informat ac1 $100.;
informat fireplace_flag1 $1.;
informat num_bedrooms1 best32.;
informat total_rooms1 best32.;
informat tax_year1 best32.;
informat eff_year_built1 best32.;
informat const_type1 best32.;
informat pool_type1 $1.;
informat fireplace_type1 best32.;
informat fireplace_num1 best32.;
informat stories_type1 $1.;
informat improvements1 best32.;
informat first_owner_name1 $100.;
informat sale_code1 $10.;
informat multi_apn1 $50.;
informat partial_interest_ind1 $50.;
informat ownership_trans_perct1 best32.;
informat owner1 $100.;
informat sale_dt1 $10.;
informat DIST best32.;
informat DISTANCE best32.;
informat COND best32.;
informat COND1 best32.;
informat QUA best32.;
informat QUA1 best32.;
informat ARIC best32.;
informat Aric1 best32.;
informat POOLFG best32.;
informat POOLFG1 best32.;
informat TRGMON best32.;
informat MON_DIF best32.;
informat ADJ_SALE_AMOUNT best32.;
informat ADJ_LOT_AREA best32.;
informat ADJ_BUILDING_SQFT best32.;
informat ADJ_FULL_BATHS best32.;
informat ADJ_HALF_BATHS best32.;
informat ADJ_CONDITION best32.;
informat ADJ_QUALITY best32.;
informat ADJ_FIREPLACE_NUM best32.;
informat ADJ_POOL_FLAG best32.;
informat ADJ_AC best32.;
informat ADJ_AGE best32.;
informat TOTAL_ADJ best32.;
informat TOTAL_AD best32.;
informat ADJ_SALEPRICE best32.;
informat median best32.;

format county_name $50.;
format apn $18.;
format Apn_Seq $3.;
format Site_House_Number_Prefix best12.;
format Site_House_Number best12.;
format Site_House_Number_Suffix best12.;
format Site_Direction $1.;
format Site_Street_Name $50.;
format Site_Post_Direct $16.;
format Site_Unit $4.;
format Site_city_State $50.;
format Site_Zip $5.;
format Site_Zip4 $4.;
format Municipality_Name $50.;
format Latitude best12.;
format Longitude best12.;
format Census_Tract $10.;
format Property_Class $3.;
format School_Dist best12.;
format Water_Front_Flag $1.;
format Land_Square_Feet best12.;
format Lot_Area best12.;
format Building_Sqft best12.;
format Gla best12.;
format half_baths best12.;
format full_baths best12.;
format Num_Baths best12.;
format Condition $50.;
format Year_Built best12.;
format Assd_Total_Val best12.;
format Assd_Land_Val best12.;
format Assd_Imp_Val best12.;
format Mkt_Total_Val best12.;
format Mkt_Land_Val best12.;
format Mkt_Imp_Val best12.;
format Sale_Date $50.;
format Sale_Amount best12.;
format id $20.;
format valid $1.;
format quality $50.;
format fips_code best12.;
format zoning best12.;
format grid_east best12.;
format grid_north best12.;
format views best12.;
format frontage best32.;
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
format const_type best12.;
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
format county_name1 $50.;
format apn1 $18.;
format apn_seq1 $3.;
format site_house_number_prefix1 best12.;
format site_house_number1 best12.;
format site_house_number_suffix1 best12.;
format site_direction1 $1.;
format site_street_name1 $50.;
format site_post_direct1 $16.;
format site_unit1 $4.;
format site_city_state1 $50.;
format site_zip1 $5.;
format site_zip4_1 $4.;
format municipality_name1 $50.;
format latitude1 best12.;
format longitude1 best12.;
format census_tract1 $10.;
format property_class1 $3.;
format school_dist1 best12.;
format water_front_flag1 $1.;
format land_square_feet1 best12.;
format lot_area1 best12.;
format building_sqft1 best12.;
format gla1 best12.;
format half_baths1 best12.;
format full_baths1 best12.;
format num_baths1 best12.;
format condition1 $50.;
format year_built1 best12.;
format assd_total_val1 best12.;
format Assd_Land_Val1 best12.;
format Assd_Imp_Val1 best12.;
format Mkt_Total_Val1 best12.;
format Mkt_Land_Val1 best12.;
format Mkt_Imp_Val1 best12.;
format sale_dATE1 $50.;
format sale_amount1 best12.;
format id1 $20.;
format quality1 $50.;
format fips_code1 best12.;
format zoning1 best12.;
format grid_east1 best12.;
format grid_north1 best12.;
format views1 best12.;
format frontage1 best12.;
format depth1 best12.;
format garage1 $50.;
format garage_sqft1 best12.;
format basement_type1 best12.;
format basement_sqft1 best12.;
format basement_finish1 best12.;
format pool_flag1 $1.;
format stories1 best12.;
format building_style1 $100.;
format ext_wall1 $100.;
format heating1 $100.;
format ac1 $100.;
format fireplace_flag1 $1.;
format num_bedrooms1 best12.;
format total_rooms1 best12.;
format tax_year1 best12.;
format eff_year_built1 best12.;
format const_type1 best12.;
format pool_type1 $1.;
format fireplace_type1 best12.;
format fireplace_num1 best12.;
format stories_type1 $1.;
format improvements1 best12.;
format first_owner_name1 $100.;
format sale_code1 $10.;
format multi_apn1 $50.;
format partial_interest_ind1 $50.;
format ownership_trans_perct1 best12.;
format owner1 $100.;
format sale_dt1 $10.;
format DIST best12.;
format DISTANCE best12.;
format COND best12.;
format COND1 best12.;
format QUA best12.;
format QUA1 best12.;
format ARIC best12.;
format Aric1 best12.;
format POOLFG best12.;
format POOLFG1 best12.;
format TRGMON best12.;
format MON_DIF best12.;
format ADJ_SALE_AMOUNT best12.;
format ADJ_LOT_AREA best12.;
format ADJ_BUILDING_SQFT best12.;
format ADJ_FULL_BATHS best12.;
format ADJ_HALF_BATHS best12.;
format ADJ_CONDITION best12.;
format ADJ_QUALITY best12.;
format ADJ_FIREPLACE_NUM best12.;
format ADJ_POOL_FLAG best12.;
format ADJ_AC best12.;
format ADJ_AGE best12.;
format TOTAL_ADJ best12.;
format TOTAL_AD best12.;
format ADJ_SALEPRICE best12.;
format median best12.;

input

 county_name $
 apn $
 Apn_Seq $
 Site_House_Number_Prefix 
 Site_House_Number 
 Site_House_Number_Suffix 
 Site_Direction $
 Site_Street_Name $
 Site_Post_Direct $
 Site_Unit $
 Site_city_State $
 Site_Zip $
 Site_Zip4 $
 Municipality_Name $
 Latitude 
 Longitude 
 Census_Tract $
 Property_Class $
 School_Dist 
 Water_Front_Flag $
 Land_Square_Feet 
 Lot_Area 
 Building_Sqft 
 Gla 
 half_baths 
 full_baths 
 Num_Baths 
 Condition $
 Year_Built 
 Assd_Total_Val 
 Assd_Land_Val 
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
 const_type 
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
 county_name1 $
 apn1 $
 apn_seq1 $
 site_house_number_prefix1 
 site_house_number1 
 site_house_number_suffix1 
 site_direction1 $
 site_street_name1 $
 site_post_direct1 $
 site_unit1 $
 site_city_state1 $
 site_zip1 $
 site_zip4_1 $
 municipality_name1 $
 latitude1 
 longitude1 
 census_tract1 $
 property_class1 $
 school_dist1 
 water_front_flag1 $
 land_square_feet1 
 lot_area1 
 building_sqft1 
 gla1 
 half_baths1 
 full_baths1 
 num_baths1 
 condition1 $
 year_built1 
 assd_total_val1 
 Assd_Land_Val1 
 Assd_Imp_Val1 
 Mkt_Total_Val1 
 Mkt_Land_Val1 
 Mkt_Imp_Val1 
 sale_dATE1 $
 sale_amount1 
 id1 $
 quality1 $
 fips_code1 
 zoning1 
 grid_east1 
 grid_north1 
 views1 
 frontage1 
 depth1 
 garage1 $
 garage_sqft1 
 basement_type1 
 basement_sqft1 
 basement_finish1 
 pool_flag1 $
 stories1 
 building_style1 $
 ext_wall1 $
 heating1 $
 ac1 $
 fireplace_flag1 $
 num_bedrooms1 
 total_rooms1 
 tax_year1 
 eff_year_built1 
 const_type1 
 pool_type1 $
 fireplace_type1 
 fireplace_num1 
 stories_type1 $
 improvements1 
 first_owner_name1 $
 sale_code1 $
 multi_apn1 $
 partial_interest_ind1 $
 ownership_trans_perct1 
 owner1 $
 sale_dt1 $
 DIST 
 DISTANCE 
 COND 
 COND1 
 QUA 
 QUA1 
 ARIC 
 Aric1 
 POOLFG 
 POOLFG1 
 TRGMON 
 MON_DIF 
 ADJ_SALE_AMOUNT 
 ADJ_LOT_AREA 
 ADJ_BUILDING_SQFT 
 ADJ_FULL_BATHS 
 ADJ_HALF_BATHS 
 ADJ_CONDITION 
 ADJ_QUALITY 
 ADJ_FIREPLACE_NUM 
 ADJ_POOL_FLAG 
 ADJ_AC 
 ADJ_AGE 
 TOTAL_ADJ 
 TOTAL_AD 
 ADJ_SALEPRICE 
 median 
 ;
  if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
       run;
