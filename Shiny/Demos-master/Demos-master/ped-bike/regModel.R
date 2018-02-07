# this R script is used to model the relationship between crash frequency and 
# contributing factors

# I used a negative binomial model to model the relationships


# read the data into R
ped_data<-readRDS("data/countModel/ped_data.rds")
bike_data<-readRDS("data/countModel/bike_data.rds")

# prepare the pedestrian data set for modeling
ped_data$fatal<-as.integer(ped_data$fatal)
ped_data$incap<-as.integer(ped_data$incap)
ped_data$nonincap<-as.integer(ped_data$nonincap)
ped_data$pdo<-as.integer(ped_data$pdo)
ped_data$totalcrashes<-as.integer(ped_data$totalcrashes)
ped_data$injurycrashesonly<-as.integer(ped_data$injurycrashesonly)
ped_data$county1<-as.factor(ped_data$county1)
    #ped_data$drctoneway1<-as.factor(ped_data$drctoneway1)
ped_data$terrain1<-as.factor(ped_data$terrain1)
ped_data$landuse1<-as.factor(ped_data$landuse1)
ped_data$speedlmt<-as.integer(ped_data$speedlmt)
ped_data$speedlmt1<-as.factor(ped_data$speedlmt1)
ped_data$speedlmtschool1<-as.factor(ped_data$speedlmtschool1)
ped_data$lanes<-as.integer(ped_data$lanes)
ped_data$thrulanes<-as.integer(ped_data$thrulanes)
ped_data$totpopamericanindian<-as.numeric(ped_data$totpopamericanindian)


# prepare the bike data set for modeling
bike_data$fatal<-as.integer(bike_data$fatal)
bike_data$incap<-as.integer(bike_data$incap)
bike_data$nonincap<-as.integer(bike_data$nonincap)
bike_data$pdo<-as.integer(bike_data$pdo)
bike_data$totalcrashes<-as.integer(bike_data$totalcrashes)
bike_data$injurycrashesonly<-as.integer(bike_data$injurycrashesonly)
bike_data$county1<-as.factor(bike_data$county1)
    #bike_data$drctoneway1<-as.factor(bike_data$drctoneway1)
bike_data$terrain1<-as.factor(bike_data$terrain1)
bike_data$landuse1<-as.factor(bike_data$landuse1)
bike_data$speedlmt<-as.integer(bike_data$speedlmt)
bike_data$speedlmt1<-as.factor(bike_data$speedlmt1)
bike_data$speedlmtschool1<-as.factor(bike_data$speedlmtschool1)
bike_data$lanes<-as.integer(bike_data$lanes)
bike_data$nbrlanes<-as.integer(bike_data$nbrlanes)
bike_data$thrulanes<-as.integer(bike_data$thrulanes)
bike_data$totpopamericanindian<-as.numeric(bike_data$totpopamericanindian)


# estimate a negative Binomial model for PEDESTRIAN crashes
# first case, we use Economic factors
library(MASS)
ped_fatalCrashes_model_econ<-glm.nb(fatal~0+avgaadt+percenthh25000_to_49999+
                                       percenthh50000_to_74999+percenthh75000_to_99999+
                                       percent_no_vehicle+percenthu_2_vehicles+
                                       percenthh_3_or_more_vehicles+percentpop_in_labor_force+
                                       percenthh_with_food_stamp,
                               data=ped_data)
summary(ped_fatalCrashes_model_econ)

# second case, we roadway factors
ped_fatalCrashes_model_road<-glm.nb(fatal~area+landuse1+speedlmt1+speedlmtschool1+
                                            lanes+avgaadt, data=ped_data)
summary(ped_fatalCrashes_model_road)


# now estimate a negative Binomial model for BIKE crashes
# first case, we use Economic factors
bike_nonIncapCrashes_model_econ<-glm(nonincap~0+avgaadt+percenthhbelow25000+
                                             percenthh25000_to_49999+
                                             percenthh50000_to_74999+
                                             percenthh75000_to_99999+
                                             mean_household_income+
                                             percent_no_vehicle+
                                             percenthu_1_vehicle+
                                             percentpop_in_labor_force+
                                             percenthh_with_food_stamp, 
                                     family="poisson", data=bike_data)
summary(bike_nonIncapCrashes_model_econ)

# second case, we roadway factors
bike_injCrashes_model_road<-glm.nb(injurycrashesonly~0+row+terrain1+landuse1+
                                           spdlmtsc2+nbrlanes+avgaadt,
                                   data=bike_data)
summary(bike_injCrashes_model_road)
