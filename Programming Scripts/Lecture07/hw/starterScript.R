# the following line will install and update 
# packages that we are using for the ML course
# NOTE: this may take some time
# NOTE: ignore potential warnings, but not errors
source("https://raw.githubusercontent.com/ChicagoBoothML/HelpR/master/booth.ml.packages.R")

# this block of code will read in all the data
library(jsonlite)
# use this line if you have downloaded "videoGames.json.gz" to your current folder
fileConnection <- gzcon(file("videoGames.json.gz", "rb"))
# use this line if the file is not downloaded to your computer (say working on rstudio.chicagobooth.edu)
# fileConnection <- gzcon(url("https://github.com/ChicagoBoothML/MachineLearning_Fall2015/raw/master/Programming%20Scripts/Lecture07/hw/videoGames.json.gz"))
data = stream_in(fileConnection)

library("recommenderlab")
# create a ratingData matrix using reviewerID, itemID, and rating
ratingData = as(data[c("reviewerID", "itemID", "rating")], "realRatingMatrix")
# we keep users that have rated more than 2 video games
ratingData = ratingData[rowCounts(ratingData) > 2,]
# we will focus only on popular video games that have 
# been rated by more than 3 times
ratingData = ratingData[,colCounts(ratingData) > 3]
# we are left with this many users and items
dim(ratingData)

# example on how to recommend using Popular method
r = Recommender(ratingData, method="Popular")

# recommend 5 items to user it row 10
rec = predict(r, ratingData[10, ], type="topNList", n=5)
as(rec, "list")

# predict ratings 
rec = predict(r, ratingData[10, ], type="ratings")
as(rec, "matrix")


