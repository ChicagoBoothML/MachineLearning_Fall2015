library(h2o)

# this should be dir
SCRIPTS_DIR = "/home/mkolar/projects/mlRepos/ml2015/notes/06_nn/scripts"

source("https://raw.githubusercontent.com/ChicagoBoothML/HelpR/master/lift.R")

### read in tabloid data from web uncomment lines below
# trainDf = read.csv("https://raw.githubusercontent.com/ChicagoBoothML/DATA__Tabloid/master/Tabloid_train.csv")
# testDf = read.csv("https://raw.githubusercontent.com/ChicagoBoothML/DATA__Tabloid/master/Tabloid_test.csv")

### if reading from local directory change the two lines below 
trainDf = read.csv("/home/mkolar/projects/mlRepos/DATA__Tabloid/Tabloid_train.csv")
testDf = read.csv("/home/mkolar/projects/mlRepos/DATA__Tabloid/Tabloid_test.csv")

trainDf$purchase = as.factor(trainDf$purchase)
testDf$purchase = as.factor(testDf$purchase)
names(trainDf)[1]="y"
names(testDf)[1]="y"

######################################################################
### setup storage for results
phatL = list() #store the test phat for the different methods here

### fit logit
lgfit = glm(y~.,trainDf,family=binomial)
print(summary(lgfit))
phat = predict(lgfit,testDf,type="response")
phatL$logit = matrix(phat,ncol=1) #logit phat


### fit h2o
h2oServer <- h2o.init(ip="localhost", port=54321, max_mem_size="4g", nthreads=-1)
train_hex = as.h2o(trainDf)
test_hex = as.h2o(testDf)

if (file.exists(file.path(SCRIPTS_DIR, "tabloid", "model1"))) {
  model1 = h2o.loadModel(path = file.path(SCRIPTS_DIR, "tabloid", "model1"))
} else {
  model1 = h2o.deeplearning(
          x=2:5, y=1, 
          training_frame=train_hex,
          hidden=10,
          epochs=1000,
          export_weights_and_biases=T,
          l1 = 1e-2
          )
}


phat = predict(model1, test_hex)
phat = as.matrix( phat[,3] )
phatL$h1n10 = phat

plot(phatL$logit, phatL$h1n10)

lift.many.plot(phatL, testDf$y)
legend("topleft",legend=names(phatL),col=1:2,lty=rep(1,2))

### fit h2o deep
if (file.exists(file.path(SCRIPTS_DIR, "tabloid", "deep.model"))) {
  deep.model = h2o.loadModel(path = file.path(SCRIPTS_DIR, "tabloid", "deep.model"))
} else {
  deep.model = h2o.deeplearning(
                  x=2:5, y=1, 
                  training_frame=train_hex, 
                  hidden=c(10,10), 
                  epochs=500,
                  activation="RectifierWithDropout",
                  l1=1e-3,
                  export_weights_and_biases=TRUE
                  )
}

phat = predict(deep.model, test_hex)
phat = as.matrix( phat[,3] )
phatL$h2n10.10 = phat

pairs(phatL)

lift.many.plot(phatL, testDf$y)
legend("topleft",legend=names(phatL),col=1:3,lty=rep(1,3))

### grid search

train1 = train_hex[1:10000, ]
train2 = train_hex[1:5000, ]

hidden_opt = list(c(10), c(100), 
                  c(10, 10), c(100, 100), 
                  c(10,10,10), c(100, 100, 100)
                 )
activation_opt = list("Tanh",
                      "TanhWithDropout",
                      "Rectifier",
                      "RectifierWithDropout")
input_dropout_ratio_opt = list(0.2, 0)
l1_opt = list(1e-5, 1e-4, 1e-3)

hyper_params = list(hidden = hidden_opt, 
                     activation = activation_opt,
                     input_dropout_ratio = input_dropout_ratio_opt,
                     l1 = l1_opt
                     )


listModels = list()
phatL$dl.grid = matrix(0, nrow(test_hex), 144)
if ( length( list.files(file.path(SCRIPTS_DIR, "tabloid"), pattern="DeepLearning_model_*") ) == 144) {
  
  modelNames = list.files(file.path(SCRIPTS_DIR, "tabloid"), pattern="DeepLearning_model_*")
  numModels = 0
  for (modelName in modelNames) {
    numModels = numModels + 1
    listModels[[numModels]] = h2o.loadModel(path = file.path(SCRIPTS_DIR, "tabloid", modelName))
  }
} else {
  model_grid = h2o.grid(
                "deeplearning",
                hyper_params = hyper_params,
                x = 2:5,
                y = 1,
                epochs = 100,
                export_weights_and_biases=TRUE,
                distribution = "bernoulli",
                training_frame = train1,
                validation_frame = train2)
  
  listModels = lapply(model_grid@model_ids, function(id) h2o.getModel(id))
}

for (ii in seq(1:144)) {
  phat = predict(listModels[[ii]], test_hex)
  phat = as.matrix( phat[,3] )
  phatL$dl.grid[,ii] = phat
}

# find AUC on validation part
# aucOnValidation = sapply(1:144, function(x) listModels[[x]]@model$validation_metrics@metrics$AUC)
# imax = which.max(aucOnValidation)

lift.many.plot(lapply(seq_len(ncol(phatL$dl.grid)), function(i) phatL$dl.grid[,i]), testDf$y)

