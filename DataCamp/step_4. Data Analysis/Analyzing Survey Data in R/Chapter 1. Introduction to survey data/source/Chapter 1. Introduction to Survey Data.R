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

#### ~ Quiz Survey Weights ####
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

#### ~ Chapter 1. Visualizing the weights #### 
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

#### ~ Chapter 2. Designs in R ####
# In the next few exercises we will practice specifying sampling designs using different samples from the api dataset, located in the survey package. The api dataset contains the Academic Performance Index and demographic information for schools in California. The apisrs dataset is a simple random sample of schools from the api dataset. Let's specify its design!

# Instructions 
# (1) Use glimpse() to look at the apisrs dataset. Notice that pw contains the survey weights and fpc contains the total number of schools in the population.

# install.packages("survey", dependencies = T)
library(survey)
library(tidyverse)
data(api)
glimpse(apisrs)

# (2) Specify the correct sampling design for apisrs and store it in an object called apisrs_design.
# Specify a simple random sampling for apisrs
apisrs_design <- svydesign(
  data = apisrs, 
  weights = ~pw, 
  fpc = ~fpc, 
  id = ~1
)

# (3) Print out a summary of apisrs_design and notice what information is provided.
summary(apisrs_design)

#### ~ Chapter 3. Stratified Designs in R ####
# Now let's practice specifying a stratified sampling design, using the dataset apistrat. The schools are stratified based on the school type stype where E = Elementary, M = Middle, and H = High School. For each school type, a simple random sample of schools was taken.

# Instructions 
# (1) Glimpse the data and notice the weights are stored in pw and fpc contains the total number of schools in each school type.
# Glimpse the data
glimpse(apistrat)

# (2) Summarize how many schools were sampled in each strata by piping apistrat into count(stype)
# Summarize strata sample sizes
apistrat %>% count(stype)

# (3) Specify the design for apistrat and store it in an object called apistrat_design
 # Specify the design
strat_design <- svydesign(data = apistrat, weights = ~pw, fpc = ~fpc, id = ~1, strata = ~stype)

# # Look at the summary information for the stratified design
summary(strat_design)

#### ~ Chapter 4. Cluster Designs in R ####

# Now let's practice specifying a cluster sampling design, using the dataset apiclus2. The schools were clustered based on school districts, dnum. Within a sampled school district, 5 schools were randomly selected for the sample. The schools are denoted by snum. The number of districts is given by fpc1 and the number of schools in the sampled districts is given by fpc2.

# Instructions 
# (1) Glimpse the data
# Glimpse the data
glimpse(apiclus2)

# (2) Specify the design for apiclus2 and store in an object called apiclus_design
# Specify the design
apiclus_design <- svydesign(id = ~dnum + snum, data = apiclus2, weights = ~pw, fpc = ~fpc1 + fpc2)

# (3) Look at the summary information for the design.
#Look at the summary information stored in the design object
summary(apiclus_design)

# Good work! Now let's compare the survey weights of these three designs.

#### ~ Chapter 5. Comparing survey weights of different designs 
# Remember that an observation's survey weight tells us how many population units that observation represents. The weights are constructed based on the sampling design. Let's compare the weights for the three samples of the api dataset. For example, in simple random sampling, each unit has an equal chance of being sampled, so each observation gets an equal survey weight. Whereas, for stratified and cluster sampling, units have an unequal chance of being sampled and that is reflected in the survey weight.

# Instructions 
# (1) Using ggplot2, construct a histogram of the survey weights, pw, for the simple random sample, apisrs.
# Construct histogram of pw
ggplot(data = apisrs,
       mapping = aes(x = pw)) + 
  geom_histogram()

# (2) Now construct a histogram of the survey weights, pw, for the stratified sample, apistrat. 
# Construct histogram of pw
ggplot(data = apistrat,
       mapping = aes(x = pw)) + 
  geom_histogram()

# (3) Lastly, construct a histogram of the survey weights, pw, for the cluster sample, apiclus2. Compare the histograms!
# Construct histogram of pw
ggplot(data = apiclus2,
       mapping = aes(x = pw)) + 
  geom_histogram()

# Now that we can specify designs, let's start doing some analyses!

#### Lecture 3. Visualizing the impact of survey weights ####

# install.packages("NHANES", dependencies = TRUE)
library(NHANES)
dim(NHANESraw)
library(dplyr)
summarise(NHANESraw, N_hat = sum(WTMEC2YR))

NHANESraw <- mutate(NHANESraw, WTMEC4YR = WTMEC2YR/2)

NHANES_design <- svydesign(NHANESraw, strata = ~SDMVSTRA, id = ~SDMVPSU, nest = TRUE, weights = ~WTMEC4YR)

glimpse(NHANESraw)
