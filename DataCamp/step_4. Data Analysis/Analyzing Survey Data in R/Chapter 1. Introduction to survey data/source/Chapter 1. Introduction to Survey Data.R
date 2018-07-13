#### Lecture 1. Survey Weights ####
# What are survey weights? 
# They are the result of using a complex sampling design to select a sample from a population 
# Roughly, the survey weight translate to the number of units in the population that a sampled unit represents 
# First weight in BLS sample  = 25,985 households
# Second weight in BLS sample = 6,581 households 

# How do survey weights impact my analyses?

# Survey Estimation 
# Survey data are commonly used to estimate a finite population quantity. 
# Using a complex sampling design, take a sample, called s, of n households. 
# Sample mean estimator: 
# For sampled units, we have the values and survey weights. 
# How do I incorporate the weights?

#### Quiz Survey Weights ####
# Let's look at the data from the Consumer Expenditure Survey and familiarize ourselves with the survey weights. Use the glimpse() function in the dplyr package to look at the ce dataset and check out the weights column, FINLWT21. ce and dplyr are pre-loaded.

# Interpret the meaning of the third observation's survey weight.
# Possible Answers
# (1) There are 20,208 people living in the third sampled household.
# (2) The third sampled household represents 20,208 US households.
# (3) The third household was sampled 20,208 times.
# (4) There are 20,208 households in the sample that are similar to the third household.

url <- "https://assets.datacamp.com/production/course_6613/datasets/ce.csv"
library(tidyverse)
ce <- read_csv(url)
write.csv(ce, "ce.csv")

glimpse(ce$FINLWT21)

# Great! Now that we know what the weights mean, let's dig a little deeper!

#### Chapter 1. Visualizing the weights #### 
# Graphics are a much better way of visualizing data than just staring at the raw data frame! Therefore, in this activity, we will load the data visualization package ggplot2 to create a histogram of the survey weights.

# Instructions 
# (1) Load the data visualization package ggplot2.
# Load ggplot2
library(ggplot2)

# (2) From the pre-loaded data frame, ce, construct a histogram of the survey weights.

# (3) Remember that the survey weights are stored in the column labeled FINLWT21.
# Construct a histogram of the weights
ggplot(data = ce, mapping = aes(x = FINLWT21)) +
  geom_histogram()

#### Lecture 2. Specifying elements of the design in R ####
# Simple Random Sampling 
# install.packages("survey")
library(survey)
# srs_design <- svydesign(data = paSample, weights = ~wts, fpc = ~N, id = ~1)

# stratified_design <- svydesign(data = paSample, id = ~1, weights = ~wts, strata = ~country, fpc = ~N)

# cluster_design <- svydesign(data = paSample, id = ~county + personid, fpc = ~N1 + N2, weights = ~wts)

#### Chapter 2. Designs in R ####
# In the next few exercises we will practice specifying sampling designs using different samples from the api dataset, located in the survey package. The api dataset contains the Academic Performance Index and demographic information for schools in California. The apisrs dataset is a simple random sample of schools from the api dataset. Let's specify its design!

# Instructions 
# Use glimpse() to look at the apisrs dataset. Notice that pw contains the survey weights and fpc contains the total number of schools in the population.

library(survey)
