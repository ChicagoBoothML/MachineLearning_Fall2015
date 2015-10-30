library(h2o)

h2oServer <- h2o.init(ip="localhost", port=54321, max_mem_size="4g", nthreads=-1)

# generate data -- XOR pattern 
set.seed(1)

p11 = cbind(rnorm(n=25,mean=1,sd=0.5),rnorm(n=25,mean=1,sd=0.5))
p12 = cbind(rnorm(n=25,mean=-1,sd=0.5),rnorm(n=25,mean=1,sd=0.5))
p13 = cbind(rnorm(n=25,mean=-1,sd=0.5),rnorm(n=25,mean=-1,sd=0.5))
p14 = cbind(rnorm(n=25,mean=1,sd=0.5),rnorm(n=25,mean=-1,sd=0.5))

g = as.factor(c(rep(0,50),rep(1,50)))
x = rbind(p11,p13,p12,p14)

dfh2o = as.h2o(data.frame(x=x,y=g), destination_frame = "xor.train")

# prepare the grid of points for testing 
px1 = seq(min(x[,1]), max(x[,1]), length.out = 100)
px2 = seq(min(x[,2]), max(x[,2]), length.out = 100)
gd = expand.grid(x.1=px1, x.2=px2)
dftest = as.h2o(gd, destination_frame = "xor.test")

# plot points
par(mar=rep(2,4))
plot(x, col=ifelse(g==1, "coral", "cornflowerblue"), axes=FALSE)
box()

#  1 hidden 2 neurons
model = h2o.deeplearning(x=1:2, y=3, 
                         training_frame = dfh2o,
                         hidden = 2,
                         activation = "Tanh",
                         epochs = 100000,
                         export_weights_and_biases = TRUE,
                         model_id = "xor.model2"
                         )

phat = h2o.predict(model, dftest)
phat = matrix( phat[,3], length(px1), length(px2) )

par(mar=rep(2,4))
contour(px1, px2, phat, levels=0.5, labels="", xlab="", ylab="", 
        main= "neural network -- 1 hidden layer with 2 neurons", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
points(gd, pch=".", cex=1.2, col=ifelse(phat>0.5, "coral", "cornflowerblue"))
box()

## get weights and biases
h2o.biases(model, vector_id = 1)
h2o.weights(model, matrix_id = 1)

## compute output of the first layer
tmp.df = as.h2o(data.frame(x.1=c(-1, -1, 1, 1), x.2=c(-1, 1, -1, 1)), destination_frame = "xor.4points")
trans.features = h2o.deepfeatures(model, tmp.df, layer = 1)
as.matrix( h2o.cbind(tmp.df, trans.features) )


## transformation of the original data
trans.features = h2o.deepfeatures(model, dfh2o[,1:2], layer = 1)
par(mar=rep(2,4))
plot(jitter(as.matrix(trans.features)), col=ifelse(g==1, "coral", "cornflowerblue"), axes=FALSE)
box()

## 

#  1 hidden 5 neurons
model5 = h2o.deeplearning(x=1:2, y=3, 
                         dfh2o,
                         hidden = c(5),
                         activation = "Tanh",
                         epochs = 100000,
                         export_weights_and_biases = TRUE,
                         model_id = "xor.model5"
)


phat = h2o.predict(model5, dftest)
phat = matrix( phat[,3], length(px1), length(px2) )

par(mar=rep(2,4))
contour(px1, px2, phat, levels=0.5, labels="", xlab="", ylab="", 
        main= "neural network -- 1 hidden layer with 5 neurons", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
points(gd, pch=".", cex=1.2, col=ifelse(phat>0.5, "coral", "cornflowerblue"))
box()

#  1 hidden 10 neurons
model10 = h2o.deeplearning(x=1:2, y=3, 
                         dfh2o,
                         hidden = c(10),
                         activation = "Tanh",
                         epochs = 100000,
                         export_weights_and_biases = TRUE,
                         model_id = "xor.model10"
)

phat = h2o.predict(model10, dftest)
phat = matrix( phat[,3], length(px1), length(px2) )

par(mar=rep(2,4))
contour(px1, px2, phat, levels=0.5, labels="", xlab="", ylab="", 
        main= "neural network -- 1 hidden layer with 10 neurons", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
points(gd, pch=".", cex=1.2, col=ifelse(phat>0.5, "coral", "cornflowerblue"))
box()

as.matrix( h2o.biases(model10, vector_id = 1) )
as.matrix( h2o.weights(model10, matrix_id = 1) )

as.matrix( h2o.biases(model10, vector_id = 2) )
as.matrix( h2o.weights(model10, matrix_id = 2) )

#  1 hidden 10 neurons regularized
model10.reg = h2o.deeplearning(x=1:2, y=3, 
                           dfh2o,
                           hidden = c(10),
                           activation = "Tanh",
                           epochs = 100000,
                           export_weights_and_biases = TRUE,
                           l1 = 1e-2,
                           model_id = "xor.model10.reg"
)

phat = h2o.predict(model10.reg, dftest)
phat = matrix( phat[,3], length(px1), length(px2) )

par(mar=rep(2,4))
contour(px1, px2, phat, levels=0.5, labels="", xlab="", ylab="", 
        main= "neural network -- 1 hidden layer with 10 neurons with regularization", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
points(gd, pch=".", cex=1.2, col=ifelse(phat>0.5, "coral", "cornflowerblue"))
box()

as.matrix( h2o.biases(model10.reg, vector_id = 1) )
as.matrix( h2o.weights(model10.reg, matrix_id = 1) )

as.matrix( h2o.biases(model10.reg, vector_id = 2) )
as.matrix( h2o.weights(model10.reg, matrix_id = 2) )

