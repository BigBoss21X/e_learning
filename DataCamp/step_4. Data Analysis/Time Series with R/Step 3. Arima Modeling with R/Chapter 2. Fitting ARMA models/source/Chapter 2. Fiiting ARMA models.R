#### Lecture 1. AR and MA Models ####
x <- arima.sim(list(order = c(1, 0, 0), ar = -.7), n = 200)
y <- arima.sim(list(order = c(0, 0, 1), ma = -.7), n = 200)

par(mfrow = c(1,2))
plot(x, main = "AR(1)")
plot(y, main = "MA(2)")

# Estimation 
# Estimation for time series is similar to using least squares for regresison
# Estimates are obtained numerically using ideas of Gauss and Newton

# Estimation with astsa
# AR(2) with mean 50: 
# Xt = 50 + 1.5(X*(t-1) - 50) - .75(X*(t-2) - 50) + Wt

x <- arima.sim(list(order = c(2, 0, 0), 
                    ar = c(1.5, -.75)), 
               n = 200) + 50
x_fit <- sarima(x, p = 2, d = 0, q = 0)
x_fit$ttable

# Estimation with astsa
# MA(1) with mean 0: 
# Xt = Wt - .7*W(t-1)
y <- arima.sim(list(order = c(0,0,1), ma = -.7), n = 200)
y_fit <- sarima(y, p = 0, d = 0, q = 1)
y_fit$ttable

#### ~ Chapter 1. Fitting an AR(1) Model ####
# Recall that you use the ACF and PACF pair to help identify the orders p and q of an ARMA model. The following table is a summary of the results:

# In this exercise, you will generate data from the AR(1) model,
# Xt=.9Xt−1+Wt,
# look at the simulated data and the sample ACF and PACF pair to determine the order. Then, you will fit the model and compare the estimated parameters to the true parameters.

# Throughout this course, you will be using sarima() from the astsa package to easily fit models to data. The command produces a residual diagnostic graphic that can be ignored until diagnostics is discussed later in the chapter.

# Instructions 
# The package astsa is preloaded.
library(astsa)
# Use the prewritten arima.sim() command to generate 100 observations from an AR(1) model with AR parameter .9. Save this to x.
x <- arima.sim(model = list(order = c(1, 0, 0), ar = .9), n = 100)

# Plot the generated data using plot().
# Plot the generated data 
par(mfrow = c(1,1))
plot(x, type = "o")

# Plot the sample ACF and PACF pairs using the acf2() command from the astsa package.
# Plot the sample P/ACF pair
plot(acf2(x))

# Use sarima() from astsa to fit an AR(1) to the previously generated data. Examine the t-table and compare the estimates to the true values. For example, if the time series is in x, to fit an AR(1) to the data, use sarima(x, p = 1, d = 0, q = 0) or simply sarima(x, 1, 0, 0).
y_fit <- sarima(x, p = 1, d = 0, q = 0)
y_fit$ttable

# Excellent work! As you can see, the sarima() command provides extensive output to understand the results of your model fit. What do you glean from this output?

#### ~ Chapter 2. Fitting an AR(2) Model ####
# For this exercise, we generated data from the AR(2) model,
# Xt=1.5Xt−1−.75Xt−2+Wt,
# using
x <- arima.sim(model = list(order = c(2, 0, 0), ar = c(1.5, -.75)), n = 200)
# Look at the simulated data and the sample ACF and PACF pair to determine the model order. Then fit the model and compare the estimated parameters to the true parameters.

# Instructions 
# The package astsa is preloaded. x contains the 200 AR(2) observations.
# Use plot() to plot the generated data in x.
# Plot x
plot(x)
# Plot the sample ACF and PACF pair using acf2() from the astsa package.
# Plot the sample P/ACF of x
plot(acf2(x))
# Use sarima() to fit an AR(2) to the previously generated data in x. Examine the t-table and compare the estimates to the true values.
# Fit an AR(2) to the data and examine the t-table
y_fit <- sarima(x, p = 2, d = 0, q = 0)
y_fit$ttable

