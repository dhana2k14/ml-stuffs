
library(shiny)
library(DT)
library(ggplot2)
library(reshape)



source("D:\\LTV\\shiny\\RA_LTV.R")
       #encoding = "UTF-8", local = TRUE)


shinyServer(function(input, output,session) {


  
 
  observe({
    if (is.null(input$ltvStartDateServ) ||
        is.null(input$ltvEndDateServ) ||
        is.null(input$ltvItemCategoryServ) ||
        is.null(input$retentionPercentagePeriod3in) || input$retentionPercentagePeriod3in==""||
        is.null(input$transactionsPeriod2in) || input$transactionsPeriod2in =="" ||
        is.null(input$transactionsPeriod3in) || input$transactionsPeriod3in =="" ||
        is.null(input$averagePurchasePeriod2in) || input$averagePurchasePeriod2in =="" ||
        is.null(input$averagePurchasePeriod3in) || input$averagePurchasePeriod3in =="" ||
        is.null(input$retentionPercentagePeriod4in) || input$retentionPercentagePeriod4in =="" ||
        is.null(input$retentionPercentagePeriod5in) || input$retentionPercentagePeriod5in =="" ||
        is.null(input$transactionsPeriod4in) ||  input$transactionsPeriod4in =="" ||
        is.null(input$transactionsPeriod5in) ||  input$transactionsPeriod5in =="" ||
        is.null(input$averagePurchasePeriod4in) || input$averagePurchasePeriod4in =="" ||
        is.null(input$averagePurchasePeriod5in) || input$averagePurchasePeriod5in =="" ||
        is.null(input$costPercentagePeriod1in) || input$costPercentagePeriod1in =="" ||
        is.null(input$costPercentagePeriod2in) || input$costPercentagePeriod2in =="" ||
        is.null(input$costPercentagePeriod3in) || input$costPercentagePeriod3in =="" ||
        is.null(input$costPercentagePeriod4in )|| input$costPercentagePeriod4in =="" || 
        is.null(input$costPercentagePeriod5in) || input$costPercentagePeriod5in =="" ||
        is.null(input$discountPercentagePeriod1in) || input$discountPercentagePeriod1in =="" ||
        is.null(input$discountPercentagePeriod2in) || input$discountPercentagePeriod2in =="" ||
        is.null(input$discountPercentagePeriod3in) || input$discountPercentagePeriod3in =="" ||
        is.null(input$discountPercentagePeriod4in) || input$discountPercentagePeriod4in =="" ||
        is.null(input$discountPercentagePeriod5in) || input$discountPercentagePeriod5in ==""
    ) {
      shinyjs::disable("calcltvButton")
    } else {
      shinyjs::enable("calcltvButton")
    }
  })
  
  
  firstTable <- getLTV(StartDate="2010-01-01",
                      items="Activewear",
                      EndDate="2015-02-23",
                      retr1=32,
                      Nt_1=2,
                      Nt_2=3,
                      ap_1=250,
                      ap_2=275,
                      retr2=95,
                      retr3=52,
                      Nt_3=4,
                      Nt_4=5,
                      ap_3=400,
                      ap_4=325,
                      cp0=10,
                      cp1=15,
                      cp2=20,
                      cp3=25,
                      cp4=30,
                      dr0=10,
                      dr1=10,
                      dr2=10,
                      dr3=10,
                      dr4=10)
  
  firstStartDate=as.Date("2010-01-01")
  firstEndDate=as.Date("2015-02-23")
  firstTable<- as.data.frame(firstTable)
  
  
  tbl=firstTable
  
  finalLtv_LTV=rbind(tbl$LTV0,tbl$LTV1,tbl$LTV2,tbl$LTV3,tbl$LTV4)
  finalLtv_Rc=rbind(tbl$Rc0,tbl$Rc1,tbl$Rc2,tbl$Rc3,tbl$Rc4)
  finalLtv_cnpv=rbind(tbl$cnpv0,tbl$cnpv1,tbl$cnpv2,tbl$cnpv3,tbl$cnpv4)
  finalLtv_NetRev=rbind(tbl$NetRev0,tbl$NetRev1,tbl$NetRev2,tbl$NetRev3,tbl$NetRev4)
  Period=rbind("Period 1","Period 2","Period 3","Period 4","Period 5")
  
  FinalLTV_combined_table=cbind(Period,finalLtv_LTV,finalLtv_NetRev,finalLtv_cnpv,finalLtv_Rc)
  FinalLTV_combined_table=as.data.frame(FinalLTV_combined_table)
  colnames(FinalLTV_combined_table)<-c("Period","LTV","Net_Revenue","Cumulative_NPV","Retained_Customers")
  firstTableWithProperName=as.data.frame(FinalLTV_combined_table)
  firstTableWithProperName
  
  
  
  
  r_CondVar<-reactiveValues(
    condVar1=1
  )
  
  
  
  
  observeEvent(input$calcltvButton, {
    r_CondVar$condVar1 <- r_CondVar$condVar1 +1
    
  })
  
  
  
  
  
  
  output$startDateUI<-renderUI({
    
    dateInput("ltvStartDateServ",label="Start Date",min=min(date_calender()),max = max(date_calender()),format = "yyyy-mm-dd", value = min(date_calender()) )
    
    
  })
  
  
  
  

  output$endDateUI<-renderUI({
    dateInput("ltvEndDateServ",label="End Date",min=min(date_calender()),max = max(date_calender()),format = "yyyy-mm-dd", value = max(date_calender()) )
    
    
  })


  
  
  
  output$itemcategoryUI <-renderUI({
    
    selectizeInput(
      "ltvItemCategoryServ", label="Item Category ", choices = itemCategory_ddl(), multiple = TRUE,selected = itemCategory_ddl()[1]
    )
 
  })
  
  
  
  
  
  
  

  
  ltvData <-reactive({
    input$calcltvButton
    
    isolate(getLTV(StartDate =input$ltvStartDateServ ,
              EndDate = input$ltvEndDateServ,
              items =input$ltvItemCategoryServ, 
              retr1 =as.numeric(input$retentionPercentagePeriod3in) , 
              Nt_1 = as.numeric(input$transactionsPeriod2in ), 
              Nt_2 = as.numeric(input$transactionsPeriod3in ), 
              ap_1 =as.numeric(input$averagePurchasePeriod2in ), 
              ap_2 =as.numeric(input$averagePurchasePeriod3in ),
              retr2 =as.numeric(input$retentionPercentagePeriod4in ), 
              retr3 =as.numeric(input$retentionPercentagePeriod5in ), 
              Nt_3=as.numeric(input$transactionsPeriod4in ),
              Nt_4=as.numeric(input$transactionsPeriod5in ), 
              ap_3=as.numeric(input$averagePurchasePeriod4in ), 
              ap_4= as.numeric(input$averagePurchasePeriod5in ), 
              cp0 = as.numeric(input$costPercentagePeriod1in) , 
              cp1 = as.numeric(input$costPercentagePeriod2in) , 
              cp2 =as.numeric(input$costPercentagePeriod3in) , 
              cp3=as.numeric(input$costPercentagePeriod4in), 
              cp4=as.numeric(input$costPercentagePeriod5in), 
              dr0 =as.numeric(input$discountPercentagePeriod1in) ,
              dr1 =as.numeric(input$discountPercentagePeriod2in ), 
              dr2 =as.numeric(input$discountPercentagePeriod3in ), 
              dr3 =as.numeric(input$discountPercentagePeriod4in ), 
              dr4 =as.numeric(input$discountPercentagePeriod5in)))
    
    
  })

  
  output$transactionsPeriod1in <- renderText({
    if(r_CondVar$condVar1==1){
      dat <-firstTable$avgnotrans
      dat
      
    }
    else{
    dat <-ltvData()$avgnotrans
    dat
    }
  })
  
  
  output$averagePurchasePeriod1in <- renderText({
    if(r_CondVar$condVar1==1){
      dat <-firstTable$avgr
      dat 
    }
    else{
    dat <-ltvData()$avgr
    dat
    }
  })
  
 
  
  output$retentionPercentagePeriod2in <- renderText({
    if(r_CondVar$condVar1==1){
      dat <-firstTable$retr0
      dat
    }
    else{
    dat <-ltvData()$retr0
    dat
    }
  })
  
  
  reactiveTableWithProperName <- reactive({
   
    tbl=ltvData()
    
    finalLtv_LTV=rbind(tbl$LTV0,tbl$LTV1,tbl$LTV2,tbl$LTV3,tbl$LTV4)
    finalLtv_Rc=rbind(tbl$Rc0,tbl$Rc1,tbl$Rc2,tbl$Rc3,tbl$Rc4)
    finalLtv_cnpv=rbind(tbl$cnpv0,tbl$cnpv1,tbl$cnpv2,tbl$cnpv3,tbl$cnpv4)
    finalLtv_NetRev=rbind(tbl$NetRev0,tbl$NetRev1,tbl$NetRev2,tbl$NetRev3,tbl$NetRev4)
    Period=rbind("Period 1","Period 2","Period 3","Period 4","Period 5")
    
    FinalLTV_combined_table=cbind(Period,finalLtv_LTV,finalLtv_NetRev,finalLtv_cnpv,finalLtv_Rc)
    FinalLTV_combined_table=as.data.frame(FinalLTV_combined_table)
    colnames(FinalLTV_combined_table)<-c("Period","LTV","Net_Revenue","Cumulative_NPV","Retained_Customers")
    FinalLTV_combined_table=as.data.frame(FinalLTV_combined_table)
    FinalLTV_combined_table
    
    
  })
  
 
 

 output$ltvVSperiods <- renderPlot({
   
   
   if(r_CondVar$condVar1==1){
     
     firstPlotDataTalble <- firstTableWithProperName 
     
     firstPlot <- ggplot(data =firstPlotDataTalble ,aes(x=factor(Period),y=as.numeric(paste(LTV))))
     firstPlot <-  firstPlot + geom_bar(stat = "identity",fill="#4169e1", colour="#4169e1") + labs(title = paste("LTV"))
     firstPlot <-  firstPlot + theme(axis.ticks=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),
                  legend.position="none",
                   panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                   panel.grid.minor=element_blank(),plot.background=element_blank())
     firstPlot
     
   }
   else{
   
   d<- reactiveTableWithProperName()
   
   a<-ggplot(data = d,aes(x=factor(Period),y=as.numeric(paste(LTV))))
   a<- a + geom_bar(stat = "identity",fill="#4169e1", colour="#4169e1")+ labs(title = paste("LTV "))
   a<- a + theme(axis.ticks=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),
                 legend.position="none",
                 panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                 panel.grid.minor=element_blank(),plot.background=element_blank())
   a
   
   }
   
 })
 
 
 output$netrevVSperiods <- renderPlot({
   
   if(r_CondVar$condVar1==1){
     
     
     d<- firstTableWithProperName 
     
     a<-ggplot(data = d,aes(x=factor(Period),y=as.numeric(round(as.numeric(paste(Net_Revenue))/1000))))
     a<- a + geom_bar(stat = "identity",fill="#a3ce21",colour="#a3ce21")+ labs(title = paste("Net Revenue"))
     
     a<- a + theme(axis.ticks=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),
                  legend.position="none",
                   panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                   panel.grid.minor=element_blank(),plot.background=element_blank())
     a
     
     
   }
   else{
   d<- reactiveTableWithProperName()
   
   a<-ggplot(data = d,aes(x=factor(Period),y=round(as.numeric(paste(Net_Revenue))/1000)))
   a<- a + geom_bar(stat = "identity",fill="#a3ce21",colour="#a3ce21") + labs(title = paste("Net Revenue"))

   a<- a + theme(axis.ticks=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),
                 legend.position="none",
                 panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                 panel.grid.minor=element_blank(),plot.background=element_blank())
   a
   
   }
 })
 
 
 
 output$outLTV1 <- renderText ({
   if(r_CondVar$condVar1==1){
     
     vcharLTV1=as.character(firstTableWithProperName$LTV[1])
     prettyNum(vcharLTV1,big.mark = ",", small.mark = " ")
   }
   else{
     vcharReactLTV1=as.character(reactiveTableWithProperName()$LTV[1])
     prettyNum(vcharReactLTV1,big.mark = ",", small.mark = " ")
   }
   })
 
 
 
 
 output$outNetRev1 <- renderText({
   if(r_CondVar$condVar1==1){
    vcharNetRev1=as.character(firstTableWithProperName$Net_Revenue[1])
    prettyNum(vcharNetRev1,big.mark = ",", small.mark = " ")
    }
   else{
     vcharReactNetRev1=as.character(reactiveTableWithProperName()$Net_Revenue[1])
     prettyNum(vcharReactNetRev1,big.mark = ",", small.mark = " ")
     }
   })
 
 
 
 
 output$outCumNPV1 <- renderText({
   if(r_CondVar$condVar1==1){
    vcharCumNPV1=as.character(firstTableWithProperName$Cumulative_NPV[1])
    prettyNum(vcharCumNPV1,big.mark = ",", small.mark = " ")
    
   }
   else{
     vcharReactCumNPV1=as.character(reactiveTableWithProperName()$Cumulative_NPV[1])
     prettyNum(vcharReactCumNPV1,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 
 output$outRetCust1 <- renderText({
   if(r_CondVar$condVar1==1){
     vcharRetCust1=as.character(firstTableWithProperName$Retained_Customers[1])
     prettyNum(vcharRetCust1,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactRetCust1=as.character(reactiveTableWithProperName()$Retained_Customers[1])
     prettyNum(vcharReactRetCust1,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 
 output$outLTV2<- renderText ({
   if(r_CondVar$condVar1==1){
    vcharLTV2 = as.character(firstTableWithProperName$LTV[2])
    prettyNum(vcharLTV2,big.mark = ",", small.mark = " ")
    
   }
   else{
   vcharReactLTV2=as.character(reactiveTableWithProperName()$LTV[2])
   prettyNum(vcharReactLTV2,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 
 output$outNetRev2<- renderText({
   if(r_CondVar$condVar1==1){
     vcharNetRev2=as.character(firstTableWithProperName$Net_Revenue[2])
     prettyNum(vcharNetRev2,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactNetRev2 = as.character(reactiveTableWithProperName()$Net_Revenue[2])
     prettyNum(vcharReactNetRev2,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 output$outCumNPV2<- renderText({
   if(r_CondVar$condVar1==1){
     vcharCumNPV2= as.character(firstTableWithProperName$Cumulative_NPV[2])
     prettyNum(vcharCumNPV2,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactCumNPV2=as.character(reactiveTableWithProperName()$Cumulative_NPV[2])
     prettyNum(vcharReactCumNPV2,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 output$outRetCust2<- renderText({
   if(r_CondVar$condVar1==1){
     vcharRetCust2=as.character(firstTableWithProperName$Retained_Customers[2])
     prettyNum(vcharRetCust2,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactRetCust2=as.character(reactiveTableWithProperName()$Retained_Customers[2])
     prettyNum(vcharReactRetCust2,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 
 
 
 output$outLTV3<- renderText({
   if(r_CondVar$condVar1==1){
     vcharLTV3=as.character(firstTableWithProperName$LTV[3])
     prettyNum(vcharLTV3,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactLTV3=as.character(reactiveTableWithProperName()$LTV[3])
     prettyNum(vcharReactLTV3,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 output$outNetRev3<- renderText({
   if(r_CondVar$condVar1==1){
     vcharNetRev3 =as.character(firstTableWithProperName$Net_Revenue[3])
     prettyNum(vcharNetRev3,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactNetRev3=as.character(reactiveTableWithProperName()$Net_Revenue[3])
     prettyNum(vcharReactNetRev3,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 output$outCumNPV3<- renderText({
   if(r_CondVar$condVar1==1){
     vcharCumNPV3=as.character(firstTableWithProperName$Cumulative_NPV[3])
     prettyNum(vcharCumNPV3,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactCumNPV3=as.character(reactiveTableWithProperName()$Cumulative_NPV[3])
     prettyNum(vcharReactCumNPV3,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 output$outRetCust3<- renderText({
   if(r_CondVar$condVar1==1){
     vcharRetCust3=as.character(firstTableWithProperName$Retained_Customers[3])
     prettyNum(vcharRetCust3,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactRetCust3=as.character(reactiveTableWithProperName()$Retained_Customers[3])
     prettyNum(vcharReactRetCust3,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 
 
 
 output$outLTV4<- renderText({
   if(r_CondVar$condVar1==1){
     vcharLTV4=as.character(firstTableWithProperName$LTV[4])
     prettyNum(vcharLTV4,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactLTV4 =as.character(reactiveTableWithProperName()$LTV[4])
     prettyNum(vcharReactLTV4,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 output$outNetRev4<- renderText({
   if(r_CondVar$condVar1==1){
     vcharNetRev4=as.character(firstTableWithProperName$Net_Revenue[4])
     prettyNum(vcharNetRev4,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactNetRev4=as.character(reactiveTableWithProperName()$Net_Revenue[4])
     prettyNum(vcharReactNetRev4,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 output$outCumNPV4<- renderText({
   if(r_CondVar$condVar1==1){
     vcharCumNPV4=as.character(firstTableWithProperName$Cumulative_NPV[4])
     prettyNum(vcharCumNPV4,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactCumNPV4=as.character(reactiveTableWithProperName()$Cumulative_NPV[4])
     prettyNum(vcharReactCumNPV4,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 output$outRetCust4<- renderText({
   if(r_CondVar$condVar1==1){
     vcharRetCust4=as.character(firstTableWithProperName$Retained_Customers[4])
     prettyNum(vcharRetCust4,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactRetCust4=as.character(reactiveTableWithProperName()$Retained_Customers[4])
     prettyNum(vcharReactRetCust4,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 
 
 
 output$outLTV5<- renderText({
   if(r_CondVar$condVar1==1){
     vcharLTV5=as.character(firstTableWithProperName$LTV[5])
     prettyNum(vcharLTV5,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactLTV5=as.character(reactiveTableWithProperName()$LTV[5])
     prettyNum(vcharReactLTV5,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 output$outNetRev5<- renderText({
   if(r_CondVar$condVar1==1){
     vcharNetRev5=as.character(firstTableWithProperName$Net_Revenue[5])
     prettyNum(vcharNetRev5,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactNetRev5=as.character(reactiveTableWithProperName()$Net_Revenue[5])
     prettyNum(vcharReactNetRev5,big.mark = ",", small.mark = " ")
     
     }
   })
 
 
 
 output$outCumNPV5<- renderText({
   if(r_CondVar$condVar1==1){
     vcharCumNPV5=as.character(firstTableWithProperName$Cumulative_NPV[5])
     prettyNum(vcharCumNPV5,big.mark = ",", small.mark = " ")
     
   }
   else{
   vcharReactCumNPV5=as.character(reactiveTableWithProperName()$Cumulative_NPV[5])
   prettyNum(vcharReactCumNPV5,big.mark = ",", small.mark = " ")
   
   }
   })
 
 
 output$outRetCust5<- renderText({
   if(r_CondVar$condVar1==1){
     vcharRetCust5=as.character(firstTableWithProperName$Retained_Customers[5])
     prettyNum(vcharRetCust5,big.mark = ",", small.mark = " ")
     
   }
   else{
     vcharReactRetCust5=as.character(reactiveTableWithProperName()$Retained_Customers[5])
     prettyNum(vcharReactRetCust5,big.mark = ",", small.mark = " ")
     
     }
   })

 reactivedataTableLTVServ <- reactive(
   if(r_CondVar$condVar1==1){
     getDataLTV(StartDate="2010-01-01",
                items="Activewear",
                EndDate="2015-02-23")
     
   } else{
     
     getDataLTV(StartDate =input$ltvStartDateServ ,
                EndDate = input$ltvEndDateServ,
                items =input$ltvItemCategoryServ)
   }
   
 )
 
 
 output$dataTableLTVUI <- DT::renderDataTable({
   
  
   reactivedataTableLTVServ()
   
   
 },options = list(
   
   lengthChange = FALSE,
   searching = FALSE,
   pageLength = 25,
   orderClasses = TRUE
   
 ),rownames = FALSE,
 #class='compact stripe'
 colnames = c( 'Loyalty Card No', 'Price', 'Store Name' )
 
)
 
 

 inputDateDiff <- reactive({
   if(r_CondVar$condVar1==1){

     firstTablePeriodDays=  firstEndDate - firstStartDate + 1
     firstTablePeriodDays <- as.numeric(firstTablePeriodDays)
     firstTablePeriodDays
     
   } else{
   periodDays <-  input$ltvEndDateServ - input$ltvStartDateServ + 1
   periodDays <- as.numeric(periodDays)
   periodDays
   }
 })
 
 
 
 
 output$period1DatesUI<- renderText({
   
   if(r_CondVar$condVar1==1){
     
     firstTablePeriod1Dates <- paste(firstStartDate ,"to",firstEndDate)
     firstTablePeriod1Dates
     
   } else{
     input$calcltvButton
     isolate(period1Dates <- paste(input$ltvStartDateServ ,"to", input$ltvEndDateServ))
   period1Dates
   }
 })
 
 
 
 output$period2DatesUI<- renderText({
   
   if(r_CondVar$condVar1==1){
     
     firstTablePeriod2Dates <- paste(firstEndDate+1,"to", firstEndDate +inputDateDiff())
     firstTablePeriod2Dates
     
     
   } else{
     input$calcltvButton
   isolate(period2Dates <-  paste(input$ltvEndDateServ+1,"to",input$ltvEndDateServ+inputDateDiff()))
   
   period2Dates
   }
   
 })
 
 
 output$period3DatesUI<- renderText({
   
   if(r_CondVar$condVar1==1){
     
     firstTablePeriod3Dates <- paste(firstEndDate + inputDateDiff() + 1,"to", firstEndDate +2*inputDateDiff())
     firstTablePeriod3Dates
     
   } else{
     
     input$calcltvButton
  isolate(period3Dates <-  paste(input$ltvEndDateServ+inputDateDiff()+1,"to",input$ltvEndDateServ+2*inputDateDiff()))
   
   period3Dates
   }
   
 })
 
 
 output$period4DatesUI<- renderText({
   
   if(r_CondVar$condVar1==1){
     
     firstTablePeriod2Dates <- paste(firstEndDate + 2*inputDateDiff() + 1,"to", firstEndDate + 3*inputDateDiff())
     firstTablePeriod2Dates
     
   } else{
     input$calcltvButton
  isolate(period4Dates <-  paste(input$ltvEndDateServ+2*inputDateDiff()+1,"to",input$ltvEndDateServ+3*inputDateDiff()))
   
   period4Dates
   }
   
 })
 
 
 output$period5DatesUI<- renderText({
   
   if(r_CondVar$condVar1==1){
     
     firstTablePeriod2Dates <- paste(firstEndDate + 3*inputDateDiff()+1,"to", firstEndDate + 4*inputDateDiff())
     firstTablePeriod2Dates
     
   } else{
     input$calcltvButton
  isolate( period5Dates <-  paste(input$ltvEndDateServ+3*inputDateDiff()+1,"to",input$ltvEndDateServ+4*inputDateDiff()))
   
   period5Dates
   }
   
 })
 
 
 
output$retentionPercentagePeriod1in <- renderText({
  
  paste(100)
  
})




output$downloadDataAsCsv<- downloadHandler(
  filename = function() { paste(input$ltvStartDateServ,input$ltvEndDateServ,input$ltvItemCategoryServ,'.csv', sep='-') },
  content = function(file) {
    write.csv(reactivedataTableLTVServ(), file)
  }
)
  
  
  
  

 
 
#   output$LTV_data <- renderTable({
#     
#     if(r_CondVar$condVar1==1){
#       
#       firstTableWithProperName
#     }else{
#       reactiveTableWithProperName()
#       
#     }
#     
#   })
  
 
 
})

