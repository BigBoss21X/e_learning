# Part 1. Classification with Nearest Neighbors
# Chapter 1. Recognizing a road sign with kNN
  ## The dataset signs is loaded in your workspace along with the dataframe next_sign, which holds the observation you want to classify.

# Load the class package.
library(class)

url <- "https://assets.datacamp.com/production/course_2906/datasets/knn_traffic_signs.csv"

signs <- read.csv(url)
write.csv(signs, file = "signs", row.names = F)
signs <- signs[, -c(1:2)]

# get sample
next_sign <- signs[sample(NROW(signs), 1), ]
next_sign <- next_sign[, -1]

str(signs)

# Create a vector of labels
  ## Create a vector of sign labels to use with kNN by extracting the column sign_type from signs.
sign_types <- signs$sign_type

# Classify the next sign observed
  ## Identify the next_sign using the knn() function.
  ## Set the train argument equal to the signs data frame without the first column.
  ## Set the test argument equal to the data frame next_sign.
  ## Use the vector of labels you created as the cl argument.
knn(train = signs[-1], test = next_sign, cl = sign_types)

# Chapter 2. Thinking like kNN
# with your help, the test car successfully identified the sign and stopped safely at the intersection. 
# How did the knn() function correctly classify the stop sign?
# Possible Answers
# It learned that stop signs are red
# The sign was in some way similar to another stop sign
# Stop signs have eight sides
# The other types of signs were less likely

# Chapter 3. Exploring the traffic sign dataset
# Instructions
  ## Use str() function to examine the signs dataset
str(signs)

  ## Use table() to count the number of observations of each sign type by passing it the column containing the labels
table(signs$sign_type)

  ## Run the provided aggregate() command to see whether the average red level might vary by sign type
attach(signs)
aggregate(r10 ~ sign_type, data = signs, mean)
detach(signs)

  ## Great Work! As you might expected, stop signs tend to have a higher average red value. This is how kNN identifies similar signs. 

# Chapter 4. Classifying a collection of road signs
signs <- read.csv("data/signs")
sign_types <- signs$sign_type

# get test_signs
test_signs <- signs[sample(NROW(signs), 59), ]
str(signs); str(test_signs)

signs_actual <- test_signs$sign_type

## Classify the test_signs data using knn(). 
  # 1. Set train equal to the observations in signs without lables. 
  # 2. Use test_signs for the test argument, again without labels.  
  # 3. For the cl argument, use the vector of labels provided for you. 
## Use kNN to identify the test road signs
signs_pred <- knn(train = signs[-1], test = test_signs[-1], cl = sign_types)

## Use table() to explore the classifier's performance at identifying the three sign types. 
  # Create the vector signs_actual by extracting the labels from test_signs
  # Pass the vector of predictions and the vector of actual signs to table() to cross tabulate them. 
table(signs_actual, signs_pred)

## Compute the overall accuracy of the kNN learner using the mean() function

mean(signs_actual == signs_pred)

# Fantastic! That self-driving car is really coming along! The confusion matrix lets you look for patterns in the classifier's errors.

# Part 2. What about the 'k' in kNN?
# Chapter 5. Understanding the impact of 'k'
# There is a complex relationship between k and classification accuracy. Bigger is not always better. Which of these is a valid reason for keeping k as small as possible(but no smaller)?
# Possible Answers
## A smaller k requires less processing power
## A smaller k reduces the impact of noisy data
  # --> A smaller k actually increases the impact of noisy data
## A smaller k minimizes the chance of a tie vote
## A smaller k may utilize more subtle patterns

## The answer is A smaller k may utilize more subtle patterns. With smaller neighborhoods, kNN can identify more subtle patterns in the data. 

# Chapter 6. Testing other 'k' values
  ## By default, the knn() function in the class package uses only the single nearest neighbor. 
  ## Setting a k parameter allows the algorithm to consider additional nearby neighbors. This enlarges the collection of neighbors which will vote on the predicted class. 
  ## Compare k values of 1, 7, and 15 to examine the impact on traffic sign classfication accuracy. 

# Instructions
  ## The class package is already loaded in your workspace along with the datasets signs and signs_test. The object signs_actual holds the true values of the signs. 
  # 1. Compute the accuracy of the default k = 1, model using the given code
signs <- read.csv("data/signs")
signs_types <- signs$sign_type
signs_test <- signs[sample(NROW(signs), 59), ]

signs_actual <- signs_test$sign_type

k_1 <- knn(train = signs[-1], test = signs_test[-1], cl = signs_types)
mean(signs_actual == k_1)

k_7 <- knn(train = signs[-1], test = signs_test[-1], cl = signs_types, k = 7)
mean(signs_actual == k_7)

k_15 <- knn(train = signs[-1], test = signs_test[-1], cl = signs_types, k = 7)
mean(signs_actual == k_15)

# Chapter 7. Seeing how the neighbors voted. 
  ## When multiple nearest neighbors hold a vote, it can sometimes be useful to examine whether the voters were unanimous or widely seperated. 
  ## For example, knowing more about the voters' confidence in the classification could allow an autonomous vehicle to use caution in the case there is any chance at all that a stop sign is ahead. 
  ## In this exercise, you will learn how to obtain the voting results from the knn() function. 

# Instructions
# The class package has already been loaded in your workspace along with the dataset signs. 
  ## Build a kNN model with the prob = TRUE parameter to compute the vote proportions. Set k = 7
  ## Use the prob parameter to get the proportion of votes for the winning class
signs <- read.csv("data/signs")
sign_types <- signs$sign_type
signs_test <- signs[sample(NROW(signs), 59), ]

sign_actual <- signs_test$sign_type

sign_pred <- knn(train = signs[-1], test = signs_test[-1], cl = sign_types, prob = TRUE, k = 7)

  ## Use the attr() function to obtain the vote proportions for the predicted class. These are stored in the attribute "prob"
  ## Get the "prob" attribute from the predicted classes
sign_prob <- attr(sign_pred, "prob")

  ## Examine the first several vote outcomes and percentages using the head() function to see how the confidence varies from sign to sign. 
head(sign_pred)
head(sign_prob)

# Part 3. Data prepration for kNN
# Chapter 8. Why normalize data?
  ## Before applying kNN to a classification task, it is common practice to rescale the data using a technique like min-max normalization. What is the purpose of this step?
  ## Possible Answers
# To ensure all data elements may contribute equal shares to distance
# To help the kNN algorithm converge on a solution faster.
# To convert all of the data elements to numbers
# To redistribute the data as a normal bell curve

## Normalization is to ensure all data elements may contribute equal shares to distance, "Rescaling" reduces the influence of extremen values on kNN's distance function. 

# Normalizing data in R
## No built-in function
## define a min-max normalize() function
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

# normalized version of r1
summary(normalize(signs$r1))

# un-normalized version of r1
summary(signs$r1)
