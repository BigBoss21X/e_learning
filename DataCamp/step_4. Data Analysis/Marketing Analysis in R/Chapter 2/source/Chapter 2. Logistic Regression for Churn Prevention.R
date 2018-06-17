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

#### Lecture 2. Modeling and Model Selection ####
# You have seen the glm() command for running a logistic regression. glm() stands for generalized linear model and offers a whole family of regression models.

# Take the exercise dataset for this coding task. The data defaultData you need for this exercise is available in your environment and ready for modleing 

# Instructions
# Use the glm() function in order to model the probability that a customer will default on his payment by using a logistic regression. Include every explanatory variable of the dataset and specify the data that shall be used.

# Do not forget to specify the argument family.

# Then, extract the coefficients and transform them to the odds ratios.

# Built logisitc regression model
glimpse(defaultData)
logitModelFull <- glm(PaymentDefault ~ . -ID, family = binomial, data = defaultData)

# Take a look at the model
summary(logitModelFull)

# Take a look at the odds
coefsexp <- coef(logitModelFull) %>% exp() %>% round(2)
coefsexp

# You've built your first logistic regression model and already gained some insights about the effects of the variables. 

#### ~ Chapter 3. Statistical Significance ####
# Everyone is talking about statistical significance, but do you know the exact meaning of it? What is the correct interpretation of a p value equal to 0.05 for a variable's coefficient, when we have the following null hypothesis:

# H0: The influence of this variable on the payment default of a customer is equal to zero.

# Possible Answers 
# The probability of finding this coefficient's value is only 5%, given that our null hypothesis (the respective coefficient is equal to zero) is true.
# The probability that the null hypothesis is true is 5%.
# The probability that the alternative hypothesis is true is 95%.

# The answer is The probability of finding this coefficient's value is only 5%, given that our null hypothesis (the respective coefficient is equal to zero) is true. 

#### Chapter 4. Model Specification ####

# The stepAIC() function gives back a reduced model, as you just saw in the previous video. Now you want to apply this method to the exercise dataset defaultData.

# The prepared dataset is available in your environment. Additionally, the MASS package is loaded and the previously built logit model logitModelFull is defined for you. Also note that we've reduced the size of the dataset as performing stepwise model selection can take a long time with larger datasets and more complex models.

# Instructions 

# Make use of the stepAIC() function. Set trace = 0, as you do not want to get an output for the whole model selection process. Save the result to the object logitModelNew.

# Then, use the summary() function to take a look at logitModelNew. You can ignore the warning message in this case. Go ahead and see what changed. Understand the results. 

# The formula is saved in an object so that you don't have to type the whole equation again when you want to use it later. 

library(MASS)

# The old (full) model
glimpse(defaultData)

logitModelFull <- glm(PaymentDefault ~ . - ID, family = binomial, data = defaultData)

# Build the new model
logitModelNew <- stepAIC(logitModelFull, trace = 0)

# Look at the model
summary(logitModelNew)

# Save the formula of the new model (it will be needed for the out-of-sample part)

formulaLogit <- as.formula(summary(logitModelNew)$call)

formulaLogit

#### Lecture 3. In Sample model fit and thresholding ####

#### Chapter 5. In-Sample fit full model ####
# It is coding time again, which means coming back to the exercise dataset defaultData.

# You now want to know how your model performs by calculating the accuracy. In order to do so, you first need a confusion matrix. 

# Take the logitModeFull, first. The model is already specified and lives in your environment. 

# Instructions 
# Use predict() to receive a probability of each customer defaulting on their payment. 
# Make predictions using the full Model. 
defaultData$predFull <- predict(logitModelFull, type = "response", na.action = na.exclude)

# In order to construct the confusion matrix use the function confusion.matrix() from SDMTools. 
# Construct the in-sample confusion matrix 
# install.packages("SDMTools")
library(SDMTools)
confMatrixModelFull <- confusion.matrix(defaultData$PaymentDefault, defaultData$predFull, threshold = 0.5)

confMatrixModelFull

# Choose a common threshold of 0.5.

# Calculate the accuracy using the confusion matrix. 
accuracyFull <- sum(diag(confMatrixModelFull)) / sum(confMatrixModelFull)

accuracyFull

# Awesome! You got it! But you have only calculated the accuracy for one of your two models. In the next step, do it for the other one as well. 

#### Chapter 6. In-Sample fit restricted model ####

# You calculated the accuracy for logitModelFull. It's very important to do that with all your model candidates.

# Therefore,logitModelNew is specified and lives in your environment.

# When comparing the values of the different models with each other: In case different models have the same accuracy values, always choose the model with less explanatory variables.

# Instructions 

# Do the same steps as in the previous exercise for the new model.

# Use predict() to receive a probability for each customer to default his payment.
# Calculate the accuracy for 'logitModelNew' 
# Make prediction
defaultData$predNew <- predict(logitModelNew, type = "response", na.action = na.exclude)

# Then calculate a confusion matrix with the same threshold of 0.5 for classification.
confMatrixModelNew <- confusion.matrix(defaultData$PaymentDefault, defaultData$predNew, threshold = 0.5)

