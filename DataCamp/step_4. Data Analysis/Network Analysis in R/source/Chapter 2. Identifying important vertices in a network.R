# Part 1. Directed Networks
# Directionality
# Chapter 1. Directed igraph objects
library(igraph)
url <- "https://assets.datacamp.com/production/course_4474/datasets/measles.csv"
measles <- read_csv(url)
write_csv(measles, "measles.csv")

# In this exercise you will learn how to create a directed graph from a dataframe, how to inspect whether a graph object is directed and/or weighted and how to extract those vertices at the beginnning and end of directed edges.

# Instructions
# Convert the dataframe measles into an igraph graph object using the function graph_from_data_frame() and ensure that it will be a directed graph by setting the second argument to TRUE.
# Get the graph object
g <- graph_from_data_frame(measles, directed = TRUE)

# Check if the graph object is directed by using is.directed().
# is the graph directed?
is.directed(g)

# Examine whether the edges of the graph object are already weighted by using is.weighted().
is.weighted(g)

# Subset each vertex from which each edge originates by using head_of(). This function takes two arguments, the first being the graph object and the second the edges to examine. For all edges you can use E(g).
# Where does each edge originate from?
table(head_of(g, E(g)))

# Chapter 2. Identifying edges for each vertex
# In this exercise you will learn how to identify particular edges. You will learn how to determine if an edge exists between two vertices as well as finding all vertices connected in either direction to a given vertex.

# First make a visualization of this network using plot(). You will improve this visualization later. It can be useful to visualize the network before analysis. To improve visibility of the plot of this network, you should make the vertex size equal to 0 and the edge arrow size equal to 0.1.
# Make a basic plot
plot(g, 
     vertex.label.color = "black", 
     edge.color = 'gray77',
     vertex.size = 0,
     edge.arrow.size = 0.1,
     layout = layout_nicely(g))

# Check if there is an edge going in each direction between vertex 184 to vertex 178 using single brackets subsetting of the graph object. If a 1 is returned that indicates TRUE there is an edge. If a 0 is returned that indicates FALSE there is not an edge.
# Is there an edge going from vertex 184 to vertex 178?
url <- "https://assets.datacamp.com/production/course_4474/datasets/friends.csv"
friends <- read_csv(url)
friends.mat <- as.matrix(friends)
g <- graph.edgelist(friends.mat, directed = FALSE)
genders <- c("M", "F", "F", "M", "M", "M", "F", "M", "M", "F", "M", "F", "M", "F", "M", "M")
ages <- c(18, 19, 21, 20, 22, 18, 23, 21, 22, 20, 20, 22, 21, 18, 19, 20)

g <- set_vertex_attr(g, "gender", value = genders)
g <- set_vertex_attr(g, "age", value = ages)

g["184", "178"]

# Is there an edge going from vertex 178 to vertex 184?
g['178', '184']

# Using the function incident() identify those edges that go in either direction from vertex 184 or only those going out from vertex 184. The first argument should be the graph object, the second should be the vertex to examine and the third argument the mode indicating the direction. Choose from all, in and out
# Show all edges going to or from vertex 184
incident(g, '184', mode = c("all"))

# Show all edges going out from vertex 184
incident(g, '184', mode = c("out"))

# Part 2. Relationships between vertices
# Chapter 1. Neighbors
# Often in network analysis it is important to explore the patterning of connections that exist between vertices. One way is to identify neighboring vertices of each vertex. You can then determine which neighboring vertices are shared even by unconnected vertices indicating how two vertices may have an indirect relationship through others. In this exercise you will learn how to identify neighbors and shared neighbors between pairs of vertices.

# Instructions
# Using the function neighbors() identify the vertices that are connected in any manner to vertex 12, those vertices that direct an edge to vertex 12 and those vertices that receive a directed edge from vertex 12. This can be achieved by choosing the correct value in the argument mode. Choose from all, in and out.

# Identify all neighbors of vertex 12 regardless of direction
neighbors(g, '12', mode = c('all'))

# Identify other vertices that direct edges towards vertex 12
neighbors(g, '12', mode = c('in'))

# Determine if vertices 42 and 124 have a neighbor in common. Create a vector n1 of those vertices that receive an edge from vertex 42 and a vector n2 of those vertices that direct an edge to vertex 124 using neighbors(). Next use intersection() to identify if there are any vertices that exist in both n1 and n2.

# Identify any vertices that receive an edge from vertex 42 and direct an edge to vertex 124
n1 <- neighbors(g, '42', mode = c('out'))
n2 <- neighbors(g, '124', mode = c('in'))
intersection(n1, n2)

# Chapter 2. Distances between vertices
# The inter-connectivity of a network can be assessed by examining the number and length of paths between vertices. A path is simply the chain of connections between vertices. The number of intervening edges between two vertices represents the geodesic distance between vertices. Vertices that are connected to each other have a geodesic distance of 1. Those that share a neighbor in common but are not connected to each other have a geodesic distance of 2 and so on. In directed networks, the direction of edges can be taken into account. If two vertices cannot be reached via following directed edges they are given a geodesic distance of infinity. In this exercise you will learn how to find the longest paths between vertices in a network and how to discern those vertices that are within nn connections of a given vertex. For disease transmission networks such as the measles dataset this helps you to identify how quickly the disease spreads through the network.

# (1) Find the length of the longest path in the network using farthest_vertices().
# Which two vertices are the furthest apart in the graph ?
farthest_vertices(g) 

# (2) Identify the sequence of the path using get_diameter(). This demonstrates the individual children that passed the disease the furthest through the network.
# Shows the path sequence between two furthest apart vertices.
get_diameter(g)  

