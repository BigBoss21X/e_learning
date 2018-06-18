#### Quiz Application of Survival Analysis ####
# Which of the following is a question that can be answered with survival analysis?
# Possible Answers 
# (1) Will a customer who just entered the website for the first time buy a specific product within two weeks or not?
# (2) Do the average shopping cart values differ between female and male customers?
# (3) After ordering for the first time in an online shop, when do customers place their second order?
# (4) Can the return rate be decreased by adding some chocolate to the parcel?

# The answer is, (3) After ordering for the first time in an online shop, when do customers place their second order? 
# Very good! In this case, you would model the time until the event of placing another order. 

#### Chapter 1. Data for survival analysis ####
# In the following exercises you are going to work with data about customers of an online shop in order to practice survival analysis. But now it's not about the time until churn, but about the time until the second order.

# The data is stored in the object dataNextOrder. The variable boughtAgain takes the value 0 for customers with only one order and 1 for customers who have placed a second order already. If a person has ordered a second time, you see the number of days between the first and second order in the variable daysSinceFirstPurch. For customers without a second order, daysSinceFirstPurch contains the time since their first (and most recent) order.

# The ggplot2 package is already loaded to your workspace.

# Instructions 
dataNextOrder <- "https://assets.datacamp.com/production/course_6027/datasets/survivalDataExercise.csv"

library(tidyverse)
dataNextOrder <- read_csv(dataNextOrder)

# Take a look at the data using head()
head(dataNextOrder)

# Plot a histogram of the days since the first purchase separately for customers with vs. without a second order. (If you're not used to ggplot2 code, don't worry: You just have to use the daysSinceFirstPurch as x variable and boughtAgain as fill and facet variable.)

ggplot(dataNextOrder) + 
  geom_histogram(aes(x = daysSinceFirstPurch, fill = factor(boughtAgain))) + 
  facet_grid(~ boughtAgain) + # Separate plots for boughtAgain = 1 vs. 0
  theme(legend.position = "none") # Don't show legend

# Well done! You already see that there are more customers in the data who bought a second time. Apart from that, the differences between the distributions are not very large.

#### Quiz Characteristics of Survival Analysis ####
# Which of the following is a characteristic of survival analysis?
# Possible Answers 
# (1) Survival analysis deals with censored data by treating them like missing data.
# (2) Survival analysis works only if the "time under observation" is the same for all observations.
# (3) Survival analysis requires that the period under observation started at the same point for all observations. 
# (4) Survival analysis is suited for situations where for some observations an event has not yet happened, but may happen at some point in time.

# The answer is, (4) Survival analysis is suited for situations where for some observations an event has not yet happened, but may happen at some point in time.

# In survival analysis, each observation has one of two states: either an event occured, or it didn't occur. But you don't know if it occurs tomorrow or in three years.

#### Quiz Survival function, hazard function and hazard rate ####
# One of the following statement is wrong. Which one?
# Possible Answers
# (1) The survival function describes the proportion of observations who are still alive (or, for example, in a customer relationship, the proportion of customers who haven't churned yet), depending on their time under observation.
# (2) The hazard rate describes the risk that an event occurs within a very small period of time (provided that it hasn't occured yet).
# (3) The longer the time under observation, the higher the hazard rate becomes, i.e., the risk that an event occurs increases.
# (4) The cumulative hazard function describes the cumulative risk until time t.

# The answer is (3), the longer the time under observation, the higher the hazard rate becomes, i.e., the risk that an event occurs increases. 
# Very good, you identified the wrong statement! The hazard rate can go up and down. For example, customers could be very likely to churn at the beginning of their customer relationship, then become less likely for some months, and then become more likely again due to a saturation effect.

#### Chapter 2. The survival object ####
# Before you start any survival analysis, you need to transform your data into the right form, the survival object. Remember: daysSinceFirstPurch contains the time between first and second order. boughtAgain tells you if there was a second order or not.

# The survival package is already loaded to your workspace.

# Instructions 
# Create a survival object from dataNextOrder using Surv(). Store the result as survObj. 
# Create survival object
# install.packages("survival")
library(survival)
survObj <- Surv(dataNextOrder$daysSinceFirstPurch, dataNextOrder$boughtAgain)

# Take a look at the object's structure. 
str(survObj)

# Perfect! Again you can see the typical structure of the survival object: For each observation there is the time under observation, marked with a + if the second order has not been placed yet.

