library(recommenderlab)

######################################################################
### make ratings with 5 users and 6 items
u1 = c(1,2,1,NA,NA,5)
u2 = c(NA,2,1,3,4,5)
u3 = c(4,5,NA,2,1,2)
u4 = c(NA,5,4,1,2,2)
u5 = c(4,5,5,1,2,1)

## r is matrix, rrm is realRatingMatrix
## realRatingMatrix is format used recommenderLab
r = rbind(u1,u2,u3,u4,u5)
colnames(r) <- c("Berny's", "La Traviata", "El Pollo Loco", "Joey's Pizza", "The Old West", "Jake and Jill")
rrm = as(r, "realRatingMatrix")

### get summary stats
getRatings(rrm)  # all ratings
colMeans(rrm)    # average rating per movie
rowMeans(rrm)    # average rating per user
rowCounts(rrm)   # how many movies did a user rate

### user similarities
similarity(rrm, method="cosine")

## fit a recommender
## each row is a different recommender
## in order to see how different recommenders work, 
## an appropriate line you need to uncomment below
##
#rec=Recommender(rrm[1:nrow(rrm)],method="UBCF", param=list(normalize = "Z-score",method="Cosine",nn=2, minRating=1))
#rec=Recommender(rrm[1:nrow(rrm)],method="UBCF", param=list(normalize = "Z-score",method="Cosine",nn=2))
#rec=Recommender(r[1:nrow(r)],method="IBCF", param=list(normalize = "Z-score",method="Jaccard",minRating=1))
#rec=Recommender(r[1:nrow(r)],method="POPULAR")
rec=Recommender(rrm[1:nrow(rrm)],method="UBCF", param=list(method="pearson",nn=2))
#rec=Recommender(rrm[1:nrow(rrm)],method="UBCF", param=list(method="pearson",nn=1))

###print out stuff about recommender
print(rec)
names(getModel(rec))
getModel(rec)$nn
getModel(rec)$description
getModel(rec)$method
getModel(rec)$sample
getModel(rec)$minRating
getModel(rec)$normalize

###impute missing ratings
recom = predict(rec, rrm, type="ratings")
### print out fits
as(recom,"matrix") ## filled in values
as(rrm,"matrix")   ## orginal data

### get best recommendation for user 1
recom = predict(rec, rrm[1,], type="topNList", n=1)
as(recom, "list")

