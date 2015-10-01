######################################################################
if(0) {cat("###load data and libs\n")
#load knn library (need to have installed this with install.packages("kknn"))
library(kknn)
#get Boston data
library(MASS) ## a library of example datasets
attach(Boston)
}
######################################################################
if(1) {cat("### run sim\n")
kvec=c(4,40,200)
nsim=100
fit1=rep(0,nsim)
fit2=rep(0,nsim)
fit3=rep(0,nsim)
train = data.frame(lstat,medv)
test = data.frame(lstat=sort(lstat))
par(mfrow=c(2,3))
ntrain=300

fitind = 400
ylm = c(10,25)

#get good one
gknn = kknn(medv~lstat,train,data.frame(lstat=test[fitind,1]),k=40,kernel = "rectangular")
set.seed(99)
for(i in 1:nsim) {
   ii = sample(1:nrow(train),ntrain)
   kfit1 = kknn(medv~lstat,train[ii,],test,k=kvec[1],kernel = "rectangular")
   kfit2 = kknn(medv~lstat,train[ii,],test,k=kvec[2],kernel = "rectangular")
   kfit3 = kknn(medv~lstat,train[ii,],test,k=kvec[3],kernel = "rectangular")

   plot(lstat,medv)
   lines(test$lstat,kfit1$fitted,col="red",lwd=2)
   points(test[fitind,1],kfit1$fitted[fitind],col="green",pch=17,cex=2)

   plot(lstat,medv)
   lines(test$lstat,kfit2$fitted,col="red",lwd=2)
   points(test[fitind,1],kfit2$fitted[fitind],col="green",pch=17,cex=2)

   plot(lstat,medv)
   lines(test$lstat,kfit3$fitted,col="red",lwd=2)
   points(test[fitind,1],kfit3$fitted[fitind],col="green",pch=17,cex=2)

   fit1[i]=kfit1$fitted[fitind]
   boxplot(fit1[1:i],ylim=ylm)
   abline(h=gknn$fitted,col="red")

   fit2[i]=kfit2$fitted[fitind]
   boxplot(fit2[1:i],ylim=ylm)
   abline(h=gknn$fitted,col="red")

   fit3[i]=kfit3$fitted[fitind]
   boxplot(fit3[1:i],ylim=ylm)
   abline(h=gknn$fitted,col="red")

   #readline("go?")
}
}
