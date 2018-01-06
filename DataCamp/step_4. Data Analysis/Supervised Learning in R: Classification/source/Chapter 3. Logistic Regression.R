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
# In the previous exercise, you found that the logistic regression model made a correct prediction nearly 80% of the time. Despite this relatively high accuracy, the result is misleading due to the rarity of outcome being predicted.

# The donors dataset is available in your workspace. What would the accuracy have been if a model had simply predicted "no donation" for each person?
# Possible Answers
# 80%, 85%, 90%, 95%
# Correct! With an accuracy of only 80%, the model is actually performing WORSE than if it were to predict non-donor for every record.

# Chapter 4. Calculating ROC Curves and AUC
# The previous exercises have demonstrated that accuracy is a very misleading measure of model performance on imbalanced datasets. Graphing the model's performance better illustrates the tradeoff between a model that is overly agressive and one that is overly passive.
# In this exercise you will create a ROC curve and compute the area under the curve (AUC) to evaluate the logistic regression model of donations you built earlier.

# Instruction
# Create a ROC curve with roc() and the columns of actual and predicted donations. Store the result as ROC.
# Create a ROC curve
library(pROC)
ROC <- roc(donors$donated, donors$donation_pred)

# Use plot() to draw the ROC object. Specify col = "blue" to color the curve blue.
# Plot the ROC Curve
plot(ROC, col = "blue")

# Calculate the area under the curve(AUC)
auc(ROC)

# Awesome job! Based on this visualization, the model isn't doing much better than baseline— a model doing nothing but making predictions at random.

# Let's compare, A_model is AUC = 0.55, B_model is AUC = 0.59, AUC = 0.62
# which of the following models illustrates the best model?
# The answer is, we need more information. 

# Part 3. Dummy variables, missing data, and interactions
# Dummy Coding categorical data
# The most common method for handling factor data for logistic regresison

# ch.1, Dummy Coding
# Create gender factor
# factor(factor_col, levles = c(0,1,2,...), labels = c("A", "B", "C",...))

# ch.2, Imputing Missing data
# For numeric data, average (simple strategy) but not recommended

# ch.3, Interactions
# glm(disease ~ obseity * smoking, data = health, family = "binomial")

# Chapter 1. Coding categorical features
# Sometimes a dataset contains numeric values that represent a categorical feature.

# In the donors dataset, wealth_rating uses numbers to indicate the donor's wealth level:
# 0 = Unknown
# 1 = Low
# 2 = Medium
# 3 = High

# This exercise illustrates how to prepare this type of categorical feature and the examines its impact on a logistic regression model.

# The dataframe donors is loaded in your workspace.
# Create a factor from the numeric wealth_rating with labels as shown above by passing the factor() function the column you want to convert, the individual levels, and the labels.
# Convert the wealth rating to a factor
glimpse(donors$wealth_rating)
donors$wealth_rating <- factor(donors$wealth_rating, levels = c(0,1,2,3), labels = c("Unknown", "Low", "Medium", "High"))

# relevel() takes the factor variable and the new reference level as a string.
# Use relevel() to change reference category
donors$wealth_rating <- relevel(donors$wealth_rating, ref = "Medium")

# Nest a call to glm() inside summary().
summary(glm(donated ~ wealth_rating, data = donors, family = "binomial"))

# Chapter 2. Handling missing data

# Use ifelse() and the test is.na(donor$age) to impute the average (rounded to 2 decimal places) for cases with missing age.
round(mean(donors$age, na.rm = T), digits = 2)
# Impute missing age values with mean(age)
donors$imputed_age <- ifelse(is.na(donors$age), round(mean(donors$age, na.rm = T), digits = 2), donors$age)

# Create a binary dummy variable named missing_age indicating the presence of missing data using another ifelse() call and the same test.
# Create missing value indicator for age
donors$missing_age <- ifelse(is.na(donors$age), "missing_age", donors$age)

# Super! This is one way to handle missing data, but be careful! Sometimes missing data has to be dealt with using more complicated methods.
