install.packages(c("devtools", "roxygen2", "testthat", "knitr"))
devtools::install_github("hadley/devtools")


install.packages("dplyr")
install.packages("plyr")
install.packages("ElemStatLearn")
install.packages("FSelector")
install.packages("ISLR")
install.packages("tree")
install.packages("rpart")
install.packages("mlbench")
install.packages("caret")
install.packages("Boruta")
install.packages('bindrcpp', dependencies=TRUE)
install.packages('devtools')
install.packages("randomForest")
install.packages("party")
install.packages("boot")
install.packages("ROSE")
install.packages('googleComputeEngineR', dependencies=TRUE)
install.packages("RWeka")




devtools::install_github("rstudio/httpuv")
devtools::install_github("assertthat")
devtools::install_github("hadley/lazyeval")
devtools::install_github("hadley/dplyr")
devtools::install_github("hadley/bigrquery")
devtools::install_github("rstudio/httpuv")
devtools::install_github("cloudyr/googleComputeEngineR")
devtools::install_github('araastat/reprtree')




#install_url("http://cran.r-project.org/bin/windows/contrib/3.2/RWeka_0.4-31.zip")


options (java.parameters = "-Xmx8192m" )
options(digits=6)
options(httr_oob_default=TRUE)

library(FSelector)
library("ISLR")
library("tree")
library("rpart")
library(mlbench)
library(Boruta)
library(googleComputeEngineR)
library(bigrquery)
library('devtools')
library(httpuv)
library(plyr)
library(ElemStatLearn)
library(FSelector)
library("ISLR")
library("tree")
library("rpart")
library(mlbench)
library(reprtree)
library("RWeka")
library("boot")
library("ROSE")





#data(hacide)
#str(hacide.train)
#table(hacide.train$cls)
#prop.table(table(hacide.train$cls))




projectId <- "yad2-analytics" # put your projectID here

df3= NULL
df4=NULL
df5=NULL
#sqlFetchAllRecords <- "SELECT  * FROM [yad2-analytics:1185028.results_20170322_140423] LIMIT 500000"
#df5 <- query_exec(sqlFetchAllRecords, project = projectId, max_pages = Inf)

sqlSuccess <- "SELECT  * FROM [yad2-analytics:1185028.results_20170322_140423] where Success = 1"
df <- query_exec(sqlSuccess, project = projectId, max_pages = Inf)
#################Data Preperation##############################
# "Drop full visitor Id, visit Id"
df <-df[-1]
df <-df[-1]
#################SQL Failure#########################################
#################Data Preperation##############################
# "Drop full visitor Id, visit Id"
df5 <-df5[-1]
df5 <-df5[-1]
#################SQL Failure#########################################



sqlSuccessSize <- length(df$WeekDay)
sqlFailureSize <- "500000"


#sqlFailure <- "SELECT  * FROM [yad2-analytics:1185028.results_20170322_140423] where Success = 0  LIMIT "
sqlFailure <- "SELECT WeekDay, Hour, MinuteRange, operatingSystem, language, MobileDeviceManuf,  VisitNumberGroup, Source, Medium, channelGrouping, campaign, platform, AccumAvgTimeonSite, AccumAvgpageviews, isFeedCar, isFeedNadlan, isFeedSecondHand, isNadlanRoomsFilter, isNadlanPriceFilter, isNadlanShowPhone, isNadlanCallSeller, Success  FROM  [yad2-analytics:1185028.results_20170322_140423] where Success = 0  LIMIT "
#print (sqlFailure)
#sqlFailure <- "SELECT WeekDay, Hour, MinuteRange, operatingSystem, language, MobileDeviceManuf, VisitNumberGroup, Source, Medium, channelGrouping, campaign, platform, AccumAvgTimeonSite, AccumAvgpageviews, isFeedCar, isFeedNadlan, isFeedSecondHand, isNadlanRoomsFilter, isNadlanPriceFilter, isNadlanShowPhone, isNadlanCallSeller, Success  FROM (SELECT rand() as random,fullvisitorid, visitid, WeekDay, Hour, MinuteRange, operatingSystem, language, MobileDeviceManuf,  VisitNumberGroup, Source, Medium, channelGrouping, campaign, platform, AccumAvgTimeonSite, AccumAvgpageviews, isFeedCar, isFeedNadlan, isFeedSecondHand, isNadlanRoomsFilter, isNadlanPriceFilter, isNadlanShowPhone, isNadlanCallSeller, Success  FROM [yad2-analytics:1185028.results_20170322_140423] where Success = 0)  LIMIT "
sqlFailure <- paste (sqlFailure, sqlFailureSize)
print (sqlFailure)
df2 <- query_exec(sqlFailure, project = projectId, max_pages = Inf)
df3<- rbind(df2,df)
df5<-df3

