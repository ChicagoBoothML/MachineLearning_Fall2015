library(MASS) ## a library of example datasets
library(kknn)
######################################################################
######################################################################
cat("###get data\n")
data(fgl) ## loads the data into R; see help(fgl)
n=nrow(fgl)
y = rep(3,n)
y[fgl$type=="WinF"]=1
y[fgl$type=="WinNF"]=2
y = as.factor(y)
levels(y) = c("WinF","WinNF","Other")
print(table(y,fgl$type))
x = cbind(fgl$RI,fgl$Na,fgl$Al)
scf = function(x) {return((x-min(x))/(max(x)-min(x)))}
x = apply(x,2,scf)
colnames(x) = c("RI","Na","Al")
ddf = data.frame(type=y,x)
names(ddf) =c("type","RI","Na","Al")
#####################################################################
cat("###plot data\n")

par(mfrow=c(1,3))
plot(RI ~ type, data=ddf, col=c(grey(.2),2:6),cex.lab=1.4)
plot(Al ~ type, data=ddf, col=c(grey(.2),2:6),cex.lab=1.4)
plot(Na ~ type, data=ddf, col=c(grey(.2),2:6),cex.lab=1.4)

pairs(x)
######################################################################
cat("###fit kNN\n")
near = kknn(type~.,ddf,ddf,k=10,kernel = "rectangular")
print(table(near$fitted,ddf$type))

fitdf = data.frame(type=ddf$type,near$prob)
names(fitdf)[2:4] = c("ProbWinF","ProbWinNF","ProbOther")

par(mfrow=c(1,3))
plot(ProbWinF~type,fitdf,col=c(grey(.5),2:3),cex.lab=1.4)
plot(ProbWinNF~type,fitdf,col=c(grey(.5),2:3),cex.lab=1.4)
plot(ProbOther~type,fitdf,col=c(grey(.5),2:3),cex.lab=1.4)

######################################################################
