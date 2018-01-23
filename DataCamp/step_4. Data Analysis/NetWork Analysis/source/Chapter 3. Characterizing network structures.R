# Part 1. Introduction
library(tidyverse)
library(igraph)
url <- "https://assets.datacamp.com/production/course_4474/datasets/gump.csv"
gump <- read_csv(url)

# Chapter 1. Forrest Gump network
# In this chapter you will use a social network based on the movie Forrest Gump. Each edge of the network indicates that those two characters were in at least one scene of the movie together. Therefore this network is undirected. To familiarize yourself with the network, you will first create the network object from the raw dataset. Then, you will identify key vertices using a measure called eigenvector centrality. Individuals with high eigenvector centrality are those that are highly connected to other highly connected individuals. You will then make an exploratory visualization of the network.

# Inspect the first few rows of the dataframe gump using head().
# Inspect Forrest Gump Movie dataset
head(gump)

# Make an undirected network using graph_from_data_frame().
# Make an undirected network
g <- graph_from_data_frame(gump, directed = FALSE)

# Identify the key vertices using the function eigen_centrality() and assign the results of this to the object g.ec. Next identify which individual has the highest eigenvector centrality using which.max(). The values of the centrality scores are stored in g.ec$vector.
# Identify key nodes using eigenvector centrality
g.ec <- eigen_centrality(g)
which.max(g.ec$vector)

# Make a plot of the Forrest Gump Network using plot(). Make the size of the vertices equal to 25 times the eigenvector centrality values that are stored in g.ec$vector
# Plot Forrest Gump Network
plot(g,
     vertex.label.color = "black", 
     vertex.label.cex = 0.6,
     vertex.size = 25*(g.ec$vector),
     edge.color = 'gray88',
     main = "Forrest Gump Network"
)

# Chapter 2. Network density and average path length
# The first graph level metric you will explore is the density of a graph. This is essentially the proportion of all potential edges between vertices that actually exist in the network graph. It is an indicator of how well connected the vertices of the graph are.

# Another measure of how interconnected a network is average path length. This is calculated by determining the mean of the lengths of the shortest paths between all pairs of vertices in the network. The longest path length between any pair of vertices is called the diameter of the network graph. You will calculate the diameter and average path length of the original graph g. 

# Using the function edge_density() calculate the density of the graph gand assign this value to the vector gd
# Get density of a graph
gd <- edge_density(g)

# Use diameter() to calculate the diameter of the original graph g
diameter(g, directed = FALSE)

# Assign the average path length of g to g.apl with the function mean_distance()
g.apl <- mean_distance(g, directed = F)

# Quiz, Graph density quiz. 
# If a graph has 7 vertices there are 21 possible edges in the network. If 14 edges exist, what is the density of the network?

# Part 2. Network Randomizations
# Chapter 1. Random graphs
# Generating random graphs is an important method for investigating how likely or unlikely other network metrics are likely to occur given certain properties of the original graph. The simplest random graph is one that has the same number of vertices as your original graph and approximately the same density as the original graph. Here you will create one random graph that is based on the original Forrest Gump Network.

# Generate a random graph using the function erdos.renyi.game(). The first argument n should be the number of nodes of the graph g which can be calculated using gorder(), the second argument p.or.m should be the density of the graph g which you previously stored as the obejct gd. The final argument is set as type='gnp' to tell the function that you are using the density of the graph to generate a random graph. Store this new graph as the vector g.random.
# Create one random graph with the same number of nodes and edges as g
g.random <- erdos.renyi.game(n = gorder(g), p.or.m = gd, type = "gnp")
g.random

plot(g.random)

# Get the density of the random graph g.random. You will notice if you generate a random graph a few times that this value will slightly vary but be approximately equal to the density of your original graph g from the previous exercise stored in the object gd. 
# Get density of new random graph `g.random`
edge_density(g.random)

# Calculate the average path length of the random graph g.random 
# Get the average path length of the random graph g.random
mean_distance(g.random, directed = FALSE)

# Chapter 2. Network Randomizations
# In the previous exercise you may have noticed that the average path length of the Forrest Gump network was smaller than the average path length of the random network. If you ran the code a few times you will have noticed that it is nearly always lower in the Forrest Gump network than the random network. What this suggests is that the Forrest Gump network is more highly interconnected than each random network even though the random networks have the same number of vertices and approximately identical graph densities. Rather than re-running this code many times, you can more formally address this by creating 1000 random graphs based on the number of vertices and density of the original Forrest Gump graph. Then, you can see how many times the average path length of the random graphs is less than the original Forrest Gump network. This is called a randomization test.

# Generate 1000 random graphs of the original graph g by executing the code that creates the list object gl and the for loop. 
gl <- vector("list", 1000)
for(i in 1:1000) {
  gl[[i]] <- erdos.renyi.game(n = gorder(g), p.or.m = gd, type = "gnp")
}

# Calculate the average path length of the 1000 random graphs using lapply(). 
gl.apl <- lapply(gl, mean_distance, directed = FALSE)

# Create a vector gl.apls of these 1000 values by executing the code that uses unlist().
gl.apls <- unlist(gl.apl)

# plot a histogram of the average path lengths of the 1000 random graphs using hist() on the vector gl.apls. Add a red dashed line to the plot using abline() with the x-intercept being the value of the average path length of the original graph g.apl. You calculated this value in the previous exercise. 
# Plot the distribution of average path lengths
hist(gl.apls, xlim = range(c(1.5, 6)))
abline(v = g.apl, col = "red", lty = 3, lwd=2)

