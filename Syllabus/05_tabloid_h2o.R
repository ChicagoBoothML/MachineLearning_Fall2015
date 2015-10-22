
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


######################################################################
cat("### setup storage for results\n")
phatL = list() #store the test phat for the different methods here

################################################################
library(h2o)
h2oServer <- h2o.init(ip="localhost", port=54321, max_mem_size="4g", nthreads=-1)
train_hex = as.h2o(trainDf)
test_hex = as.h2o(testDf)

EPOCHS=3

args <- list(
  list(hidden=c(64),             epochs=EPOCHS),
  list(hidden=c(128),            epochs=EPOCHS),
  list(hidden=c(256),            epochs=EPOCHS),
  list(hidden=c(512),            epochs=EPOCHS),
  list(hidden=c(1024),           epochs=EPOCHS),
  list(hidden=c(64,64),          epochs=EPOCHS),
  list(hidden=c(128,128),        epochs=EPOCHS),
  list(hidden=c(256,256),        epochs=EPOCHS),
  list(hidden=c(64,64,64),       epochs=EPOCHS),
  list(hidden=c(128,128,128),    epochs=EPOCHS),
  list(hidden=c(256,256,256),    epochs=EPOCHS),
  
  list(hidden=c(64),             epochs=EPOCHS, activation="RectifierWithDropout"),
  list(hidden=c(128),            epochs=EPOCHS, activation="RectifierWithDropout"),
  list(hidden=c(256),            epochs=EPOCHS, activation="RectifierWithDropout"),
  list(hidden=c(512),            epochs=EPOCHS, activation="RectifierWithDropout"),
  list(hidden=c(1024),           epochs=EPOCHS, activation="RectifierWithDropout"),
  list(hidden=c(64,64),          epochs=EPOCHS, activation="RectifierWithDropout"),
  list(hidden=c(128,128),        epochs=EPOCHS, activation="RectifierWithDropout"),
  list(hidden=c(256,256),        epochs=EPOCHS, activation="RectifierWithDropout"),
  list(hidden=c(64,64,64),       epochs=EPOCHS, activation="RectifierWithDropout"),
  list(hidden=c(128,128,128),    epochs=EPOCHS, activation="RectifierWithDropout"),
  list(hidden=c(256,256,256),    epochs=EPOCHS, activation="RectifierWithDropout"),
  
  list(hidden=c(64),             epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
  list(hidden=c(128),            epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
  list(hidden=c(256),            epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
  list(hidden=c(512),            epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
  list(hidden=c(1024),           epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
  list(hidden=c(64,64),          epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
  list(hidden=c(128,128),        epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
  list(hidden=c(256,256),        epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
  list(hidden=c(64,64,64),       epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
  list(hidden=c(128,128,128),    epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
  list(hidden=c(256,256,256),    epochs=EPOCHS, activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5)
)

run <- function(extra_params) {
  str(extra_params)
  print("Training.")
  model <- do.call(h2o.deeplearning, modifyList(list(
      x=2:5, y=1, 
      training_frame=train_hex 
      ), extra_params)
      )
  phat = predict(model, test_hex)
  phat = as.matrix( phat[,3] )
  phat
}

o = lapply(args, run)
phatL$dl = matrix(unlist(o), ncol=length(o))


#model = h2o.deeplearning(
#      x=2:5, y=1, 
#      training_frame=train_hex,
#      hidden=10,
#      epochs=10,
#      export_weights_and_biases=T  
#      )

###############################################################
cat("### fit logit\n")
###settings for logit (just one of course)
phatL$logit = matrix(0.0,nrow(testDf),1) #only one logit fit 

###fit logit
lgfit = glm(y~.,trainDf,family=binomial)
print(summary(lgfit))
###predict using logit
phat = predict(lgfit,testDf,type="response")
phatL$logit = matrix(phat,ncol=1) #logit phat


######################################################################
cat("### lift\n")
load("tabloid_h2o_results.RData")
nmethod = length(phatL)
phatBest = matrix(0.0,nrow(testDf),nmethod) #pick off best from each method
colnames(phatBest) = names(phatL)
for(i in 1:nmethod) {
  nrun = ncol(phatL[[i]])
  lvec = rep(0,nrun)
  print(nrun)
  print(lvec)
  for(j in 1:nrun) lvec[j] = lossf(testDf$y,phatL[[i]][,j])
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

###########################
liftfL(testDf$y, no)

#h2o.shutdown(h2oServer)
