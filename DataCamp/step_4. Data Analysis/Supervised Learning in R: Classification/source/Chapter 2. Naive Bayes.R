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

locations <- read.csv(url)
glimpse(locations)

where9am <- locations %>% 
  filter(hour == 9) %>% 
  select(daytype, weekday, location) 

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
table(where9am)

where9am$location <- factor(where9am$location, 
                            labels = c("appointment", "campus", "home", "office"))

locmodel <- naive_bayes(location ~ daytype, data = where9am)


thursday9am <- where9am %>% 
  filter(weekday == "thursday") %>% 
  select(daytype) %>% head(n = 1)

saturday9am <- locations %>% 
  filter(weekday == "saturday") %>% 
  select(daytype) %>% head(n = 1)

# Forecast the Thursday 9am location using predict() with the thursday9am object as newdata argument. 
# Predict Thursday's 9am location
predict(locmodel, thursday9am)

# Do the same for predicting the saturday9am location.
# Predict Saturdays's 9am location
predict(locmodel, saturday9am)

# Chapter 4. Examining "raw" probabilities
# The naivebayes package offers several ways to peek inside a Naive Bayes model.
# Typing the name of the model object provides the a priori (overall) and conditional probabilities of each of the model's predictors. If one were so inclined, you might use these for calculating posterior (predicted) probabilities by hand.
# Alternatively, R will compute the posterior probabilities for you if the type = "prob" parameter is supplied to the predict() function.
# Using these methods, examine how the model's predicted 9am location probability varies from day-to-day.

# Instructions
# The model locmodel that you fit in the previous exercise is in your workspace. 

# Print the locmodel object to the console to view the computed a priori and conditional probabilties
# Examine the location prediction model
locmodel

# Use the predict() function similarly to the previous exercise, but with type = "prob" to see the predicted probabilities for Thursday at 9am. 
# Obtain the predicted probabilties for Thursday at 9am
predict(locmodel, thursday9am, type = "prob")

# Compare these to the predicted probabilities for Saturday at 9am.
# Obtain the predicted probabilities for Saturday at 9am
# saturday9am data frame's structure is a bit different. 
predict(locmodel, saturday9am, type = "prob")

# Chapter 5. Understanding independence
# Understanding the idea of event independence will become important as you learn more about how "naive" Bayes got its name. Which of the following is true about independent events?

# Possible Answers
# The events cannot occur at the same time. 
# -> If I flip a coin two times in a row, both flips are independent. 

# A Venn diagram will always show no intersection. 
# -> The Venn diagram shows an intersection if the events can occur together. But, this doesn't mean they're dependent.

# Knowing the outcome of one event does not help predict the other. 
# -> Yes! One event is independent of another if knowing one doesen't give you information about how likely the other is. For example, knowing if it's raining in New York doesn't help you predict the weather in San Francisco. The weather events in the two cities are independent of each other. 

# At least one of the events is completely random. 
# -> All of the events you're learning about are random to a certain extent. 

# The answer is (3). 

# Chapter 6. Who are you calling naive?
# The Naive Bayes algorithm got its name because it makes a "naive" assumption about event independence. 
# What is the purpose of making this assumption? 
# Possible Answers
# Independent events can never have a joint probability of zero. 
  # -> Independent events CAN have a joint probability of zero if they cannot occur together. 

# The joint probability calculation is simpler for independent events. 
  # -> Yes! The joint probability of independent events can be computed much more simply by multiplying their individual probabilities. 

# Conditional probability is undefined for dependent events. 
  # -> Conditional Probability is required for understanding event dependency. 

# Dependent events cannot be used to make predictions. 
  # ->  Dependent events are in fact very important for making predictions

# Chapter 7. A more sophisticated location model
# The locations dataset records Brett's location every hour for 13 weeks. Each hour, the tracking information includes the daytype (weekend or weekday) as well as the hourtype (morning, afternoon, evening, or night). 
# Using this data, build a more sophisticated model to see how Brett's predicted location not only varies by the day of week but also by the time of day. 

# Instructions
# The dataset locations is already loaded in your workspace. 
# Use the R formula interface to build a model where location depends on both daytype and hourtype. Recall that the function naive_bayes() takes 2 arguments: formula and data

# Build a NB model of location
locmodel <- naive_bayes(location ~ daytype + hourtype, data = locations)

glimpse(locations)
head(locations)

weekday_afternoon <- locations %>% 
  filter(daytype == "weekday" & hourtype == "afternoon") %>% 
  select(daytype, hourtype) %>% 
  head(n = 1)

weekday_evening <- locations %>% 
  filter(daytype == "weekday" & hourtype == "evening") %>% 
  select(daytype, hourtype) %>% 
  head(n = 1)

weekend_afternoon <- locations %>% 
  filter(daytype == "weekend" & hourtype == "afternoon") %>% 
  select(daytype, hourtype) %>% 
  head(n = 1)

# Predict Brett's location on a weekday afternoon using the dataframe weekday_afternoon and the predict() function.
# Predict Brett's location on a weekday afternoon
predict(locmodel, newdata = weekday_afternoon)

# Do the same for a weekday_evening.
# Predict Brett's location on a weekday evening

predict(locmodel, newdata = weekday_evening)

# Chapter 8. Preparing for unforeseen circumstances
# While Brett was tracking his location over 13 weeks, he never went into the office during the weekend. Consequently, the joint probability of P(office and weekend) = 0.

# Explore how this impacts the predicted probability that Brett may go to work on the weekend in the future. Additionally, you can see how using the Laplace correction will allow a small chance for these types of unforeseen circumstances.

# The "naivebayes" package is loaded into the workspace already
# The Naive Bayes location model(locmodel) has already been built. 
# The model locmodel is already in your workspace, along with the dataframe weekend_afternoon.

# Use the locmodel to output predicted probabilities for a weekend afternoon by using the predict() function. Remember to set the type argument. 
# Observe the predicted probabilities for a weekend afternoon
predict(locmodel, newdata = weekend_afternoon, type = "prob")

# Create a new naive Bayes model with the Laplace smoothing parameter set to 1. You can do this by setting the laplace argument in your call to naive_bayes(). Save this as locmodel2
locmodel2 <- naive_bayes(location ~ daytype + hourtype, data = locations, laplace = 1)

# See how the new predicted probabilities compare by using the predict() function on your new model.
# Observe the new predicted probabilities for a weekend
predict(locmodel2, newdata = weekend_afternoon, type = "prob")
# Adding the Laplace correction allows for the small chance that Brett might go to the office on the weekend in the future.

# Chapter 9. Understanding the Laplace correction
# By default, the naive_bayes() function in the naivebayes package does not use the Laplace correction. What is the risk of leaving this parameter unset?
# Possible Answers 
# (1) Some potential outcomes may be predicted to be impossible. 
  # -> The small probability added to every outcome ensures that they are all possible even if never previously observed. 

# (2) The algorithm may have a divide by zero error. 
  # -> A probabiltity of zero dosen't cause this error. 

# (3) Naive Bayes will ignore features with zero values. 
  # -> Naive Bayes does not actually exclude the zero values. 

# (4) The model may not estimate probabilities for some cases. 
  # -> The model will still estimate a probabiltiy for all cases. 

# Chapter 10. Handling Numeric Predictors
# Numeric data is often binned before it is used with Naive Bayes. Which of these is not an example of bining?
# Ex) Age values recorded as "child" or "adult" categories
# Ex) geographic coordinates recoded into geographic regions (West, East, etc.)
# Ex) test scores divided into four groups by percentile. 
