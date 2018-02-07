#Importing libraries
library(class)
library(colorspace)
library(digest)
#library(RODBC)
library(Rcpp)
library(plyr)
library(quadprog)
library(quantmod)
library(RJDBC)


date_calender<-function(){
  
  
  
  
  drv <- JDBC("oracle.jdbc.driver.OracleDriver",classPath="D:\\shiny\\RFM\\ojdbc6.jar", " ")
  myconn <- dbConnect(drv, "jdbc:oracle:thin:@172.25.121.55:1521/ORCL", "MRO_INV_OPT", "MRO_INV")
  
 
  
  
  
  
 #myconn <-odbcConnect("retail_orcl", uid="MRO_INV_OPT", pwd="MRO_INV")
  
  
  query="SELECT to_char(min(trunc(to_date(invoice_date,'DDMMYYYY'))),'YYYY-MM-DD') as min_date,to_char(max(trunc(to_date(invoice_date,'DDMMYYYY'))),'YYYY-MM-DD') as max_date  from EGL_ORDERS_S"
  
  #query="SELECT min(to_date(invoice_date,'DDMMYYYY')) as min_date,max(to_date(invoice_date,'DDMMYYYY')) as max_date  from EGL_ORDERS_S"

  
  
  result_date = dbGetQuery(myconn, query)
  #result_min_date=as.POSIXct(result_date$MIN_DATE, format = "%y/%m/%d")
  #result_max_date=as.POSIXct(result_date$MAX_DATE,format = "%y/%m/%d")
  result_min_date=as.Date(result_date$MIN_DATE)
  result_max_date=as.Date(result_date$MAX_DATE)
  final_result_date=c(result_min_date,result_max_date)
  
  #dbDisconnect(myconn)
  
}


store_ddl<-function(){
  
  #myconn <-odbcConnect("retail", uid="RetailsUser", pwd="Welcome123")
  
  drv <- JDBC("oracle.jdbc.driver.OracleDriver",classPath="D:\\shiny\\RFM\\ojdbc6.jar", " ")
  myconn <- dbConnect(drv, "jdbc:oracle:thin:@172.25.121.55:1521/ORCL", "MRO_INV_OPT", "MRO_INV")
  
  query="Select Order_Origin as store_name from EGL_ORDER_ORIGIN_LOOKUP_STG"
  
  
  
  result_store=dbGetQuery(myconn, query)
  
  result_store<-as.character(result_store$STORE_NAME)
  
  #dbDisconnect(myconn)
  
}

itemCategory_ddl<-function(){
  
  
  drv <- JDBC("oracle.jdbc.driver.OracleDriver",classPath="D:\\shiny\\RFM\\ojdbc6.jar", " ")
  myconn <- dbConnect(drv, "jdbc:oracle:thin:@172.25.121.55:1521/ORCL", "MRO_INV_OPT", "MRO_INV")
  
  
  query="SELECT distinct range_desc as item_name from EGL_RANGE_LOOKUP_STG"
  
  
  
  result_item=dbGetQuery(myconn, query)
  
  result_item<-as.character(result_item$ITEM_NAME)
  
  #dbDisconnect(myconn)
  
}







#Function getRFM

#INPUT PARAMETERS-StartDate,EndDate,Store name,Item Category and Weights of Recency,Frequency and Monetary
#OUTPUT PARAMETER-Dataframew ith relative RFM for all loyalty card nos within the StartDate and EndDate
#DESCRIPTION-
#Creating a customized function which will do the following:-

#FILTERS
#1)Filter the data within the provided start and end date.
#2)Filter the data according to the Store name passed as argument
#3)Filter the data according to the Item_Category passed as argument

#RECENCY,FREQUENCY AND MONETARY CALCULATION
#1)--Calculate Recency as difference between the most recent date of a customer and end date provided
#  --Calculate Frequency as the number of transactions done by a particular customer in the period between start date and end date
#  --Calculate Monetary as the sum of the Price purchased by a particular customer in the period between start date and end date
#2)Create a merged dataset having loyalty Card no and corresponding recency,Frequency and Monetary value
#3)Calculate an RFM score for each Loyalty Card no
#  --Recency will be inversed and also will be divided by 365(i.e no of days in a year) for standardization.
#  --RFM Score=Recency*WR+Frequency*WF+Monetary*WM
#4)Relative RFM=RFM Score/Maximum value of RFM Score for the selected filters




