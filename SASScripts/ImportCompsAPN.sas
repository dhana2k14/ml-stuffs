
data WORK.Comps_APN                                ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
       infile 'C:\Users\Public\Documents\comps_apn.txt' delimiter ='|' MISSOVER DSD lrecl=32767 firstobs=2 ;
informat county_name1 $50.;
informat apn1 $18.;
informat apn_seq1 $18.;
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
informat valid $1.;
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

format county_name1 $50.;
format apn1 $18.;
format apn_seq1 $18.;
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
format year_built1 $4.;
format assd_total_val1 best12.;
format Assd_Land_Val1 best12.;
format Assd_Imp_Val1 best12.;
format Mkt_Total_Val1 best12.;
format Mkt_Land_Val1 best12.;
format Mkt_Imp_Val1 best12.;
format sale_dATE1 $50.;
format sale_amount1 best12.;
format id1 $20.;
format valid $1.;
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

input 

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
 valid $
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
  ;
       if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
       run;