# (3) Use ego() to find all vertices that are reachable within 2 connections of vertex 42 and then those that can reach vertex 42 within two connections. The first argument of ego() is the graph object, the second argument is the maximum number of connections between the vertices, the third argument is the vertex of interest, and the fourth argument determines if you are considering connections going out or into the vertex of interest.
# Identify vertices that are reachable within two connections from vertex 42
ego(g, 2, '42', mode = c('out'))

# Identify vertices that can reach vertex 42 within two connections
ego(g, 2, '42', mode = c('in'))

# Quiz 1. Finding longest path between two vertices
# What is the longest possible path in a network referred to as? 
# The longest path in a network is the one with the most interconnections between two vertices. It is the one with the largest geodesic distance and is obtained in igraph using get_diameter().
# (1) Weight (2) Geodesic distance (3) Degree (4) Diameter 

# Part 3. Which nodes are significant in a network ?
# Chapter 1. Identifying key vertices
# Perhaps the most straightforward measure of vertex importance is the degree of a vertex. The out-degree of a vertex is the number of other individuals to which a vertex has an outgoing edge directed to. The in-degree is the number of edges received from other individuals. In the measles network, individuals that infect many other individuals will have a high out-degree. In this exercise you will identify whether indviduals infect equivalent amount of other children or if there are key children who have high out-degrees and infect many other children.

# (1) Calculate the out-degree of each vertex using the function degree(). The first argument is the network graph object and the second argument is the mode which should be one of out, in or all. Assign the output of this function to the object g.outd.
# Calculate the out-degree of each vertex
g.outd <- degree(g, mode = c("out"))

# (2) View a summary of the out-degrees of all individuals using the function table() on the vector object g.outd.
# View a summary of out-degree
table(g.outd)

# (3) Make a histogram of the out-degrees using the function hist() on the vector object g.outd.
hist(g.outd, breaks = 30)

# (4) Determine which vertex has the highest out-degree in the network using the function which.max() on the vector object g.outd
which.max(g.outd)

# Chapter 2. Betweenness
# Another measure of the importance of a given vertex is its betweenness. This is an index of how frequently the vertex lies on shortest paths between any two vertices in the network. It can be thought of as how critical the vertex is to the flow of information through a network. Individuals with high betweenness are key bridges between different parts of a network. In our measles transmission network, vertices with high betweenness are those children who were central to passing on the disease to other parts of the network. In this exercise, you will identify the betweenness score for each vertex and then make a new plot of the network adjusting the vertex size by its betweenness score to highlight these key vertices.

# (1) Calculate the betweenness of each vertex using the function betweenness() on the graph object g. Ensure that the scores are calculated for a directed network. The results of this function will be assigned as g.b.

g.b <- betweenness(g, directed = TRUE)

# (2) Visually examine the distribution of betweenness scores using the function hist()
# Show histogram of vertex betweenness
hist(g.b, breaks = 80)

# (3) Use plot() to make a plot of the network based on betweenness scores. The vertex labels should be made NA so that they do not appear. The vertex size attribute should be one plus the square-root of the betweenness scores that are in object g.b. Given the huge disparity in betweenness scores in this network, normalizing the scores in this manner ensures that all nodes can be viewed but their relative importance is still identifiable.
plot(g, 
     vertex.label = NA,
     edge.color = 'black',
     vertex.size = sqrt(g.b)+1,
     edge.arrow.size = 0.05,
     layout = layout_nicely(g))

# Chapter 3. Visualizing important nodes and edges
# One issue with the measles dataset is that there are three individuals for whom no information is known about who infected them. One of these individuals (vertex 184) appears ultimately responsible for spreading the disease to many other individuals even though they did not directly infect too many indviduals. However, because vertex 184 has no incoming edge in the network they appear to have low betweenness. One way it is possible to explore the importance of this vertex is by visualizing the geodesic distances of connections going out from this individual. In this exercise you shall create a plot of these distances from this patient zero.

# (1) Use make_ego_graph() to create a subset of our network comprised of vertices that are connected to vertex 184. The first argument is the original graph g. The second argument is the maximal number of connections that any vertex needs to be connected to our vertex of interest. In this case we can use diameter() to return the length of the longest path in the network. The third argument is our vertex of interest which should be 184. The final argument is the mode. In this instance you can include all connections regardless of direction.
# Make an ego graph
g184 <- make_ego_graph(g, diameter(g), nodes = '184', mode = c("all"))[[1]]

# (2) Create an object dists that contains the geodesic distance of every vertex from vertex 184. Use the function distances() to calculate this.
# Get a vector of geodesic distances of all vertices from vertex 184 
dists <- distances(g184, "184")

# (3) Assign the attribute color to each vertex. Each color will be selected based on its geodesic distance. The color palette colors is a length equal to the maximal geodesic distance plus one. This is so that vertices of the same distance are plotted in the same color and patient zero also has its own color.
# Create a color palette of length equal to the maximal geodesic distance plus one.
colors <- c("black", "red", "orange", "blue", "dodgerblue", "cyan")

# Set color attribute to vertices of network g184.
V(g184)$color <- colors[dists+1]

# (4) Use plot() to visualize the network g184. The vertex label should be the geodesic distances dists.
# Visualize the network based on geodesic distance from vertex 184 (patient zero).
plot(g184, 
     vertex.label = dists, 
     vertex.label.color = "white",
     vertex.label.cex = .6,
     edge.color = 'black',
     vertex.size = 7,
     edge.arrow.size = .05,
     main = "Geodesic Distances from Patient Zero"
)

# Quiz, Which measure of a vertex importance is determined by how often that vertex lies on the shortest path between any two vertices in a network? 
# Hint, Vertices that lie between many vertices on shortest paths are considered to be influential.
