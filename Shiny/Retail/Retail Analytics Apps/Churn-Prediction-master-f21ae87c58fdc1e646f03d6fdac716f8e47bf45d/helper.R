
store_ddl<-function(){
  storelist <- as.data.frame(read.csv("D:\\Shiny\\ChurnPrediction\\data\\storelist.csv"))
  storelist <- as.character(storelist$Stores)
}

item_ddl <- function(){
  itemlist <- as.data.frame(read.csv("D:\\Shiny\\ChurnPrediction\\data\\itemlist.csv"))
  itemlist <- as.character(itemlist$Items)
}


# churnData <- function(){
#   churn.data <- read.csv("D:\\Shiny\\ChurnPrediction\\data\\Binary-01.csv")
#   churn.data
#   
# }
createBins<-function(help.churn.data){
  
  
  for (i in  1:nrow(help.churn.data)){
    if(help.churn.data$Age[i]<=20){
      help.churn.data$AgeBins[i]<-"Less than 20"
    }
    else if(help.churn.data$Age[i]>20 & help.churn.data$Age[i]<=30){
      help.churn.data$AgeBins[i]<-"21-30"
    }
    else if(help.churn.data$Age[i]>30 & help.churn.data$Age[i]<=40){
      help.churn.data$AgeBins[i]<-"31-40"
    }
    else if(help.churn.data$Age[i]>40 & help.churn.data$Age[i]<=50){
      help.churn.data$AgeBins[i]<-"41-50"
    }
    
    else {
      help.churn.data$AgeBins[i]<-"More than 50"
    }
    
    
  } 
  
  
  
  for (i in  1:nrow(help.churn.data)){
    if(help.churn.data$Income[i]<=20000){
      help.churn.data$IncomeBins[i]<-"Less than 20K"
    }
    else if(help.churn.data$Income[i]>20000 & help.churn.data$Income[i]<=30000){
      help.churn.data$IncomeBins[i]<-"21K-30K"
    }
    else if(help.churn.data$Income[i]>30001 & help.churn.data$Income[i]<=40000){
      help.churn.data$IncomeBins[i]<-"31K-40K"
    }
    else if(help.churn.data$Income[i]>40000 & help.churn.data$Income[i]<=50000){
      help.churn.data$IncomeBins[i]<-"41K-50K"
    }
    else if(help.churn.data$Income[i]>50000 & help.churn.data$Income[i]<=60000){
      help.churn.data$IncomeBins[i]<-"51K-60K"
    }
    else {
      help.churn.data$IncomeBins[i]<-"More than 60K"
    }
    
    
  }
  
  

  help.churn.data
}





# subset.churn.data1 <- subset(churn.data1,churn.data1$AgeBins == "More than 50" & churn.data1$IncomeBins == "21K-30K" & churn.data1$Gender == "Male")
# 
# summary(subset.churn.data1)
