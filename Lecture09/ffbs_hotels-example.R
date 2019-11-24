#--------------------------------------------------
#  R code
ffbsu = function(y,V,W,m0,C0){
#y_t = theta_t + v_t, v_t ~ N(0,V)
#theta_t = theta_{t-1} + w_t, w_t ~ N(0,W)
#theta_0 ~ N(m0,C0)
  n=length(y);a=rep(0,n);R=rep(0,n)
  m=rep(0,n);C=rep(0,n);B=rep(0,n-1);H=rep(0,n-1)
  # time t=1
  #a[1]=a1;R[1]=R1
  a[1]=m0;R[1]=C0+W
  f=a[1];Q=R[1]+V;A=R[1]/Q
  m[1]=a[1]+A*(y[1]-f);C[1]=R[1]-Q*A**2
  # forward filtering
  for (t in 2:n){
    a[t]=m[t-1];R[t]=C[t-1]+W
    f=a[t];Q=R[t]+V;A=R[t]/Q
    m[t]=a[t]+A*(y[t]-f);C[t]=R[t]-Q*A**2
    B[t-1]=C[t-1]/R[t];H[t-1]=sqrt(C[t-1]-R[t]*B[t-1]**2)
  }
  # backward sampling
  theta=rep(0,n);theta[n]=rnorm(1,m[n],sqrt(C[n]))
  for (t in (n-1):1) theta[t]=rnorm(1,m[t]+B[t]*(theta[t+1]-a[t+1]),H[t])
  return(theta)
}

#--------------------------------------------------
# hotels initial
hd = read.table('hotelocc.txt',header=T)
#> names(hd)
#[1] "chicago" "hotel"   "tm"

n=nrow(hd)
hlm = lm(hotel~chicago,hd)
print(summary(hlm))

par(mfrow=c(1,1))
plot(hd$chicago,hd$hotel,xlab='chicago',ylab='hotel',pch=16,col='blue')
abline(hlm$coef,lwd=2.0,col='red')
# dev.copy2pdf(file='hotreg.pdf',height=8,width=8)

tdf = data.frame(r=hlm$resid)
tdf$tm = 1:n
rlm = lm(r~tm,tdf)
plot(tdf$r,ylab='residuals',xlab='time',pch=16,col='blue')
lines(rlm$fit,col='red',lwd=2)
# dev.copy2pdf(file='reshotreg.pdf',height=8,width=8)

#--------------------------------------------------
# hotels
hd = read.table('hotelocc.txt',header=T)
n=nrow(hd)
hd$tm = 1:n

treg = lm(hotel~.,hd)
print(summary(treg))

V=5.4^2
#yy = hd$hotel-.7*hd$chicago - 26.7
yy=hlm$resid
W=4

nd=5000
td = matrix(0,nd,n)

for(i in 1:nd) {
td[i,] = ffbsu(yy,V,W,60,100)
}

par(mfrow=c(1,2))
qmat = apply(td,2,quantile,probs=c(.05,.25,.5,.75,.95))
plot(yy,xlab='month',ylab='occ rate')
lines(qmat[3,],col='blue')
lines(qmat[1,],col='red')
lines(qmat[5,],col='red')
lines(qmat[2,],col='green')
lines(qmat[4,],col='green')
lines(rlm$fit,col='black',lwd=1,lty=3)
title(paste(main='W= ',W))

W=1
for(i in 1:nd) {
td[i,] = ffbsu(yy,V,W,60,100)
}

qmat = apply(td,2,quantile,probs=c(.05,.25,.5,.75,.95))
plot(yy,xlab='month',ylab='occ rate')
lines(qmat[3,],col='blue')
lines(qmat[1,],col='red')
lines(qmat[5,],col='red')
lines(qmat[2,],col='green')
lines(qmat[4,],col='green')
lines(rlm$fit,col='black',lwd=1,lty=3)
title(paste(main='W= ',W))
# dev.copy2pdf(file='rfit.pdf',height=6,width=12)

#Coefficients:
#            Estimate Std. Error t value Pr(>|t|)    
#(Intercept) 26.69391    6.41884   4.159  0.00029 ***
#chicago      0.69524    0.09585   7.253 8.41e-08 ***
#tm          -0.59648    0.11340  -5.260 1.52e-05 ***
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
#
#Residual standard error: 5.372 on 27 degrees of freedom
