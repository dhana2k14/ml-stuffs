
library(shiny)
library(DT)
library(ggplot2)
#server rfm


source("RFM_coding_standards.R")



shinyServer(function(input, output,session) {
  
  check=getRFM(StartDate="2015-01-01",
         
         EndDate="2015-01-31",
         
         stores=c("1"),
         items=c("Christmas Cards"),
         WeightRecency=1,
         WeightFrequency=1,
         WeightMonetary=1)
  
  check=as.data.frame(check)
  
  
 
  
  
  
  
  
  output$startDateUI<-renderUI({
    
    dateInput("startDateServ",label="Start Date",min=min(date_calender()),max = max(date_calender()), value = min(date_calender()) )
    
    
  })
  
  
  
  
  
  
  
  output$endDateUI<-renderUI({
    dateInput("endDateServ",label="End Date",min=min(date_calender()),max = max(date_calender()), value = max(date_calender()) )
    
    
  })
  
  
  
  
  
  
  output$storeDatasetUI <-renderUI({
    selectizeInput(
      "storeServ", 
      label="Store ", 
      choices = store_ddl() ,
      selected = store_ddl()[1],
      multiple = TRUE)
    
    
  })
  
  
  
  
  
  
  output$itemcategoryUI <-renderUI({
    
    selectizeInput(
      "itemCategoryServ", label="Item Category ", choices = itemCategory_ddl(), multiple = TRUE ,selected = itemCategory_ddl()[1]
    )
    
    
    
  })
  
 
  
  v<-reactiveValues(
     condvar1=1
  )
  
  
  
  
  observeEvent(input$calcRfmButton, {
    v$condvar1<-v$condvar1 +1
    
  })
  
  
  
  observe({
    shinyjs::toggleState("calcRfmButton", !is.null(input$storeServ))
  })
  
  
  rfmData<-reactive({
    
    
    input$calcRfmButton
    
   
    isolate(
      
      
      getRFM(StartDate = as.character(input$startDateServ) ,
                   EndDate = as.character(input$endDateServ) , 
                   stores = as.vector(input$storeServ), 
                   items = as.vector(input$itemCategoryServ) , 
                   WeightRecency = as.numeric(input$weightRecencyUI) , 
                   WeightFrequency = as.numeric(input$weightFrequencyUI) , 
                   WeightMonetary = as.numeric(input$weightMonetaryUI)))
    
    
    
  })
  
  
  
  
  
  
  
  
  output$recency<-renderUI({
    
   if(v$condvar1==1){
      
      sliderInput("recencyRange", "Recency in days",
                  min = min(as.numeric(check$Recency)), max =max(as.numeric(check$Recency)) , value = c(min(as.numeric(check$Recency)),max(as.numeric(check$Recency))) )
     
   }
   
      else{
    sliderInput("recencyRange", "Recency in days",
                min = min(as.numeric(rfmData()$Recency)), max =max(as.numeric(rfmData()$Recency)) , value =c(min(as.numeric(rfmData()$Recency)),max(as.numeric(rfmData()$Recency))) )
      }
  })
  
  
  
  
  
  
  
  output$frequency<-renderUI({
    
    if(v$condvar1==1){
      sliderInput("frequencyRange", "Frequency",
                  min = min(as.numeric(check$Frequency)) , max = max(as.numeric(check$Frequency)), value = c(min(as.numeric(check$Frequency)), max(as.numeric(check$Frequency))))
      
      
    }
      
      else{
    #min and max from rfm daya
    sliderInput("frequencyRange", "Frequency",
                min = min(as.numeric(rfmData()$Frequency)) , max = max(as.numeric(rfmData()$Frequency)), value = c(min(as.numeric(rfmData()$Frequency)), max(as.numeric(rfmData()$Frequency))))
      }  
  })
  
  
  
  
  
  
  output$countCustomers <- renderText({
    
    if(v$condvar1==1){
      d <- check
      d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
      
      if(paste(length(d[,5]))==0){
        print("No Customers")
      } else {
        paste(length(d[,5]))
      }
      
    }
    else{
    d <- rfmData()
    d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
    
    if(paste(length(d[,5]))==0){
      print("No Customers")
    } else {
      paste(length(d[,5]))
    }
    }
    
  })
  
  
  output$cust<-renderText({
    
    if(v$condvar1==1){
      d <- check
      d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
      
      if(length(d[,5])==0){
        print("  ")
      } else {
        paste("      Customers with Average Purchase Value of")
      }
      
    }
    else{
      d <- rfmData()
      d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
      
      if(length(d[,5])==0){
        print("   ")
      } else {
        paste("Customers with Average Purchase Value of")
      }
    }
  })
  
  
  output$averagePurchase <- renderText({
    if(v$condvar1==1){
      
      d <- check
      d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
      d=as.data.frame(d)
      if(length(d[,5])!=0){
        paste(round(sum(as.numeric(paste(d$Monetary)))/length(d$Monetary),2)) 
      } else {
        paste(" ")
        
      }
     
      
    }
    else{
    d <- rfmData()
    d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
    d=as.data.frame(d)
    if(length(d[,5])!=0){
    paste(round(sum(as.numeric(paste(d$Monetary)))/length(d$Monetary),2))
    } else {
      paste(" ")
    }
    
    }
    
  })
  
  
  
  
#   output$avgpur<-renderText({
#     if(v$condvar1==1){
#       d <- check
#       d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
#       
#       if(length(d[,5])==0){
#         print("  ")
#       } else {
#         paste("Average Purchase")
#       }
#       
#     }
#     else{
#       d <- rfmData()
#       d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
#       
#       if(length(d[,5])==0){
#         print("   ")
#       } else {
#         paste("Average Purchase")
#       }
#     }
#   })
  
  
  
  output$relativeRFM_range <- renderText({
    
    if(v$condvar1 == 1){
      d <- check
      d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
      paste(round(min(d[,7],2))," < Relative RFM < ",round(max(d[,7]),2))
      
    }
    else{
    d <- rfmData()
    d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
    paste(round(min(d[,7],2))," < Relative RFM < ",round(max(d[,7]),2))
    
    }
  })
  
  
  output$barchart<- renderPlot({
    
    
    if(v$condvar1==1){
      
     
      
      d <- check
      d=subset(d,as.numeric(d$Recency)>=input$recencyRange[1] & as.numeric(d$Recency)<=input$recencyRange[2] & as.numeric(d$Frequency)>=input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
      if(length(d[,5])!=0){
      d=rbind(d,c("Bins"="0.00-0.20","Recency"=NA,"Frequency"=NA,"Monetary"=NA,"Loyalty_Card_No"=NA,"RFM_Score"=NA,"Relative_RFM"=NA))
      d=rbind(d,c("Bins"="0.21-0.40","Recency"=NA,"Frequency"=NA,"Monetary"=NA,"Loyalty_Card_No"=NA,"RFM_Score"=NA,"Relative_RFM"=NA))
      d=rbind(d,c("Bins"="0.41-0.60","Recency"=NA,"Frequency"=NA,"Monetary"=NA,"Loyalty_Card_No"=NA,"RFM_Score"=NA,"Relative_RFM"=NA))
      d=rbind(d,c("Bins"="0.61-0.80","Recency"=NA,"Frequency"=NA,"Monetary"=NA,"Loyalty_Card_No"=NA,"RFM_Score"=NA,"Relative_RFM"=NA))
      d=rbind(d,c("Bins"="0.81-1.00","Recency"=NA,"Frequency"=NA,"Monetary"=NA,"Loyalty_Card_No"=NA,"RFM_Score"=NA,"Relative_RFM"=NA))
      
      #barplot(height=as.numeric(d[,6]),horiz = TRUE)
      
      #qplot(factor(Relative_RFM),data=d, binwidth = 0.25,geom ="bar", xlim = c(0,1) )
      
      d=count(d$Bins)
      
      a<-ggplot(data = d,aes(x=factor(x),y=as.numeric(freq)-1))
      ###a<-ggplot(data = d,aes(x=factor(as.character(Bins)),y=length(Loyalty_Card_No)))
      a<- a + geom_bar(stat = "identity",fill="#0078d7",colour="#0078d7") # + geom_text(stat = "bin",aes(label=..count..)))  # + stat_bin(aes(label=..count..), vjust=0, geom="text", position="identity") 
      a<- a +xlab(label = "Relative RFM") + ylab(label = "Customer")
      a<- a + geom_text(stat = "identity",aes(label=sprintf("%s",as.numeric(freq)-1),vjust=-.5)) + labs(title = "Number of customers by Relative RFM")
      a<- a + theme(axis.line=element_blank(),axis.title.x=element_blank(), 
                    axis.text.y=element_blank(),axis.ticks=element_blank(),
                   
                    axis.title.y=element_blank(),legend.position="none",
                    panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                    panel.grid.minor=element_blank(),plot.background=element_blank())
      a
      } else {
        paste(" ")
      }
      
    }
    #x=rfmData()[,4]
    #seq(from= 0,to=1,by=0.1)
    # hist(as.numeric(getRFM_plot(rfmData(),input$recencyRange[1],input$recencyRange[2],input$frequencyRange[1],frequencyRange[2])), col = 'grey', border = 'black')
    else{
      
      
    d <- rfmData()
    d=subset(d,as.numeric(d$Recency)>=input$recencyRange[1] & as.numeric(d$Recency)<=input$recencyRange[2] & as.numeric(d$Frequency)>=input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
    if(length(d[,5])!=0){
    d=rbind(d,c("Bins"="0.00-0.20","Recency"=NA,"Frequency"=NA,"Monetary"=NA,"Loyalty_Card_No"=NA,"RFM_Score"=NA,"Relative_RFM"=NA))
    d=rbind(d,c("Bins"="0.21-0.40","Recency"=NA,"Frequency"=NA,"Monetary"=NA,"Loyalty_Card_No"=NA,"RFM_Score"=NA,"Relative_RFM"=NA))
    d=rbind(d,c("Bins"="0.41-0.60","Recency"=NA,"Frequency"=NA,"Monetary"=NA,"Loyalty_Card_No"=NA,"RFM_Score"=NA,"Relative_RFM"=NA))
    d=rbind(d,c("Bins"="0.61-0.80","Recency"=NA,"Frequency"=NA,"Monetary"=NA,"Loyalty_Card_No"=NA,"RFM_Score"=NA,"Relative_RFM"=NA))
    d=rbind(d,c("Bins"="0.81-1.00","Recency"=NA,"Frequency"=NA,"Monetary"=NA,"Loyalty_Card_No"=NA,"RFM_Score"=NA,"Relative_RFM"=NA))
    
    #barplot(height=as.numeric(d[,6]),horiz = TRUE)
    
    #qplot(factor(Relative_RFM),data=d, binwidth = 0.25,geom ="bar", xlim = c(0,1) )
    
    d=count(d$Bins)
    
    a<-ggplot(data = d,aes(x=factor(x),y=as.numeric(freq)-1))
    ###a<-ggplot(data = d,aes(x=factor(as.character(Bins)),y=length(Loyalty_Card_No)))
    a<- a + geom_bar(stat = "identity",fill="#0078d7",colour="#0078d7") # + geom_text(stat = "bin",aes(label=..count..)))  # + stat_bin(aes(label=..count..), vjust=0, geom="text", position="identity") 
    a<- a +xlab(label = "Relative RFM") + ylab(label = "Customer")
    a<- a + geom_text(stat = "identity",aes(label=sprintf("%s",as.numeric(freq)-1),vjust=-.5)) + labs(title = "Number of customers by Relative RFM")
    a<- a + theme(axis.line=element_blank(),axis.title.x=element_blank(), 
                  axis.text.y=element_blank(),axis.ticks=element_blank(),
                  
                  axis.title.y=element_blank(),legend.position="none",
                  panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                  panel.grid.minor=element_blank(),plot.background=element_blank())
    a
    } else {
      
      paste(" ")
      
    }
    
    }
    
  })
  
  
  
  
  
  
  
  
#   output$countCustomerTab2 <- renderText({
#     
#     
#     
#     if(v$condvar1==1){
#       d <- check
#       d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
#       
#       paste("Customers",length(d[,5]))
#       
#     }
#     else{
#       d <- rfmData()
#       d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
#       
#       paste("Customers",length(d[,5]))
#     }
#     
#     
#   })
#   
  
  
  
  
  
  
  
#   output$averagePurchaseTab2<-renderText({
#     if(v$condvar1==1){
#       
#       d <- check
#       d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
#       d=as.data.frame(d)
#       paste("Average Purchase :","$",round(sum(as.numeric(paste(d$Monetary)))/length(d$Monetary),2))
#       
#     }
#     else{
#       d <- rfmData()
#       d=subset(d,as.numeric(d$Recency) >= input$recencyRange[1] & as.numeric(d$Recency) <= input$recencyRange[2] & as.numeric(d$Frequency) >= input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
#       d=as.data.frame(d)
#       paste("Average Purchase :","$",round(sum(as.numeric(paste(d$Monetary)))/length(d$Monetary),2))
#       
#       
#     }
#     
#   })
#   
  

  
  
  
  
  
  
#   output$recencyRangeTab2 <- renderText({
#     
#     paste("Recency: ",input$recencyRange[1],"-",input$recencyRange[2])
#   })
#   
#   
#   
#   
#   
#   
#   
#   output$frquencyRangeTab2<- renderText({
#     paste("Frequency: ",input$frequencyRange[1],"-",input$frequencyRange[2])
#     
#   })
#   
  
 
  
  reactiveDataTableRFM <- reactive(
    
    
    if(v$condvar1==1){
      d <- check
      d=subset(d,as.numeric(d$Recency)>=input$recencyRange[1] & as.numeric(d$Recency)<=input$recencyRange[2] & as.numeric(d$Frequency)>=input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
      d<- as.data.frame(d)
      if(input$binSelection == "All"){
        d
      } else{
        d<-subset(d,Bins==input$binSelection)
        d<-as.data.frame(d)
        d
      }
      
    }
    else{
      
      d<- rfmData()
      d=subset(d,as.numeric(d$Recency)>=input$recencyRange[1] & as.numeric(d$Recency)<=input$recencyRange[2] & as.numeric(d$Frequency)>=input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
      d<- as.data.frame(d)
      if(input$binSelection == "All"){
        d<-as.data.frame(d)
        d
      } else{
        d<-subset(d,Bins==input$binSelection)
        d<-as.data.frame(d)
        d
      }
    }
    
  )
  
  
  
   
  output$RFM_table<- DT::renderDataTable({
    
    reactiveDataTableRFM()
    
  },options = list(
    
    lengthChange = FALSE,
    searching = FALSE,
    pageLength = 25,
    orderClasses = TRUE
    
  ),rownames = FALSE,
  class='compact stripe',
  colnames = c( 'Bins', 'Loyalty Card', 'Recency', 'Frequency','Monetary (in $)','RFM score','Relative RFM'))

  
#   
#  output$RFM_table<-renderDataTable({
#    
#    d <- check
#    d=subset(d,as.numeric(d$Recency)>=input$recencyRange[1] & as.numeric(d$Recency)<=input$recencyRange[2] & as.numeric(d$Frequency)>=input$frequencyRange[1] & as.numeric(d$Frequency)<= input$frequencyRange[2] )
#    d<- as.data.frame(d)
#    d
#    
#  },options = list(
#    searching = FALSE,
#    pageLength = 5,
#    orderClasses = TRUE,
#    lengthMenu = c(5, 10, 15, 20)
#  ))
  
  
  
  
  output$downloadDataAsCsvRFM<- downloadHandler(
    filename = function() { paste(input$startDateServ,input$endDateServ,input$itemCategoryServ,input$storeServ,'.csv', sep='-') },
    content = function(file) {
      write.csv(reactiveDataTableRFM(), file)
    }
  )
  
  
})


