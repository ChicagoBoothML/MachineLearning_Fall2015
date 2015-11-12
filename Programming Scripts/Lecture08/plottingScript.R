

# We will use the "igraph" package.
#
# A manual is available at 
# http://igraph.org/r/doc/igraph.pdf
#
# A book on Network analysis using igraph is available from UChicago library
# You can obtain the PDF for free from the library's webpage
#
# Statistical Analysis of Network Data with R  
# Eric D. Kolaczyk, Gábor Csárdi
# http://pi.lib.uchicago.edu/1001/cat/bib/10038425
# 
# Code from the book: https://github.com/kolaczyk/sand
#
# if you do not have the package installed
# install.packages("igraph")
library(igraph) 

# Make sure that the files 
#
#   Krack-High-Tec-edgelist-Advice.txt
#   Krack-High-Tec-edgelist-Friendship.txt
#   Krack-High-Tec-edgelist-ReportsTo.txt
#   Krack-High-Tec-Attributes.csv
# 
# are located in your current working directory.
# Recall that you can set the working directory by 
#
# setwd('path/to/your_directory')
#
# These files contain information about edges of your graph
advice_data_frame <- read.table('Krack-High-Tec-edgelist-Advice.txt')
friendship_data_frame <- read.table('Krack-High-Tec-edgelist-Friendship.txt')
reports_to_data_frame <- read.table('Krack-High-Tec-edgelist-ReportsTo.txt')

# Let us examine the top six rows via
# head()
head(friendship_data_frame)

# Let us now load attributes for each node in the graph
attributes <- read.csv('http://sna.stanford.edu/sna_R_labs/data/Krack-High-Tec-Attributes.csv', header=T)
attributes

# For convenience, we can assign column names to our newly 
# imported data frames. c() is a common generic R function that 
# combines its arguments into a single vector.
colnames(advice_data_frame) <- c('ego', 'alter', 'advice_tie')
head(advice_data_frame)

colnames(friendship_data_frame) <- c('ego', 'alter', 'friendship_tie')
head(friendship_data_frame)

colnames(reports_to_data_frame) <- c('ego', 'alter', 'reports_to_tie')
head(reports_to_data_frame)

# We want to combine information from these three data sets 

# Before we merge these data, we need to make sure 'ego' and 'alter' are the
# same across data sets. We can compare each row using the == syntax. 
# The command below should return TRUE for every row if all ego rows
# are the same for advice and friendship:
advice_data_frame$ego == friendship_data_frame$ego

# That's a lot of output to sort through. Instead, we can just have R return 
# which row entries are not equal using the syntax below:
which(advice_data_frame$ego != friendship_data_frame$ego)

# Repeat for other variables
which(advice_data_frame$alter != friendship_data_frame$alter)
which(reports_to_data_frame$alter != friendship_data_frame$alter)
which(reports_to_data_frame$ego != friendship_data_frame$ego)

# Now that we've verified they are all the same, we can combine them into 
# a single data frame. 
krack_full_data_frame <- data.frame(ego = advice_data_frame[,1],
                                    alter = advice_data_frame[,2],
                                    advice_tie = advice_data_frame[,3],
                                    friendship_tie = friendship_data_frame[,3], 
                                    reports_to_tie = reports_to_data_frame[,3])
head(krack_full_data_frame)

# Now let's move on to some data processing.

# Reduce to non-zero edges so that the edge list only contains
# actual ties of some type.
krack_full_nonzero_edges <- subset(krack_full_data_frame, 
                                   (advice_tie > 0 | friendship_tie > 0 | reports_to_tie > 0))
head(krack_full_nonzero_edges)

# Now we can import our data into a "graph" object using igraph's 
# graph.data.frame() function. Coercing the data into a graph
# object is what allows us to perform network-analysis techniques.
krack_full <- graph.data.frame(krack_full_nonzero_edges) 
summary(krack_full)

# By default, graph.data.frame() treats the first two columns of 
# a data frame as an edge list and any remaining columns as 
# edge attributes. Thus, the 232 edges appearing in the summary()
# output refer to the 232 pairs of vertices that are joined by 
# *any type* of tie. The tie types themselves are listed as edge 
# attributes.

# To get a vector of edges for a specific type of tie, use the 
# get.edge.attribute() function.
get.edge.attribute(krack_full, 'advice_tie')
get.edge.attribute(krack_full, 'friendship_tie')
get.edge.attribute(krack_full, 'reports_to_tie')

# If you would like to symmetrize the network, making all 
# asymmetric ties symmetric, use the as.undirected()
# function: 
krack_full_symmetrized <- as.undirected(krack_full, mode='collapse')
summary(krack_full_symmetrized)



###
# 3. ADDING VERTEX ATTRIBUTES TO A GRAPH OBJECT
###

# One way to add the attributes to your graph object is to iterate
# through each attribute and each vertex. This means that we will
# add one attribute at a time to each vertex in the network.
#
# V(krack_full) returns a list of the IDs of each vertex in the 
# graph. names(attributes) returns a list of the column names in
# the attributes table. The double-for loop tells R to repeat the
# code between the brackets once for each attribute and once for
# each vertex.
for (i in V(krack_full)) {
  for (j in names(attributes)) {
    krack_full <- set.vertex.attribute(krack_full, 
                                       j, 
                                       index = i, 
                                       attributes[i, j])
  }
}

# A shorter way is to just read in attribute names when you
# create the graph object:

# First create a vector of vertex labels, in this case 1:n
attributes = cbind(1:length(attributes[,1]), attributes)

krack_full <- graph.data.frame(d = krack_full_nonzero_edges, 
                               vertices = attributes) 

