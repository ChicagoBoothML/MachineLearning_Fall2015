library(ElemStatLearn)

x <- mixture.example$x
g <- mixture.example$y
xnew <- mixture.example$xnew
px1 <- mixture.example$px1
px2 <- mixture.example$px2
gd <- expand.grid(x=px1, y=px2)


par(mar=rep(2,4))
plot(x, col=ifelse(g==1, "coral", "cornflowerblue"), axes=FALSE)
box()

#dev.copy(pdf, "05_lr_mixture.pdf")
#dev.off()

## logistic regression

df_train = data.frame(x1=x[,1], x2=x[,2], y=g)
df_test = data.frame(x1=xnew[,1], x2=xnew[,2])
lr_fit = glm(y~., data=df_train, family=binomial())
prob = predict(lr_fit, df_test, type="response")

prob_lr <- matrix(prob, length(px1), length(px2))
par(mar=rep(2,4))
contour(px1, px2, prob_lr, levels=0.5, labels="", xlab="", ylab="", main=
          "logistic regression", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
points(gd, pch=".", cex=1.2, col=ifelse(prob_lr>0.5, "coral", "cornflowerblue"))
box()

#dev.copy(pdf, "05_lr_mixture_1.pdf")
#dev.off()


## logistic regression -- 2

df_train = data.frame(x=poly(x[,1], x[,2], degree=2, raw=TRUE), y=g)
df_test  = data.frame(x=poly(xnew[,1], xnew[,2], degree=2, raw=TRUE))

lr_fit = glm(y~., data=df_train, family=binomial())
prob = predict(lr_fit, df_test, type="response")

prob_lr <- matrix(prob, length(px1), length(px2))
par(mar=rep(2,4))
contour(px1, px2, prob_lr, levels=0.5, labels="", xlab="", ylab="", main=
          "logistic regression -- quadratic with interactions", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
points(gd, pch=".", cex=1.2, col=ifelse(prob_lr>0.5, "coral", "cornflowerblue"))
box()

#dev.copy(pdf, "05_lr_mixture_2.pdf")
#dev.off()

## logistic regression -- 3

df_train = data.frame(x=poly(x[,1], x[,2], degree=3, raw=TRUE), y=g)
df_test  = data.frame(x=poly(xnew[,1], xnew[,2], degree=3, raw=TRUE))

lr_fit = glm(y~., data=df_train, family=binomial())
prob = predict(lr_fit, df_test, type="response")

prob_lr <- matrix(prob, length(px1), length(px2))
par(mar=rep(2,4))
contour(px1, px2, prob_lr, levels=0.5, labels="", xlab="", ylab="", main=
          "logistic regression -- cubic with interactions", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
points(gd, pch=".", cex=1.2, col=ifelse(prob_lr>0.5, "coral", "cornflowerblue"))
box()

#dev.copy(pdf, "05_lr_mixture_3.pdf")
#dev.off()


## logistic regression -- 7

df_train = data.frame(x=poly(x[,1], x[,2], degree=7, raw=TRUE), y=g)
df_test  = data.frame(x=poly(xnew[,1], xnew[,2], degree=7, raw=TRUE))

lr_fit = glm(y~., data=df_train, family=binomial())
prob = predict(lr_fit, df_test, type="response")

prob_lr <- matrix(prob, length(px1), length(px2))
par(mar=rep(2,4))
contour(px1, px2, prob_lr, levels=0.5, labels="", xlab="", ylab="", main=
          "logistic regression -- 7th degree polynomial", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
points(gd, pch=".", cex=1.2, col=ifelse(prob_lr>0.5, "coral", "cornflowerblue"))
box()

#dev.copy(pdf, "05_lr_mixture_7.pdf")
#dev.off()

## fitted coefficients are huge
## see:: lr_fit$coefficients[1:10]
lr_fit_7 = lr_fit

## lasso

library(glmnet)
bigX_train = as.matrix(df_train[,-ncol(df_train)], nrow=nrow(df_train))
bigX_test = as.matrix(df_test, nrow=nrow(df_test))

lr_fit = cv.glmnet(x=bigX_train, y=g, family="binomial", nfolds=5)
prob = predict(lr_fit$glmnet.fit, bigX_test, type="response", s=lr_fit$lambda.min)

prob_lr <- matrix(prob, length(px1), length(px2))
par(mar=rep(2,4))
contour(px1, px2, prob_lr, levels=0.5, labels="", xlab="", ylab="", main=
          "logistic regression -- lasso", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
points(gd, pch=".", cex=1.2, col=ifelse(prob_lr>0.5, "coral", "cornflowerblue"))
box()

lr_fit_lasso = lr_fit

#dev.copy(pdf, "05_lr_mixture_lasso.pdf")
#dev.off()

# investigate lr_coef
lr_coef = coef(lr_fit_lasso$glmnet.fit, s=lr_fit_lasso$lambda.min)

## ridge regression

lr_fit = cv.glmnet(x=bigX_train, y=g, family="binomial", nfolds=5, alpha=0)
prob = predict(lr_fit$glmnet.fit, bigX_test, type="response", s=lr_fit$lambda.min)

prob_lr <- matrix(prob, length(px1), length(px2))
par(mar=rep(2,4))
contour(px1, px2, prob_lr, levels=0.5, labels="", xlab="", ylab="", main=
          "logistic regression -- ridge penalty", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
points(gd, pch=".", cex=1.2, col=ifelse(prob_lr>0.5, "coral", "cornflowerblue"))
box()

#dev.copy(pdf, "05_lr_mixture_ridge.pdf")
#dev.off()

lr_fit_ridge = lr_fit

# investigate lr_coef
lr_coef = coef(lr_fit_ridge$glmnet.fit, s=lr_fit_ridge$lambda.min)