# Calculate the accuracy of the restricted model and compare it to the accuracy od the full model. You will continue your analysis only with the superior model.
accuracyNew <- sum(diag(confMatrixModelNew) / sum(confMatrixModelNew))
accuracyNew

# and compare it to the full model's accuracy
accuracyFull

# You calculated the accuracy measures for both model candidates. As the accuracy values are approximately the same, let's continue with the smaller model logitModelNew. 

#### Chapter 7. Finding the optimal threshold ####
# You now know that the choice of the threshold is essential for your results. Check empirically which threshold is most reasonable in this case.

# The SDMTools package is already loaded. Additionally, we specified the dataframe payoffMatrix that contains a column with the thresholds, 0.1, 0.2, ..., 0.5 for you. From the last exercise we know that the restricted model was the best one. So only calculate the optimal threshold for that model. 

# Instructions 
# Build a for loop, which gives out a confusion matrix plus its respective payoff, for each possible threshold value.
# Prepare data frame with threshold values and empty payoff column
payoffMatrix <- data.frame(threshold = seq(from = 0.1, to = 0.9, by = 0.1), 
                           payoff = NA)

payoffMatrix
# Inside the loop, you will need a payoff formula for the specific costs given in the following scenario:

for(i in 1:length(payoffMatrix$threshold)) {
  # Calculate confusion matrix with varying threshold
  confMatrix <- confusion.matrix(
    defaultData$PaymentDefault, 
    defaultData$predNew, 
    threshold = payoffMatrix$threshold[i]
  )
  
  # Calculate payoff and save it to the corresponding row
  payoffMatrix$payoff[i] <- confMatrix[1,1] * 250 + confMatrix[1,2] * (-1000)
}

confMatrix <- confusion.matrix(
  defaultData$PaymentDefault, 
  defaultData$predNew, 
  threshold = payoffMatrix$threshold[1]
)

# payoff = 250 * true negative - 1000 * false negative

# Remember the threshold that leads to the highest payoff. 
payoffMatrix

#### Chapter 8. Danger of Overfitting ####
# What is the main reason of overfitting?
# Answer: The model is highly tailored to the given data and not suited for explaining new data. 

#### Lecture 4. Out-of-sample validation and cross validation ####

#### ~ Chapter 9. Assessing out-of-sample model fit ####
# You now know that it makes more sense to look at the out-of-sample model fit than the in-sample fit. In this exercise, you therefore want to come up with an out-of-sample accuracy measure.

# Before, you will have to do some preparational steps, though. Take defaultData again. logitModelNew is already loaded in your environment.

# Be aware that for a complete analysis you would always have to compare different model candidates also (and especially) using out-of-sample data.

# The in-sample accuracy - using the optimal threshold of 0.3 - is 0.7922901. Make sure you understand if there is overfitting.

# Instructions
# First, split the dataset randomly into training and test set. The training set shall contain 2/3 of the overall data. 
# Split data in train and test set 
set.seed(534381)

defaultData$isTrain <- rbinom(nrow(defaultData), 1, 0.66)

train <- subset(defaultData, defaultData$isTrain == 1)
test <- subset(defaultData, defaultData$isTrain == 0)

# Then, quickly run the model and call it logitTrainNew. Use the given formula
logitTrainNew <- glm(formulaLogit, family = "binomial", data = train)

test$predNew <- predict(logitTrainNew, type = "response", newdata = test) # Predictions

# Make predictions on the test set and then calculate the out-of-sample accuracy with the help of a confusion matrix. 
# Out-of-sample confusion matrix and accuracy
confMatrixModelNew <- confusion.matrix(test$PaymentDefault, test$predNew, threshold = 0.3)

# Compare the out-of-sample accuracy to the in-sample value, given above.
sum(diag(confMatrixModelNew)) / sum(confMatrixModelNew)

# Good Job! Knowing how to validate in an out-of-sample manner is essential for reliable results! In case you experience overfitting in the future you would have to go back to modeling and build smaller models. 

#### ~ Chapter 10. Cross Validation ####

# Cross validation is a clever method to avoid overfitting as you could see. In this exercise you are going to calculate the cross validated accuracy.

# You can go right ahead, the neccessary data and models are waiting for you. You can find the accuracy function in the first few lines of code. Try it out!

# Instructions #
# Use a 6-fold cross validation and calcuate the accuracy for the models. The function you need is cv.glm() of the book package 
library(boot)
# Accuracy function 
costAcc <- function(r, pi = 0) {
  cm <- confusion.matrix(r, pi, threshold = 0.3)
  acc <- sum(diag(cm)) / sum(cm)
  return(acc)
}


# Compare your accuracy of the cross validation to the one of the in-sample validation. Remember, it was 0.7922901.
# Cross validated accuracy for logitModelNew
set.seed(534381)
cv.glm(defaultData, logitModelNew, cost = costAcc, K = 6)$delta[1]

# Well done! You would know which model to choose, right? Our Session is coming to an end. I hope you learned a lot about churn prevention and logistic regression. Join me in the next chapter for more exciting data science!
