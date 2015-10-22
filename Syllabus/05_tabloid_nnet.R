library(nnet)
source('05_helper.R')

cat("### read in tabloid data from web\n")
trainDf = read.csv(
  "https://raw.githubusercontent.com/ChicagoBoothML/DATA__Tabloid/master/Tabloid_train.csv")
testDf = read.csv(
  "https://raw.githubusercontent.com/ChicagoBoothML/DATA__Tabloid/master/Tabloid_test.csv")
trainDf$purchase = as.factor(trainDf$purchase)
testDf$purchase = as.factor(testDf$purchase)
names(trainDf)[1]="y"
names(testDf)[1]="y"

cat("### setup storage for results\n")
phatL = list() #store the test phat for the different methods here

cat("### fit logit\n")
###settings for logit (just one of course)
phatL$logit = matrix(0.0,nrow(testDf),1) #only one logit fit 

###fit logit
lgfit = glm(y~.,trainDf,family=binomial)
print(summary(lgfit))
###predict using logit
phat = predict(lgfit,testDf,type="response")
phatL$logit = matrix(phat,ncol=1) #logit phat

cat("### fit nnet\n")
###settings for logit (just one of course)
phatL$nnet = matrix(0.0,nrow(testDf),1) #only one logit fit 

###fit logit
nnetfit = nnet(y~.,data=trainDf,size=10, decay=0.0005, maxit=10000)
print(summary(nnetfit))
###predict using logit
phat = predict(nnetfit,testDf,type="response")
phatL$nnet = matrix(phat,ncol=1) #nnet phat

plot(phatL$logit, phatL$nnet)

plot.nnet(nnetfit)


