# storelist <- as.data.frame(read.csv("D:\\Shiny\\ChurnPrediction2\\data\\storelist.csv"))

# itemlist <- as.data.frame(read.csv("D:\\Shiny\\ChurnPrediction2\\data\\itemlist.csv"))

# churn.data <- read.csv("D:\\Shiny\\ChurnPrediction2\\data\\Binary-01.csv")


source("helper.R")

library(shiny)

library(ggplot2)

library(plyr)

library(ggmap)

library(ggplot2)

library(zipcode)

library(maps)




churn.data <- readRDS("D:\\Shiny\\ChurnPrediction2\\data\\Binary-01.rds")

storelist <- readRDS("D:\\Shiny\\ChurnPrediction2\\data\\storelist.rds")

itemlist <- readRDS("D:\\Shiny\\ChurnPrediction2\\data\\itemlist.rds")




data("zipcode")










shinyServer(function(input, output) {
  
  
  
  
  
  
  
  
  
  zipcode$zip <- as.integer(zipcode$zip)
  
  default.churn.data1 <-churn.data
  
  default.churn.data1 <- createBins(default.churn.data1)
  
  default.churn.data1$probGroups <- cut(x=default.churn.data1$Probability.Of.churn,
                                        
                                        breaks=seq(from=0,
                                                   
                                                   to=ceiling(max(as.numeric(default.churn.data1$Probability.Of.churn)))+0.1,
                                                   
                                                   by = 0.20),
                                        
                                        include.lowest = TRUE,
                                        
                                        right = TRUE)
  
  default.frqtable<-count(default.churn.data1$probGroups)
  
  
  
  # For ploting only the store point on map
  
  store.loglat <- churn.data[,c("Store","Store.Zip")]
  
  store.loglat <- as.data.frame(store.loglat)
  
  store.loglat <- unique(store.loglat)
  
  store.loglat <- merge(store.loglat,zipcode,by.x = "Store.Zip",by.y = "zip",all.x = TRUE)
  
  store.loglat <- na.omit(store.loglat)
  
  
 
  
  
  
  
  # plotting map with customer data points and store data points
  default.map.churn.data <- merge(default.churn.data1,zipcode,by.x = "Customer.Zip",by.y = "zip",all.x = TRUE)
  
  default.map.churn.data <- na.omit(default.map.churn.data)
  
  default.all_states <- map_data("state")
  
  default.p <- ggplot()
  
  default.p <- default.p + geom_polygon(data=default.all_states, aes(x=long, y=lat, group = group),color="white",fill="grey")
  
  #   default.p <- ggplot()
  
  #   default.p <- default.p + geom_polygon( data=default.all_states, aes(x=long, y=lat, group = group),colour="white", fill="grey" )
  
  default.p <- default.p + geom_point(aes(x = longitude, y = latitude,color='Customers'), data =default.map.churn.data,alpha=0.2)
  
  default.p <- default.p + geom_point(aes(x = longitude, y = latitude,color="Store"),data = store.loglat)
  
  default.p <- default.p +  scale_fill_discrete("") 
  
  default.p <- default.p + theme(axis.text.x=element_blank(),
                                 
                                 axis.text.y=element_blank(),
                                 
                                 axis.title.x = element_blank(),
                                 
                                 axis.title.y = element_blank(),
                                 
                                 axis.ticks.x = element_blank(),
                                 
                                 axis.ticks.y = element_blank(),
                                 
                                 panel.grid.minor= element_blank(),
                                 
                                 panel.grid.major = element_blank(),
                                 
                                 panel.background = element_blank(),
                                 
                                 legend.title =element_blank())
  
  

  
  
  output$storelistUI <- renderUI({
    
    
    
    selectInput(inputId = "storeServ",label = "Store",choices =as.character(storelist[,1]) ,selected = storelist$Stores[1],multiple = TRUE,width = '100%')
    
    
    
  })
  
  
  
  
  
  output$itemlistUI <- renderUI({
    
    
    
    selectInput(inputId = "itemServ",label = "Item",choices = as.character(itemlist[,1]),selected = itemlist$Items[1],multiple = TRUE,width = '100%')
    
  })
  
  
  
  
  #for html table
  output$prob1 <- renderText({
    
    if(myreactivevar$myvar ==1){
      paste(default.frqtable[1,2])
    }else{
      frqtable.subset()[1,2]
      }
    
    
  })
  
  
  
  
  #for html table
  
  output$prob2 <- renderText({
    
    if(myreactivevar$myvar ==1){
      paste(default.frqtable[2,2])
    }else{
      frqtable.subset()[2,2]
      
      }
    
  })
  
  
  
  
  # for html table
  
  output$prob3 <- renderText({
    if(myreactivevar$myvar ==1){
      paste(default.frqtable[3,2])
    }else{
      frqtable.subset()[3,2]
      
      }
    
  })
  
  
  
  
  # for html table
  
  output$prob4 <- renderText({
    if(myreactivevar$myvar ==1){
      paste(default.frqtable[4,2])
    }else{
      frqtable.subset()[4,2]
      }
    
  })
  
  
  #for html table
  
  output$prob5 <- renderText({
    if(myreactivevar$myvar ==1){
      paste(default.frqtable[5,2])
    }else{
      frqtable.subset()[5,2]
      
      }
    
  })
  
  
  churnprobdatatable <- eventReactive(input$plotbutton,{
    
    frqtable.subset1 <-frqtable.subset()
    bin <- c("0.00-0.20","0.21-0.40","0.41-0.60","0.61-0.80","0.81-1.00")
    
    frqtable.subset1<- data.frame(frqtable.subset1,bin)
    
    
  })

  
  

  
 # dataTable 
  output$churnprobdatatable <- renderDataTable({
   
     
    if(myreactivevar$myvar ==1){
      bin <- c("0.00-0.20","0.21-0.40","0.41-0.60","0.61-0.80","0.81-1.00")
      
      default.frqtable<- data.frame(default.frqtable,bin)
      
      default.frqtable[,c(3,2)]
    }else{
      churnprobdatatable()[,c(3,2)]
      
    }
    
    
    
  },options = list(
    lengthChange = FALSE,
    searching = FALSE,
    paging = FALSE,
    orderClasses = TRUE,
    info = FALSE,
    autoWidth = TRUE,
    columnDefs = list(list(width = '20px', targets = "_all"))
    

    
  ),rownames = FALSE,
  class='table-bordered',
colname=c("Probability Of Churn","Customer Count")
  )
  
  
  
  
  
  
  myreactivevar <- reactiveValues(
    
    myvar=1
    
  )
  
  
  
  
  
  observeEvent(input$plotbutton, {
    
    myreactivevar$myvar <- myreactivevar$myvar +1
    
    
    
  })
  
  
  
  churn.data.subset <- reactive({
    
    churn.data1 <-churn.data
    
    churn.data1 <- createBins(churn.data1)
    
    churn.data1$probGroups <- cut(x=churn.data1$Probability.Of.churn,
                                  
                                  breaks=seq(from=0,
                                             
                                             to=ceiling(max(as.numeric(churn.data1$Probability.Of.churn)))+0.1,
                                             
                                             by = 0.20),
                                  
                                  include.lowest = TRUE,
                                  
                                  right = TRUE)
    
    
    
    subset.churn.data1 <- subset(churn.data1,churn.data1$Gender==input$gender
                                 
                                 & churn.data1$AgeBins == input$age
                                 
                                 & churn.data1$IncomeBins == input$incomegroup)
    
  })
  
  
  
  frqtable.subset <- reactive({
    
    frqtable <- count(churn.data.subset()$probGroups)
    
  })
  
  
  
  
  
  
  
  
  react.map.churn.data  <- eventReactive(input$plotbutton,{
    
    map.data <-na.omit(merge(churn.data.subset(),zipcode,by.x = "Customer.Zip",by.y = "zip",all.x = TRUE))
    

    
  })
  
  
  
  
  
  mymapplot <- eventReactive(input$plotbutton,{
    
    
    
    #     map<-get_map(location='united states', zoom=5, maptype = "toner-lite",
    
    #                  source='google',color='color')
    
    #     mappoints<- ggmap(map)+ geom_point(aes(x = longitude, y = latitude, size = 2), data = react.map.churn.data(), alpha = .5)
    
    #     mappoints
    
    
    
    
    
    
    
    #     zip.plot<-qmplot(longitude,latitude,
    
    #                      data =react.map.churn.data() ,
    
    #                      colour =I('red') ,
    
    #                      darken = .2,
    
    #                      zoom =input$slide,
    
    #                      source = 'google',margins = TRUE)
    
    #     zip.plot
    

    
    all_states <- map_data("state")
    
    subset.store.loglat<-store.loglat
    
    p <- ggplot()
    
    p <- p + geom_polygon(data=all_states, aes(x=long, y=lat, group = group),color="white",fill="grey" )
    
    
    
    #     p <- ggplot()
    
    #     p <- p + geom_polygon( data=all_states, aes(x=long, y=lat, group = group),colour="white", fill="grey" )
    
    p <- p + geom_point(aes(x = longitude, y = latitude,color='Customers'), data =react.map.churn.data())
    
    p <- p + geom_point(aes(x = longitude, y = latitude,color='Store'),data = subset.store.loglat)
    
    p <- p + theme(axis.text.x=element_blank(),
                   
                   axis.text.y=element_blank(),
                   
                   axis.title.x = element_blank(),
                   
                   axis.title.y = element_blank(),
                   
                   axis.ticks.x = element_blank(),
                   
                   axis.ticks.y = element_blank(),
                   
                   panel.grid.minor= element_blank(),
                   
                   panel.grid.major = element_blank(),
                   
                   panel.background = element_blank(),
                   
                   legend.title=element_blank())
    
    p
    

    #     fu<-ggplot(mtcars, aes(x=longitude, y=latitude)) + geom_point()

  })
  
  
  
  output$mymap <- renderPlot({
    
    if(myreactivevar$myvar ==1 ){
      
      default.p

    }else{
      mymapplot()
    }
    
  })
  
  
  
  
  
  output$jitter <- renderPlot({
    
    
    if(myreactivevar$myvar ==1){
      jitter.p <- ggplot() + geom_point(data = default.map.churn.data, aes(x=Gender,y=Income,color=probGroups),position=position_jitter( width = 0.2, height = 0) )
      
      jitter.p <- jitter.p + theme(panel.grid.minor= element_blank(),
                                   
                                   panel.grid.major = element_blank(),
                                   
                                   panel.background = element_blank(),
                                   
                                 legend.position=c(.5, .5))
    
    jitter.p
    
    
    }else{
      
      jitter.p <- ggplot() + geom_point(data = react.map.churn.data() , aes(x=Gender,y=Income,color=probGroups),position=position_jitter( width = 0.2, height = 0) )
      
      jitter.p <- jitter.p + theme(panel.grid.minor= element_blank(),
                                   
                                   panel.grid.major = element_blank(),
                                   
                                   panel.background = element_blank(),
                                   
                                   legend.position=c(.5, .5))
      
      jitter.p
      
      
    }
    
  })
  
  
  

  #   output$qwerty <- renderPrint({
  
  #        QW<- subset(store.loglat, store.loglat$longitude <= input$myplot_brush$xmax & store.loglat$longitude > input$myplot_brush$xmin & store.loglat$latitude >= input$myplot_brush$ymin & store.loglat$latitude < input$myplot_brush$ymax  )
  
  #     QW$Store
  
  #     
  
  #   })
  
  #   
  
  #   output$asdf <- renderTable({
  
  #     
  
  #     react.map.churn.data()
  
  # #     
  
  # #      & store.loglat$latitude >= input$myplot_brush$ymin & store.loglat$latitude < input$myplot_brush$ymax
  
  # #     subset(store.loglat, store.loglat$longitude <= input$myplot_brush$xmax & store.loglat$longitude > input$myplot_brush$xmin & store.loglat$latitude >= input$myplot_brush$ymin & store.loglat$latitude < input$myplot_brush$ymax  )
  
  #     
  
  #   }) 
  
  #    
  
  
  
  reactiveDataTableChurnPrediction <- reactive(
    
    if(myreactivevar$myvar == 1 ){
      
      
      
      store.loglat.1 <- store.loglat
      
      store.loglat.1 <- subset(store.loglat, store.loglat$longitude <  input$myplot_brush$xmax   & store.loglat$longitude > input$myplot_brush$xmin  & store.loglat$latitude >= input$myplot_brush$ymin  & store.loglat$latitude < input$myplot_brush$ymax)
      
      #     store.loglat.1 <- subset(store.loglat, store.loglat$longitude <= input$myplot_brush$xmax & store.loglat$longitude > input$myplot_brush$xmin & store.loglat$latitude >= input$myplot_brush$ymin & store.loglat$latitude < input$myplot_brush$ymax  )
      
      store.loglat.1 <- store.loglat.1$Store
      
      store.data <- merge(default.churn.data1[,1:11],store.loglat,by.x = "Store",by.y = "Store",all.y = TRUE)
      
      store.data <- store.data[store.data$Store %in% store.loglat.1,]
      
      store.data[,c(1,2,7:10)]
      
    
      
    }else{
      
      store.loglat.1 <- store.loglat
      
      store.loglat.1 <- subset(store.loglat, store.loglat$longitude <= input$myplot_brush$xmax & store.loglat$longitude > input$myplot_brush$xmin & store.loglat$latitude >= input$myplot_brush$ymin & store.loglat$latitude < input$myplot_brush$ymax  )
      
      store.loglat.1 <- store.loglat.1$Store
      
      store.data <- na.omit(merge(react.map.churn.data()[,1:11],store.loglat,by.x = "Store",by.y = "Store",all.y = TRUE))
      
      store.data <- store.data[store.data$Store %in% store.loglat.1,]
      
      #       store.data <- store.data[,c(1,2,7:10)]
      store.data[,c(1,2,8:11)]
      
    }
    
  )
  
  
  output$doubleclickdata_storedata <- renderDataTable({
    
    reactiveDataTableChurnPrediction()
    
  },options = list(
    lengthChange = FALSE,
    pageLength = 10,
    orderClasses = TRUE
    
    
  ),rownames = FALSE,
  filter = 'top',
  
  class='compact stripe',
  colname=c("Store","Loyalty Card","Age","Gender","Income","Probability")
  )
  
  output$downloadDataAsCsvChurnPrediction<- downloadHandler(
    filename = function() { paste(input$startDateServ,input$endDateServ,"ChurnPrediction",'.csv', sep='-') },
    content = function(file) {
      write.csv(reactiveDataTableChurnPrediction (), file)
    }
  )
  
  
  output$reactvar <- renderText({
    
    
    
    store.loglat.1 <- store.loglat
    
    store.loglat.1 <- subset(store.loglat, store.loglat$longitude <  input$myplot_brush$xmax   & store.loglat$longitude > input$myplot_brush$xmin  & store.loglat$latitude >= input$myplot_brush$ymin  & store.loglat$latitude < input$myplot_brush$ymax)
    
    store.loglat.1 <- store.loglat.1$Store
    
    
    
    paste(myreactivevar$myvar,store.loglat.1)
    
  })
  
  
  
  
  
  
  
  output$brushdata <- renderPrint({
    
    input$myplot_brush
    
    
    
  })
  
  #   output$mypoint_data <- renderDataTable({
  
  #     if(myreactivevar$myvar == 1 ){
  
  #       default.vv <- na.omit(default.map.churn.data)
  
  #       default.vv <- subset(default.vv,default.vv$longitude >= input$myplot_brush$xmin & default.vv$longitude <= input$myplot_brush$xmax & default.vv$latitude >= input$myplot_brush$ymin & default.vv$latitude <= input$myplot_brush$ymax )
  
  #       default.vv <- default.vv[,c(1,2,7:11)]
  
  #       
  
  #       }else{
  
  #     vv <- react.map.churn.data()
  
  #     
  
  #     vv <- subset(vv,vv$longitude >= input$myplot_brush$xmin & vv$longitude <= input$myplot_brush$xmax & vv$latitude >= input$myplot_brush$ymin & vv$latitude <= input$myplot_brush$ymax )
  
  #     vv <- vv[,c(1,2,7:11)]
  
  #       }
  
  #     
  
  #   },options = list(
  
  #     
  
  #     lengthChange = FALSE,
  
  #     searching = FALSE,
  
  #     pageLength = 10,
  
  #     orderClasses = TRUE
  
  #     
  
  #   ),rownames = FALSE,
  
  #   class='compact stripe',
  
  #   colname=c("Customer zip","Loyalty Card","Age","Gender","Income","Probability","Store")
  
  #   
  
  #   )
  
  #   
  
  
  
  
  
  
})