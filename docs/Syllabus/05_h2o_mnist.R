
#MNIST_DIR = "/home/mkolar/projects/DATA___LeCun___MNISTDigits/"

library(randomForest)
library(glmnet)
library(caret)
library(h2o)

MNIST_DIR = "."

load_mnist <- function(folder) {
  load_image_file <- function(filename) {
    ret = list()
    f = file(filename,'rb')
    readBin(f,'integer',n=1,size=4,endian='big')
    ret$n = readBin(f,'integer',n=1,size=4,endian='big')
    nrow = readBin(f,'integer',n=1,size=4,endian='big')
    ncol = readBin(f,'integer',n=1,size=4,endian='big')
    x = readBin(f,'integer',n=ret$n*nrow*ncol,size=1,signed=F)
    ret$x = matrix(x, ncol=nrow*ncol, byrow=T)
    close(f)
    ret
  }
  load_label_file <- function(filename) {
    f = file(filename,'rb')
    readBin(f,'integer',n=1,size=4,endian='big')
    n = readBin(f,'integer',n=1,size=4,endian='big')
    y = readBin(f,'integer',n=n,size=1,signed=F)
    close(f)
    y
  }
  train <- load_image_file(file.path(folder, 'train-images.idx3-ubyte'))
  test <- load_image_file(file.path(folder, 't10k-images.idx3-ubyte'))
  
  train$y <- load_label_file(file.path(folder, 'train-labels.idx1-ubyte'))
  test$y <- load_label_file(file.path(folder, 't10k-labels.idx1-ubyte'))

  list(train=train, test=test)  
}


show_digit <- function(arr784, col=gray(12:1/12), ...) {
  image(matrix(arr784, nrow=28)[,28:1], col=col, ...)
}

digit.data = load_mnist(MNIST_DIR)


###

h2oServer <- h2o.init(ip="localhost", port=54321, max_mem_size="4g", nthreads=4)
train_hex = as.h2o(data.frame(x=digit.data$train$x, y=digit.data$train$y))
test_hex = as.h2o(data.frame(x=digit.data$test$x, y=digit.data$test$y))

train_hex[,785] <- as.factor(train_hex[,785])
test_hex[,785] <- as.factor(test_hex[,785])

run <- function(extra_params) {
  str(extra_params)
  print("Training.")
  model <- do.call(h2o.deeplearning, modifyList(list(x=1:784, y=785,
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


EPOCHS=.2
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
table = writecsv(lapply(args, run))



