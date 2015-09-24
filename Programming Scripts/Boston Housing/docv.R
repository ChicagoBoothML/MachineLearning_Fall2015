############################################################
############################################################
## Function to do cross validation.
## docv is a general method that takes a prediction function as an argument.
## docvknn is for kNN, it calls docv handing in a wrapper of kknn.
############################################################
############################################################
#--------------------------------------------------
mse=function(y,yhat) {return(sum((y-yhat)^2))}
doknn=function(x,y,xp,k) {
   kdo=k[1]
   train = data.frame(x,y=y)
   test = data.frame(xp); names(test) = names(train)[1:(ncol(train)-1)]
   near  = kknn(y~.,train,test,k=kdo,kernel='rectangular')
   return(near$fitted)
}
#--------------------------------------------------
docv = function(x,y,set,predfun,loss,nfold=10,doran=TRUE,verbose=TRUE,...)
{
   #a little error checking
   if(!(is.matrix(x) | is.data.frame(x))) {cat('error in docv: x is not a matrix or data frame\n'); return(0)}
   if(!(is.vector(y))) {cat('error in docv: y is not a vector\n'); return(0)}
   if(!(length(y)==nrow(x))) {cat('error in docv: length(y) != nrow(x)\n'); return(0)}

   nset = nrow(set); n=length(y) #get dimensions
   if(n==nfold) doran=FALSE #no need to shuffle if you are doing them all.
   cat('in docv: nset,n,nfold: ',nset,n,nfold,'\n')
   lossv = rep(0,nset) #return values
   if(doran) {ii = sample(1:n,n); y=y[ii]; x=x[ii,,drop=FALSE]} #shuffle rows

   fs = round(n/nfold) # fold size
   for(i in 1:nfold) { #fold loop
      bot=(i-1)*fs+1; top=ifelse(i==nfold,n,i*fs); ii =bot:top
      if(verbose) cat('on fold: ',i,', range: ',bot,':',top,'\n')
      xin = x[-ii,,drop=FALSE]; yin=y[-ii]; xout=x[ii,,drop=FALSE]; yout=y[ii]
      for(k in 1:nset) { #setting loop
         yhat = predfun(xin,yin,xout,set[k,],...)
         lossv[k]=lossv[k]+loss(yout,yhat)
      } 
   } 

   return(lossv)
}
#--------------------------------------------------
#cv version for knn
docvknn = function(x,y,k,nfold=10,doran=TRUE,verbose=TRUE) {
return(docv(x,y,matrix(k,ncol=1),doknn,mse,nfold=nfold,doran=doran,verbose=verbose))
}
