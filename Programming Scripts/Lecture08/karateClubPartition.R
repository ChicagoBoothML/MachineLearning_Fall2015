library(igraph)
# if you do not have igraphdata package, install it
# install.packages("igraphdata")
library(igraphdata)
data(karate, package = "igraphdata")
help(karate)

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

# large number of community detection algorithms
#
# edge.betweenness.community [Newman and Girvan, 2004]
# fastgreedy.community [Clauset et al., 2004] (modularity optimization method)
# label.propagation.community [Raghavan et al., 2007]
# leading.eigenvector.community [Newman, 2006]
# multilevel.community [Blondel et al., 2008] (the Louvain method)
# optimal.community [Brandes et al., 2008]
# spinglass.community [Reichardt and Bornholdt, 2006]
# walktrap.community [Pons and Latapy, 2005]
# infomap.community [Rosvall and Bergstrom, 2008]

ebc = edge.betweenness.community(karate)
dendPlot(ebc)
plot(ebc, karate,
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape)

# group intro two communities
ebc2 = cutat(ebc, 2)
colors = c('blue', 'red')
plot(karate,
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape,
     vertex.color=colors[ebc2]
     )

wc = walktrap.community(karate)
plot(wc, karate,
     layout=karate_layout, 
     vertex.shape=faction_vertex_shape)



# spectral clustering
k.lap = graph.laplacian(karate)
eig.anal =eigen(k.lap)
plot(eig.anal$values, col="blue",
     ylab="Eigenvalues of Graph Laplacian")
f.vec <- eig.anal$vectors[, 33]
faction <- get.vertex.attribute(karate, "Faction")
f.colors <- as.character(length(faction))
f.colors[faction == 1] <- "red"
f.colors[faction == 2] <- "cyan"
plot(f.vec, pch=16, xlab="Actor Number",
     ylab="Fiedler Vector Entry", col=f.colors)
abline(0, 0, lwd=2, col="lightgray")

