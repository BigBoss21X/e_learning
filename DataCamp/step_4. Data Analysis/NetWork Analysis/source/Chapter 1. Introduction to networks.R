# Chapter 1. Creating an igraph object
# Here you will learn how to create an igraph 'object' from data stored in an edgelist. The data are friendships in a group of students. You will also learn how to make a basic visualization of the network.

# Each row of the friends dataframe represents an edge in the network.

# INSTRUCTIONS
library(igraph)
library(readr)
url <- "https://assets.datacamp.com/production/course_4474/datasets/friends.csv"
friends <- read_csv(url)

# (1) Inspect the first few rows of the dataframe friends using the function head().
# Inspect the first few rows of the dataframe 'friends'
head(friends)

# (2) Create new object friends.mat from the dataframe friends using as.matrix().
# Convert friends dataframe to a matrix
friends.mat <- as.matrix(friends)

# (3) Convert variable to an igraph object g using graph.edgelist().
# Convert friends matrix to an igraph object
g <- graph.edgelist(friends.mat, directed = FALSE)

# (4) Make a basic plot of the network using plot().
# Make a very basic plot of the network
plot(g)

# Chapter 2. Counting vertices and edges
# A lot of basic information about a network can be extracted from an igraph object. In this exercise you will learn how to count the vertices and edges from a network by applying several functions to the graph object g.

# Each row of the friends dataframe represents an edge in the network.
# (1) Use V() and E() to view the vertices and edges respectively of the network.
# Subset vertices and edges
V(g)
E(g)

# (2) Use gsize() to count the number of edges in a network.
# Count number of edges
gsize(g)

# (3) Use gorder() to count the number of vertices in a network.
# Count number of vertices
gorder(g)

# Chapter 3. Node attributes and subsetting
# In this exercise you will learn how to add attributes to vertices in the network and view them.
genders <- c("M", "F", "F", "M", "M", "M", "F", "M", "M", "F", "M", "F", "M", "F", "M", "M")
ages <- c(18, 19, 21, 20, 22, 18, 23, 21, 22, 20, 20, 22, 21, 18, 19, 20)

# (1) Create a new vertex attribute called 'gender' from the vector genders using set_vertex_attr().
g <- set_vertex_attr(g, "gender", value = genders)

# (2) Create a new vertex attribute called 'age' from the vector ages using set_vertex_attr().
g <- set_vertex_attr(g, "age", value = ages)

# (3) View all vertex attributes using vertex_attr().
vertex_attr(g)


# (4) View the attributes of the first five vertices in a dataframe using V(g)[[]].
V(g)[[1:5]]

# Chapter 4. Edge attributes and subsetting
# In this exercise you will learn how to add attributes to edges in the network and view them. For instance, we will add the attribute 'hours' that represents how many hours per week each pair of friends spend with each other.
hours <- c(1, 2, 2, 1, 2, 5, 5, 1, 1, 3, 2, 1, 1, 5, 1, 2, 4, 1, 3, 1, 1, 1, 4, 1, 3, 3, 4)

# (1) Create a new edge attribute called 'hours' from the vector hours using set_edge_attr().
# Create new edge attribute called 'hours'
g <- set_edge_attr(g, "hours", value = hours)

# (2) View all edge attributes using edge_attr().
# View edge attributes of graph object
edge_attr(g)

# (3) View all edges that include the person "Britt".
# Find all edges that include "Britt"
E(g)[[inc('Britt')]]  

# (4) View all edges where the attribute hours is greater than or equal to 4 hours.
# Find all pairs that spend 4 or more hours together per week
E(g)[[hours >= 4]]

# Chapter 5. Visualizing attributes
# In this exercise we will learn how to create igraph objects with attributes directly from dataframes and how to visualize attributes in plots. We will use a second network of friendship connections between students.

# (1) Create a new igraph object with graph_from_data_frame(). Two dataframes need to be provided - friends1_edges contains all edges in the network with attributes and friends1_nodes contains all vertices in the network with attributes.
url2 <- "https://assets.datacamp.com/production/course_4474/datasets/friends1_edges.csv"
friends1_edges <- read_csv(url2)

