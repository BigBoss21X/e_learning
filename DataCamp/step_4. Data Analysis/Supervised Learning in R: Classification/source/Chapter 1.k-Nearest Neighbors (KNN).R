# Chapter 1. Recognizing a road sign with kNN
  ## The dataset signs is loaded in your workspace along with the dataframe next_sign, which holds the observation you want to classify.

# Load the class package.
library(class)

url <- "https://assets.datacamp.com/production/course_2906/datasets/knn_traffic_signs.csv"

signs <- read.csv(url)
signs <- signs[, -c(1:2)]

# get sample
next_sign <- signs[sample(NROW(signs), 1), ]
next_sign <- next_sign[, -1]

str(signs)

# Create a vector of labels
# Create a vector of sign labels to use with kNN by extracting the column sign_type from signs.
sign_types <- signs$sign_type

# Classify the next sign observed
# Identify the next_sign using the knn() function.
# Set the train argument equal to the signs data frame without the first column.
# Set the test argument equal to the data frame next_sign.
# Use the vector of labels you created as the cl argument.
knn(train = signs[-1], test = next_sign, cl = sign_types)

# Chapter 2. Thinking like kNN
# with your help, the test car successfully identified the sign and stopped safely at the intersection. 
# How did the knn() function correctly classify the stop sign?

