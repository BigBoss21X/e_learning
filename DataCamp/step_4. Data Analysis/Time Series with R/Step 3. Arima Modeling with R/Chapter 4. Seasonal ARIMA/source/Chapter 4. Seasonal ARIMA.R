#### Lecture 1. Pure Seasonal Models ####
# Pure Seasonal Models 
# Often collect data with a known seasonal component
# Air Passengers (1 cycle every S = 12 months)
# Johnson & Johnson Earnings (1 cycle every S = 4 quarters)
# Consider pure seasonal models such as an SAR(P=1)s=12
# Xt = øX(t-12) + Wt

# ACF and PACF of Pure Seasonal Models 

#### Quiz P/ACF of Pure Seasonal Models ####
# In the video, you saw that a pure seasonal ARMA time series is correlated at the seasonal lags only. Consequently, the ACF and PACF behave as the nonseasonal counterparts, but at the seasonal lags, 1S, 2S, ..., where S is the seasonal period (S = 12 for monthly data). As in the nonseasonal case, you have the pure seasonal table:

# *The values at nonseasonal lags are zero.

# We have plotted the true ACF and PACF of a pure seasonal model. Identify the model with the following abbreviations SAR(P)S, SMA(Q)S, or SARMA(P,Q)S for the pure seasonal AR, MA or ARMA with seasonal period S, respectively.

#### ~ Chapter 1. Fit a Pure Seasonal Model ####

# As with other models, you can fit seasonal models in R using the sarima() command in the astsa package.

# To get a feeling of how pure seasonal models work, it is best to consider simulated data. We generated 250 observations from a pure seasonal model given by


# Xt=.9X(t−12)+Wt+.5W(t−12),

library(tidyverse)
library(astsa)
library(stats)
library(zoo)

# which we would denote as a SARMA(P = 1, Q = 1)S = 12. Three years of data and the model ACF and PACF are plotted for you.

# You will compare the sample ACF and PACF values from the generated data to the true values displayed to the right.

# The astsa package is preloaded for you and the generated data are in x.

# Instruction 

# (1) Use acf2() to plot the sample ACF and PACF of the generated data to lag 60 and compare to actual values. To estimate to lag 60, set the max.lag argument equal to 60.
# Plot sample P/ACF to lag 60 and compare to the true values
x <- ts(AirPassengers, frequency = 12)

acf2(x, max.lag = 60)

# (2) Fit the model to generated data using sarima(). In addition to the p, d, and q arguments in your sarima() command, specify P, D, Q, and S (note that R is case sensitive).

# Fit the seasonal model to x
sarima(x, p = 0, d = 0, q = 0, P = 1, D = 0, Q = 1, S = 12)

# Well done! Fitting a seasonal model using sarima() requires a few additional arguments, but follows the same basic process as nonseasonal models.

#### Lecture 2. Mixed Seasonal Models #### 

# Mixed Models: SARIMA(p,d,q)x(P,D,Q)s Model
# Consider a SARIMA(0,0,1)x(1,0,0)12 model 
# SAR(1): Value this month is related to last year's value X(t-12) 
# MA(1): This month's value related to last month's shock W(t-1)

# Seasonal Persistence

#### ~ Chapter 2. Fit a Mixed Seasonal Model ####
# Pure seasonal dependence such as that explored earlier in this chapter is relatively rare. Most seasonal time series have mixed dependence, meaning only some of the variation is explained by seasonal trends.

# Recall that the full seasonal model is denoted by SARIMA(p,d,q)x(P,D,Q)S where capital letters denote the seasonal orders.

# As before, this exercise asks you to compare the sample P/ACF pair to the true values for some simulated seasonal data and fit a model to the data using sarima(). This time, the simulated data come from a mixed seasonal model, SARIMA(0,0,1)x(0,0,1)12. The plots on the right show three years of data, as well as the model ACF and PACF. Notice that, as opposed to the pure seasonal model, there are correlations at the nonseasonal lags as well as the seasonal lags.

# As always, the astsa package is preloaded. The generated data are in x.

# Instructions 
# plot the sample ACF and PACF of the generated data to lag 60(max.lag = 60) and compare them to the actual values 
# Plot sample P/ACF pair to lag 60 and compare to actual
plot(acf2(x, max.lag = 60))

# Fit the model to generated data(x) using sarima(). As in the previous exercise, be sure to specify the additional seasonal in your sarima() command. 
# Fit the seasonal model to x
sarima(x, p = 0, d = 0, q = 1, P = 0, D = 0, Q = 1, S = 12)

# Excellent! Time series data collected on a seasonal basis typcially have mixed dependence. For example, what happens in June is often related to what happend in May as well as what happened in June of last year.

#### ~ Chapter 3. Data Analysis - Unemployment I ####
# In the video, we fit a seasonal ARIMA model to the log of the monthly AirPassengers data set. You will now start to fit a seasonal ARIMA model to the monthly US unemployment data, unemp, from the astsa package.

# The first thing to do is to plot the data, notice the trend and the seasonal persistence. Then look at the detrended data and remove the seasonal persistence. After that, the fully differenced data should look stationary.

# The astsa package is preloaded in your workspace.

# Instructions 
# Plot the monthly US unemployment (unemp) time series from astsa. Note trend and seasonality.
# Plot unemp 
plot(unemp)

# Detrend and plot the data. Save this as d_unemp. Notice the seasonal persistence.
# Difference your data and plot it
d_unemp <- diff(unemp)
plot(d_unemp)

# Seasonally difference the detrended series and save this as dd_unemp. Plot this new data and notice that it looks stationary now.
# Seasonally difference d_unemp and plot it
dd_unemp <- diff(d_unemp, lag = 12)
plot(dd_unemp)

# Excellent work! Now that you have removed the trend and seasonal variation in unemployment, the data appear to be stationary.

#### ~ Chapter 4. Data Analysis - Unemployment II ####
# Now, you will continue fitting an SARIMA model to the monthly US unemployment unemp time series by looking at the sample ACF and PACF of the fully differenced series.

# Note that the lag axis in the sample P/ACF plot is in terms of years. Thus, lags 1, 2, 3, ... represent 1 year (12 months), 2 years (24 months), 3 years (36 months), ...

# Once again, the astsa package is preloaded in your workspace.

# Instructions 

# Difference the data fully (as in the previous exercise) and plot the sample ACF and PACF of the transformed data to lag 60 months (5 years). Consider that, for
# Plot P/ACF pair of the fully differenced data to lag 60
dd_unemp <- diff(diff(unemp), lag = 12)
acf2(dd_unemp, max.lag = 60)

# the nonseaonal component: the PACF cuts off at lag 2 and the ACF tails off.
# Fit an appropriate model
sarima(unemp, p = 2, d = 1, q = 0, P = 0, D = 1, Q = 1, S = 12)

# the seasonal component: the ACF cuts off at lag 12 and the PACF tails off at lags 12, 24, 36, ...

# Suggest and fit a model using sarima(). Check the residuals to ensure appropriate model fit.

# Well done! As always, keep a close eye on the output from your sarima() command to get a feel for the fit of your model.
