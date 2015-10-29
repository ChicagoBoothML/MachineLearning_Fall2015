library(randomForest)
library(e1071)
library(h2o)
library(glmnet)

# we will not train many models in the classroom on this example
# as they will take a long time
inClass = TRUE

# MNIST files in Git repository 
MNIST_DIR = "/home/mkolar/projects/mlRepos/DATA___LeCun___MNISTDigits"

# code to load digits and show one digit
# assumption here is that we are in "scripts/" directory
source("mnist.helper.R")

# load all digits
digit.data = load_mnist(MNIST_DIR)

# training sample size and number of pixels
dim(digit.data$train$x)

#   Pixels are organized into images like this:
#  
#   001 002 003 ... 026 027 028
#   029 030 031 ... 054 055 056
#   057 058 059 ... 082 083 084
#    |   |   |  ...  |   |   |
#   729 730 731 ... 754 755 756
#   757 758 759 ... 782 783 784
#

show_digit(digit.data$train$x[1, ])
show_digit(digit.data$train$x[2, ])


####################################
### 
### Logistic regression
###
####################################

if (file.exists("glmnet_mnist.RData")) {
  load("glmnet_mnist.RData")
} else {
  glm_fit = cv.glmnet(x=digit.data$train$x, y=as.factor(digit.data$train$y), 
                      family="multinomial",
                      type.logistic="modified.Newton")
  save(glm_fit, file = "glmnet_mnist.RData")
}

phat = predict(glm_fit, digit.data$test$x, s=glm_fit$lambda.1se, type = "response")
yhat = apply(phat,1,which.max)
ot = table(yhat, digit.data$test$y)
sum(diag(ot)) / 10000 # accuracy 

plot(glm_fit)

plot(glm_fit_ridge$glmnet.fit, xvar = "lambda")


####################################
### 
### Random forest
###
####################################

if (file.exists("mnist.rf.mtry_28.RData")) {
  load(fName)
} else {
  num_trees = 1000
  
  rf_28 = randomForest(
    x=digit.data$train$x, 
    y=as.factor(digit.data$train$y), 
    xtests=digit.data$test$x,
    sampsize=6000,   # sample about 10% of data
    ntree=num_trees, 
    mtry=28,         # try 28 = sqrt(784) features at each split
    importance=TRUE, 
    nodesize=100     # need this many observations in the leaf
  )
  
  save(rf_28, file = "fName")
}
rf_28

varImpPlot(rf_28, type=2, n.var=20, main="Variable importance")
predicted.test = predict(rf_28, test)
confusionMatrix(table(predicted.test,digit.data$test$y))

####################################
### 
### Neural networks
###
####################################

# start or connect to h2o server
h2oServer <- h2o.init(ip="localhost", port=54321, max_mem_size="4g", nthreads=-1)

# we need to load data into h2o format
train_hex = as.h2o(data.frame(x=digit.data$train$x, y=digit.data$train$y))
test_hex = as.h2o(data.frame(x=digit.data$test$x, y=digit.data$test$y))

predictors = 1:784
response = 785

train_hex[,response] <- as.factor(train_hex[,response])
test_hex[,response] <- as.factor(test_hex[,response])

# create frames with input features only
# we will need these later for unsupervised training
trainX = train_hex[,-response]
testX = test_hex[,-response]


####################################################################

if (inClass == FALSE) {
  dl_model <- h2o.deeplearning(x=predictors, y=response,
                             training_frame=train_hex,
                             activation="RectifierWithDropout",
                             input_dropout_ratio=0.2,
                             classification_stop=-1,  # Turn off early stopping
                             l1=1e-5,
                             hidden=c(128,128,256), epochs=10,
                             model_id = "DL_FirstMNIST"
  )
  h2o.saveModel(dl_model, path = "mnist" )  
} else {
  dl_model = h2o.loadModel(file.path("mnist", "DL_FirstMNIST"))
}

# performance on test
ptest = h2o.performance(dl_model, test_hex )
h2o.confusionMatrix(ptest)

# performance on train
ptrain = h2o.performance(dl_model, train_hex)
h2o.confusionMatrix(ptrain)

####################################################################
# training many models to see which may do well
# 

