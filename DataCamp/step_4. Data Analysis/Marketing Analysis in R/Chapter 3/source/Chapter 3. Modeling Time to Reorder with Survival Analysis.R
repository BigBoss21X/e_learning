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

#### Chapter 3. Kaplan-Meier Analysis ####
# In this exercise you are going to practice Kaplan-Meier Analysis - without and with a categorical covariate.

# The survival package is loaded to your workspace. Also, the survival object survObj and your data dataNextOrder are still in the environment. But now, the data contains an additional covariate called voucher, which you will need in this exercise. This categorical variable tells you if the customer used a voucher in her first order. It contains the value 0 or 1.

#### Instructions ####
# 1. Compute a Kaplan-Meier Analysis (without covariates) using survfit(). Store the result in an object fitKMSimple and print it. Remember, the dependent variable is again your survival object.
# Compute and print fit
fitKMSimple <- survfit(survObj ~ 1)
print(fitKMSimple)

# 2. Plot the results and add axis labels(xlab and ylab arguments)
plot(fitKMSimple, 
     conf.int = FALSE, 
     xlab = "Time since first purchase", 
     ylab = "Survival function", 
     main = "Survival function")

# 3. Now go a step further: Compute a Kaplan Meier Analysis with the variable voucher as covariate. 
# Compute fit with categorical covariate
fitKMCov <- survfit(survObj ~ voucher, data = dataNextOrder)
print(fitKMCov)

# 4. Again, Plot the result and add axis labels
# Plot fit with covariate and add labels
plot(fitKMCov, lty = 2:3,
     xlab = "Time since first purchase", ylab = "Survival function", main = "Survival function")
legend(90, .9, c("No", "Yes"), lty = 2:3)

# Perfect! You analyzed how voucher usage is related to the survival curve! Customers using a voucher seem to take longer to place their second order. They are maybe waiting for another voucher?

#### Lecture Cox PH model with constant covariates #### 
#### ~ Quiz Proportional Hazard Assumption ####
# What does the proportional hazard assumption mean?
# Possbile Answers
# (1) The influence of the predictors does not change over time 
# (2) The hazard function is the same for all levels of the categorical variables 
# (3) The risk that an event occurs does not change over time 
# (4) The shape of the hazard is linear 

# The answer is (1), For example, it would not be allowed that the gender 'male' has as positive effect on the survival time after a short time under observation, but a large negative effect after a longer time under observation. 

#### ~ Chapter 4. Cox Proportional Hazard Model ####
# Now you are going to compute a Cox Proportional Hazard model on the online shop data. Your data stored in dataNextOrder now contains four additional variables: the shoppingCartValue of the first order in dollars, whether the customer used a voucher, whether the order was returned, and the gender.

# The rms package is already loaded in the workspace.

# Instructions
# (1) Compute the Cox PH model using cph(). Include the variables shoppingCartValue, voucher, returned and gender as predictors. Store the result in an object called fitCPH. And, of course, print the results.
# Determine distributions of predictor variables
# install.packages("rms", dependencies = TRUE)
library(rms)
dd <- datadist(dataNextOrder)
options(datadist = "dd")
# Compute Cox PH Model and print results 
fitCPH <- cph(Surv(daysSinceFirstPurch, boughtAgain) ~ shoppingCartValue + voucher + returned + gender, 
              data = dataNextOrder, 
              x = TRUE, y = TRUE, surv = TRUE)
print(fitCPH)

# (2) Take the exponential of the coefficients to interpret them. With respect to interpretation, take into account that shoppingCartValue is a continuous variable, whereas the remaining variables are categorical.
# Interpretation coefficients
exp(fitCPH$coefficients)

# (3) Plot the result summary 
plot(summary(fitCPH), log = TRUE)

# You can see that a shopping cart value increase of 1 dollar decreases the hazard to buy again by a factor of only slightly below 1 - but the coefficient is significant, as are all coefficients. For customers who used a voucher, the hazard is 0.74 times lower, and for customers who returned any of the items, the hazard is 0.73 times lower. Being a man compared to a woman increases the hazard of buying again by the factor 1.11. 

# Interpretation of coefficients 
# You computed a Cox PH model and got a coefficient of 0.8 for your continuous predictor X. What is the correct interpretation?
# Possible Answers
# (1) A one-unit increases in X increases the hazard by 0.8
# (2) The higher the value on X, the lower the hazard
# (3) A one-unit increase in X increases the hazard by a factor of about 2.23
# (4) A one-unit increase in X increases the hazard by about 2.23. 

# Very good! You took two important things into account: The effect is multiplicative and you took exponential. 

#### Lecture: checking model assumptions and making predictions ####
#### Quiz Violating of the PH Assumption ####
# What can you do if the proportional hazard assumption is violated for a predictor?
# (1) Stratify the sample according to this predictor and analyse the strata separately.
# (2) Use time-independent coefficients to resolve interactions of time and predictor effects
# (3) Use cross-validation and divide the data randomly into parts.
# (4) Collect more data to get a more precise estimation of the predictor's coefficient.

# The answer is (1), You can divide the data into strata and estimate the model separately within each stratum.

#### ~ Chapter 5. Model Assumptions ####
# You already had a look at the Cox PH model in the last coding exercise. In this exercise, you are going to find out if your model is appropriate at all. Your model is still stored in the object fitCPH.

# instructions 
# Check the proportional hazard assumption of the model using cox.zph(). Store the test result in an object called testCPH and print it.
testCPH <- cox.zph(fitCPH)
print(testCPH)

# The assumption seems to be violated for one variable at the 0.05 alpha level. Which one? Plot the coefficient beta dependent on time for this variable.
library(rms)
plot(testCPH, var = "gender=male")

# Validate the model using cross validation in the validate() function from the rms package.
# Validate Model
validate(fitCPH, 
         method = "crossvalidation", 
         B = 10, 
         dxy = TRUE, 
         pr = FALSE)

# Well done! Unfortunately, the explanatory power of your model is rather low. You could try to collect more explanatory variables.

#### ~ Chapter 6. Predictions ####
# Now you are going to predict the survival curve for a new customer from the Cox Proportional Hazard model you estimated before. The model is still available in the object fitCPH.

# The new customer is female and used a voucher in her first order. The order was placed 21 days ago and had a shopping cart value of 99.90 dollars. She didn't return the order.

# Remember: voucher and returned can have the values 0 or 1.

# Instruction

# (1) reate a one-row dataframe called newCustomer with the new customer's characteristics listed in the assignment text above.
# Create data with new customer
newCustomer <- data.frame(daysSinceFirstPurch = 21, shoppingCartValue = 99.90, gender = "female", voucher = 1, returned = 0, stringsAsFactors = FALSE)

# (2) Predict the expected median time until the second order for this customer and plot the predicted survival curve.
# Make predictions
pred <- survfit(fitCPH, newdata = newCustomer)
print(pred)
plot(pred)

# (3) You are informed that due to database problems the gender was incorrectly coded: The new customer is actually male. Copy the dataframe newCustomer into a dataframe called newCustomer2 and change the respective variable.

# Correct the customer's gender
newCustomer2 <- newCustomer
newCustomer2$gender <- "male"

# (4) Recompute the predicted median with the corrected data. What changed?
# Redo prediction
pred2 <- survfit(fitCPH, newdata = newCustomer2)
print(pred2)

# Well Done! The correction of the gender decreased the predicted median time until the second order from 47 to 44 days.
