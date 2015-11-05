######################################################################
######################################################################
### initial basics

##simple ratings matrix
#user ratings
oliver = c(1,1,2,5,7,8,9,7)
thibault = c(5,9,4,1,1,7,5,9)
maria = c(1,4,2,5,8,6,2,8)
pedro = c(2,6,7,2,6,1,8,9)
ines = c(1,3,2,4,8,9,7,7)
gertrude = c(1,6,5,7,3,2,5,5)

##Make ratings matrix rM by stacking user ratings
rM = rbind(oliver, thibault, maria, pedro, ines, gertrude)
#column names are the items (restaurants)
colnames(rM) <- c("Berny's", "La Traviata", "El Pollo Loco", "Joey's Pizza", "The Old West", "Jake and Jill", "Full Moon", "Acropolis")
print(rM)

##CF (collaborative filtering) uses distance between users and distances between items
##euclidean user and item distances
duser = dist(rM,method="euclidean") #user distances
cat("duser:\n")
print(duser)
ditem = dist(t(rM),method="euclidean") #item distances
cat("ditem:\n")
print(ditem)

#install.packages("proxy") , to get enhanced dist function
library(proxy)
dist(rM,method="cosine") #this is actually 1-(cosine similarity measure)
##you can get the similarity more directly using
simil(rM,method="cosine")

##to see distances/similarities in proxy package
summary(pr_DB)

##Jaccard similarity is used for binary matrices.
binaryRatingMatrix <- rM > 5
print(binaryRatingMatrix)
dist(binaryRatingMatrix, method = 'jaccard')
#e.g. .6 = 3/5  3 cases where disagree and not false/false divided 5 cases not false/false

##user based collaborative filtering
# dave has missing impute via user based
dave =c(1,5,7,NA,8,NA,6,7)
rdM = rbind(dave,rM)

#suserd = 1-as.matrix(dist(rdM,method="cosine")) #cosine similarities
suserd = as.matrix(simil(rdM,method="cosine")) #cosine similarities

# dave is most similar to pedro (.97) and gertrude (.79).
# estimate of dave's missing rating for item 4 (Joey's Pizza) is 
# similarity weighted average of pedro and gertrude
rd4 = (.97*2+.79*7)/(.97+.79)
cat("rd4 (dave for item 4): ",rd4,"\n")


######################################################################
######################################################################
### look at Movie data and Jester Joke data
### read in data and do some pre-processing
###load librairies
library(recommenderlab)

library(data.table) #big data version of data.frame 
#https://www.datacamp.com/courses/data-analysis-the-data-table-way

#will use function otype to the learn the object type, library for inspecting objects
library(pryr) 

###read jester data
jester <- fread("jesterfinal151cols.csv", sep = ",", header = F)
jester[, V1 := NULL] #how we kill first column of a data.table

jester_m <- as.matrix(jester) #make it a matrix
jester_m <- ifelse(jester_m == 99, NA, jester_m) #99 -> NA
jester_rrm <- as(jester_m, "realRatingMatrix") #coerce to type from recommenderlab


##inspect jester_rrm
cat(otype(jester_rrm),"\n")
cat(str(jester_rrm),"\n")
cat(jester_rrm@data@Dim,"\n")
cat("size of jester_rrm: \n")
print(object.size(jester_rrm),units="Mb")
cat("size of jester_m: \n")
print(object.size(jester_m),units="Mb")
cat("size of jester: \n")
print(object.size(jester),units="Mb")

###read movie data
movies <- fread("ratings.dat", sep = ":", header = F)
head(movies)
movies[, c("V2", "V4", "V6", "V7") := NULL] #because file as :: separators need to kill NA columns
head(movies)

###turn movies into a ratings matrix, 
userid_factor <- as.factor(movies[, V1]) #pull off userid as factor
movieid_factor <- as.factor(movies[, V3]) #pull off movie id as factor
#sparseMatrix is part of Matrix package (required by recommenderlab)
movies_sm <- sparseMatrix(i = as.numeric(userid_factor), j =
   as.numeric(movieid_factor), x = as.numeric(movies[,V5]))

movies_rrm <- new("realRatingMatrix", data = movies_sm) ##get realRatingMatrix from movies_sm
colnames(movies_rrm) <- levels(movieid_factor) #get right column names back from levels 
rownames(movies_rrm) <- levels(userid_factor) #get right row names back from levels