if (inClass == FALSE) {
  # it will take some time to train all
  
  EPOCHS = 2
  args <- list(
    list(epochs=EPOCHS),
    list(epochs=EPOCHS, activation="Tanh"),
    list(epochs=EPOCHS, hidden=c(512,512)),
    list(epochs=5*EPOCHS, hidden=c(64,128,128)),
    list(epochs=5*EPOCHS, hidden=c(512,512), 
         activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
    list(epochs=5*EPOCHS, hidden=c(256,256,256), 
         activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
    list(epochs=5*EPOCHS, hidden=c(200,200), 
         activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5),
    list(epochs=5*EPOCHS, hidden=c(100,100,100), 
         activation="RectifierWithDropout", input_dropout_ratio=0.2, l1=1e-5)
  )

  run <- function(extra_params) {
    str(extra_params)
    print("Training.")
    model <- do.call(h2o.deeplearning, modifyList(list(x=predictors, y=response,
                                                       training_frame=train_hex), extra_params))
    sampleshist <- model@model$scoring_history$samples
    samples <- sampleshist[length(sampleshist)]
    time <- model@model$run_time/1000
    print(paste0("training samples: ", samples))
    print(paste0("training time   : ", time, " seconds"))
    print(paste0("training speed  : ", samples/time, " samples/second"))
    
    print("Scoring on test set.")
    p <- h2o.performance(model, test_hex)
    cm <- h2o.confusionMatrix(p)
    test_error <- cm$Error[length(cm$Error)]
    print(paste0("test set error  : ", test_error))
    
    c(paste(names(extra_params), extra_params, sep = "=", collapse=" "), 
      samples, sprintf("%.3f", time), 
      sprintf("%.3f", samples/time), sprintf("%.3f", test_error))
  }

  writecsv <- function(results) {
    table <- matrix(unlist(results), ncol = 5, byrow = TRUE)
    colnames(table) <- c("parameters", "training samples",
                         "training time", "training speed", "test set error")
    table
  }

  table = writecsv(lapply(args, run))
  save(table, file="mnist.h2o.table_results.RData")
  
} else {
  load("mnist.h2o.table_results.RData")
  table
}

##############################################################
# model trained for 1000 epochs
# The code below took long time to run
# (about 15h on my old desktop)

if (inClass == FALSE) {
  mdl = h2o.deeplearning(x=predictors, y=response,
                            training_frame=train_hex,
                            activation="RectifierWithDropout",
                            input_dropout_ratio=0.2,
                            classification_stop=-1,  # Turn off early stopping
                            l1=1e-5,
                            hidden=c(1024,1024,2048), epochs=1000,
                            model_id = "goodModel.epoch1000"
  )
  h2o.saveModel(mdl, path = "mnist")  
} else {
  mdl = h2o.loadModel( path = file.path("mnist", "goodModel.epoch1000") )
}

# performance on test
ptest = h2o.performance(mdl, test_hex )
h2o.confusionMatrix(ptest)

# performance on train
ptrain = h2o.performance(mdl, train_hex)
h2o.confusionMatrix(ptrain)

# extract features using the model

trainX.deep.features = h2o.deepfeatures(mdl, trainX, layer = 3)
testX.deep.features = h2o.deepfeatures(mdl, testX, layer = 3)

dim(trainX.deep.features)

if (inClass == FALSE) {
  deep.rf = h2o.randomForest(x=1:2048, y=2049, 
                           training_frame = h2o.cbind(trainX.deep.features, train_hex[,response]),
                           ntrees = 1000,
                           min_rows = 100,
                           model_id = "DRF_features.2048"
                           )
  h2o.saveModel(deep.rf, path="mnist")
} else {
  deep.rf = h2o.loadModel( path = file.path("mnist", "DRF_features.2048") )
}

phat = h2o.predict(deep.rf, testX.deep.features)
head(phat)

h2o.confusionMatrix(deep.rf, h2o.cbind(testX.deep.features, test_hex[,785]))


#########################
## 
## Autoencoder
##
#########################

nfeatures = 50 

# train autoencoder on train_unsupervised
auto_encoder = h2o.deeplearning(x=predictors,
                                training_frame=trainX,
                                activation="Tanh",
                                autoencoder=T,
                                hidden=c(nfeatures),
                                epochs=1,
                                export_weights_and_biases = T
                                )

train.ae.features = h2o.deepfeatures(auto_encoder, trainX, 1)
summary(train.ae.features)

test.ae.features = h2o.deepfeatures(auto_encoder, testX, 1)

# we have a 50 dimensional representation of our data
# let's train a random forest
if (inClass == FALSE) {
  deep.ae.rf = h2o.randomForest(x=1:50, y=51, 
                              training_frame = h2o.cbind(train.ae.features, train_labels),
                              ntrees = 500,
                              min_rows = 100,
                              model_id = "DRF_features.50"
                              )
  h2o.saveModel(deep.ae.rf, path="mnist")
} else {
  deep.ae.rf = h2o.loadModel( path = file.path("mnist", "DRF_features.50") )
}

phat = h2o.predict(deep.ae.rf, test.ae.features)
head(phat)

h2o.confusionMatrix(deep.ae.rf, h2o.cbind(test.ae.features, test_labels))

########### we can also use the representation to find outliers

auto_encoder = h2o.deeplearning(x=predictors,
                                training_frame=trainX,
                                activation="Tanh",
                                autoencoder=T,
                                hidden=c(50),
                                l1=1e-5,
                                ignore_const_cols=F,
                                epochs=1)

# 2) DETECT OUTLIERS
# h2o.anomaly computes the per-row reconstruction error for the test data set
# (passing it through the autoencoder model and computing mean square error (MSE) for each row)
test_rec_error = as.data.frame(h2o.anomaly(auto_encoder, testX)) 

# 3) VISUALIZE OUTLIERS
# Let's look at the test set points with low/median/high reconstruction errors.
# We will now visualize the original test set points and their reconstructions obtained 
# by propagating them through the narrow neural net.

# Convert the test data into its autoencoded representation (pass through narrow neural net)
test_recon = predict(auto_encoder, testX)

# The good
# Let's plot the 25 digits with lowest reconstruction error.
# First we plot the reconstruction, then the original scanned images.  
plotDigits(test_recon, test_rec_error, c(1:25))
plotDigits(testX,   test_rec_error, c(1:25))

# The bad
# Now the same for the 25 digits with median reconstruction error.
plotDigits(test_recon, test_rec_error, c(4988:5012))
plotDigits(testX,   test_rec_error, c(4988:5012))

# The ugly
# And here are the biggest outliers - The 25 digits with highest reconstruction error!
plotDigits(test_recon, test_rec_error, c(9976:10000))
plotDigits(testX,   test_rec_error, c(9976:10000))


######################
#
# Stacked autoencoder
#
######################

# this function builds a vector of autoencoder models, one per layer
get_stacked_ae_array <- function(training_data,layers,args){  
  vector <- c()
  index = 0
  for(i in 1:length(layers)){    
    index = index + 1
    ae_model <- do.call(h2o.deeplearning, 
                        modifyList(list(x=names(training_data),
                                        training_frame=training_data,
                                        autoencoder=T,
                                        hidden=layers[i]),
                                   args))
    training_data = h2o.deepfeatures(ae_model,training_data,layer=1)
    
    names(training_data) <- gsub("DF", paste0("L",index,sep=""), names(training_data)) 
    vector <- c(vector, ae_model)    
  }
  vector
}

# this function returns final encoded contents
apply_stacked_ae_array <- function(data,ae){
  index = 0
  for(i in 1:length(ae)){
    index = index + 1
    data = h2o.deepfeatures(ae[[i]],data,layer=1)
    names(data) <- gsub("DF", paste0("L",index,sep=""), names(data)) 
  }
  data
}

## Build reference model on full dataset and evaluate it on the test set
## This is a bad model
model_ref = h2o.deeplearning(training_frame=train_hex, 
                              x=predictors, y=resp, 
                              hidden=c(10), 
                              epochs=1)
phat_ref = h2o.performance(model_ref, test_hex)
h2o.logloss(phat_ref)
h2o.confusionMatrix(phat_ref)

## Now build a stacked autoencoder model with three stacked layer AE models
## First AE model will compress the 717 non-const predictors into 200
## Second AE model will compress 200 into 100
## Third AE model will compress 100 into 50
layers <- c(200,100,50)
args <- list(activation="Tanh", epochs=1, l1=1e-5)
stacked_ae <- get_stacked_ae_array(trainX, layers, args)

## Now compress the training/testing data with this 3-stage set of AE models
train_compressed <- apply_stacked_ae_array(trainX, stacked_ae) 
test_compressed <- apply_stacked_ae_array(testX, stacked_ae)

model_on_compressed_data <- h2o.deeplearning(training_frame=h2o.cbind(train_compressed, train_hex[,resp]), 
                                             x=1:50, y=51, 
                                             hidden=c(10), 
                                             epochs=1
                                             )

phat = h2o.performance(model_on_compressed_data, h2o.cbind(test_compressed, test_hex[,resp]))
h2o.logloss(phat)
h2o.confusionMatrix(phat)


#########################
## 
## Autoencoder -- visualization
##
#########################

if (inClass == FALSE) {
  pca.ae = h2o.deeplearning(x=predictors,
                          training_frame=trainX,
                          activation="Tanh",
                          autoencoder=T,
                          hidden=c(1024, 512, 256, 128, 2),
                          l1=1e-5,
                          ignore_const_cols=F,
                          epochs=10,
                          model_id="pca.ae"
                          )
  h2o.saveModel(deep.rf, path="mnist")
} else {
  pca.ae = h2o.loadModel( path = file.path("mnist", "pca.ae") )
}

pca.ae.train.features = h2o.deepfeatures(pca.ae, trainX, 5)
dim(pca.ae.train.features)

plot(as.matrix(pca.ae.train.features[1:1000,]), 
     pch=as.character( digit.data$train$y[1:1000] ), 
     col=c(1:10)[digit.data$train$y[1:1000]+1])
