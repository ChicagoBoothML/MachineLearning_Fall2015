# Lauritzen and Spiegehalter (1988) presents the following narrative:
#
#     “Shortness–of–breath (dyspnoea ) may be due to tuberculosis, lung cancer
# or bronchitis, or none of them, or more than one of them.
#
# A recent visit to Asia increases the chances of tuberculosis, while smoking
# is known to be a risk factor for both lung cancer and bronchitis.
#
# The results of a single chest X–ray do not discriminate between lung cancer
# and tuberculosis, as neither does the presence or absence of dyspnoea.”
#
#
#  p(V) = p(A)p(T|A)p(S)p(L|S)p(B|S)p(E|T, L)p(D|E, B)p(X|E)

library(gRain)

yn <- c("yes","no")
a <- cptable(~asia, values=c(1,99),levels=yn)
t.a <- cptable(~tub+asia, values=c(5,95,1,99),levels=yn)
s <- cptable(~smoke, values=c(5,5), levels=yn)
l.s <- cptable(~lung+smoke, values=c(1,9,1,99), levels=yn)
b.s <- cptable(~bronc+smoke, values=c(6,4,3,7), levels=yn)
e.lt <- cptable(~either+lung+tub,values=c(1,0,1,0,1,0,0,1),levels=yn)
x.e <- cptable(~xray+either, values=c(98,2,5,95), levels=yn)
d.be <- cptable(~dysp+bronc+either, values=c(9,1,7,3,8,2,1,9), levels=yn)
plist <- compileCPT(list(a, t.a, s, l.s, b.s, e.lt, x.e, d.be))
bnet <- grain(plist)
bnet

plist

plist$tub

plot(bnet)

# Queries
querygrain(bnet, nodes=c('lung', 'tub', 'bronc'))

# Setting findings and probability of findings

bnet.f <- setFinding(bnet, nodes=c('asia', 'dysp'), state=c('yes','yes'))
bnet.f

querygrain(bnet.f, nodes=c('lung', 'tub', 'bronc'))

querygrain(bnet.f, nodes=c('lung', 'tub', 'bronc'), type='joint')