# Note that we now have 'AGE,' 'TENURE,' 'LEVEL,' and 'DEPT'
# listed alongside 'name' as vertex attributes.
summary(krack_full)

# We can see a list of the values for a given attribute for all of
# the actors in the network.
get.vertex.attribute(krack_full, 'AGE')
get.vertex.attribute(krack_full, 'TENURE')
get.vertex.attribute(krack_full, 'LEVEL')
get.vertex.attribute(krack_full, 'DEPT')


###
# 4. VISUALIZE THE NETWORKS
###

# First, let's plot the network with all possible ties.
plot(krack_full)

# This is a bit of a jumble, so let's look at the networks for
# single edge types.

# advice only
krack_advice_only <- delete.edges(krack_full, 
                                  E(krack_full)[get.edge.attribute(krack_full,
                                                                   name = "advice_tie") == 0])
summary(krack_advice_only)
plot(krack_advice_only)


# friendship only
krack_friendship_only <- delete.edges(krack_full, 
                                      E(krack_full)[get.edge.attribute(krack_full, 
                                                                       name = "friendship_tie") == 0])
summary(krack_friendship_only)
plot(krack_friendship_only)


# reports-to only
krack_reports_to_only <- delete.edges(krack_full, 
                                      E(krack_full)[get.edge.attribute(krack_full, 
                                                                       name = "reports_to_tie") == 0])
summary(krack_reports_to_only)
plot(krack_reports_to_only)


# Still kind of messy, so let's clean things up a bit. For 
# simplicity, we'll focus on reports_to ties for now.

# First, we can optimize the layout by applying the layout 
# algorithm to the specific set of ties we care about. Here 
# we'll use Fruchterman-Rheingold; other options are 
# described in the igraph help page for "layout," which 
# can be accessed by entering ?layout.

reports_to_layout <- layout.fruchterman.reingold(krack_reports_to_only)
plot(krack_reports_to_only, 
     layout=reports_to_layout)

# Now let's color-code vertices by department and clean up the 
# plot by removing vertex labels and shrinking the arrow size. 
dept_vertex_colors = get.vertex.attribute(krack_full,"DEPT")
colors = c('Black', 'Red', 'Blue', 'Yellow', 'Green')
dept_vertex_colors[dept_vertex_colors == 0] = colors[1]
dept_vertex_colors[dept_vertex_colors == 1] = colors[2]
dept_vertex_colors[dept_vertex_colors == 2] = colors[3]
dept_vertex_colors[dept_vertex_colors == 3] = colors[4] 
dept_vertex_colors[dept_vertex_colors == 4] = colors[5]

plot(krack_reports_to_only, 
     layout=reports_to_layout, 
     vertex.color=dept_vertex_colors, 
     vertex.label=NA, 
     edge.arrow.size=.5)
# Now let's set the vertex size by tenure.
tenure_vertex_sizes = get.vertex.attribute(krack_full,"TENURE")

plot(krack_reports_to_only, 
     layout=reports_to_layout, 
     vertex.color=dept_vertex_colors, 
     vertex.label=NA, 
     edge.arrow.size=.5,
     vertex.size=tenure_vertex_sizes+1)


# Now let's incorporate additional tie types. We'll use the 
# layout generated by the reports-to ties but overlay the 
# advice and friendship ties in red and blue.

tie_type_colors = c(rgb(1,0,0,.5), rgb(0,0,1,.5), rgb(0,0,0,.5))
E(krack_full)$color[ E(krack_full)$advice_tie==1 ] = tie_type_colors[1]
E(krack_full)$color[ E(krack_full)$friendship_tie==1 ] = tie_type_colors[2]
E(krack_full)$color[ E(krack_full)$reports_to_tie==1 ] = tie_type_colors[3]
E(krack_full)$arrow.size=.5 
V(krack_full)$color = dept_vertex_colors
V(krack_full)$frame = dept_vertex_colors

plot(krack_full, 
     layout=reports_to_layout, 
     vertex.color=dept_vertex_colors, 
     vertex.label=NA, 
     edge.arrow.size=.5,
     vertex.size=tenure_vertex_sizes+1)


# Add a legend. Note that the plot window must be open for this to 
# work.
legend(1, 
       1.25,
       legend = c('Advice', 
                  'Friendship',
                  'Reports To'), 
       col = tie_type_colors, 
       lty=1,
       cex = .7)


# Another option for visualizing different network ties relative 
# to one another is to overlay the edges from one tie type on the 
# structure generated by another tie type. Here we can use the
# reports-to layout but show the friendship ties:

plot(krack_friendship_only, 
     layout=reports_to_layout, 
     vertex.color=dept_vertex_colors, 
     vertex.label=NA, 
     edge.arrow.size=.5,
     vertex.size=tenure_vertex_sizes+1, 
     main='Krackhardt High-Tech Managers')


# Plot advice_only using the same layout 
plot(krack_advice_only, 
     layout=reports_to_layout, 
     vertex.color=dept_vertex_colors, 
     vertex.label=NA, 
     edge.arrow.size=.5,
     vertex.size=tenure_vertex_sizes+1)


###
# 5. EXPORT THE NETWORK
###

# The write.graph() function exports a graph object in various
# formats readable by other programs. There is no explicit
# option for a UCINET data type, but you can export the graph
# as a Pajek object by setting the 'format' parameter to 'pajek.'
# Note that the file will appear in whichever directory is set 
# as the default in R's preferences, unless you previously 
# changed this via setwd().
write.graph(krack_full, file='krack_full.dl', format="pajek")

# For a more general file type (e.g., importable to Excel),
# use the "edgelist" format. Note that neither of these will
# write the attributes; only the ties are maintained.
write.graph(krack_full, file='krack_full.txt', format="edgelist")