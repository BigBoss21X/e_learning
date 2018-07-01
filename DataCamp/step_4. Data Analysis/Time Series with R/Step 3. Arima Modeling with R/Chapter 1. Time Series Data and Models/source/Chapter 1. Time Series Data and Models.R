# install.packages(c("astsa", "xts"), dependencies = T)
sapply(c("astsa", "xts"), require, character.only = T)

#### Lecture 1. First Things First ####

# Time Series Data - 1
plot(jj, main = "Johnson & Johnson Quartely Earnings per Share", type = "c")
text(jj, labels = 1:4, col = 1:4)

# Time Series Data - 2
plot(globtemp, main = "Global Temperature Deviations", type = "o")

# Time Series Data - 3
plot(sp500w, main = "S&P 500 Weekly Returns")

# Time Series Regression Models 
# Regression ¥i=ßXi + £i, where £i is white noise
# White Noise:
# - Independent normals with common variance
# - is basic building block of time series 
# AutoRegression: Xt = øXt-1 + £i (£i is white noise)
# Moving Average: £t = Wt + øWt-1(Wt is white noise)
# ARMA: Xt = øXt-1 + Wt + øWt-1

#### ~ Chapter 1. Data Play ####
# In the video, you saw various types of data. In this exercise, you will plot additional time series data and compare them to what you saw in the video. It is useful to think about how these time series compare to the series in the video. In particular, concentrate on the type of trend, seasonality or periodicity, and homoscedasticity.

# Before you use a data set for the first time, you should use the help system to see the details of the data. For example, use help(AirPassengers) or ?AirPassengers to see the details of the series.

# Instructions
# (1) The packages astsa and xts are preloaded in your R environment
# install.packages(c("astsa", "xts"), dependencies = T)
sapply(c("astsa", "xts"), require, character.only = T)
# (2) Use help() to view the specifics of the AirPassengers data file. 
# View a detailed description of AirPassengers
help(AirPassengers)
# (3) Use plot() to plot the airline passenger data (AirPassengers) and compare it to a series you saw in the video.
plot(AirPassengers)
# (4) Plot the DJIA daily closings(djia$Close) and compare it to a series you saw in the video. 
plot(djia$Close)
# (5) Plot the Southern Oscillation Index (soi) and inspect it for trend, seasonality, and homoscedasticity.
plot(soi)

# Excellent work! As you can see, the AirPassengers dataset contains monthly information on airline passengers from 1949 through 1960. Note that when you plot ts objects using plot(), the data will automatically be plotted over time.

#### ~ Quiz Elements of Time Series ####
# Look at the AirPassengers series again. Select the answer that is FALSE 
# Instructions 
# Possible Answers 
# (1) There is seasonality
# (2) There is trend
# (3) There is heteroscedasticity. 
# (4) The series is white noise. 
# (5) Over the time period of this data, it was still ok to smoke on planes. 

# Exactly! The AirPassengers data show a handful of important qualities, including seasonality, trend, and heteroscedasticity, which distinguish the data from standard white noise.

#### Lecture 2. Stationarity and Nonstationarity ####
# A time series is stationary when it is "stable", meaning: 
# The mean is constant over time (no trend)
# The correlation structure remains constant over time

# Stationarity
# Given data x1, ...., xn we can estimate by averaging
# For example, if the mean is constant, we can estimate it by the sample average x
# Pairs can be used to estimate correlation on different lags: 
# (x1, x2), (x2, x3), (x3, x4), ... for lag1
# (x1, x3), (x2, x4), (x3, x5). ... for lag2

# Data: Souther Oscillation Index
plot(soi)
lag(soi, -1)
# Reasonable to assume stationary, but perhaps some slight trend. 
# To estimate autocorrelation, compute the correlation coefficient between the time series and itself at various lags. 
# Here you see how to get the correlation at lag1 and lag6. 

# Random Walk Trend
plot(globtemp)
# Not stationary, but differenced data are stationary. 
# Xt globtemp
# Xt - Xt-1, diff(globtemp)
plot(diff(globtemp))

# Trend Stationarity
# Stationarity around a trend, differencing still works! 
plot(chicken)
plot(diff(chicken))

# Nonstationarity in trend and variability
# First log, then difference
plot(jj, type = "o")
plot(log(jj), type = "o")
plot(diff(log(jj)), type = "o")

#### ~ Chapter 2. Differencing #### 
# As seen in the video, when a time series is trend stationary, it will have stationary behavior around a trend, A simple example is Yt = å + ßt + Xt, where Xt, is stationary. 

# A difference type of model for trend is random walk, which
