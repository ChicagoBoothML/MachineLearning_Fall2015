########################
#
# Part 1
#
########################

emails = read.csv("emails.csv", stringsAsFactors=FALSE)
emails$spam = factor(emails$spam, labels = c("ham", "spam"))
str(emails)

# we will split data into train and test according to 
#   sampling_vector
set.seed(1)
num_emails = nrow(emails)
sampling_vector = sample(num_emails, floor(0.8 * num_emails))

# the table has two columns
# let's look how many spam emails we have
table(emails$spam)

# this is the text of the first email
emails$text[1]

# Using the emails in the data frame, we will build a corpus of emails
# For that we use the tm package
# Snowball package is used for stemming
# If you have not installed these packagese, run
#   
#   install.packages("tm")
#   install.packages("SnowballC")
#
library(tm)
library(SnowballC)

# create corpus
corpus = Corpus(VectorSource(emails$text))

corpus[[1]]$content
corpus[[1]]$meta

# From now on, follow NB_reviews.R script from the class webpage
# to preprocess text data and create the document term matrix
# containing content of emails.

#############################
###  your code here to create the document term matrix





#############################
# in your code above, you have created the document term matrix
# and you have stored it into the variable named `dtm`

#
# next we remove infrequent words
# we keep columns that are less than 0.99 percent sparse
# this is the parameter that you will need to tune in the homework
sparse_dtm = removeSparseTerms(x=dtm, sparse = 0.99)
sparse_dtm

# split into train and test using sampling_vector
df = as.data.frame(as.matrix(sparse_dtm))
df_train = df[sampling_vector,]
df_test = df[-sampling_vector,]
spam_train = emails$spam[sampling_vector]
spam_test = emails$spam[-sampling_vector]

# if you have not installed the library that contains 
# naiveBayes function, run
# 
#  install.packages("e1071")
library(e1071)

### your code for classification goes below









#############################################
# 
# Part 2
#
#############################################

# this is the code you saw in the classroom
# for creating random graphs using stochastic block model
# 
# there is also code to fit the model using the lda package 

library(igraph)

# block matrix -- assortative
# our graph will have three communities
# try playing with this matrix to obtain different types of graphs
M = matrix(c( 0.6, 0.01, 0.01,
              0.01, 0.6,  0.01,
              0.01, 0.01, 0.6), 
           nrow = 3)

# sample a random graph
# 30 vertices grouped into 3 communities with 10 nodes each
rg = sample_sbm(30,                   # number of nodes in a random graph 
                pref.matrix = M,      # stochastic block matrix M that tells us probability of forming a link between nodes -- needs to be symmetric for undirected graphs
                block.sizes = c(10,10,10),  # how many nodes belong to each community 
                loops = F,            # no loops (vertex that connects to itself)
                directed = F          # we want an undirected graph 
                ) 

# membership vector used to color vertices 
membership_vector = c(rep(1, 10), rep(2, 10), rep(3, 10))
plot_layout = layout.fruchterman.reingold(rg)
plot(rg, 
     vertex.color=membership_vector,
     layout = plot_layout)



# given a graph, we would like to uncover parameters of the model 
# that is likely to have generated the random graph
# in this example, we know that the graph was generated according to the stochastic block model
# we can compare the estimated parameters to the true parameters
#
# however, in practice, we only see a graph (that is, its adjacency matrix) 
# to evaluate our model, we use domain knowledge. for example, whether community 
# memberships of nodes make sense 

## estimate parameters using the lda package
library(lda)

result =
  mmsb.collapsed.gibbs.sampler(get.adjacency(rg),  # first parameter is the adjacency matrix
                               K = 3,              # we are fitting the graph using a stochastic block model with three groups
                               num.iterations=10000,    # this and the following parameters specify parameters of the fitting procedure  -- don't worry about this
                               alpha = 0.1,
                               burnin = 500L,
                               beta.prior = list(1, 1))

# this matrix tells us for each vertex what is the probability that it belongs to 
# one of the K communities
memberships = with(result, t(document_sums) / colSums(document_sums))
memberships

# the estimate of the stochastic block matrix M 
ratio = with(result, blocks.pos / (blocks.pos + blocks.neg))
ratio


# the code below is for plotting purposes
# you do not need to use that for your homework
# note that the code below works only for K=3

require("ggplot2")
require("grid")

colnames(memberships) = paste("theta", 1:3, sep=".")
memberships = cbind(data.frame(name=1:nrow(memberships)), memberships)
memberships$colors = with(memberships, rgb(theta.3, theta.1, theta.2))
center = c(sqrt(3) / 4, sqrt(3) / 4)
angles = with(memberships, atan2(theta.3 - center[2], theta.1 - center[1]))
angle.diffs = tapply(angles, as.factor(angles), function(x) {
  pi/4 + seq(from=-(length(x) - 1) / 2,
             to=(length(x) - 1) / 2,
             length.out=length(x)) * pi / 6
})
angles[order(angles)] = unlist(angle.diffs)
plot.1 <- ggplot(data = memberships) +
  geom_segment(aes(x = c(0, 0, 1),  y = c(0, 1, 0),
                   xend = c(0, 1, 0), yend = c(1, 0, 0))) +
  geom_point(aes(x = theta.1, y = theta.3, color = colors)) +
  scale_colour_manual(values = structure(memberships$colors, names = memberships$colors)) +
  scale_x_continuous(breaks=seq(0, 1, length.out=5),
                     limits = c(-0.25, 1.25)) +
  scale_y_continuous(breaks=seq(0, 1, length.out=5),
                     limits = c(-0.25, 1.25)) +
  geom_text(aes(x=theta.1, y=theta.3, label=name, colour = colors,
                angle=angles * 180 / pi), 
            data = memberships,
            size=2, hjust=-0.5) +
  ggtitle("Latent positions") +
  xlab(expression(theta[1])) +
  ylab(expression(theta[3])) +
  theme(panel.grid.minor = element_blank(), legend.position = "none")

## Block relations plot
total = with(result, blocks.pos + blocks.neg)
data = as.data.frame(cbind(Probability=as.numeric(ratio),
                            Count=as.numeric(total),
                            Column=rep(1:3, each=3),
                            Row=rep(1:3, times=3)))
plot.2 = qplot(Column, Row, main="Block relations",
                size=Count, colour=Probability, data=data) +
  scale_size(range=c(7,15)) +
  scale_x_continuous(breaks=1:3, limits=c(0.5, 3.5)) +
  scale_y_reverse(breaks=1:3, limits=c(3.5, 0.5))

grid.newpage()
pushViewport(viewport(layout = grid.layout(1, 2)))
print(plot.1, vp=viewport(layout.pos.row=1,layout.pos.col=1))
print(plot.2, vp=viewport(layout.pos.row=1,layout.pos.col=2))

