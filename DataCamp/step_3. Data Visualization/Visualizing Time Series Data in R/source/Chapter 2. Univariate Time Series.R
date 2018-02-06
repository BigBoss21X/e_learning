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

#### Part 2. Other Visualization tools ####
# Chapter 1. Histogram of returns
# A simple chart of returns does not reveal much about the time series properties; often, data must be displayed in a different format to visualize interesting features.

# The density function, represented by the histogram of returns, indicates the most common returns in a time series without taking time into account. In R, these are calculated with the hist() and density() functions. 

# In the video, you saw how to create a histogram with 20 buckets, a title, and no Y axis label: 
# hist(amazon_stocks, breaks = 20, main = "AMAZON return distribution", xlab = "")

# Recall that you can use the lines() function to add a new time series, even with different line properties like color and thickness, to an existing plot. 

# In this exercise, you will create a histogram of the Apple daily returns data for the last two years contained in rtn. 

# Instructions
# (1) Draw the histogram of rtn titled "Apple stock return distribution" and with probability = TRUE to scale the histogram to a probability density. 
# Create a histogram of Apple stock returns
par(mfrow = c(1,1))
hist(rtn, main = "Apple stock return distribution", probability = TRUE)

# (2) Add a new line to the plot showing the density of rtn
# add a density line
density(rtn, na.rm = T)

# (3) Redraw the density line with twice the default width and a red color
lines(density(rtn, na.rm = T), col = "red", lwd = 2)

# Chapter 3. Box and whisker plot
# A box and whisker plot gives information regarding the shape, variability, and center(or median) of a data set. It is particularly useful for displaying skewed data.
# By comparing the data set to a standard normal distribution, you can identify departure from normality(asymmetry, skewness, etc). The lines extending parallel from the boxes are known as whiskers, which are used to indicate variablitiy outside the upper and lower quartiles, i.e. outliers, Those outliers are usually plotted as individual dots that are in-line with whiskers. 
# In the video, you also saw how to use boxplot()  to create a horizontal box and whisker plot:

# > boxplot(amazon_stocks, horizontal = TRUE, main = "Amazon return distribution")

# In this exercise, you will draw a box and whisker plot for Apple stock returns in rtn, which is in your workspace.

# Instructions 
# (1) Draw a box and whisker plot of the data in rtn
# Draw box and whisker plot for the Apple returns
# rtn <- rtn[!is.na(rtn)]
rtn <- as.numeric(rtn)
boxplot(rtn, horizontal = TRUE)

# (2) Draw a box and whisker plot for a standard normal distribution with 1000 points, which you can create with rnorm(1000)
boxplot(rnorm(1000), horizontal = TRUE)

# (3) Redraw both plots, in their original order, on the same 2x1 graphical window and make them horizontal
par(mfrow = c(2,1))
boxplot(rtn, horizontal = TRUE)
boxplot(rnorm(1000), horizontal = TRUE)

# Chapter 4. Autocorrelation
# Another important piece of information is the relationship between one point in the time series and points that come before it. This is called autocorrelation and it can be displayed as a chart which indicates the correlation between points separated by various time lags.

# In R, you can plot the autocorrelation function using acf(), which by default, displays the first 30 lags (i.e. the correlation between points n and n - 1, n and n - 2, n and n - 3 and so on up to 30). The autocorrelogram, or the autocorrelation chart, tells you how any point in the time series is related to its past as well as how significant this relationship is. The significance levels are given by 2 horizontal lines above and below 0.

# You saw in the video that using this function is fairly straightforward:

# > acf(amazon_stocks,main = "AMAZON return autocorrelations")

# In this exercise, you will create an autocorrelation plot of the Apple stock price return data in rtn.

# Instructions 
# (1) Draw an autocorrelation plot of rtn and title it "Apple return autocorrelation" 
# Draw autocorrelation plot
par(mfrow = c(1,1))
acf(rtn, main = "Apple return autocorrelation")

# (2) Redraw the plot and change the maximum lag to 10 by adding lag.max = 10
acf(rtn, main = "Apple return autocorrelation", lag.max = 10)

# Chapter 5. q-q plot
# A Q-Q plot is a plot of the quantiles of one dataset against the quantiles of a second dataset. This is often used to understand if the data matches the standard statistical framework, or a normal distribution. 
# If the data is normally distributed, the points in the q-q plot follow a straight diagonal line. This is useful to check for normaility at a glance but note that it is not an accurate statistical test. In the video, you saw how to create a q-q plot using the qqnorm() function, and how to create a reference line for if the data were perfectly normally distributed with qqline(): 

# > qqnorm(amazon_stocks, main = "AMAZON return QQ-plot")
# 
# > qqline(amazon_stocks, col = "red")

# In the context of this course, the first dataset is Apple stock return and the second dataset is a standard normal distribution. In this exercise, you will check how Apple stock returns in rtn deviate from a normal distribution.

# Instructions 
# (1) Draw a q-q plot for rtn titled "Apple return Q-Q plot" 
# Create q-q plot
qqnorm(rtn, main = "Apple return QQ-plot")

# (2) Add a reference line in red for the normal distribution using qqline()
# Add a red line showing normality
qqline(rtn, col = "red")

#### Part 3. How to use everything we learned so far? ####
# Chapter 1. A comprehensive time series diagnostic
# Each plotting function that you've learned so far provides a different piece of insight about a time series. By putting together the histogram, the box and whisker plot, the autocorrelogram, and the q-q plot, you can gather a lot of useful information about time series behavior.

# In this exercise, you will explore the ExxonMobil return data in the rtn series available in your workspace.

# Instructions 
# (1) Draw a histogram of rtn, scale it to a probability density, and add a red line to the plot showing the density of rtn
# Draw histogram and add red density line
hist(rtn, probability = TRUE)
lines(density(rtn), col = "red")

# (2) Draw a boxplot of rtn
# Draw box and whisker plot
boxplot(rtn)

# (3) Draw an autocorrelogram of rtn
# Draw autocorrelogram
acf(rtn)

# (4) Draw a q-q plot of rtn and add a red reference line showing the normal distribution
qqnorm(rtn)
qqline(rtn, col = "red")

# Chapter 2. A comprehensive time series diagnostic (2)
# To allow a quick and efficient diagnostic, it is often more convenient to display the four charts above on the same graphical window.
# In this exercise, you will put all the charts you created from the previous exercise onto one graphical window.

# Instructions 
# (1) Set up the graphical window with 2 rows and 2 columns
# Set up 2x2 graphical window
par(mfrow = c(2,2))

# (2) Recreate the plots from the previous exercise (this has been done for you)
# Recreate all four plots
hist(rtn, probability = TRUE)
lines(density(rtn), col = "red")
boxplot(rtn)
acf(rtn)
qqnorm(rtn)
qqline(rtn, col = "red")
