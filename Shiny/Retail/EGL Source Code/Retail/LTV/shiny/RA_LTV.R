#Importing libraries
library(class)
library(colorspace)
library(RODBC)
library(Rcpp)
library(plyr)
library(quadprog)
library(quantmod)
library(reshape)


#encoding = "UTF-8"

date_calender<-function(){
  
  myconn <-odbcConnect("retail", uid="RetailsUser", pwd="Welcome123")
  
  
  
  query="SELECT min([Transaction_date]) as min_date,max([Transaction_date]) as max_date
  from [dbo].[Main_data_retail_analytics_VERSION_2]"
  
  result_date=sqlQuery(myconn, query)
  result_min_date=as.Date(result_date$min_date)
  result_max_date=as.Date(result_date$max_date)
  final_result_date=c(result_min_date,result_max_date)
  
  
  
}



itemCategory_ddl<-function(){
  
  myconn <-odbcConnect("retail", uid="sa", pwd="Password123")
  
  
  query="SELECT distinct([Item_Category_Code_Desc]) as item_name
  from [dbo].[Main_data_retail_analytics_VERSION_2]"
  
  result_item=sqlQuery(myconn, query)
  
  result_item<-as.character(result_item$item_name)
  
  
}






getLTV=function(StartDate,EndDate,items, retr1,Nt_1,Nt_2,ap_1,ap_2,retr2,retr3,Nt_3,Nt_4,ap_3,ap_4,cp0,cp1,cp2,cp3,cp4,dr0,dr1,dr2,dr3,dr4)


