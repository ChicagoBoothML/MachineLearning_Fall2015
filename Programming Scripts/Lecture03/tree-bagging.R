##----------------------------------------------------------
if(1) {
## load library
library(tree)
}
#--------------------------------------------------
if(0) {#boston data
library(MASS) ## a library of example datasets
attach(Boston)
n = dim(Boston)[1]
ddf = data.frame(x=lstat,y=medv)
oo=order(ddf$x)
ddf = ddf[oo,]
}
#--------------------------------------------------
if(1) { #simulated data
sigma=2
n=500
x=sort(rnorm(n))
y = x^3+sigma*rnorm(n)
ddf=data.frame(x,y)
}
#--------------------------------------------------
if(1) {
par(mfrow=c(1,1))
plot(x,y)
readline("done?")
}
#--------------------------------------------------
if(1) {#do bootstrap loop
B=400
n=nrow(ddf)
nn = rep(0,B)
fmat=matrix(0,n,B)
set.seed(99)

par(mfrow=c(1,2))
for(i in 1:B) {
   if((i%%100)==0) cat('i: ',i,'\n')
   ii = sample(1:n,n,replace=TRUE)
   nn[i] = length(unique(ii))
   bigtree = tree(y~x,ddf[ii,],mindev=.0002)
   #print(length(unique(bigtree$where)))
   temptree = prune.tree(bigtree,best=30)
   #print(length(unique(temptree$where)))
   fmat[,i]=predict(temptree,ddf)

   plot(ddf$x,ddf$y)
   lines(ddf$x,fmat[,i],col=i,lwd=2)
   plot(temptree,type="uniform")
   Sys.sleep(.1)
   
}
readline("done?")
}
#--------------------------------------------------
if(1) {#plot it
par(mfrow=c(1,1))
plot(ddf$x,ddf$y)
efit = apply(fmat,1,mean)
lines(ddf$x,efit,col='blue',lwd=4)
if(1) {
   lines(x,x^3,col="red")
}
}

