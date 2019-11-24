library(depmixS4) #the HMM library 
library(quantmod) #a great library for technical analysis and working with time series
library(ggplot2)
library(gridExtra)

EURUSD1d = read.csv("EURUSD1d.csv")
head(EURUSD1d)

Date<-as.character(EURUSD1d[,1])
DateTS<- as.POSIXlt(Date, format = "%Y.%m.%d %H:%M:%S") #create date and time objects
TSData<-data.frame(EURUSD1d[,2:5],row.names=DateTS)
TSData<-as.xts(TSData) #build our time series data set

ATRindicator<-ATR(TSData, n=14) #calculate the indicator
ATR<-ATRindicator[,2] #grab just the ATR

LogReturns <- log(EURUSD1d$Close) - log(EURUSD1d$Open) #calculate the logarithmic returns

ModelData<-data.frame(LogReturns,ATR) #create the data frame for our HMM model

ModelData<-ModelData[-c(1:14),] #remove the data where the indicators are being calculated

colnames(ModelData)<-c("LogReturns","ATR") #name our columns

set.seed(12)
HMM<-depmix(list(LogReturns~1,ATR~1),data=ModelData,nstates=3,family=list(gaussian(),gaussian())) #We’re setting the LogReturns and ATR as our response variables, using the data frame we just built, want to set 3 different regimes, and setting the response distributions to be gaussian.

HMMfit<-fit(HMM, verbose = FALSE) #fit our model to the data set

print(HMMfit) #we can compare the log Likelihood as well as the AIC and BIC values to help choose our model

summary(HMMfit)

HMMpost<-posterior(HMMfit) #find the posterior odds for each state over our data set

head(HMMpost) #we can see that we now have the probability for each state for everyday as well as the highest probability class.


DFIndicators <- data.frame(DateTS, LogReturns, ATR); 
DFIndicatorsClean <- DFIndicators[-c(1:14), ]

Plot1Data<-data.frame(DFIndicatorsClean, HMMpost$state)
LogReturnsPlot = ggplot(Plot1Data,aes(x=Plot1Data[,1],y=Plot1Data[,2]))+geom_line(color="darkblue")+labs(title="",y="Log Returns",x="Date")
ATRPlot = ggplot(Plot1Data,aes(x=Plot1Data[,1],y=Plot1Data[,3]))+geom_line(color="darkblue")+labs(title="",y="ATR(14)",x="Date")
RegimePlot = ggplot(Plot1Data,aes(x=Plot1Data[,1],y=Plot1Data[,4]))+geom_line(color="darkblue")+labs(title="",y="Regime",x="Date")
grid.arrange(LogReturnsPlot,ATRPlot,RegimePlot,ncol=1,nrow=3)

RegimePlotData<-data.frame(Plot1Data$DateTS,HMMpost)
Regime1Plot = ggplot(RegimePlotData,aes(x=RegimePlotData[,1],y=RegimePlotData[,3]))+geom_line(color="purple")+labs(title="Regime 1",y="Probability",x="Date")
Regime2Plot = ggplot(RegimePlotData,aes(x=RegimePlotData[,1],y=RegimePlotData[,4]))+geom_line(color="purple")+labs(title="Regime 2",y="Probability",x="Date")
Regime3Plot = ggplot(RegimePlotData,aes(x=RegimePlotData[,1],y=RegimePlotData[,5]))+geom_line(color="purple")+labs(title="Regime 3",y="Probability",x="Date")
grid.arrange(Regime1Plot,Regime2Plot,Regime3Plot,ncol=1,nrow=3)