# Well done! As you can see from the t-table output, the estimates produced by the sarima() command are close to the true parameters.

#### ~ Chapter 3. Fitting an MA(1) Model ####
# In this exercise, we generated data from an MA(1) model,
# Xt=Wt−.8Wt−1,
x <- arima.sim(model = list(order = c(0, 0, 1), ma = -.8), n = 100)
# Look at the simulated data and the sample ACF and PACF to determine the order based on the table given in the first exercise. Then fit the model.
# Recall that for pure MA(q) models, the theoretical ACF will cut off at lag q while the PACF will tail off.

# Instructions 

# (1) The package astsa is preloaded. 100 MA(1) observations are available in your workspace as x.
# astsa is preloaded
library(astsa)

# (2) Use plot() to plot the generated data in x.
# Plot x
plot(x)

# (3) Plot the sample ACF and PACF pairs using acf2() from the astsa package.
plot(acf2(x))

# (4) Use sarima() from astsa to fit an MA(1) to the previously generated data. Examine the t-table and compare the estimates to the true values.
y_fit <- sarima(x, p = 0, d = 0, q = 1)
y_fit$ttable

# Excellent! Once again, the parameter estimates produced by sarima() come quite close to the input specified when the data was created (-.8).

#### Lecture 2. AR and MR together ####
# Xt = øX(t-1) + Wt + θW(t-1)
# auto-regression /  correlated errors
x <- arima.sim(list(order = c(1, 0, 1), ar = .9, ma = -.4), n = 200)

plot(x,  main = "ARMA(1, 1)")

#### ~ Chapter 4. Fitting an ARMA model ####
# You are now ready to merge the AR model and the MA model into the ARMA model. We generated data from the ARMA(2,1) model,

# Xt=Xt−1−.9Xt−2+Wt+.8Wt−1,
x <- arima.sim(model = list(order = c(2, 0, 1), ar = c(1, -.9), ma = .8), n = 250)
plot(x, type = "o")
# Look at the simulated data and the sample ACF and PACF pair to determine a possible model.

# Recall that for ARMA(p,q) models, both the theoretical ACF and PACF tail off. In this case, the orders are difficult to discern from data and it may not be clear if either the sample ACF or sample PACF is cutting off or tailing off. In this case, you know the actual model orders, so fit an ARMA(2,1) to the generated data. General modeling strategies will be discussed further in the course.

# Instructions 
# The package astsa is preloaded. 250 ARMA(2,1) observations are in x.
# plot x
plot(x, type = "o")

# As in the previous exercises, use plot() to plot the generated data in x and use acf2() to view the sample ACF and PACF pairs.
# Plot the sample P/ACF of x
plot(acf2(x))

# Use sarima() to fit an ARMA(2,1) to the generated data. Examine the t-table and compare the estimates to the true values.
y_fit <- sarima(x, p = 2, d = 0, q = 1)
y_fit$ttable

# Great job! As you can see, the sarima() command can estimate parameter values for many different types of models, including AR, MA, and ARMA.

#### ~ Quiz Identify an ARMA Model ####
# Look at (1) the data plots and (2) the sample ACF and PACF of the logged and differenced varve series:
plot(varve)
dl_varve <- diff(log(varve))
plot(dl_varve)

# Use help(varve) to read about the data or use an internet search on varve to learn more.

# From the ACF and PACF, which model is the most likely model for dl_varve?

x <- arima.sim(model = list(order = c(0, 0, 1), ma = .7),  n = 600)
# Instructions 
# Possible Answers
# (1) MA(1)
# (2) AR(5)
# (3) ARMA(2,1)

# The answer is (1), 
# Exactly! Remember that an MA(q) model has an ACF that cuts off at lag q and a PACF that tails off. In this case, the ACF cuts off at lag 1 and the PACF tails off, suggesting an MA(1) model.