{  
  
  
  retr1=as.numeric(retr1/100)
  Nt_1= as.numeric(Nt_1)
  Nt_2= as.numeric(Nt_2)
  ap_1= as.numeric(ap_1)
  ap_2= as.numeric(ap_2)
  retr2= as.numeric(retr2/100)
  retr3= as.numeric(retr3/100)
  Nt_3= as.numeric(Nt_3)
  Nt_4= as.numeric(Nt_4)
  ap_3= as.numeric(ap_3)
  ap_4= as.numeric(ap_4)
  cp0= as.numeric(cp0/100)
  cp1= as.numeric(cp1/100)
  cp2= as.numeric(cp2/100)
  cp3= as.numeric(cp3/100)
  cp4= as.numeric(cp4/100)
  dr0= as.numeric(dr0/100)
  dr1= as.numeric(dr1/100)
  dr2= as.numeric(dr2/100)
  dr3= as.numeric(dr3/100)
  dr4= as.numeric(dr4/100)
  
  
  #Pasting start and end date between '' to print them in SQL query
  vcharStartDate1<-paste("'",StartDate,"'",sep="")
  vcharEndDate1<-paste("'",EndDate,"'",sep="")
  
  
  #Pasting Items between '' to print them in SQL query
  
  
    if(length(items)<=1)
    {
      vcharItemString=paste("'",items[1],"'",sep="")
    } else {
      vcharItemString=paste("'",items[1],"'",sep="")
      for(i in 2:length(items)){
        vcharItemString <-paste(vcharItemString,paste("'",items[i],"'",sep=""),sep=",")
        
      }
    }
  
  
  
  
  
  #Converting dates passed as arguments to proper format
  #startDate <- as.Date(as.POSIXct(startDate,format="%m/%d/%Y"))
  #endDate <- as.Date(as.POSIXct(endDate,format="%m/%d/%Y"))
  
  
  #Filtering data between start and end Date from the result set of database
  
  
  query <- sprintf('SELECT Receipt_No,Acquisition_date,Price,Loyalty_Card_No
                   from [dbo].Main_data_retail_analytics_VERSION_2 where Acquisition_date >=%s And Acquisition_date <%s and Item_Category_Code_Desc in (%s) ',vcharStartDate1,vcharEndDate1,vcharItemString)
  
  
  
  #creating connection object and running sql query
  myconn <-odbcConnect("retail", uid="sa", pwd="Password123")
  result=sqlQuery(myconn, query)
  close(myconn)
  dim(result)
  result<-as.data.frame(result)
  
  #Put data in a variable 
  Ltf <- result
  head(Ltf)
  uni_transaction <- length(unique(Ltf$Receipt_No))
  uni_loyalty_card <- length(unique(Ltf$Loyalty_Card_No))
  
  # average number of transactions in a period
  avgtrans<- uni_transaction/uni_loyalty_card
  avgnotrans <- round(avgtrans,2)
  # calculate average purchase value
  
  Ltf2 <- Ltf
  dim(Ltf)
  
  data.m <- melt(Ltf2, id=c(1), measure=c(3))
  
  data.c <- cast(data.m, Receipt_No ~ variable, sum)
  
  avgr <- round(mean(data.c$Price),2)
  
  
  
  
  # segment size
  
  Segmentsize <- uni_loyalty_card
  
  # retention rate
  
  retr0=0.24
  retr0per=0.24*100
  # Retained Customers  in  acquisition year
  
  Rc0= Segmentsize
  
  Rc1= round(Rc0*as.numeric(retr0))
  
  Rc2= round(Rc1*as.numeric(retr1))
  
  Rc3= round(Rc2*retr2)
  
  Rc4= round(Rc3*retr3)
  
  
  # number of transactions 
  
  Nt0 = round(avgtrans,2)
  
  Nt1 = Nt_1
  
  Nt2 = Nt_2
  
  Nt3 = Nt_3
  
  Nt4 = Nt_4
  
  # Average Purchase value
  
  Ap0 = avgr
  
  Ap1 = round(ap_1,2)
  Ap2 = round(ap_2,2)
  Ap3 = round(ap_3,2)
  Ap4 = round(ap_4,2)
  
  
  
  #Revenue in Period
  Rv0= round(Rc0*Nt0*Ap0,2)
  
  
  Rv1 = round(Rc1*Nt1*Ap1,2)
  
  Rv2 = round(Rc2*Nt2*Ap2,2)
  
  Rv3 = round(Rc3*Nt3*Ap3,2)
  
  Rv4 = round(Rc4*Nt4*Ap4,2)
  
  
  
  #Calculate cost
  
  
  cost0 = round(Rv0*cp0,2)
  cost1 = round(Rv1*cp1,2)
  cost2 = round(Rv2*cp2,2)
  cost3 = round(Rv3*cp3,2)
  cost4 = round(Rv4*cp4,2)
  
  # Calculate Net Revenue
  
  NetRev0 = round(Rv0-cost0)
  NetRev1 = round(Rv1-cost1)
  NetRev2 = round(Rv2-cost2)
  NetRev3 = round(Rv3-cost3)
  NetRev4 = round(Rv4-cost4) 
  
  
  #NPV calculation
  
  np0 = round(NetRev0/dr0,2)
  np1 = round(NetRev1/dr1,2)
  np2 = round(NetRev2/dr2,2)
  np3 = round(NetRev3/dr3,2)
  np4 = round(NetRev4/dr4,2)
  
  # Cumulative NPV
  
  cnpv0 = round(np0)
  cnpv1 = round(np0+ np1)
  cnpv2 = round(np0+np1+np2)
  cnpv3 = round(np0+np1+np2+np3) 
  cnpv4 = round(np0+np1+np2+np3+np4) 
  
  
  # LTV calculation
  
  LTV0 = round(cnpv0/Rc0)
  
  LTV1 = round(cnpv1/Rc0)
  
  LTV2 = round(cnpv2/Rc0)
  
  LTV3 = round(cnpv3/Rc0)
  
  LTV4 = round(cnpv4/Rc0)
  
  
  
  finalRetaimedCustomers=cbind(Rc0,Rc1,Rc2,Rc3,Rc4)
  
  finalNPV=cbind(cnpv0,cnpv1,cnpv2,cnpv3,cnpv4)
  
  finalLtv=cbind(LTV0,LTV1,LTV2,LTV3,LTV4)
  
  finalNetRev=cbind(NetRev0,NetRev1,NetRev2,NetRev3,NetRev4)
  
  finalLtvTable = cbind(finalRetaimedCustomers,finalNPV,finalLtv,finalNetRev,avgnotrans,avgr,retr0per)
  
  finalLtvTable =as.data.frame(finalLtvTable)
  

  
}









getDataLTV = function(StartDate,EndDate,items){
  
  vcharStartDate1<-paste("'",StartDate,"'",sep="")
  vcharEndDate1<-paste("'",EndDate,"'",sep="")
  
  
  #Pasting Items between '' to print them in SQL query
  
  
  if(length(items)<=1)
  {
    vcharItemString=paste("'",items[1],"'",sep="")
  } else {
    vcharItemString=paste("'",items[1],"'",sep="")
    for(i in 2:length(items)){
      vcharItemString <-paste(vcharItemString,paste("'",items[i],"'",sep=""),sep=",")
      
    }
  }
  
  
  
  
  
  #Converting dates passed as arguments to proper format
  #startDate <- as.Date(as.POSIXct(startDate,format="%m/%d/%Y"))
  #endDate <- as.Date(as.POSIXct(endDate,format="%m/%d/%Y"))
  
  
  #Filtering data between start and end Date from the result set of database
  
  
  query <- sprintf('SELECT Loyalty_Card_No , Acquisition_date,sum(Price) as Total,Store_No
                   from [dbo].Main_data_retail_analytics_VERSION_2 where Acquisition_date >=%s And Acquisition_date <%s and Item_Category_Code_Desc in (%s) 
                   group by Loyalty_Card_No,Price,Acquisition_date,Store_No',vcharStartDate1,vcharEndDate1,vcharItemString)
  
  
  
  #creating connection object and running sql query
  myconn <-odbcConnect("retail", uid="sa", pwd="Password123")
  result=sqlQuery(myconn, query)
  close(myconn)
  dim(result)
  result<-as.data.frame(result)
  
  result=result[,-2]
  result
  
}




#Writing a dynamic SQL query to fetch the data with required filters
#SQLconnection name-retail,user-sa,password-Password123


# LT=getLTV(StartDate,EndDate,items, retr1,Nt_1,Nt_2,ap_1,ap_2,retr2,retr3,Nt_3,Nt_4,ap_3,ap_4,cp0,cp1,cp2,cp3,cp4,dr0,dr1,dr2,dr3,dr4)
# 
# 
# StartDate="2010-01-01"
# items="Activewear"
# EndDate="2015-02-23"
# retr1=9
# Nt_1=400
# Nt_2=200
# ap_1=58
# ap_2=7
# retr2=75
# retr3=5
# Nt_3=100
# Nt_4=600
# ap_3=96
# ap_4=98
# cp0=67
# cp1=99
# cp2=96
# cp3=75
# cp4=85
# dr0=68
# dr1=53
# dr2=86
# dr3=65
# dr4=9
# 

# finalLtvTable=LT
# 
# finalLtv_LTV=rbind(finalLtvTable$LTV0,finalLtvTable$LTV1,finalLtvTable$LTV2,finalLtvTable$LTV3,finalLtvTable$LTV4)
# finalLtv_Rc=rbind(finalLtvTable$Rc0,finalLtvTable$Rc1,finalLtvTable$Rc2,finalLtvTable$Rc3,finalLtvTable$Rc4)
# finalLtv_cnpv=rbind(finalLtvTable$cnpv0,finalLtvTable$cnpv1,finalLtvTable$cnpv2,finalLtvTable$cnpv3,finalLtvTable$cnpv4)
# finalLtv_NetRev=rbind(finalLtvTable$NetRev0,finalLtvTable$NetRev1,finalLtvTable$NetRev2,finalLtvTable$NetRev3,finalLtvTable$NetRev4)
# Period=rbind("Period 1","Period 2","Period 3","Period 4","Period 5")
# FinalLTV_combined_table=cbind(Period,finalLtv_LTV,finalLtv_NetRev,finalLtv_cnpv,finalLtv_Rc)
# FinalLTV_combined_table=as.data.frame(FinalLTV_combined_table)
# colnames(FinalLTV_combined_table)<-c("Periods","LTV","Net_Revenue","Cummulative_NPV","Retained_Customers")
# 
# FinalLTV_combined_table=as.data.frame(FinalLTV_combined_table)
# #FinalLTV_combined_table$Cummulative_NPV= as.numeric(paste(FinalLTV_combined_table$Cummulative_NPV))
# format(round(FinalLTV_combined_table$Cummulative_NPV, 2), nsmall = 2)
# FinalLTV_combined_table