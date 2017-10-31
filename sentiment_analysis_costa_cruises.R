#CODE FOR FIRST APPROACH(Matching text against dictionary and interested only in the words present in our dictionary like here we are interested only in seeing whether our comments are having words which are present in our positive and negative dictionary)
library(rJava)
.jinit(parameters="-Xmx4g")
library(NLP)
library(openNLP)
library(wordnet)
#setDict("C:\\Program Files\\R\\R-3.1.2\\library\\wordnet\\dict")
#initDict("C:\\Program Files\\R\\R-3.1.2\\library\\wordnet\\dict")
setDict("C:\\Users\\28806\\Documents\\R\\win-library\\3.1\\wordnet\\dict")
initDict("C:\\Users\\28806\\Documents\\R\\win-library\\3.1\\wordnet\\dict")

#---------------------------------------------------------
#---------------------------------------------------------
#user defined function to change sentiment based on negation keyword before the sentiment 

opposite <- function(p)
{
  if(p == "positive")
  {
    p="negative"
  }
  else if(p== "negative")
  {
    p="positive"
  }
  else
  {
    p="neutral"
  }
  return(p)
}


#----------------------------------------------------------
#Reading All Libraries
#-----------------------------------------------------------
ambience = scan(file = as.character("E:\\POC\\IBEROSTAR\\Library\\ambience.txt"), what="charcter", comment.char=";",sep ="\n")
amenities = scan(file = as.character("E:\\POC\\IBEROSTAR\\Library\\amenities.txt"), what="charcter", comment.char=";",sep = "\n")
billing = scan(file = as.character("E:\\POC\\IBEROSTAR\\Library\\billing & price.txt"), what="charcter", comment.char=";",sep = "\n")
food = scan(file = as.character("E:\\POC\\IBEROSTAR\\Library\\food.txt"), what="charcter", comment.char=";",sep = "\n")
service = scan(file = as.character("E:\\POC\\IBEROSTAR\\Library\\Service.txt"), what="charcter", comment.char=";",sep = "\n")
room = scan(file = as.character("E:\\POC\\IBEROSTAR\\Library\\room.txt"), what="charcter", comment.char=";",sep = "\n")
staff = scan(file = as.character("E:\\POC\\IBEROSTAR\\Library\\Staff.txt"), what="charcter", comment.char=";",sep = "\n")
#suggestion_Improvement = scan(file = as.character("E:\\POC\\IBEROSTAR\\Library\\suggestion and improvement.txt"), what="charcter", comment.char=";",sep = "\n")
positive = scan(file = as.character("E:\\POC\\IBEROSTAR\\Library\\positive.txt"), what="charcter", comment.char=";",sep = "\n")
negative = scan(file = as.character("E:\\POC\\IBEROSTAR\\Library\\negative.txt"), what="charcter", comment.char=";",sep = "\n")
NegationDict = c("no", "not","never","wernt","wasnt","nt")
#-------------------------------------------------
index=read.csv("E:\\POC\\IBEROSTAR\\Library\\index.csv",stringsAsFactors = F)
index[,1]<-gsub(" ", "", index[,1], fixed = TRUE)
#input = read.csv("E:\\POC\\costa cruises\\input\\Holidaywatchdog data.csv", stringsAsFactors = F)

input = read.csv("E:\\POC\\IBEROSTAR\\input_1000.csv", stringsAsFactors = F)