getRFM<-function(StartDate,EndDate,stores,items,WeightRecency,WeightFrequency,WeightMonetary)
{  
  
  
  #Pasting start and end date between '' to print them in SQL query
  vcharStartDate1<-paste("'",StartDate,"'",sep="")
  vcharEndDate1<-paste("'",EndDate,"'",sep="")
  
  
  #Pasting Items between '' to print them in SQL query
  
  if(items=="All Items")
  {
    vcharItemString=paste("'Activewear'",",","'Baby & Toddler Clothing'",",","'One-Pieces'",",","'Outerwear'",",","'Outfit Sets'",",","'Pants'",",","'Shirts & Tops'",",","'Shorts'",",","'Skirts'",",","'Sleepwear & Loungewear'",",","'Suits'",",","'Swimwear'",",","'Traditional & Ceremonial Clothing'",",","'Underwear & Socks'",",","'Uniforms'",",","'Wedding & Bridal Party Dresses'")
    
    
  } else {
    if(length(items)<=1)
    {
      vcharItemString=paste("'",items[1],"'",sep="")
    } else {
      vcharItemString=paste("'",items[1],"'",sep="")
      for(i in 2:length(items)){
        vcharItemString <-paste(vcharItemString,paste("'",items[i],"'",sep=""),sep=",")
        
      }
    }
  }
  
  #Pasting Stores between '' to print them in SQL query
  if(stores=="All Stores")
  {
    vcharStoreString=paste("'S0001'",",","'S0002'",",","'S0003'",",","'S0004'",",","'S0005'",",","'S0006'",",","'S0007'",",","'S0008'",",","'S0009'",",","'S0010'",",","'S0011'",",","'S0012'",",","'S0013'",",","'S0014'",",","'S0015'",",","'S0017'",",","'S0018'",",","'S0020'",",","'S0021'",",","'S0022'",",","'S0023'",",","'S0024'",",","'S0025'",",","'S0026'",",","'S0027'",",","'S0028'",",","'S0029'",",","'S0032'",",","'S0033'",",","'S0034'",",","'S0035'",",","'S0036'",",","'S0037'",",","'S0038'",",","'S0040'",",","'S0041'",",","'S0042'",",","'S0043'",",","'S0044'",",","'S0045'",",","'S0046'",",","'S0047'",",","'S0048'",",","'S0049'",",","'S0050'",",","'S0051'",",","'S0052'",",","'S0053'",",","'S0057'",",","'S0058'",",","'S0059'")
    
    
  } else {
    if(length(stores)<=1)
    {
      vcharStoreString=paste("'",stores[1],"'",sep="")
      
    } else {
      vcharStoreString=paste("'",stores[1],"'",sep="")
      for(i in 2:length(stores)){
        vcharStoreString <-paste(vcharStoreString,paste("'",stores[i],"'",sep=""),sep=",")
        
      }
    }
    
  }
  
  
  
  #Writing a dynamic SQL query to fetch the data with required filters
  #SQLconnection name-retail,user-sa,password-Password123
  #SQLquery <- sprintf('SELECT count(Loyalty_Card_No)as frequency_data,
  #                    sum(Price)as monetary_data,max(Transaction_date)as recency_date,Loyalty_Card_No ,Store_No ,Item_Category_Code_Desc 
  #                    from [dbo].Main_data_retail_analytics_VERSION_2 where Transaction_date >=%s And Transaction_date <%s and Item_Category_Code_Desc IN (%s)And Store_No IN (%s) group by Loyalty_Card_No ,Store_No ,Item_Category_Code_Desc',vcharStartDate1,vcharEndDate1,vcharItemString,vcharStoreString)
  
  
  
  SQLquery <- sprintf("SELECT count(Admin_Account_Number)as frequency_data,
  sum(EOD.NET_SALES)as monetary_data,
  to_char(max(trunc(to_date(Invoice_date,'DDMMYYYY'))),'YYYY-MM-DD') as recency_date,
  EO.Admin_Account_number,EO.Order_Origin,Item_Range
  from 
  EGL_ORDER_DETAILS_S EOD
  JOIN
  EGL_ORDERS_S EO on (EOD.Unique_invoice_number = EO.INVOICE_NUMBER)
  WHERE to_char(trunc(to_date(Invoice_date,'DDMMYYYY')),'YYYY-MM-DD') >= \'2015-01-01\' 
  AND 
   to_char(trunc(to_date(Invoice_date,'DDMMYYYY')),'YYYY-MM-DD') < \'2015-01-02\'
  group by
  EO.Admin_Account_number,EO.Order_Origin,Item_Range")
  
  
  drv <- JDBC("oracle.jdbc.driver.OracleDriver",classPath="D:\\shiny\\RFM\\ojdbc6.jar", " ")
  SQLconn <- dbConnect(drv, "jdbc:oracle:thin:@172.25.121.55:1521/ORCL", "MRO_INV_OPT", "MRO_INV")
  
  vcharSQLResult=dbGetQuery(SQLconn, SQLquery)
 
  dbDisconnect(SQLconn)
  
  
  dfSQLResult<-as.data.frame(vcharSQLResult,stringsAsFactors=FALSE)
  
  
  #Calculating Recency,Frequency and Monetary
  EndDate<- as.Date(EndDate)
  dfSQLResult$RECENCY_DATE <- as.Date(dfSQLResult$RECENCY_DATE)
  vdifftimeRecent<- difftime(EndDate ,dfSQLResult$RECENCY_DATE , units = c("days"))
  vdifftimeRecent <- as.data.frame(vdifftimeRecent)
  #Binding Recency,Frequency and Monetary with their respective loyalty Cards
  vmatRecency= cbind("Recency"=vdifftimeRecent[,1],"Loyalty_Card_No"=as.character(dfSQLResult$ADMIN_ACCOUNT_NUMBER))
  vmatFrequency <- cbind("Frequency"=dfSQLResult$FREQUENCY_DATA,"Loyalty_Card_No"=as.character(dfSQLResult$ADMIN_ACCOUNT_NUMBER))
  vmatMonetary<-cbind("Monetary"=dfSQLResult$MONETARY_DATA,"Loyalty_Card_No"=as.character(dfSQLResult$ADMIN_ACCOUNT_NUMBER))
  
  
  #Forcing R not to use exponential scientific notation
  #options("scipen"=100, "digits"=4)
  
  #Converting matrices into dataframes so that we can access the columns of those dataframes individually
  dfRecency=as.data.frame(vmatRecency,stringsAsFactors=FALSE)
  dfFrequency=as.data.frame(vmatFrequency,stringsAsFactors=FALSE)
  dfMonetary=as.data.frame(vmatMonetary,stringsAsFactors=FALSE)
  print("printing df")
  print(head(dfRecency))
  print(colnames(dfRecency))
  print(head(dfFrequency))
  print(colnames(dfFrequency))
  print(head(dfMonetary))
  print(colnames(dfMonetary))
  
  
  #Joining recency,frequency and monetary for corresponding LoyaltyCardno
  vmatMerged_data=cbind("Recency"=dfRecency$Recency,"Frequency"=dfFrequency$Frequency,"Monetary"=dfMonetary$Monetary,"Loyalty_Card_No"=as.character(dfRecency$Loyalty_Card_No))
  
  #converting the above matrix into dataframe
  dfMerged_data= as.data.frame(vmatMerged_data)
  
  
  #Calculating inverse of Recency and Standardizing it by dividing it by 365
  #Changing class of Recency,Frequency and Monetary into numeric so that we can apply mathematical functions to them
  ## IMPORTANT POINT TO NOTE
  #if we directly convert as.numeric from a factor value it converts it wrongly so we are using as.numeric(paste(Merged_Data$Monetary)))
  
  vnumRecency_std=paste(as.numeric((365/as.numeric(paste(dfMerged_data$Recency)))))
  vnumFrequency_std=as.numeric(paste((dfMerged_data$Frequency)))
  Monetary_new1=as.numeric(paste(dfMerged_data$Monetary))
  vnumMonetary_std=((Monetary_new1)/(vnumFrequency_std))
  
  
  #Converting matrices into dataframes so that we can access the columns of those dataframes individually
  dfRecency_std=as.data.frame(vnumRecency_std)
  dfFrequency_std=as.data.frame(vnumFrequency_std)
  dfMonetary_std=as.data.frame(vnumMonetary_std)
  
  #Changing class of Recency,Frequency and Monetary columns into numeric so that we can apply mathematical functions to them
  dfRecency_std$vnumRecency_std=as.numeric(paste(dfRecency_std$vnumRecency_std))
  dfFrequency_std$vnumFrequency_std=as.numeric(paste(dfFrequency_std$vnumFrequency_std))
  dfMonetary_std$vnumMonetary_std=as.numeric(paste(dfMonetary_std$vnumMonetary_std))
  
  #Calculating an RFM Score as
  #RFM Score = R*WR+F*WF+M*WM
  #where R=Recency,F=Frequency,M=Monetary 
  #and WR= Weight for Recency,WF= Weight for Frequency,WM=Weight for Monetary
  #Then combining the Recency,Frequency,Monetary and RFM values for each loyalty Card
  
  vmatRFM_Score=cbind("Loyalty_Card_No"=as.character(dfRecency$Loyalty_Card_No),"Recency"=dfRecency_std$vnumRecency_std,"Frequency"=dfFrequency_std$vnumFrequency_std,"Monetary"=dfMonetary_std$vnumMonetary_std,"RFM_Score"=paste(as.numeric(((dfRecency_std$vnumRecency_std*WeightRecency)+(dfFrequency_std$vnumFrequency_std*WeightFrequency)+(dfMonetary_std$vnumMonetary_std*WeightMonetary)))))
  dfFinal_RFM_Score=as.data.frame(vmatRFM_Score)
  print("printing vmatRFM")
  print(vmatRFM_Score[1:5,])
  
  print("printing dfFinalRFM_score")
  print(head(dfFinal_RFM_Score))
  
 
  #Calculating the maximum RFM Score for the filtered data
  vnummax_RFM=max(as.numeric(paste(dfFinal_RFM_Score$RFM_Score)))
  #vnummax_RFM=as.numeric(100)
  print("printing vnummax RFM")
  print(vnummax_RFM)
  
  #Calculating the number of rows of the filtered data
  vintrowcount_RFM=nrow(dfFinal_RFM_Score)
  print("printing no of rows")
  print(vintrowcount_RFM)
  
  #Calculating relative RFM by dividing each RFM_score by maximum RFM Score during the time period selected
  #If the number of rows is 0 then Relative RFM should come as 0
  if (vintrowcount_RFM==0) {
    Relative_RFM=0
    print("printing relativeRFM ")
    print(head(Relative_RFM))
  }  else {
    Relative_RFM=(as.numeric(paste(dfFinal_RFM_Score$RFM_Score))/vnummax_RFM)
    print("printing relativeRFM in else")
    print(head(Relative_RFM))
  }
  
  
  dfRelative_RFM= as.data.frame(Relative_RFM,stringsAsFactors=FALSE)
  print("printing dfrelativeRFM")
  print(head(dfRelative_RFM))
  
  #Adding a column Bins to the dataframe

  dfFinalRFMScore=cbind(dfFinal_RFM_Score,dfRelative_RFM)
  # print("printing relative RFM cbind")
  # print(dfFinalRFMScore[1:5])
  dfFinalRFMScoretable=cbind(Bins="0",dfFinalRFMScore)
  dfFinalRFMScoretable = as.data.frame(dfFinalRFMScoretable)
  dfFinalRFMScoretable$Bins=as.character(dfFinalRFMScoretable$Bins)
  print("printing RFM table")
  print(head(dfFinalRFMScoretable))
  
  #By creating bins we divide the records according to the relative RFM of each loyalty Card no
  #0<Relative RFM<0.20 - Bin "0.00-0.20"
  #0.20<Relative RFM<0.40 - Bin "0.20-0.40"
  #0.40<Relative RFM<0.60 - Bin "0.40-0.60"
  #0.60<Relative RFM<0.80 - Bin "0.60-0.80"
  #0.80<Relative RFM<1.00 - Bin "0.80-1.00"  
  
  i=1
  for (i in  1:nrow(dfFinalRFMScore)){
    if(dfFinalRFMScoretable$Relative_RFM[i]>0 & dfFinalRFMScoretable$Relative_RFM[i]<=0.2){
      dfFinalRFMScoretable$Bins[i]<-"0.00-0.20"
      }
    else if(dfFinalRFMScoretable$Relative_RFM[i]>0.2 & dfFinalRFMScoretable$Relative_RFM[i]<=0.4){
      dfFinalRFMScoretable$Bins[i]<-"0.21-0.40"
      }
    else if(dfFinalRFMScoretable$Relative_RFM[i]>0.4 & dfFinalRFMScoretable$Relative_RFM[i]<=0.6){
      dfFinalRFMScoretable$Bins[i]<-"0.41-0.60"
      
      }
    else if(dfFinalRFMScoretable$Relative_RFM[i]>0.6 & dfFinalRFMScoretable$Relative_RFM[i]<=0.8){
      dfFinalRFMScoretable$Bins[i]<-"0.61-0.80"
      
    }
    else {
      dfFinalRFMScoretable$Bins[i]<-"0.81-1.00"
      
    }
   
    
  }  
  
  #Creating a final dataframe with loyalty card No,recency,frequency,monetary values,RFM Score,Relative RFM and the Bin value
  dfFinalRFMScoretable=as.data.frame(dfFinalRFMScoretable,stringsAsFactors=FALSE)
  print("printing RFM table")
  print(head(dfFinalRFMScoretable))
  #Rounding values of columns to 2 digits for clarity
  dfFinalRFMScoretable$Recency=round(as.numeric(paste(as.numeric(365/as.numeric((paste(dfFinalRFMScore$Recency)))))))
  dfFinalRFMScoretable$Frequency=round(as.numeric(paste(dfFinalRFMScoretable$Frequency)),2)
  dfFinalRFMScoretable$Monetary=round(as.numeric(paste(dfFinalRFMScoretable$Monetary)),2)
  dfFinalRFMScoretable$RFM_Score=round(as.numeric(paste(dfFinalRFMScoretable$RFM_Score)),2)
  dfFinalRFMScoretable$Relative_RFM=round(as.numeric(paste(dfFinalRFMScoretable$Relative_RFM)),2)
  
  #Creating a final output table to be displayed in visualization dashboard
  dfFinalRFMScoretable=as.data.frame(dfFinalRFMScoretable,stringsAsFactors=FALSE)
 
  
  
}#end of function getRFM




getTable <- function(datasubset,binSelection){
  
  
  
  if(binSelection=="All")
    datasubset
  
  else if(binSelection=="0.00-0.20") 
    subset(datasubset,datasubset$Bins == "0.00-0.20")
  
  else if(binSelection=="0.21-0.40")
    subset(datasubset,datasubset$Bins =="0.21-0.40")
  
  else if(binSelection=="0.41-0.60")
    subset(datasubset,datasubset$Bins =="0.41-0.60")
  
  else if(binSelection=="0.61-0.80")
    subset(datasubset,datasubset$Bins =="0.61-0.80")
  
  else (binSelection=="0.81-1.00")
  subset(datasubset,datasubset$Bins == "0.81-1.00")
  
}      










getRFM_plot=function(dataSet,recency1,recency2,frequency1,frequency2){
  print("printing inside function")
  print(head(dataSet))
  x=subset(dataset,as.numeric(dataset$Recency)>=recency1&as.numeric(dataset$Recency)<=recency2 & as.numeric(dataset$Frequency)>=frequency1& as.numeric(dataset$Frequency)<=frequency2 )
  print("printing x")
  print(colnames(x))
  return(x$Loyalty_Card_No)
}

