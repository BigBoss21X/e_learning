# Estimating Probability
# The Probability of A is denoted P(A)
# home 10, restaurant 3, work 23, store 4
# P(work) = 23 / 40 = 57.5%
# P(store) = 4 / 40 = 10.0%

# Joint Probability with Independent Events & Conditional Probability with Dependent Events

# Making Predictions with Naive Bayes
# install.packages("naivebayes")
library(naivebayes)
library(tidyverse)

# building a Naive Bayes Model
url <- "https://assets.datacamp.com/production/course_2906/datasets/locations.csv"

location <- read.csv(url)
glimpse(location)

where9am <- location %>% 
  filter(hour == 9) %>% 
  select(daytype, location) 

# Chapter 1. Computing Probabilities
# The where9am data frame contains 91 days (thirteen weeks) worth of data in which Brett recorded his location at 9am each day as well as whether the daytype was a weekend or weekday. 

# Using the conditional probability formula below, you can compute the probability that Brett is working in the office, given that it is a weekday. 

# P(A|B) = P(A and B) / P(B)

# Calculations like these are the basic of the Naive Bayes destination prediction model you'll develop in later exercise.

# Find P(office) using nrow and subset() to count rows in the dataset and save the result as p_A
glimpse(where9am)
?subset
# Compute P(A)
p_A <- nrow(subset(where9am, location == "office")) / nrow(where9am)

# Find P(weekday), using nrow() and subset() again, save the result as p_B
p_B <- nrow(subset(where9am, daytype == "weekday")) / nrow(where9am)

# Use nrow() and subset() a final time to find P(office and weekday). Save the result as p_AB
p_AB <- nrow(subset(where9am, location == "office" & daytype == "weekday")) / nrow(where9am)

# Compute P(Office | weekday) and save the result as p_A_given_B
p_A_given_B <- p_AB / p_B

# Chapter 2. Understanding dependent events
# In the previous exercise, you found that there is a 55% chance Brett is in the office at 9am given that it is a weekday. On the other hand, if Brett is never in the office on a weekend, which of the following is/are true?

# Possible Answers 
# P(office and weekend) = 0.
# P(office | weekend) = 0.
# Brett's location is dependent on the day of the week. 
# All of the above. 

# Chapter 3. A simple Naive Bayes location model
# The previous exercises showed that the probability that Brett is at work or at home at 9am is highly dependent on whether it is the weekend or a weekday. 
# To see this finding in action, use the where9am data frame to build a Naive Bayes model on the same data. 
# You can then use this model to predict the future: where does the model think that Brett will be at 9am on Thursday and at 9am on Saturday? 

# Instructions
# The dataframe where9am is available in your workspace. This dataset contains information about Brett's location at 9am on different days. 

# Load naivebayes package. 
library(naivebayes)

# Use naive_bayes() with a formula like y ~ x to build a model of location as a function of daytype. 
# Build the location prediction model
where9am
locmodel <- naive_bayes(location ~ daytype, data = where9am)

# Forecast the Thursday 9am location using predict() with the thursday9am object as newdata argument. 
# Predict Thursday's 9am location
thursday9am <- data.frame(daytype = "weekday")
predict(locmodel, thursday9am)

# Do the same for predicting the saturday9am location.
# Predict Saturdays's 9am location
saturday9am <- data.frame(daytype = "weekend")
predict(locmodel, saturday9am)

# Chapter 4. 