# Calculate the proportion of times that the values of the average path length of random graphs gl.apls are lower that the value of the original graph g.apl. This is essentially the probability that we would expect our observed average path length by chance given the original density and number of vertices of the original graph. 
# Calculate the proportion of graphs with an average path length lower than our observed
sum(gl.apls < g.apl)/1000

# Quiz Randomization quiz
# Randomization tests enable you to identify:
# Possible Answers
# (1) The density of a network, (2) The number of vertices in a network, (3) The number of edges in a network, (4) Whether features of your original network are particularly unusual. 

# Answer is (4)

# Part 3. Network substructures
# Chapter 1. Triangles and transitivity
# Another important measure of local connectivity in a network graph involves investigating triangles (also known as triads). In this exercise you will find all closed triangles that exist in a network. This means that an edge exists between three given vertices. You can then calculate the transitivity of the network. This is equivalent to the proportion of all possible triangles in the network that are closed. You will also learn how to identify the number of closed triangles that any given vertex is a part of and its local transitivity - that is, the proportion of closed triangles that the vertex is a part of given the theoretical number of triangles it could be a part of.

# Instructions
# (1) Show a matrix of all possible triangles in the Forrest Gump network g using the function triangles()
# Show all triangles in the network.
matrix(triangles(g), nrow = 3)

# (2) Using the function count_triangles(), find how many triangles that the vertex "BUBBA" is a part of. The vids argument refers to the id of the vertex.
# Count the number of triangles that vertex "BUBBA" is in. 
count_triangles(g, vids = "BUBBA")

# (3) Calcuate the global transitivity of the network g using transitivity(). 
# Calculate  the global transitivity of the network.
g.tr <- transitivity(g)

# (4) Find the local transitivity of vertex "BUBBA" also using the function transitivity(). The type is defined as local to indicate that you are calculating a local rather than global transitivity.
transitivity(g, vids = "BUBBA", type = "local")

# Chapter 2. Transitivity randomizations
# As you did for the average path length, let's investigate if the global transitivity of the Forrest Gump network is significantly higher than we would expect by chance for random networks of the same size and density. You can compare Forrest Gump's global transitivity to 1000 other random networks.

# Instructions
# (1) One thousand random networks are stored in the list object gl. Using lapply() and transitivity() calculate the global transitivity of each of these networks. Assign these results to gl.tr.
# Calculate average transitivity of 1000 random graphs
gl.tr <- lapply(gl, transitivity)

# (2) Using unlist() convert gl.tr to a numeric vector gl.trs.
gl.trs <- unlist(gl.tr)

# (3) Get summary statistics of transitivity scores
summary(gl.trs)

# (4) Calculate the proportion of random graphs that have a transitivity higher than the transitivity of Forrest Gump's network, which you previously calculated and assigned to g.tr
# Calculate the proportion of graphs with a transitivity score higher than Forrest Gump's network.
sum(gl.trs > gl.tr)/1000

# Chapter 3. Cliques
# Identifying cliques is a common practice in undirected networks. In a clique every two unique nodes are adjacent - that means that every individual node is connected to every other individual node in the clique. In this exercise you will identify the largest cliques in the Forrest Gump network. You will also identify the number of maximal cliques of various sizes. A clique is maximal if it cannot be extended to a larger clique.

# Instructions
# (1) Identify the largest cliques in the network using the function largest_cliques(). 
# Identify the largest cliques in the network
largest_cliques(g)

# (2) Determine all the maximal cliques in the network using the function max_cliques(). Assign the output of this function to the list object clq
# Determine all maximal cliques in the network and assign to object 'clq'
clq <- max_cliques(g)

# (3) Calculate the length of each of the maximal cliques. Use lapply() to loop through the object clq determining the length() of each object in the list. Then unlist() and use table() to observe how large each of the maximal cliques are.
# Calculate the size of each maximal clique.
table(unlist(lapply(clq, length)))

# Chapter 4. Visualize largest cliques
# Often in network visualization you will need to subset part of a network to inspect the inter-connections of particular vertices. Here, you will create a visualization of the largest cliques in the Forrest Gump network. In the last exercise you determined that there were two cliques of size 9. You will plot these side-by-side after creating two new igraph objects by subsetting out these cliques from the main network. The function subgraph() enables you to choose which vertices to keep in a new network object.

# Assign the list of the largest cliques in the network to the object lc.
# Assign largest cliques output to object 'lc'
lc <- largest_cliques(g)

# Create two new undirected subgraphs using the function subgraph(). The first, gs1, should contain only the vertices in the first largest clique. The second, gs2, should contain only the vertices in the second largest clique. This function is wrapped in as.undirected() to ensure that the subgraph is also undirected.
# Create two new undirected subgraphs, each containing only the vertices of each largest clique.
gs1 <- as.undirected(subgraph(g, lc[[1]]))
gs2 <- as.undirected(subgraph(g, lc[[2]]))

# Visualize the two largest cliques side by side using plot(). First execute the code: par(mfrow=c(1,2)). This is to ensure that the two visualizations sit side-by-side. Make sure that the layout is set to layout.circle() to make the visualization easier to view.

# Plot the two largest cliques side-by-side
par(mfrow=c(1,2)) # To plot two plots side-by-side

plot(gs1,
     vertex.label.color = "black", 
     vertex.label.cex = 0.9,
     vertex.size = 0,
     edge.color = 'gray28',
     main = "Largest Clique 1",
     layout = layout.circle(gs1)
)

plot(gs2,
     vertex.label.color = "black", 
     vertex.label.cex = 0.9,
     vertex.size = 0,
     edge.color = 'gray28',
     main = "Largest Clique 2",
     layout = layout.circle(gs2)
)



