#load libraries and docv.R
library(MASS)
library(kknn)
source("docv.R") #this has docvknn used below
#make variable names in Boston directly available
attach(Boston)
#do k-fold cross validation, 5 twice, 10 once
set.seed(99) #always set the seed! (Gretzky was number 99)
kv = 2:100 #these are the k values (k as in kNN) we will try
#docvknn(matrix x, vector y,vector of k values, number of folds),
#does cross-validation for training data (x,y).
cv1 = docvknn(matrix(lstat,ncol=1),medv,kv,nfold=5)
cv2 = docvknn(matrix(lstat,ncol=1),medv,kv,nfold=5)
cv3 = docvknn(matrix(lstat,ncol=1),medv,kv,nfold=10)
#docvknn returns error sum of squares, want RMSE
cv1 = sqrt(cv1/length(medv))
cv2 = sqrt(cv2/length(medv))
cv3 = sqrt(cv3/length(medv))

#plot
rgy = range(c(cv1,cv2,cv3))
plot(log(1/kv),cv1,type="l",col="red",ylim=rgy,lwd=2,cex.lab=2.0,
     xlab="log(1/k)", ylab="RMSE")
lines(log(1/kv),cv2,col="blue",lwd=2)
lines(log(1/kv),cv3,col="green",lwd=2)
legend("topleft",legend=c("5-fold 1","5-fold 2","10 fold"),
       col=c("red","blue","green"),lwd=2,cex=1.5)
#get the min
cv = (cv1+cv2+cv3)/3 #use average
kbest = kv[which.min(cv)]
cat("the best k is: ",kbest,"\n")
#fit kNN with best k and plot the fit.
kfbest = kknn(medv~lstat,data.frame(lstat,medv),data.frame(lstat=sort(lstat)),
              k=kbest,kernel = "rectangular")
plot(lstat,medv,cex.lab=1.2)
lines(sort(lstat),kfbest$fitted,col="red",lwd=2,cex.lab=2)