#### Lecture 3. Model Choice and Residual Analysis ####
# AIC and BIC 
# average(observed - predicted)^2 + k(p+q) 
# Error increases, Number of Parameters decrease
# AIC and BIC measure the error and penalise (differently) for adding parameters
# For example, AIC has k = 2 and BIC has k = log(n)
# Goal: find the model with the smallest AIC or BIC

# Model Choice AR(1) vs MA(2)
gnpgr <- diff(log(gnp))
sarima(gnpgr, p = 1, d = 0, q = 0)
sarima(gnpgr, p = 0, d = 0, q = 2)

# Residual Analysis 
# sarima() includes residual analysis graphic showing
# (1) standardized residuals 
# (2) Sample ACF of residuals 
# (3) Normal Q-Q plot
# (4) Q-Statistic p-values

#### ~ Chapter 5 Model Choice - I ####
# Based on the sample P/ACF pair of the logged and differenced varve data (dl_varve), an MA(1) was indicated. The best approach to fitting ARMA is to start with a low order model, and then try to add a parameter at a time to see if the results change.

# In this exercise, you will fit various models to the dl_varve data and note the AIC and BIC for each model. In the next exercise, you will use these AICs and BICs to choose a model. Remember that you want to retain the model with the smallest AIC and/or BIC value.

# A note before you start: sarima(x, p = 0, d = 0, q = 1) and sarima(x, 0, 0, 1) are the same.

# Instructions 
# (1) The package astsa is preloaded. The varve series has been logged and differenced as dl_varve <- diff(log(varve)).
dl_varve <- diff(log(varve))

# (2) Use sarima() to fit an MA(1) to dl_varve. Take a close look at the output of your sarima() command to see the AIC and BIC for this model.
# Fit an MA(1) to dl_varve.   
sarima(dl_varve, p = 0, d = 0, q = 1)

# (3) Repeat the previous exercise, but add an MA parameter by fitting an MA(2) model. Based on AIC and BIC, is this an improvement over the previous model?
# Fit an MA(2) to dl_varve. Improvement?
sarima(dl_varve, p = 0, d = 0, q = 2)

# (4) Instead of adding an MA parameter, add an AR parameter to the original MA(1) fit. That is, fit an ARMA(1,1) to dl_varve. Based on AIC and BIC, is this an improvement over the previous models?
# Fit an ARMA(1,1) to dl_varve. Improvement?
sarima(dl_varve, p = 1, d = 0, q = 1)

# Great job! AIC and BIC help you find the model with the smallest error using the least number of parameters. The idea is based on the parsimony principle, which is basic to all science and tells you to choose the simplest scientific explanation that fits the evidence.

#### ~ Quiz Model Choice - II ####
# In the previous exercise, you fit three different models to the logged and differenced varve series (dl_varve). The data are displayed to the right. The extracted AIC and BIC from each run are tabled below.
data.frame(
  Model = c("MA(1)", "MA(2)", "ARMA(1,1)"), 
  AIC = c(-0.4437, -0.4659, -0.4702), 
  BIC = c(-1.4366, -1.4518, -1.4561)
)
# Using the table, indicate which statement below is FALSE.

# Possible Answers 
# (1) AIC and BIC both prefer the ARMA(1,1) model over the other fitted models.
# (2) AIC prefers the MA(1) model.
# (3) BIC prefers the MA(2) over the MA(1)
# (4) Because they use different penalties, the AIC and BIC can prefer different models.
# The answer is (2), wrong

# Exactly! The lowest AIC value of the three models is the ARMA(1,1) model, meaning AIC prefers that model over the MA(1) model.