##inspect movies_rrm
cat(otype(movies_rrm),"\n")
cat(str(movies_rrm),"\n")
cat(movies_rrm@data@Dim,"\n")
cat("size of movies_rrm: \n")
print(object.size(movies_rrm),units="Mb")
cat("size of movies: \n")
print(object.size(movies),units="Mb")

######################################################################
######################################################################
### look at data
##note: we may want to standardize the ratings somehow
## standardization should occur at the user level, that is, standardize each row.
jester_ratings <- getRatings(jester_rrm)
jester_normalized_ratings <- getRatings(normalize(jester_rrm,method = "Z-score"))
movies_ratings <- getRatings(movies_rrm)
movies_normalized_ratings <- getRatings(normalize(movies_rrm,method = "Z-score"))

##histograms of ratings and standardized ratings
par(mfrow=c(2,2))
hist(jester_ratings,nclass=50)
hist(movies_ratings,nclas=20)
hist(jester_normalized_ratings,nclass=100)
hist(movies_normalized_ratings,nclass=50)

##how many ratings per user
jester_items_rated_per_user <- rowCounts(jester_rrm)
##average rating for an item
jester_average_item_rating_per_item <- colMeans(jester_rrm)

#same for movies
movies_items_rated_per_user <- rowCounts(movies_rrm)
movies_average_item_rating_per_item <- colMeans(movies_rrm)

hist(jester_items_rated_per_user)
hist(movies_items_rated_per_user)
hist(jester_average_item_rating_per_item)
hist(movies_average_item_rating_per_item)

##get overall summaries
##in jester, some columns may not have ratings giving NAs
(jester_avg_items_rated_per_user <- mean(rowCounts(jester_rrm)))
(jester_avg_item_rating <- mean(colMeans(jester_rrm), na.rm = T))
(movies_avg_items_rated_per_user <- mean(rowCounts(movies_rrm)))
(movies_avg_item_rating <- mean(colMeans(movies_rrm)))

##################################################
##################################################
##Evaluating binary top-N recommendations
## Goal is to make a list of N recommendations that are most likely to
#         interest a user.
## binarize jester and then do train/test
#We'll call any rating that is 5 or above a positive rating.
jester_bn <- binarize(jester_rrm, minRating = 5) #binary version, good if rating > 5
jester_bn <- jester_bn[rowCounts(jester_bn) > 10] #have to have rated 10
dim(jester_bn)

##list of algorithms and associated parameters to evaluate
## nn specifies 50 as the number of nearest neighbors to use
algorithms <- list(
"Random" = list(name = "RANDOM", param = NULL), #just recommend randomly
"Popular" = list(name = "POPULAR", param = NULL), #most popular
"UserBasedCF_COS"=list(name="UBCF",param=list(method="Cosine", nn = 50)),
"UserBasedCF_JAC"=list(name="UBCF",param=list(method="Jaccard", nn = 50))
)

#Note: here are the algorithms that come with the library
#> recommenderRegistry$get_entry_names()
# [1] "AR_binaryRatingMatrix"      "IBCF_binaryRatingMatrix"   
# [3] "IBCF_realRatingMatrix"      "PCA_realRatingMatrix"      
# [5] "POPULAR_binaryRatingMatrix" "POPULAR_realRatingMatrix"  
# [7] "RANDOM_realRatingMatrix"    "RANDOM_binaryRatingMatrix" 
# [9] "SVD_realRatingMatrix"       "UBCF_binaryRatingMatrix"   
#[11] "UBCF_realRatingMatrix"

#train/test split 80% train
#k is number of runs to evaluate on
#the number of ratings we will take as given from our test users is the ``given'' parameter
   #recall we selected users that had made at least 10 ratings

#We will do a straight 80-20 split for our training and
#test set, consider 10 ratings from our test users as known ratings, 
#and evaluate over a single run
jester_split_scheme <- evaluationScheme(jester_bn, method = "split", 
                                              train = 0.8, given = 10, k = 1) 

#specify the range of N values to use when making top-N recommendations
#via the n parameter. We will do this for values 1 through 20:
jester_split_eval <- evaluate(jester_split_scheme, algorithms, n = 1 : 20)

