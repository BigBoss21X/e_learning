# Data import & library loaded
library(tidyverse)
library(readr)

url <- "https://assets.datacamp.com/production/course_2906/datasets/donors.csv"

donors <- read_csv(url)
glimpse(donors)

donors <- donors %>% mutate_if(is.character, as.factor)
glimpse(donors)
levels(donors$recency)
levels(donors$frequency)
levels(donors$money)

# Chapter 1. Building simple logistic regression models
# The donors dataset contains 93,462 examples of people mailed in a fundraising solicitation for paralzed military veterans. The donated column is 1 if the person made a donation in response to the mailing and 0 otherwise. This binary outcome will be the dependent variable for the logistic regression model. 

# The remaining columns are features of the prospective donors that may influence their donation behavior. These are the model's independent variables. 

# When building a regression model, it is often helpful to form a hypothesis about which independent variables will be predictive of the dependent variable. The bad_address column, which is set to 1 for an invalid mailing address and 0 otherwise, seems like it might reduce the chances of a donation. Similarly, one might suspect that religious intersect(interest_religion) and interest in veterans affairs(interest_veterans) would be associated with greater charitable giving. 

# in this exercise, you will use these three factors to create a simple model of donation behavior. 

# Examine donors using the str() function. 
# Examine the dataset to identify potential independent variables
str(donors)

# Count the number of occurrences of each level of the donated variable using the table() function. 
table(donors$donated)

# Fit a logistic regression model using the formula interface and the three independent variables described above. 
  ## Call glm() with the formula as its first argument and the dataframe as the data argument. 
  ## Save the result as donation_model. 
donation_model <- glm(donated ~ bad_address + interest_religion + interest_veterans, data = donors, family = "binomial")

# Summarize the model results
summary(donation_model)

# Chapter 2. Making a binary prediction
# In the previous exercise, you used the glm() function to build a logistic regression model of donor behavior. As with many of R's machine learning methods, you can apply the predict() function to the model object to forecast future behavior. By default, predict() outputs predicions in terms of log odds unless type = "response" is specified. This converts the log odds to probabilities. 

# Because a logistic regression model estimates the probability of the outcome, it is up to you to determine the threshold at which the probability implies action. One must balance the extremes of being too cautious versus being too aggressive. For example, if you were to solicit only the people with a 99% or greater donation probability, you may miss out on many people with lower estimated probabilities that still choose to donate. This balance is particularly important to consider for severely imbalanced outcomes, such as in this dataset where donations are relatively rare. 

# Instructions
# Use the predict() function to estimate each person's donation probability. Use the type argument to get probabilities. Assign the predictions to a new column called donation_prob.
# Estimate the donation probability
donors$donation_prob <- predict(donation_model, type = "response")

# Find the actual probability that an average person would donate by passing the mean() function a column of the dataframe.
# Find the donation probability of the average prospect
mean(donors$donated)

# Use ifelse() to predict a donation if their predicted donation probability is greater than average. Assign the predictions to a new column called donation_pred.
# Predict a donation if probability of donation is greater than average (0.0504)
donors$donation_pred <- ifelse(donors$donation_prob > 0.0504, 1, 0)

# Use the mean() function to calculate the model's accuracy.
mean(donors$donated == donors$donation_pred)

# But, with an accuracy of nearly 80%, the model seems to be doing its job. But, is it too good to be true?

# Chapter 3. The limitations of accuracy. 
