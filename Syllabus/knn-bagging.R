
##----------------------------------------------------------
if(1) {
## load libraries
library(class) ## a library with lots of classification tools
library(kknn) ## knn library
## Get data
library(MASS) ## a library of example datasets
attach(Boston)
n = dim(Boston)[1]
}
#--------------------------------------------------
if(1) {
ddf = data.frame(lstat,medv)
}
#--------------------------------------------------
if(1) {#do bootstrap loop
thek=15
B=5000
n=nrow(ddf)
nn = rep(0,B)
fmat=matrix(0,n,B)
set.seed(99)
for(i in 1:B) {
   if((i%%100)==0) cat('i: ',i,'\n')
   ii = sample(1:n,n,replace=TRUE)
   nn[i] = length(unique(ii))
   near = kknn(medv~lstat,ddf[ii,],ddf,k=thek,kernel='rectangular')
   fmat[,i]=near$fitted
}
}
#--------------------------------------------------
if(1) {#plot it
efit = apply(fmat,1,mean)
plot(lstat,medv)
points(lstat,efit,col='red')
oo = order(lstat)
for(i in 1:B) {
 lines(lstat[oo],fmat[oo,i],col=i)
 #Sys.sleep(.1)
}

lines(lstat[oo],efit[oo],col='red',lwd=4)
}

