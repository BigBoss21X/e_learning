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

# A difference type of model for trend is random walk, which has the form Xt = Xt-1 + Wt, where Wt is white noise. It is called a random walk because at time t the process is where it was at time t-1 plus a completely random movement. For a random walk with drift, a constant is added to the model and will cause the random walk to drift in the direction(positive or negative) of the drift. 

# We simulated and plotted data from these models. Note the difference in the behavior of the two models. 

# In both cases, simple difference can remove the trend and coerce the data to stationarity. Differencing looks at the difference between the value of a time series at a certain point in time and its preceding value. That is, Xt - Xt-1 is computed. 

# To check that it works, you will difference each generated time series and plot the deterended series. If a time series is in x, then diff(x) will have the detrended series obtained by differencing the data. To plot the detrended series, simply use plot(diff(x)). 

# Instructions 
# In one line, difference and plot the detrended trend stationary data in y by nesting a call to diff() within a call to plot(). Does the result look stationary?
# plot detrended y (trend stationary)
plot(diff(chicken), main = "trend stationary", type = "o")

# Do the same for x. Does the result look stationary?
plot(diff(globtemp), main = "random walk", type = "o")

# Well done! As you can see, differencing both your trend stationary data and your random walk data has the effect of removing the trends, despite the important differences between the two datasets.

##### ~ Chapter 3. Detrending Data ####
# As you have seen in the previous exercise, differencing is generally good for removing trend from time series data. Recall that differencing looks at the difference between the value of a time series at a certain point in time and its preceding value. 
# In this exercise, you will use differencing diff() to detrend and plot real time series data. 

# Instructions
# (1) The package astsa is preloaded. 
# (2) Generate a multifigure plot comparing the global temperature data(globtemp) with detrended series. You can create a multifigure plot by running the pre-written par() command followed by two separate call to plot(). 
par(mfrow = c(2,1))
plot(globtemp, type = "o")
plot(diff(globtemp), type = "o")

# (3) Generate another multifigure plot comparing the weekly cardiovascular mortaility in LA county(cmort) with detrended series. 
par(mfrow = c(2,1))
plot(cmort, type = "o")
plot(diff(cmort), type = "o")

# Excellent! Differencing is a great way to remove trends from your data.

#### ~ Chapter 4. Dealing with Trend and Heteroscedasticity ####
# Here, we will coerce nonstationary data to stationarity by calculating the return or growth rate as follows.
# Often time series are generated as Xt = (1 + pt)Xt-1
# Meaning that the value of the time series observed at time t equals the value observed at time t-1 and a small percent change pt at time t. 
# A simple deterministic example is putting money into a bank with a fixed interest p. In this case, X, is the value of the account at time period t with an initial deposit of X0. 

# Typically, Pt is referred to as the return or growth rate of a time series, and this process is often stable. 

# For reasons that are outside the scope of this course, it can be shown that the growth rate pt can be approximated by Yt = logXt - logXt-1 ≈ pt. 

# In R, pt is often calculated as diff(log(x)) and plotting it can be done in one line plot(diff(log(x)))

# Instructions
# (1) As before, the packages astsa and xts are preloaded. 
sapply(c("astsa", "xts"), require, character.only = TRUE)

# (2) Generate a multifigure plot to (1) plot the quartely US GNP(gnp) data and notice it is not stationary, and (2) plot the approximate growth rate of the US GNP using diff() and log(). 
# Plot GNP series (gnp) and its growth rate
par(mfrow = c(2,1))
plot(gnp)
plot(diff(log(gnp)))

# (3) Use a multifigure plot to (1) plot the daily DJIA closings (djia$Close) and notice that it is not stationary. The data are an xts object. Then (2) plot the approximate DJIA returns using diff() and log(). How does this compare to the growth rate of the GNP?
# Plot DJIA closings (djia$Close) and its returns
par(mfrow = c(2,1))
plot(djia$Close)
plot(diff(log(djia$Close)))

# Great job! Once again, by combining a few commands to manipulate your data, you can coerce otherwise nonstationary data to stationarity.

#### Lecture 3. Stationary Time Series: ARMA ####
# Wold Decomposition
# Wold proved that any stationary time series may be represented as a linear combination of white noise: 
# Xt = Wt + a1*Wt-1 + a2*Wt-2 + ...
# For constants a1, a2, ...
# any ARMA model has this form, which means they are suited to modeling time series. 
# Note: Special case of MA(q) is already of this form, where constants are () after q-th term. 

# Generating ARMA using arima.sim()
# Basic syntax: arima.sim(model, n, ..)
# model is a list with order of the model as c(p, d, q) and the coefficients (p = order of AR, q = order of MA)
# n is the length of series
# Generate MA(1) given by
# Xt = Wt + 0.9*Wt-1
x <- arima.sim(list(order = c(0,0,1), ma = 0.9), n = 100)
plot(x, type = "o")

# Generating and plotting AR(2)
# Generate AR(2) given by 
# Xt = -0.9 * Xt-2 + Wt
x <- arima.sim(list(order = c(2,0,0), ar = c(0, -0.9)), n = 100)
plot(x, type = "o")

#### ~ Chapter 5. Simulating ARMA Models ####
# As we saw in the video, any stationary time series can be written as a linear combination of white noise. In addition, any ARMA model has this form, so it is a good choice for modeling stationary time series.
# R provides a simple function called arima.sim() to generate data from an ARMA model. For example, the syntax for generating 100 observations from an MA(1) with parameter .9  
arima.sim(model = list(order = c(0, 0, 1), ma = .9 ), n = 100)
# You can also use order = c(0, 0, 0) to generate white noise.
# In this exercise, you will generate data from various ARMA models. For each command, generate 200 observations and plot the result.

# Instructions 
# (1) Use arima.sim() and plot() to generate and plot white noise.
# Generate and plot white noise
WN <- arima.sim(model = list(order = c(0,0,0)), n = 200)
plot(WN, type = "o")
# (2) Use arima.sim() and plot() to generate and plot an MA(1) with parameter .9.
MA <- arima.sim(model = list(order = c(0,0,1), ma = .9), n = 200)
plot(MA, type = "o")

# (3) Use arima.sim() and plot() to generate and plot an AR(2) with parameters 1.5 and -.75.
AR <- arima.sim(model = list(order = c(2,0,0), ar = c(1.5, -.75)), n = 200)
plot(AR, type = "o")

# Great job! The arima.sim() command is a very useful way to quickly simulate time series data.
