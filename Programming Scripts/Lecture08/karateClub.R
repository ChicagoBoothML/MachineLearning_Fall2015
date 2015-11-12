library(igraph)
# if you do not have igraphdata package, install it
# install.packages("igraphdata")
library(igraphdata)
data(karate, package = "igraphdata")
help(karate)

# list attributes of each vertex
list.vertex.attributes(karate)
# get name of each vertex
get.vertex.attribute(karate, "name")
# get faction membership of each vertex
get.vertex.attribute(karate, "Faction")

# obtain layout and plot graph
if (file.exists("karate.layout.Rdata")) {
  load("karate.layout.Rdata")
} else {
  karate_layout <- layout.davidson.harel(karate)
}
# nodes in faction 1 will be rectangles
# nodes in faction 2 will be circles
shapes = c('rectangle', 'circle')
faction_vertex_shape = get.vertex.attribute(karate, "Faction")
faction_vertex_shape[faction_vertex_shape == 1] = shapes[1]
faction_vertex_shape[faction_vertex_shape == 2] = shapes[2]
plot(karate, 
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape)

# compute degree for each node
karate_degree = degree(karate)
order_degree = order(karate_degree, decreasing = T)
# get 10 most connected people and their degree
order_degree[1:5]
karate_degree[order_degree[1:5]]
plot(karate, 
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape,
     vertex.size=karate_degree / sum(karate_degree) * 200)

# compute eigenvector centrality for each node
karate_eigenvector = eigen_centrality(karate, scale=F)$vector
order_eigenvector = order(karate_eigenvector, decreasing = T)
# get 10 most connected people and their degree
order_eigenvector[1:5]
karate_eigenvector[order_eigenvector[1:5]]
plot(karate, 
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape,
     vertex.size=karate_eigenvector / sum(karate_eigenvector) * 200)

# compute clustering centrality for each node
karate_clustering = closeness(karate, weights = NULL)
order_clustering = order(karate_clustering, decreasing = T)
# get 10 most connected people and their degree
order_clustering[1:5]
karate_clustering[order_clustering[1:5]]
plot(karate, 
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape,
     vertex.size=karate_clustering / sum(karate_clustering) * 200)

# compute betweenness centrality for each node
karate_betweenness = betweenness(karate, directed=F, weights = NULL)
order_betweenness = order(karate_betweenness, decreasing = T)
# get 10 most connected people and their degree
order_betweenness[1:5]
karate_betweenness[order_betweenness[1:5]]
plot(karate, 
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape,
     vertex.size=karate_betweenness / sum(karate_betweenness) * 200)


plot(karate_degree / sum(karate_degree), karate_eigenvector)


