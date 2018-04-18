########################################
### get libraries
library(MASS)
library(rpart)

########################################
### get data
df = Boston
df$medv = df$medv-mean(df$medv)
n = length(df$lstat)

########################################
### maintain function on a grid of values
NUM_GRID = 100  # number of points on which we evaluate the fit
range.x = range(df$lstat)
grid.x = seq(range.x[1], range.x[2], length.out = NUM_GRID)

#give the fv such tne new.x is closest to x
myPredict = function(x, fv, new.x) {
  fv[which.min(sapply(x, function(z) sqrt(sum((z - new.x) ^ 2))))]
}

########################################
### boosting params
MAX_DEPTH = 1 #fit stumps
MAX_B = 50 #number of boosting iterations
lambda = 0.1

########################################
###initialize f and r
fhat=rep(0,NUM_GRID)
residuals=df$medv

########################################
### boosting loop
sleeptime = .8 #time to wait before drawing a new plot
Bcut=10 # number of iterations to advance by hitting return, after that us sleeptime
par( mfrow = c( 2, 2 ) )
fmat = matrix(0.0,NUM_GRID,MAX_B)
fmat[,1]=fhat

for (B in seq(1, MAX_B-1)) {
  if (B %% 1 == 0) print(paste("Iteration ==> ", B, sep=""))

  # plot points and current fit  
  plot(df$lstat, df$medv)
  points(grid.x, fhat, cex=1, col="red", type="l",lwd=2)
  title(main="data and current f")

  # plot the current fit 
  plot(grid.x, fhat, cex=1, col="red", ylim=range(df$medv),type="l",lwd=2)
  title(main="current f")
  
  # plot residuals, with fit and crushed fit
  plot(df$lstat, residuals, col="black")
  title(main="fit and crushed fit to resids")
  
  # fit residuals
  tmp.tr = rpart(res~lstat, data.frame(res=residuals, lstat=df$lstat), 
             control=rpart.control(maxdepth = MAX_DEPTH))
  # plot fit and crushed fit
  for (cx in grid.x) {
    py = predict(tmp.tr, data.frame(lstat=cx))
    points(cx, py, col="red",pch=16)
    points(cx, lambda * py, col="green",pch=16)
  }
  
  # update fit
  for (i in 1:NUM_GRID) {
    py = predict(tmp.tr, data.frame(lstat=grid.x[i]))
    fhat[i] = fhat[i] + lambda * py
  }
  fmat[,B+1]=fhat
  
  # update residuals
  for (i in 1:n) {
    residuals[i] = df$medv[i] - myPredict(grid.x, fhat, df$lstat[i])
  }
  
  # plot the new current fit 
  if(B<Bcut) {
     readline("update f?")
   } else {
      Sys.sleep(sleeptime)
   }
  plot(grid.x, fhat, cex=1, col="red", ylim=range(df$medv),type="l",lwd=2)
  title(main=paste("new current f, interation: ",B))

  
  if(B<Bcut) {
     readline("update f?")
   } else {
      Sys.sleep(sleeptime)
   }
}

########################################
###plot function iterations
par(mfrow=c(1,1))
sleeptime = .3
for(i in 1:ncol(fmat)) {
   plot(df$lstat,df$medv,pch=".",col="blue")
   lines(grid.x,fmat[,i],col="red",lwd=2)
   Sys.sleep(sleeptime)
}



