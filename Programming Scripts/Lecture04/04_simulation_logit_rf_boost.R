######################################################################
cat("### simulate data from a logit with 2 x's\n")
set.seed(99)
beta=matrix(c(2,2),ncol=1)
trainn=10000
testn=5000
p=2
##train
x = matrix(2*runif(trainn*p)-1,ncol=p)
eta = x %*% beta
pvec = exp(eta)/(1+exp(eta))
trainDf = data.frame(y=rbinom(trainn,1,pvec),x=x)
trainDf$y = as.factor(trainDf$y)
##test
x = matrix(2*runif(testn*p)-1,ncol=p)
eta = x %*% beta
pvecte = exp(eta)/(1+exp(eta))
testDf = data.frame(y=rbinom(testn,1,pvecte),x=x)
testDf$y = as.factor(testDf$y)

pnm = "sim"
######################################################################
cat("### load librairies and make loss and lift functions\n")
library(tree)
library(randomForest)
library(gbm)

#--------------------------------------------------
#deviance loss function
lossf = function(y,phat,wht=0.0000001) {
#y should be 0/1
#wht shrinks probs in phat towards .5, don't log 0!
   if(is.factor(y)) y = as.numeric(y)-1
   phat = (1-wht)*phat + wht*.5
   py = ifelse(y==1,phat,1-phat)
   return(-2*sum(log(py)))
}

#--------------------------------------------------
#lift function
liftf = function(yl,phatl,dopl=TRUE) {
   if(is.factor(yl)) yl = as.numeric(yl)-1
   oo = order(-phatl)
   sy = cumsum(yl[oo])/sum(yl==1)
   if(dopl) {
      ii = (1:length(sy))/length(sy)
      plot(ii,sy,type='l',lwd=2,col='blue',xlab='% tried',ylab='% of successes',cex.lab=2)
      abline(0,1,lty=2)
   }
   return(sy)
}

######################################################################
cat("### setup storage for results\n")
phatL = list() #store the test phat for the different methods here

######################################################################
cat("### fit logit\n")
###settings for logit (just one of course)
phatL$logit = matrix(0.0,nrow(testDf),1) #only one logit fit 

###fit logit
lgfit = glm(y~.,trainDf,family=binomial)
print(summary(lgfit))
###predict using logit
phat = predict(lgfit,testDf,type="response")

phatL$logit = matrix(phat,ncol=1) #logit phat

##do lift
junk=liftf(testDf$y,phatL$logit[,1])

######################################################################
cat("### fit random Forests\n")
set.seed(99)

##settings for randomForest
p=ncol(trainDf)-1
mtryv = c(p,sqrt(p))
ntreev = c(500,1000)
setrf = expand.grid(mtryv,ntreev)
colnames(setrf)=c("mtry","ntree")
phatL$rf = matrix(0.0,nrow(testDf),nrow(setrf))

###fit rf
for(i in 1:nrow(setrf)) {
   cat("on randomForest fit ",i,"\n")
   print(setrf[i,])

   #fit and predict
   frf = randomForest(y~.,data=trainDf,mtry=setrf[i,1],ntree=setrf[i,2])
   phat = predict(frf,newdata=testDf,type="prob")[,2]

   phatL$rf[,i]=phat
}

######################################################################
cat("### fit boosting\n")

##settings for boosting
idv = c(2,4)
ntv = c(1000,5000)
shv = c(.1,.01)
setboost = expand.grid(idv,ntv,shv)
colnames(setboost) = c("tdepth","ntree","shrink")
phatL$boost = matrix(0.0,nrow(testDf),nrow(setboost))

trainDfB = trainDf; trainDfB$y = as.numeric(trainDfB$y)-1
testDfB = testDf; testDfB$y = as.numeric(testDfB$y)-1

##fit boosting
for(i in 1:nrow(setboost)) {
   cat("on boosting fit ",i,"\n")
   print(setboost[i,])

   ##fit and predict
   fboost = gbm(y~.,data=trainDfB,distribution="bernoulli",
              n.trees=setboost[i,2],interaction.depth=setboost[i,1],shrinkage=setboost[i,3])
   phat = predict(fboost,newdata=testDfB,n.trees=setboost[i,2],type="response")

   phatL$boost[,i] = phat
}

######################################################################
cat("### plot loss\n")
lossL = list()
nmethod = length(phatL)
for(i in 1:nmethod) {
   nrun = ncol(phatL[[i]])
   lvec = rep(0,nrun)
   print(nrun)
   for(j in 1:nrun) lvec[j] = lossf(testDf$y,phatL[[i]][,j])
   lossL[[i]]=lvec; names(lossL)[i] = names(phatL)[i]
}
lossv = unlist(lossL)
plot(lossv,ylab="loss on Test",type="n")
nloss=0
for(i in 1:nmethod) {
   ii = nloss + 1:ncol(phatL[[i]])
   points(ii,lossv[ii],col=i,pch=17)
   nloss = nloss + ncol(phatL[[i]])
}
legend("topright",legend=names(phatL),col=1:nmethod,pch=rep(17,nmethod))


######################################################################
cat("### lift\n")
nmethod = length(phatL)
phatBest = matrix(0.0,nrow(testDf),nmethod) #pick off best from each method
colnames(phatBest) = names(phatL)
for(i in 1:nmethod) {
   nrun = ncol(phatL[[i]])
   lvec = rep(0,nrun)
   print(nrun)
   for(j in 1:nrun) lvec[j] = lossf(testDf$y,phatL[[i]][,j])
   print(lvec)
   imin = which.min(lvec)
   cat("imin: ",imin,"\n")
   phatBest[,i] = phatL[[i]][,imin]
   phatBest[,i] = phatL[[i]][,1]
}
pairs(phatBest)

dfrac = (1:nrow(testDf))/nrow(testDf)
plot(c(0,1),c(0,1),xlab='% tried',ylab='% of successes',cex.lab=2,type="n")
for(i in 1:ncol(phatBest)) {
   temp = liftf(testDf$y,phatBest[,i],dopl=FALSE)
   lines(dfrac,temp,type="l",col=i)
}
abline(0,1,lty=2)
legend("topleft",legend=names(phatL),col=1:nmethod,lty=rep(1,nmethod))