table(df3$Success)



data_balanced_both <- ovun.sample(Success ~ ., data = df5, method = "both", p=0.5,N=length(df5$WeekDay), seed = 1)$data
table(data_balanced_both$Success)

data_balanced_under <- ovun.sample(Success ~ ., data = df5, method = "under", N = sqlSuccessSize*2, seed = 1)$data
table(data_balanced_under$Success)



data_balanced_over <- ovun.sample(Success ~., data = df5, method = "over",N =sqlFailureSize*2,seed=1)$data
table(data_balanced_over$Success)


write.arff(data_balanced_both, "/Users/admin/Documents/yad2-ml/yad1-ml/data_balanced_both_2017_03_22.arff", eol = "\n")
write.arff(data_balanced_under, "/Users/admin/Documents/yad2-ml/yad1-ml/data_balanced_under_2017_03_22.arff", eol = "\n")
write.arff(data_balanced_over, "/Users/admin/Documents/yad2-ml/yad1-ml/data_balanced_over_2017_03_22.arff", eol = "\n")

df5<-data_balanced_under
df3<-data_balanced_under





#####################Bootstrap#############################
#library(boot)
#bootcorr <- boot(df3, df3$Success, R=500)

#data_balanced_over <- ovun.sample(Success ~., data = df5, method = "over",N = 1544)$data

#table(data_balanced_over$Success)

#data_balanced_both <- ovun.sample(Success ~ ., data = df5, method = "both", p=0.5,N=30000, seed = 1)$data
#data_balanced_under <- ovun.sample(Success ~ ., data = df5, method = "under", N = 12, seed = 1)$data
getwd()

df5$WeekDay = as.factor(df5$WeekDay)
df5$Hour = as.factor(df5$Hour)
df5$MinuteRange = as.factor(df5$MinuteRange)
df5$operatingSystem = as.factor(df5$operatingSystem)
df5$language = as.factor(df5$language)
df5$MobileDeviceManuf = as.factor(df5$MobileDeviceManuf)
df5$VisitNumberGroup = as.factor(df5$VisitNumberGroup)
df5$Source = as.factor(df5$Source)
df5$Medium = as.factor(df5$Medium)
df5$campaign = as.factor(df5$campaign)
df5$channelGrouping = as.factor(df5$channelGrouping)
df5$campaign = as.factor(df5$campaign)
df5$platform = as.factor(df5$platform)
df5$AccumAvgTimeonSite = as.numeric(df5$AccumAvgTimeonSite)
df5$AccumAvgpageviews = as.numeric(df5$AccumAvgpageviews)
df5$isFeedCar = as.factor(df5$isFeedCar)
df5$isFeedNadlan = as.factor(df5$isFeedNadlan)
df5$isFeedSecondHand = as.factor(df5$isFeedSecondHand)
df5$isNadlanRoomsFilter = as.factor(df5$isNadlanRoomsFilter)
df5$isNadlanPriceFilter = as.factor(df5$isNadlanPriceFilter)
df5$isNadlanShowPhone = as.factor(df5$isNadlanShowPhone)
df5$isNadlanCallSeller = as.factor(df5$isNadlanCallSeller)
df3 <- df5


