# a simple hmm example using depmixs4
# details here http://petewerner.blogspot.com/2014/09/hmm-example-with-depmixs4.html

library(depmixS4)

##
# part 1, set up a two state process
# the first state draws realizations from N(-1, 1), the second from N(1, 1) 
# transition between states is determined by a stochastic transtion matrix

#transition matrix
tmat <- matrix(c(0.9, 0.15, 0.1, 0.85), nr=2)
tmat

#set of states
states <- c(1,2)

n <- 100 #number of iterations
s0 <- 1 #initial state

set.seed(1)
rea <- data.frame(rnorm(n, -2, 1), rnorm(n, 1, 5))
s <- s0

#state transition record
trans <- c(s0)

#generate n transitions (including initial state)
for (i in 1:(n-1)) {
	s <- sample(states, size=1, prob=tmat[s, ])
	trans <- c(trans, s)
}

#at each step, our sample trajectory takes realized values from process 1 or 2 depending on the current state
traj <- sapply(1:n, function(x) rea[x,trans[x]])

##
# part 2, use depmix to reconstruct the state
##

#set up the model
mod <- depmix(traj ~ 1, data=data.frame(traj), nstates=2)

#fit the model 
f <- fit(mod)
#check to see how the state transtion matricies and process mean/sd matches our sample data
summary(f)

#get the estimated state for each timestep 
esttrans <- posterior(f)

par(mfrow=c(3,1))
plot(1:n, traj, type='l', main='Sample trajectory')
plot(1:n, esttrans[,1], type='l', main='Estimated state')
plot(1:n, trans, type='l', main='Actual state')




