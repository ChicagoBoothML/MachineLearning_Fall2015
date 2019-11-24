library(gbm)

set.seed(1)

# generate data
n = 1000
X = matrix(runif(2*n, -1, 1), nrow = n)
Y = as.integer(rowSums(X * X) > 0.4)
df = data.frame(X, Y)

plot(df$X1, df$X2, pch=c(3,1)[df$Y+1], col=c("green","red")[df$Y+1])

#
MAX_TREES = 5000
GRID_SIZE = 20

boost.fit = gbm(Y~., 
                distribution = "adaboost", 
                data=df, 
                n.trees=MAX_TREES, 
                interaction.depth = 1,
                shrinkage = 0.01)
  
x1 = seq(-1,1,length.out = GRID_SIZE)
x2 = seq(-1,1,length.out = GRID_SIZE)
z = rep(0, GRID_SIZE*GRID_SIZE)

for (ntree in seq(1,MAX_TREES, by = 30)) {
  for (i in 1:GRID_SIZE) {
    for (j in 1:GRID_SIZE) {
      z[(i-1)*GRID_SIZE+j] = predict(boost.fit, data.frame(X1=x1[i],X2=x2[j]), n.trees = ntree)
    }
  }
  image(x1, x2, matrix(z, nrow=GRID_SIZE), main=paste("Boosted trees = ", ntree, sep=""))
  points(df$X1, df$X2, pch=c(3,1)[df$Y+1], col=c("black","black")[df$Y+1])
}

plot(boost.fit$train.error)