#### ~ Chapter 6. Residual Analysis - I ####
# As you saw in the video, an sarima() run includes a residual analysis graphic. Specifically, the output shows (1) the standardized residuals, (2) the sample ACF of the residuals, (3) a normal Q-Q plot, and (4) the p-values corresponding to the Box-Ljung-Pierce Q-statistic.

# In each run, check the four residual plots as follows:
  
# The standardized residuals should behave as a white noise sequence with mean zero and variance one. Examime the residual plot for departures from this behavior.
# The sample ACF of the residuals should look like that of white noise. Examine the ACF for departures from this behavior.
# Normality is an essential assumption when fitting ARMA models. Examine the Q-Q plot for departures from normality and to identify outliers.
# Use the Q-statistic plot to help test for departures from whiteness of the residuals.
# As in the previous exercise, dl_varve <- diff(log(varve)), which is plotted below a plot of varve. The astsa package is preloaded.

# Instructions 
# (1) Use sarima() to fit an MA(1) to dl_varve and do a complete residual analysis as prescribed above. Make a note of what you see for the next exercise.
# Fit an MA(1) to dl_varve. Examine the residuals
sarima(dl_varve, p = 0, d = 0, q = 1)

# (2) Use another call to sarima() to fit an ARMA(1,1) to dl_varve and do a complete residual analysis as prescribed above. Again, make a note of what you see for the next exercise.
# Fit an ARMA(1,1) to dl_varve. Examine the residuals
sarima(dl_varve, p = 1, d = 0, q = 1)

# Well done! By now you have mastered constructing parameters through the sarima() command, but the rich and comprehensive output of this command is always worth exploring. What did you learn about the residuals produced by your MA(1) and ARMA(1,1) models?

#### ~ Quiz Residual Analysis - II ####
# In the previous exercise, you fit two different ARMA models to the logged and differenced varve series: an MA(1) and an ARMA(1,1) model. The residual analysis graphics are displayed in order of the run: 
  
# MA(1)
# ARMA(1, 1)

# Which of the following statements is FALSE (partially truthful statements are false - data analysis is not politics)?

# Instructions 
# Possible Answers
# (1) The residuals for the MA(1) model are not white noise.
# (2) The residuals for the ARMA(1, 1) model appear to be Gaussian white noise.
# (3) It is not a good idea to look at the residual analysis because it might tell you if your model is incorrect and you might have to stay late at work to figure out the correct model.
# The answer is (3), That's right! You should always examine the residuals because the model assumes the errors are Gaussian white noise.

#### ~ Chapter 7. ARMA get in ####
# By now you have gained considerable experience fitting ARMA models to data, but before you start celebrating, try one more exercise (sort of) on your own.

# The data in oil are crude oil, WTI spot price FOB (in dollars per barrel), weekly data from 2000 to 2008. Use your skills to fit an ARMA model to the returns. The weekly crude oil prices (oil) are plotted for you. Throughout the exercise, work with the returns, which you will calculate.

# As before, the astsa package is preloaded for you. The data are preloaded as oil and plotted on the right.

# Instructions 
# Calculate the approximate crude oil price returns using diff() and log(). Put the returns in oil_returns.
# Calculate approximate oil returns
oil_returns <- diff(log(oil))

# Plot oil_returns and notice that there are a couple of outliers prior to 2004. Convince yourself that the returns are stationary.
plot(oil_returns)

# Plot the sample ACF and PACF of the oil_returns using acf2() from the astsa package.
plot(acf2(oil_returns))

# From the P/ACF pair, it is apparent that the correlations are small and the returns are nearly noise. But it could be that both the ACF and PACF are tailing off. If this is the case, then an ARMA(1,1) is suggested. Fit this model to the oil returns using sarima(). Does the model fit well? Can you see the outliers in the residual plot?
sarima(oil_returns, p = 1, d = 0, q = 1)

# Excellent work! You have now successfully manipulated some real-world time series data, explored the qualities of that data, and modeled an ARMA(1,1) model to your data. In the next chapter, you will explore more complicated models.
