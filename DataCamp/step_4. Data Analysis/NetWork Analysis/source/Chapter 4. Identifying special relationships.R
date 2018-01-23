# Part 1. Identifying special relationships
# Chapter 1. Assortativity
# In this exercise you will determine the assorativity() of the second friendship network from the first chapter. This is a measure of how preferentially attached vertices are to other vertices with identical attributes. You will also determine the degree assortativity which determines how preferentially attached are vertices to other vertices of a similar degree.
library(igraph)
library(tidyverse)

url2 <- "https://assets.datacamp.com/production/course_4474/datasets/friends1_edges.csv"
friends1_edges <- read_csv(url2)

url3 <- "https://assets.datacamp.com/production/course_4474/datasets/friends1_nodes.csv"
friends1_nodes <- read_csv(url3)

g1 <- graph_from_data_frame(d = friends1_edges, vertices = friends1_nodes, directed = FALSE)

# (1) Make an exploratory plot of the friendship network object g1 using plot().
plot(g1)

# (2) Convert the gender attribute of each vertex to a vector of numbers called values by factorizing and then using as.numeric().
values <- as.numeric(factor(V(g1)$gender))

# (3) Calculate the assortativity based on gender by using the function assortativity(). The first argument should be the graph object g1. The second argument are the values.
assortativity(g1, values)

# (4) Calculate the degree assortativity of the network using assortativity.degree(). The first argument should be the graph object.
assortativity.degree(g1, directed = FALSE)

# Chapter 2. Using randomizations to assess assortativity
# In this exercise you will determine how likely the observed assortativity in the friendship network is given the genders of vertices by performing a randomization procedure. You will randomly permute the gender of vertices in the network 1000 times and recalculate the assortativity for each random network.

# (1) Use assortativity() to calculate the assortativity of the graph object g1 based on gender using the object values calculated in the previous exercise, and assign this to the object observed.assortativity.
# Calculate the observed assortativity
observed.assortativity <- assortativity(g1, values)

# (2) Inside the for loop calculate the assortativity of the network g1 using assortativity() while randomly permuting the object values each time with sample().
# Calculate the assortativity of the network randomizing the gender attribute 1000 times
results <- vector('list', 1000)
for(i in 1:1000){
  results[[i]] <- assortativity(g1, sample(values))
}

# (3) Plot the distribution of assortativity values from this permutation procedure using hist() and add a red vertical line for the original g1 network observed assortativity value that is stored in observed.assortativity.
# Plot the distribution of assortativity values and add a red vertical line at the original observed value
hist(unlist(results))
abline(v = observed.assortativity, col = "red", lty = 3, lwd=2)

# Chapter 3. Reciprocity
# The reciprocity of a directed network reflects the proportion of edges that are symmetrical. That is, the proportion of outgoing edges that also have an incoming edge. It is commonly used to determine how inter-connected directed networks are. An example of a such a network may be grooming exchanges in chimpanzees. Certain chimps may groom another but do not get groomed by that individual, whereas other chimps may both groom each other and so would have a reciprocal tie.
url <- "https://assets.datacamp.com/production/course_4474/datasets/measles.csv"
measles <- read_csv(url)
g <- graph_from_data_frame(measles, directed = TRUE)

# In this example network of chimps grooming each other, make an exploratory plot of the network g using plot(). Make the arrow size 0.3 using the argument edge.arrow.size and the arrow width 0.5 using the argument edge.arrow.width.
# Make a plot of the chimp grooming network
plot(g,
     edge.color = "black",
     edge.arrow.size = 0.1,
     edge.arrow.width = 0.2)

# Calculate the reciprocity of the graph using reciprocity().
# Calculate the reciprocity of the graph
reciprocity(g)

# Part 2. Community Detection in Networks
# Chapter 1. Fast-greedy community detection
# The first community detection method you will try is fast-greedy community detection. You will use the Zachary Karate Club network. This social network contains 34 club members and 78 edges. Each edge indicates that those two club members interacted outside the karate club as well as at the club. Using this network you will determine how many sub-communities the network has and which club members belong to which subgroups. You will also plot the networks by community membership.

# (1) Use the function fastgreedy.community() to create a community object. Assign this to the object kc.
# Perform fast-greedy community detection on network graph
kc = fastgreedy.community(g2)

