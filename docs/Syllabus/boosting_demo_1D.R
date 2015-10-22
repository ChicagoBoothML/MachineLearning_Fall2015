
library(MASS)
library(rpart)

df = Boston

myPredict = function(x, y, new.x) {
  y[which.min(sapply(x, function(z) sqrt(sum((z - new.x) ^ 2))))]
}

n = length(df$lstat)

MAX_DEPTH = 1
NUM_GRID = 100  # number of points on which we evaluate the fit
MAX_B = 100
lambda = 0.01

residuals = rep(0, n)
range.x = range(df$lstat)
grid.x = seq(range.x[1], range.x[2], length.out = NUM_GRID)
fitted.y = rep(0, NUM_GRID)

predictor = list()
par( mfrow = c( 2, 2 ) )

tmp.tr = rpart(medv~lstat, df, control=rpart.control(maxdepth = MAX_DEPTH))
for (i in 1:NUM_GRID) {
  py = predict(tmp.tr, data.frame(lstat=grid.x[i]))
  fitted.y[i] = fitted.y[i] + py
}

for (i in 1:n) {
  residuals[i] = df$medv[i] - myPredict(grid.x, fitted.y, df$lstat[i])
}

for (B in seq(1, MAX_B-1)) {
  if (B %% 5 == 0) print(paste("Iteration ==> ", B, sep=""))
  # plot points and current fit  
  plot(df$lstat, df$medv)
  points(grid.x, fitted.y, cex=1, col="red", ylim=c(7,51))

  # plot the current fit 
  plot(grid.x, fitted.y, cex=1, col="red", ylim=c(7,51))
  
  # plot residuals
  plot(df$lstat, residuals, col="black")
  
  # fit residuals
  tmp.tr = rpart(res~lstat, data.frame(res=residuals, lstat=df$lstat), control=rpart.control(maxdepth = MAX_DEPTH))
  # plot fit and crushed fit
  for (cx in grid.x) {
    py = predict(tmp.tr, data.frame(lstat=cx))
    points(cx, py, col="red")
    points(cx, lambda * py, col="green")
  }
  
  # update fit
  for (i in 1:NUM_GRID) {
    py = predict(tmp.tr, data.frame(lstat=grid.x[i]))
    fitted.y[i] = fitted.y[i] + lambda * py
  }
  
  # update residuals
  for (i in 1:n) {
    residuals[i] = df$medv[i] - myPredict(grid.x, fitted.y, df$lstat[i])
  }
  
  # skip plot
  plot.new()
  
  
}