url3 <- "https://assets.datacamp.com/production/course_4474/datasets/friends1_nodes.csv"
friends1_nodes <- read_csv(url3)

g1 <- graph_from_data_frame(d = friends1_edges, vertices = friends1_nodes, directed = FALSE)

# (2) View all edges where the attribute hours is greater than or equal to 5 hours.
# Subset edges greater than or equal to 5 hours
E(g1)[[hours >= 5]]  

# (3) Create a new vertex attribute containing color names: orange for females and dodgerblue for males.
V(g1)$color <- ifelse(V(g1)$gender == "F", "orange", "dodgerblue")

# (4) Plot the network with vertices colored by gender and make label names black.
plot(g1, vertex.label.color = "black")

# Quiz 1. What term is typically used to describe the relative strength of edges?
# Possible Answers: Distance, Weight, Direction, Length
# The answer is (Weight)

# Chapter 6. igraph network layouts
# The igraph package provides several built in layout algorithms for network visualization. Depending upon the size of a given network different layouts may be more effective in communicating the structure of the network. Ideally the best layout is the one that minimizes the number of edges that cross each other in the network. In this exercise you will explore just a few of the many default layout algorithms. Re-executing the code for each plot will lead to a slightly different version of the same layout type. Doing this a few times can help to find the best looking visualization for your network.

# INSTRUCTIONS

# (1) In the plot function, change the layout argument to layout_in_circle() to produce a circle network.
# Plot the graph object g1 in a circle layout
plot(g1, vertex.label.color = "black", layout = layout_in_circle(g1))

# (2) In the plot function, change the layout argument to layout_with_fr() to produce a network with the Fruchterman-Reingold layout.
# Plot the graph object g1 in a Fruchterman-Reingold layout 
plot(g1, vertex.label.color = "black", layout = layout_with_fr(g1))

# (3) You can also stipulate the layout by providing a matrix of (x, y) coordinates for each vertex. Here you use the layout_as_tree() function to generate the matrix m of coordinates. Then pass m to the layout function in plot() to plot.
# Plot the graph object g1 in a Tree layout 
m <- layout_as_tree(g1)
plot(g1, vertex.label.color = "black", layout = m)

# (4) Choosing a correct layout can be bewildering. Fortunately igraph has a function layout_nicely() that tries to choose the most appropriate layout function for a given graph object. Use this function to produce the matrix m1 and plot the network using these coordinates.
m1 <- layout_nicely(g1)
plot(g1, vertex.label.color = "black", layout = m1)

# Chapter 7. Visualizing edges
# In this exercise you will learn how to change the size of edges in a network based on their weight, as well as how to remove edges from a network which can sometimes be helpful in more effectively visualizing large and highly clustered networks. In this introductory chapter, we have just scratched the surface of what's possible in visualizing igraph networks. You will continue to develop these skills in future chapters.

# INSTRUCTIONS

# (1) Create a vector w1 of edge weights based on the number of hours friends spend together.
vertex_attr(g1)
w1 <- E(g1)$hours

# (2)Plot the network ensuring that the edge.width is set to the vector of weights you just created. Using edge.color = 'black' ensures that all edges will be black.
m1 <- layout_nicely(g1)
plot(g1, 
     vertex.label.color = "black", 
     edge.color = 'black',
     edge.width = w1,
     layout = m1)

# (3) Next, create a new graph object g2 that is the g1 network but with all edges of that are of weight less than two hours removed. This is done by using delete_edges() which takes two arguments. The first is the graph object and the second is the subset of edges to be removed. In this case, you will remove any edges that have a value of less than two hours.
g2 <- delete_edges(g1, E(g1)[hours < 2])

# (4) Finally, plot the new network g2 using the appropriate vector of edge widths and layout.
# Plot the new graph 
w2 <- E(g2)$hours
m2 <- layout_nicely(g2)

plot(g2, 
     vertex.label.color = "black", 
     edge.color = 'black',
     edge.width = w2,
     layout = m2)

# Quiz on igraph objects
E(g1)[[inc("Jasmine")]]