# (2) Use the function sizes() on kc to determine how many communities were detected and how many club members are in each.
# Determine sizes of each community
sizes(kc)

# (3) Display which club members are in which community using the function membership().
# Determine which individuals belong to which community
membership(kc)

# (4) Make the default community plot by using the function plot(). The first argument should be the object kc and the second argument is the graph object g.
# Plot the community structure of the network
plot(kc, g2)

# Chapter 2. Edge-betweenness community detection
# An alternative community detection method is edge-betweenness. In this exercise you will repeat the community detection of the karate club using this method and compare the results visually to the fast-greedy method.

# (1) Use the function edge.betweenness.community() on the graph object g to create the community igraph object gc.
# Perform edge-betweenness community detection on network graph
gc = edge.betweenness.community(g2)

# (2) Calculate the size and number of communities by using the function sizes on the community igraph object.
# Determine sizes of each community
sizes(gc)

# (3) Plot each community plot next to each other using par(). The first plot should include the community object kc from the previous exercise. The second plot should include the community object gc
# Plot community networks determined by fast-greedy and edge-betweenness methods side-by-side
par(mfrow = c(1, 2)) 
plot(kc, g2)
plot(gc, g2)

# (4) Community quiz
# igraph has many community detection algorithms. How many communities does the algorithm leading.eigenvector.community() believe that the karate club network object g can be assigned to?

# Part 3. Interactive networks with threejs
# Chapter 1. Interactive networks with threejs
# In this course you have exclusively used igraph to make basic static network plots. There are many packages available to make network plots. One very useful one is threejs which allows you to make interactive network visualizations. This package also integrates seamlessly with igraph. In this exercise you will make a basic interactive network plot of the karate club network using the threejs package. Once you have produced the visualization be sure to move the network around with your mouse. You should be able to scroll in and out of the network as well as rotate the network.
# install.packages("threejs")
library(threejs)

# First using set_vertex_attr() let's make a new vertex attribute called color that is dodgerblue.
# Set a vertex attribute called 'color' to 'dodgerblue' 
g2 <- set_vertex_attr(g2, "color", value = "dodgerblue")

# Plot the network g using the threejs function graphjs(). The first argument should be the graph object g. Also make the vertex size equal to 1.
# Redraw the graph and make the vertex size 1
graphjs(g2, vertex.size = 1)

# Chapter 2. Sizing vertices in threejs
# As with all network visualizations it is often worth adjusting the size of vertices to illustrate their relative importance. This is also straightforward in threejs. In this exercise you will create an interactive threejs plot of the karate club network and size vertices based on their relative eigenvector centrality.

# (1) Calculate the eigenvector centrality of each vertex using eigen_centrality() and store the values in the object ec.
# Create numerical vector of vertex eigenvector centralities 
ec <- as.numeric(eigen_centrality(g)$vector)

# (2) Using sqrt() adjust the values in ec to create a new vector of values v which is equal to five times the square root of the original eigenvector centrality.
# Create new vector 'v' that is equal to the square-root of 'ec' multiplied by 5
v <- 5*sqrt(ec)

# (3) Plot the network using the threejs function graphjs and making the argument vertex.size equal to the values in v.
# Plot the network using the threejs function graphjs and making the argument vertex.size equal to the values in v.
graphjs(g, vertex.size = v)

# Chapter 3. 3D community network graph
# Finally in this exercise you will create an interactive threejs plot with the vertices based on their community membership as produced by the fast-greedy community detection method.

# (1) Use the function membership() on the community igraph object kc to generate a vector of community membership for each vertex.
# Create an object 'i' containin the memberships of the fast-greedy community detection
i <-  membership(kc)

# (2) Check how many communities there are using the function sizes() on the community igraph object kc.
# Check the number of different communities
sizes(kc)

# (3) Use set_vertex_attr() to add a vertex attribute called color to the graph object g. The values to add are the colors based on the membership assigned to object i
# Add a color attribute to each vertex, setting the vertex color based on community membership
g <- set_vertex_attr(g, "color", value = c("yellow", "blue", "red")[i])

# (4) Plot the three-dimensionsal graph by using the function graphjs() on the network object g.
# Plot the graph using threejs
graphjs(g)