#data.rose <- ROSE(Success ~ ., data = df5, seed = 1)$data
#table(data.rose$Success)
#df3 <- data.rose


###############Feature Selection 1#######################
weights <- information.gain(Success~., df3)
#weights[order(weights$attr_importance),]
subset <- cutoff.k(weights, 5)
f <- as.simple.formula(subset, "Success")
print(f)


###############Feature Selection 2#######################

gainRational <- gain.ratio(Success~., df3)
subset2 <- cutoff.k(gainRational, 5)
f2 <- as.simple.formula(subset2, "Success")
print(f2)

###############Chi Square #3####################################################

weightsChi <- chi.squared(Success~., df3)
#select a subset of 5 features with the lowest weight
subset3 <- cutoff.k(weightsChi, 5)
#print the results
f3 <- as.simple.formula(subset3, "profitable")
print(f3)
print(f2)
print(f)

###### Feature Selection #4  #####################################
#set.seed(123)
#boruta.train <- Boruta(Success~., data = df3, doTrace = 2)
#print(boruta.train[1])
#plot(boruta.train, xlab = , xaxt = "n")
df4=NULL
df4<- data.frame(df3)
#df4<- data.frame(df3[1:5],df3[7:17],df3[19:24])
df4$Success <- as.factor(df4$Success)
importance <- random.forest.importance(Success ~ ., df4)
print(importance)

library("randomForest")
randomForest(Success ~ ., df4)

# Load the party package. It will automatically load other required packages.
library(party)
library(randomForest)
library(reprtree)
library(rpart)



# grow tree 
#fit <- rpart(Success ~ WeekDay + Hour + MinuteRange + operatingSystem+ language + MobileDeviceManuf +   VisitNumberGroup + Source + Medium + channelGrouping + campaign + platform + AccumAvgTimeonSite + AccumAvgpageviews + isFeedCar , method="class", data=df4)
# plot tree 
#plot(fit, uniform=TRUE,  main="Classification Tree for Yad2")
#text(fit, use.n=TRUE, all=TRUE, cex=.8)

df6 <- df4
df4<- data_balanced_both

###### Data Preperation for Random Forest ################
df4$WeekDay = as.factor(df4$WeekDay)
df4$Hour = as.factor(df4$Hour)
df4$MinuteRange = as.factor(df4$MinuteRange)
df4$operatingSystem = as.factor(df4$operatingSystem)
df4$language = as.factor(df4$language)
df4$MobileDeviceManuf = as.factor(df4$MobileDeviceManuf)
df4$VisitNumberGroup = as.factor(df4$VisitNumberGroup)
df4$Source = as.factor(df4$Source)
df4$Medium = as.factor(df4$Medium)
df4$channelGrouping = as.factor(df4$channelGrouping)
df4$campaign = as.factor(df4$campaign)
df4$platform = as.factor(df4$platform)
df4$AccumAvgTimeonSite = as.numeric(df4$AccumAvgTimeonSite)
df4$AccumAvgpageviews = as.numeric(df4$AccumAvgpageviews)
df4$isFeedCar = as.factor(df4$isFeedCar)


