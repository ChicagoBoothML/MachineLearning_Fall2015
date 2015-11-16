#### part 1

library(igraph)
# if you do not have igraphdata package, install it
# install.packages("igraphdata")
library(igraphdata)
data(karate, package = "igraphdata")

# nodes in faction 1 will be rectangles
# nodes in faction 2 will be circles
shapes = c('rectangle', 'circle')
faction_vertex_shape = get.vertex.attribute(karate, "Faction")
faction_vertex_shape[faction_vertex_shape == 1] = shapes[1]
faction_vertex_shape[faction_vertex_shape == 2] = shapes[2]

# store layout so that it does not change for different plots
karate_layout = layout.davidson.harel(karate)

# first, we obtain communities using
# edge betweeness clustering algorithm
# ebc is a communities object
ebc = cluster_edge_betweenness(karate)
# we can perform various things using communities object
# see help(communities)
length(ebc)       # how many communities are there
communities(ebc)  # what are communities
membership(ebc)   # vector containing membership of each vertex
sizes(ebc)        # how many vertices are in each community
algorithm(ebc)    # what algorithm was used to obtain the communities
is.hierarchical(ebc)   # was a hierarchical algorithm used to find the community structure
dendPlot(ebc)        # this makes only sense for hierarchical algorithms

plot(karate, 
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape,
     vertex.color=ebc$membership)

# alternative way to plot community detection result
plot(ebc, karate, 
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape)

# since the output of edge betweensess is hierarchical
# we can cut the tree at a different level
# by default, the tree is cut so that the resulting clustering 
# gives the highest modularity score
cl2 = cutat(ebc, 2)     # create two groups -- this works only for hierarchical clusters
plot(karate,
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape,
     vertex.color=cl2)

# compute modularity based for different communities
modularity(karate, ebc$membership)  
modularity(karate, cl2)


cl = cluster_fast_greedy(karate)
is.hierarchical(cl)

cl = cluster_infomap(karate)
is.hierarchical(cl)

cl = cluster_label_prop(karate)
is.hierarchical(cl)

cl = cluster_leading_eigen(karate)
is.hierarchical(cl)

cl = cluster_louvain(karate)
is.hierarchical(cl)

cl = cluster_optimal(karate)
is.hierarchical(cl)

cl = cluster_spinglass(karate)
is.hierarchical(cl)

cl = cluster_walktrap(karate)
is.hierarchical(cl)


###  part 2

wg = read.graph("wikipedia.gml", "gml")
summary(wg)

list.vertex.attributes(wg)
get.vertex.attribute(wg, "label")[1:5]

# some algorithms work on undirected graphs only
wgu = as.undirected(wg)
summary(wgu)

# compute communities and visually inspect if they make sense

