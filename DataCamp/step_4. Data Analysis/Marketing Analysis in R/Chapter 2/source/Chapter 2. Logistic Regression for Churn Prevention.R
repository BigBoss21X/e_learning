#### Lecture 1. Binary Logistic Regresson ####
# (1) Probability to churn P(Y = 1)
# (2) log Odds
# (3) Odds
# (4) Probability to churn 

#### Quiz. Application Churn Prevention ####
# Let's begin with some basics. Remember the customer churn case from the video. What is the main incentive for an online shop to do churn prevention?

# Possible Answers
# (1) Attracting new customers
# (2) Gaining insights about existing customers
# (3) Convincing existing customers to buy again and stay loyal to the online shop

# The answer is (3)
# Churn Prevention is a measure to ensure that customers visit the online shop again. 

#### Chapter 1. Data Discovery #### 
# For your coding exercises you will use the theory that you just saw and apply it to a new dataset. This dataset is about bank customers and will be used to predict if customers will default on their loan payments.
# There are very helpful functions in R to get an overview of the dataset at hand. For now you will only look at summary() and str().
# Necessary packages are loaded and the dataset defaultData is already present in your working environment.

# Instructions 
# Use summary() and str() to look at your data.
# Also make sure to get some more insights about the variable of interest PaymentDefault by plotting a bar chart of the two levels.

install_pkgs <- function(pkgs) {
  new.pkg <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
  if(length(new.pkg)) {
    install.packages(new.pkg, dependencies = TRUE)
  }
  sapply(pkgs, require, character.only = TRUE)
}

pkgs <- c("tidyverse")

install_pkgs(pkgs)

defaultData <- "https://assets.datacamp.com/production/repositories/1861/datasets/0b0772985a8676c3613e8ac2c6053f5e60a3aebd/defaultData.csv"

defaultData <- read.csv(defaultData, sep = ";")

# Summary of data
summary(defaultData)

# Look at data structure
glimpse(defaultData)

# Analyze the blancedness of dependent variable 
ggplot(defaultData, aes(x = PaymentDefault)) + 
  geom_histogram(stat = "count")

#### Chapter 2. Peculiarities of the dependent variable ####
# You've got some insights from me about the mathematics behind a logistic regression. Now, I want to know how you can transform the outcome variable (taking only values of 0 and 1) in order to examine a linear influence of the explanatory variables?

# Possible Answers 
# (1) By using the exponential function to transform it to a range from 음의 무한대 ~ 양의 무한대
# (2) By using the logarithmic odds to transform it to a range from 음의 무한대 ~ 양의 무한대
# (3) By using the square root of the variables to transform it to a range from 음의 무한대 ~ 양의 무한대

# The answer is 2. Unfortunately this makes interpretability more difficult. 

# (3)