#input = read.csv("E:\\xyz_AIDA.csv", stringsAsFactors = F)
sentiment_ref=read.csv("E:\\POC\\IBEROSTAR\\Library\\sentiment_ref.csv",stringsAsFactors = F)
sentiment_ref[,1]<-gsub(" ", "", sentiment_ref[,1], fixed = TRUE)
output=data.frame(Review_Id="1",Review="a",Category="a",Sentiment="a",date="a",location="a",hotelname="a",stringsAsFactors=FALSE)
#edit (input)
z=1
for(z in 2001:4000)
{
  #    comment= input[z,2]
  comment=input[z,4]
  comment=gsub("\t", "", comment, fixed = TRUE)
  comment=gsub("\n", "", comment, fixed = TRUE)
  s=as.String(comment)
  s=tolower(s)
#  s = gsub("[^a"," ",s)
  #}
  punct <- '[]\\?!\"\'#$%&(){}+*/:;,_`|~\\[<=>@\\^-]'
  s=gsub( punct, "",s)
  comment_truncated<-substr(s,start=1,stop=4000)
  comment_truncated = as.character(comment_truncated)
  if(length(grep("[[:alpha:]]", s))!=0)
  {
    
    
    #s=gsub("[[:punct:]]", "", s)
    ## Need sentence and word token annotations.
    sent_token_annotator <- Maxent_Sent_Token_Annotator()
    word_token_annotator <- Maxent_Word_Token_Annotator()
    a2 <- annotate(s, list(sent_token_annotator, word_token_annotator))
    #s[a2]
    pos_tag_annotator <- Maxent_POS_Tag_Annotator()
   # pos_tag_annotator
    a3 <- annotate(s, pos_tag_annotator, a2)
    
    a3w <- subset(a3, type == "word")
    # tags <- sapply(a3w$features, `[[`, "POS")
    
    Negation_index=which(s[a3w] %in% NegationDict )
    ambience_index = which(s[a3w] %in% ambience )
   amenities_index = which(s[a3w] %in% amenities )
    billing_price_index = which(s[a3w] %in% billing)
    
    food_index = which(s[a3w] %in% food )
   
   room_index = which(s[a3w] %in% room )
    service_index = which(s[a3w] %in% service )
    
    
    staff_index= which(s[a3w] %in% staff)
  # suggestion_Improvement_index = which(s[a3w] %in% suggestion_Improvement )
    
   
    positive_index = which(s[a3w] %in% positive )
    negative_index = which(s[a3w] %in% negative )
    
    
    if(length(c(ambience_index,billing_price_index,food_index,service_index,staff_index,amenities_index))>0)
    {
      category_index<-s[a3w[(c(ambience_index,billing_price_index,food_index,service_index,staff_index,amenities_index))]]
      category_index=as.character(category_index)
    }
    if(length(c(positive_index,negative_index))>0)
    {
      sentiment_index<-s[a3w[(c(positive_index,negative_index))]]
      sentiment_index=as.character(sentiment_index)
    } 
    
    
    #  s[a3w[MyNouns]]
    #  s[a3w[MyAdjective]]
    EntitySentiment = data.frame(shift = 1, Category_keyword = "Noun", Sentiment_keyword = "Adjective",category="a",sentiment="b",stringsAsFactors = FALSE)
    EntitySentiment = EntitySentiment [-1,]
    
    
    
    i = -1
    for (i in -3:3)
    {
      for(j in   c(ambience_index,billing_price_index,food_index,service_index,staff_index,amenities_index)) 
      {
        
        for(k in  c(positive_index,negative_index))   
        {
          
          if(j == k - i)
          {
            count_check=0
            for(l in Negation_index)
            {
              if(k-l > 0 & k-l<4)
              { 
                count_check=1
              }
            }
            if (count_check==1)
            {
              
              if(length(subset(index,Category_keyword==s[a3w[j]])[,2])>0)
              {
                category_ip=subset(index,Category_keyword==s[a3w[j]])[,2]
              }
              else
              {
                category_ip="others"
              }
              if(length(subset(sentiment_ref,Sentiment_keyword==s[a3w[k]])[,2])> 0)
              {
                sentiment=subset(sentiment_ref,Sentiment_keyword==s[a3w[k]])[,2]
                sentiment=opposite(sentiment)
              }
              else
              {
                sentiment="neutral"
              }
              record = cbind(i, s[a3w[j]], paste(c('Not',s[a3w[k]]), collapse=' '),category_ip,sentiment)
              # record = cbind(i, s[a3w[j]],df_sentiment$Sentiment,collapse=' ')
            } else {      
              
              
              if(length(subset(index,Category_keyword==s[a3w[j]])[,2])>0)
              {
                category_ip=subset(index,Category_keyword==s[a3w[j]])[,2]
              }
              else
              {
                category_ip="others"
              }
              if(length(subset(sentiment_ref,Sentiment_keyword==s[a3w[k]])[,2])>0)
              {
                sentiment=subset(sentiment_ref,Sentiment_keyword==s[a3w[k]])[,2]
              }
              else
              {
                sentiment="neutral"
              }
              record = cbind(i, s[a3w[j]], s[a3w[k]],category_ip,sentiment)
            }
            #  record = cbind(i, s[a3w[j]], s[a3w[k]])
            EntitySentiment = rbind(record, EntitySentiment)
            
          }
        }
      }
    }
    if(nrow(EntitySentiment)==0)
    {
      if(length(c(ambience_index,billing_price_index,food_index,service_index,staff_index,amenities_index))==0)
      {
        if(length(c(positive_index,negative_index))==0)
        {
          record = cbind(1, "others", "neutral","unknown","unknown")
          EntitySentiment = rbind(record, EntitySentiment)
        }
        else
        {
          for(c in 1:length(sentiment_index))
          {
            sentiment_ip=subset(sentiment_ref,Sentiment_keyword==sentiment_index[c])[,2]
            record = cbind(1, "others", "neutral","unknown",sentiment_ip)
            EntitySentiment = rbind(record, EntitySentiment)
          }
        }
        
      }
      else
      {
        for(c in 1:length(category_index))
        {
          category_ip=subset(index,Category_keyword==category_index[c])[,2]
          record = cbind(1, "others", "neutral",category_ip,"unknown")
          EntitySentiment = rbind(record, EntitySentiment)
        }
      }
    }
    colnames(EntitySentiment) = c("Shift", "Category_keyword", "Sentiment_keyword","Category","Sentiment")
  }
  
  else
  {
    print("else")
    EntitySentiment = data.frame(shift = 1, Category_keyword = "Noun", Sentiment_keyword = "Adjective",category="a",sentiment="b")
    EntitySentiment = EntitySentiment [-1,]
    record = cbind(1, "others", "neutral","undetermined","undetermined")
    EntitySentiment = rbind(record, EntitySentiment)
    colnames(EntitySentiment) = c("Shift", "Category_keyword", "Sentiment_keyword","Category","Sentiment")
  }
  #edit(EntitySentiment)
  print(z)
  # unique(EntitySentiment[,c(4,5)])
  # test<-cbind(test,review=comment)
#   if(nrow(EntitySentiment)>0)
#   {
#     
#     for (c in 1 : length(unique(EntitySentiment$Category)))
#     {
#       EntitySentiment$o_sentiment = "NULL"
#       p_cnt = nrow(EntitySentiment[which((as.character(EntitySentiment$Sentiment) == "positive") & (as.character(EntitySentiment$Category) == unique(EntitySentiment$Category)[c])),])
#       n_cnt = nrow(EntitySentiment[which((as.character(EntitySentiment$Sentiment) == "negative") & (as.character(EntitySentiment$Category) == unique(EntitySentiment$Category)[c])),])
#       
#       if(p_cnt >n_cnt)
#       {
#         EntitySentiment[which(EntitySentiment$Category == unique(EntitySentiment$Category)[c]),6] = "positive"
#       }
#       else if(p_cnt <n_cnt)
#       {
#         EntitySentiment[which(EntitySentiment$Category == unique(EntitySentiment$Category)[c]),6] = "negative"
#       }
#       else
#       {
#         EntitySentiment[which(EntitySentiment$Category == unique(EntitySentiment$Category)[c]),6] = "neutral_sentiment"
#       }
#       c  
#     }
#     
    
    for(n in 1:nrow(unique(EntitySentiment[,c(4,5)])))
    {
      test=unique(EntitySentiment[,c(4,5)])[n,]
      test<-cbind(Review_Id=input[z,1],Review=comment_truncated,test,date=input[z,2],location=input[z,3],hotelname=input[z,6])
      output=rbind(output,test)
    }
  }
  aq=ls()
  aq=aq[aq!="ambience" & aq!="opposite" & aq!="room" & aq!="billing" & aq!="food" & aq!= "service" & aq!="staff" & aq!="amenities"  & aq!= "positive" & aq!="negative" & aq!="NegationDict" & aq!="index" & aq!="input" & aq!="sentiment_ref" & aq!="output" & aq!="z"]
  rm(list=aq)
  
}
output=output[-1,]

