#########################################
# Sentiment Analysis
#########################################

# Set these paths to where you downloaded the files
path_to_neg_folder = "aclImdb/train/neg"
path_to_pos_folder = "aclImdb/train/pos"

# packages for text analysis
# install.packages("tm")
# install.packages("SnowballC")
library(tm)
library(SnowballC)


# In linguistics Corpus is a collection of documents
# In the tm package, corpus is a collection of 
# strings representing individual sources of text
nb_pos = Corpus(DirSource(path_to_pos_folder), readerControl = list(language="en"))
nb_neg = Corpus(DirSource(path_to_neg_folder), readerControl = list(language="en"))
# recursive parameter in the c() function used to merge the two corpora is needed
# to maintain the metadata information stored in the corpus objects
nb_all = c(nb_pos, nb_neg, recursive=T)

# see the metadata for the first review in our corpus
# observe id 
#       id           : 0_9.txt
# this is the name of the file
# each filename is of the form <counter>_<score>.txt
# scores in the range 7-10 are positive
# scores in the range 0-4 are negative
# we only have such polar reviews 
meta(nb_all[[1]])

# create vector of filenames
ids = sapply(1:length(nb_all), function(x) meta(nb_all[[x]], "id"))
head(ids)

# extract scores from the filenames using sub function
scores = as.numeric(sapply(ids, function(x) sub("[0-9]+_([0-9]+)\\.txt", "\\1", x)))
scores = factor(ifelse(scores>=7,"positive","negative"))
summary(scores)

# preprocessing steps 
nb_all = tm_map(nb_all, content_transformer(removeNumbers))
nb_all = tm_map(nb_all, content_transformer(removePunctuation))
nb_all = tm_map(nb_all, content_transformer(tolower))
nb_all = tm_map(nb_all, content_transformer(removeWords), stopwords("english"))
nb_all = tm_map(nb_all, content_transformer(stripWhitespace))

# create document term matrix
nb_dtm = DocumentTermMatrix(nb_all)
dim(nb_dtm)
nb_dtm

# remove infrequent items
# try repeating this with different sparsity
nb_dtm = removeSparseTerms(x=nb_dtm, sparse = 0.99)
dim(nb_dtm)
nb_dtm

# inspect first review
inspect(nb_dtm[1,]) 
terms = which( inspect(nb_dtm[1,]) != 0 ) # find terms in review 1
inspect( nb_dtm[1,terms] )

# convert all elements to binary
# The occurrence of the word fantastic tells us a lot 
# The fact that it occurs 5 times may not tell us much more
nb_dtm = weightBin(nb_dtm)

inspect( nb_dtm[1,terms] )

# split into train and test
nb_df = as.data.frame(as.matrix(nb_dtm))
set.seed(1)
nb_sampling_vector = sample(25000, 20000)
nb_df_train = nb_df[nb_sampling_vector,]
nb_df_test = nb_df[-nb_sampling_vector,]
scores_train = scores[nb_sampling_vector]
scores_test = scores[-nb_sampling_vector]

library(e1071)
nb_model = naiveBayes(nb_df_train, scores_train)

# compute training error
if (file.exists("nb_train_predictions.RData")) {
  load("nb_train_predictions.Rdata")
} else {
  nb_train_predictions = predict(nb_model, nb_df_train) 
  save(nb_train_predictions, file = "nb_train_predictions.RData")
}
mean(nb_train_predictions == scores_train)
table(actual = scores_train, predictions = nb_train_predictions)

# compute test error
if (file.exists("nb_test_predictions.RData")) {
  load("nb_test_predictions.RData")
} else {
  nb_test_predictions = predict(nb_model, nb_df_test)
  save(nb_test_predictions, file = "nb_test_predictions.RData")
}
mean(nb_test_predictions == scores_test)
table(actual = scores_test, predictions = nb_test_predictions)

# also perform stemming as a preprocessing step
nb_all = tm_map(nb_all, stemDocument, language = "english")
nb_dtm = DocumentTermMatrix(nb_all) 
nb_dtm = removeSparseTerms(x=nb_dtm, sparse = 0.99)
nb_dtm = weightBin(nb_dtm)
nb_df = as.data.frame(as.matrix(nb_dtm))
nb_df_train = nb_df[nb_sampling_vector,]
nb_df_test = nb_df[-nb_sampling_vector,]

# train model on stemmed corpora
nb_model_stem = naiveBayes(nb_df_train, scores_train)
if (file.exists("nb_test_predictions_stem.RData")) {
  load("nb_test_predictions_stem.RData")
} else {
  nb_test_predictions_stem = predict(nb_model_stem, nb_df_test)
  save(nb_test_predictions_stem, file = "nb_test_predictions_stem.RData")
}
mean(nb_test_predictions_stem == scores_test)
table(actual = scores_test, predictions = nb_test_predictions_stem)

# Note: Recompute the nb_dtm without stemming before running the next bit
nb_all = c(nb_pos, nb_neg, recursive=T)
nb_all = tm_map(nb_all, content_transformer(removeNumbers))
nb_all = tm_map(nb_all, content_transformer(removePunctuation))
nb_all = tm_map(nb_all, content_transformer(tolower))
nb_all = tm_map(nb_all, content_transformer(removeWords), stopwords("english"))
nb_all = tm_map(nb_all, content_transformer(stripWhitespace))
nb_dtm = DocumentTermMatrix(nb_all) 
nb_dtm = removeSparseTerms(x=nb_dtm, sparse = 0.99)
nb_df = as.data.frame(as.matrix(nb_dtm))
nb_df_train = nb_df[nb_sampling_vector,]
nb_df_test = nb_df[-nb_sampling_vector,]

nb_model_laplace = naiveBayes(nb_df_train, scores_train, laplace=10)
if (file.exists("nb_test_predictions_laplace.RData")) {
  load("nb_test_predictions_laplace.RData")
} else {
  nb_test_predictions_laplace = predict(nb_model_laplace, nb_df_test)
  save(nb_test_predictions_laplace, file = "nb_test_predictions_laplace.RData")
}
mean(nb_test_predictions_laplace == scores_test)
table(actual = scores_test, predictions = nb_test_predictions_laplace)