options(digits = 4) #number of digits to use when printing a number
##get results for algorithm 4 which was UserBased Jaccard
getConfusionMatrix(jester_split_eval[[4]])
 
##ROC curve, plots all 4 methods
par(mfrow=c(1,1))
plot(jester_split_eval, annotate = 2, legend = "topright")
title(main = "TPR vs FPR For Binary Jester Data")


##################################################
##################################################
###Evaluating non-binary top-N recommendations
##do cross-validation to evaluate 5 methods on movie data

#############################
#algorithms to try,  SVD is just a data compression scheme
normalized_algorithms <- list(
"Random" = list(name = "RANDOM", param = list(normalize = "Z-score")),
"Popular" = list(name = "POPULAR", param = list(normalize = "Z-score")),
"UserBasedCF" = list(name = "UBCF", param = list(normalize = "Z-score", method = "Cosine", nn = 50)),
"ItemBasedCF" = list(name = "IBCF", param = list(normalize = "Z-score")),
"SVD" = list(name = "SVD", param = list(categories = 30, normalize = "Z-score", treat_na = "median"))
)

#############################
#cross validation scheme

#goodRating: 	
#threshold at which ratings are considered good for evaluation. 
#E.g., with goodRating=3 all items with actual user rating of greater or equal 3 are considered positives 
#in the evaluation process. 

movies_cross_scheme <- evaluationScheme(movies_rrm, method =
    "cross-validation", k = 10, given = 10, goodRating = 4)


#############################
#will continue to investigate making top-N recommendations in the range of 1 to 20
if(file.exists("movies_cross_eval.RData")) {
   cat("movies_cross_eval.RData exists\n")
   load("movies_cross_eval.RData")
} else {
   cat("movies_cross_eval.RData does not exist\n")
   movies_cross_eval <- evaluate(movies_cross_scheme, normalized_algorithms, n = 1 : 20)
   save(movies_cross_eval,file="movies_cross_eval.RData")
}

plot(movies_cross_eval, annotate = 4, legend = "topright")
title(main = "TPR versus FPR For Movielens Data")

##################################################
##################################################
###Evaluating individual predictions
## just do train/test to evaluate ubcf and ibcf on jester

##NOTE:
## you have to split into in-sample and out-of-sample based on users.
## you also have to split ratings into known and not known. (which are x and which are y).

##``Another way to evaluate a recommendation system is to ask it to predict the
##specific values of a portion of the known ratings made by a set of test users, using
##the remainder of their ratings as given.''

##train/test split (train and test are on a user basis)
## use 5 ratings to match (to compute distances), check how often you get "goodRating" right
if(file.exists("jester_split_scheme.RData")) {
   load("jester_split_scheme.RData")
} else {
   jester_split_scheme <- evaluationScheme(jester_rrm, method ="split", train = 0.8, given = 5, goodRating = 5)
   save(jester_split_scheme,file="jester_split_scheme.RData")
}

##fit ubcf and ibcf models on training data
#we will define individual user- and item-based collaborative filtering
#recommenders using the Recommender() and getData() functions. The logic
#behind these is that the getData() function will extract the ratings set aside for
#training by the evaluation scheme and the Recommender() function will use these
#data to train a model

jester_ubcf_srec <- Recommender(getData(jester_split_scheme, "train"), "UBCF")
jester_ibcf_srec <- Recommender(getData(jester_split_scheme, "train"), "IBCF")

###get predictions
##known is known items in test, see "given", we use the 5 given to match.
if(file.exists("jester_ubcf_known.RData")) {
   load("jester_ubcf_known.RData")
} else {
   jester_ubcf_known <- predict(jester_ubcf_srec, getData(jester_split_scheme, "known"), type="ratings")
   save(jester_ubcf_known,file="jester_ubcf_known.RData")
}

jester_ibcf_known <- predict(jester_ibcf_srec, getData(jester_split_scheme, "known"), type="ratings")


## measure performance
##unknown is unknown items in test, how well did we predict on present ratings in test, not used to match.
(jester_ubcf_acc <- calcPredictionAccuracy(jester_ubcf_known, getData(jester_split_scheme, "unknown")))

(jester_ibcf_acc <- calcPredictionAccuracy(jester_ibcf_known, getData(jester_split_scheme, "unknown")))