featureArrayCounter = array(c("WeekDay","Hour","operatingSystem","language","MobileDeviceManuf","VisitNumberGroup","Source","Medium","channelGrouping","campaign","platform","AccumAvgTimeonSite","AccumAvgpageviews","isFeedCar"))
subsetAfterMimumReduction <- df4
for (i in (1:14 ) ) 
{
  counterPerFeature <- count(df4, featureArrayCounter[i])
  sprintf("Feature is + %s",  length(featureArrayCounter[i]))
  sprintf("number of category per Feature + %s",  length(counterPerFeature$freq))
    for (j in (1:length(counterPerFeature$freq) )) 
    {
      if(counterPerFeature$freq[j] <40)
      {
        
        if (featureArrayCounter[i]== "WeekDay")
        {
          subsetAfterMimumReduction = subset(subsetAfterMimumReduction, subsetAfterMimumReduction$WeekDay != counterPerFeature$WeekDay[j] )
        }else if (featureArrayCounter[i]== "Hour")
        {
          subsetAfterMimumReduction = subset(subsetAfterMimumReduction, subsetAfterMimumReduction$Hour != counterPerFeature$Hour[j] )
        }else if (featureArrayCounter[i]== "operatingSystem")
        {
          subsetAfterMimumReduction = subset(subsetAfterMimumReduction, subsetAfterMimumReduction$operatingSystem != counterPerFeature$operatingSystem[j] )
        }else if (featureArrayCounter[i]== "language")
        {
          subsetAfterMimumReduction = subset(subsetAfterMimumReduction, subsetAfterMimumReduction$language != counterPerFeature$language[j] )
        }else if (featureArrayCounter[i]== "MobileDeviceManuf")
        {
          subsetAfterMimumReduction = subset(subsetAfterMimumReduction, subsetAfterMimumReduction$MobileDeviceManuf != counterPerFeature$MobileDeviceManuf[j] )
        }else if (featureArrayCounter[i]== "VisitNumberGroup")
        {
          subsetAfterMimumReduction = subset(subsetAfterMimumReduction, subsetAfterMimumReduction$VisitNumberGroup != counterPerFeature$VisitNumberGroup[j] )
        }else if (featureArrayCounter[i]== "Source")
        {
          subsetAfterMimumReduction = subset(subsetAfterMimumReduction, subsetAfterMimumReduction$Source != counterPerFeature$Source[j] )
        }else if (featureArrayCounter[i]== "Medium")
        {
          subsetAfterMimumReduction = subset(subsetAfterMimumReduction, subsetAfterMimumReduction$Medium != counterPerFeature$Medium[j] )
        }
        
      }
    }
  
}

df4 <- subsetAfterMimumReduction
count(df4, "Success")
model <- randomForest(Success ~ WeekDay +Hour + MinuteRange + operatingSystem + language   + VisitNumberGroup  + Medium  + channelGrouping   + platform + AccumAvgTimeonSite + AccumAvgpageviews + isFeedCar + isFeedSecondHand  + isNadlanRoomsFilter + isNadlanPriceFilter + isNadlanShowPhone + isNadlanCallSeller    , method="class", data=df4, ntree=50, do.trace=5, importance = TRUE)
#fit <- randomForest(Success ~ WeekDay + Hour + MinuteRange + operatingSystem+ language + MobileDeviceManuf +   VisitNumberGroup + Source + Medium + channelGrouping + campaign + platform + AccumAvgTimeonSite + AccumAvgpageviews + isFeedCar , method="class", data=df4)
model$confusion
varImpPlot(model)


OOB.votes <- predict (model,df4,type="prob");
OOB.pred <- OOB.votes[,2];

pred.obj <- prediction (OOB.pred,y);
plot(model, log="y")
plot(model)

print(model)

importance(model)

#library("party")
#fit <- ctree(Success ~ WeekDay +Hour + MinuteRange + operatingSystem + language + MobileDeviceManuf + VisitNumberGroup + Source +  + channelGrouping + campaign + platform + AccumAvgTimeonSite + AccumAvgpageviews + isFeedCar + isFeedSecondHand  + isNadlanRoomsFilter + isNadlanPriceFilter + isNadlanShowPhone + isNadlanCallSeller, data=df4)
#plot(fit, type="simple")


reprtree:::plot.getTree(model)
tree <- getTree(model, k=1, labelVar=TRUE)
realtree <- reprtree:::as.tree(tree, model)



print(tree)


printcp(fit) # display the results 
plotcp(fit) # visualize cross-validation results 
summary(fit) # detailed summary of splits



#################Utility Functions###########################
###### Function to replace N/A in zero
na.zero <- function (x) {
  x[is.na(x)] <- 0
  return(x)
}

na.unknown <- function (x) {
  x[is.na(x)] <- "UNKNOWN"
  return(x)
}