#to be run after getting the output for exporting

write.csv(output,"E:\\POC\\Yelp_Data\\output1_bck.csv",row.names=FALSE)
# options( java.parameters = "-Xmx4g")
# #nrow(input)
# comment=paste(input[z,2], input[z,4], input[z,5], input[z,6],input[z,7],sep=' ')
# for(z in 1:nrow(input))
# 
#   
#   
# for (c in 1 : length(unique(EntitySentiment$Category)))
# {
#   
#   p_cnt = nrow(EntitySentiment[which((as.character(EntitySentiment$Sentiment) == "positive") & (as.character(EntitySentiment$Category) == unique(EntitySentiment$Category)[c])),])
#   n_cnt = nrow(EntitySentiment[which((as.character(EntitySentiment$Sentiment) == "negative") & (as.character(EntitySentiment$Category) == unique(EntitySentiment$Category)[c])),])
#   
#   if(p_cnt >n_cnt)
#   {
#     EntitySentiment[which(EntitySentiment$Category == unique(EntitySentiment$Category)[c]),6] = "positive"
#   }
#   else if(p_cnt <n_cnt)
#   {
#     EntitySentiment[which(EntitySentiment$Category == unique(EntitySentiment$Category)[c]),6] = "negative"
#   }
#   else
#   {
#     EntitySentiment[which(EntitySentiment$Category == unique(EntitySentiment$Category)[c]),6] = "neutral_sentiment"
#   }
# c  
# }
# 
# 
# 
#   
  
  

  
  
  
  