#### Part 1. Univariate time series analysis ####
# Chapter 1. Representing a univariate time series
# The very first step in the analysis of any time series is to address if the time series have the right mathematical properties to apply the standard statistical framework. If not, you must transform the time series first.

# In finance, price series are often transformed to differenced data, making it a return series. In R, the ROC() (which stands for "Rate of Change") function from the TTR package does this automatically to a price or volume series x:

# ROC(x)

# In this exercise, you will compare plots of the Apple daily prices and Apple daily returns using the stock data contained in data, which is available in your workspace.

library(xts)
library(tidyverse)

# data import
url <- "https://assets.datacamp.com/production/course_2300/datasets/dataset_2_1.csv"

data <- read.csv(url, sep = " ")
write.csv(data, "Daily returns for Apple.csv", row.names = F)

apple <- read.csv("Daily returns for Apple.csv")
apple$count <- 1
glimpse(apple)
data <- read.zoo(apple)
head(data)

# instructions
# (1) Plot data and name the chart "Apple stock price"
plot(data$Apple, main = "Apple stock price", xlab = "date", ylab = "price")

# (2) Apply ROC() to data to create a time series rtn containing Apple's daily returns
# install.packages("TTR")
library(TTR)
# Create a time series called rtn
rtn <- ROC(data$Apple)

# (3) Plot data and rtn, in that order, as two new plots on a 2x1 graphical window
# Plot Apple daily price and daily returns 
par(mfrow = c(1,2))
plot(data$Apple, main = "Apple stock price")
plot(rtn, main = "")
