######################################################################
### do hmm on sequences of characters in words.
######################################################################
library(HMM)  #hidden markov model R library
######################################################################
cat("### read in data\n")
##chardata will be lower case characters plus (N,P,W) which denote types of special characters
#these chars came from words, so roughly we are looking at the character sequence in words
chardat = scan("hmm-characters.txt",what="character")
print(table(chardat))
cat("number of characters: ",length(chardat),"\n")
######################################################################
cat("### fit hmm\n")
cds = chardat[1:3000]  #use subset to makes things run fairly fast

##set up hmm elements
#states and observations dims
states = c("1", "2", "3") #three hiden states
nstates <- length(states)  
syms = unique(cds)  # possible observation outcomes
nsyms = length(syms)

#random starting values for transition probs, starting probs, and observation probs
set.seed(123)
startP = matrix(runif(nstates), 1, nstates); startP = startP/sum(startP) #probs for initial states
tranP = matrix(runif(nstates * nstates),nstates, nstates) #state transition matrix
tranP = sweep(tranP, 1,rowSums(tranP), FUN = "/")
obP = matrix(runif(nstates * nsyms), nstates, nsyms) #for each state, a distribution on possible observed symbols
obP = sweep(obP, 1, rowSums(obP), FUN = "/")

#setup and run Baum-Welch and Viterbi
hmm = initHMM(states, syms, startProbs = startP, transProbs = tranP, emissionProbs = obP) #initialize hmm
cat("*** run BaumWelch (this may take a while, why did the siamese twins move to England?)\n")
BW = baumWelch(hmm, cds) #this may take a little while
cat("so the other one could drive\n")
sts = viterbi(BW$hmm, cds)
######################################################################
cat("### plot fitted hhm\n")

#observation probs
fhmm = BW$hmm
obProb = fhmm$emissionProbs
plot(c(1,nsyms),range(obProb),type="n",xlab="char #",ylab="prob")
title(main="observation (character) probs for different states")
for(i in 1:nstates) text(1:nsyms,obProb[i,],syms,col=i,cex=2)
legend("topleft",legend=paste0("state",1:3),col=1:nstates,pch=rep(16,nstates))
dev.copy2pdf(file="obs-probs.pdf",height=6,width=12)

#transition probs
tProb = fhmm$transProbs
plot(c(1,nstates),range(tProb),type="n",xlab="state",ylab="state Prob")
for(i in 1:nstates) lines(1:nstates,tProb[i,],col=i,lwd=2)
legend("topleft",legend=paste0("state",1:3),col=1:nstates,lwd=rep(2,nstates))
title(main="transition probabilities")
#dev.copy2pdf(file="trans-probs.pdf",height=6,width=12)

plot(as.numeric(sts[1:50]),xlab="observation #",ylab="state",type="b",pch=16,col="blue")
#dev.copy2pdf(file="states.pdf",height=6,width=12)





