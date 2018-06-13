# Customer Lifetime Value (CLV)
# (1) predicted future net-profit 
# (2) identify promising customers
# (3) prioritize customers according to future margins
# (4) no further customer segmentation

# The identification of special segments in your customers is the main goal of cluster analysis. This is nothing CLV analysis can do. 

#### Chapter 1. Looking at data ####
# The dataset salesData is loaded in the workspace. It contains information on customers for the months one to three. Only the sales of month four are included. The following table gives a description of some of the variables whose meaning is less obvious.

code <- data.frame(
  variable = c(
    "id", 
    "mostFreqStore", 
    "mostFreqCat", 
    "nCats", 
    "preferredBrand", 
    "nBrands"
  ), 
  Description = c(
    "identification number of customer", 
    "store person bought mostly from
", 
    "category person purchased mostly", 
    "number of different categories", 
    "brand person purchased mostly", 
    "number of different brands"
  )
)

# package install
install_pkgs <- function(pkgs) {
  new.pkg <- pkgs[!(pkgs %in% installed.packages()[, "Package"])] 
  if(length(new.pkg)) {
    install.packages(new.pkg, dependencies = TRUE)
  }
  sapply(pkgs, require, character.only = TRUE)
}

pkgs <- c("readr", "dplyr", "corrplot", "ggplot2")

install_pkgs(pkgs)

# The packages readr, dplyr, corrplot, and ggplot2 have been installed and loaded.

#### ~ Instructions ####
# data
ChurnData <- "https://assets.datacamp.com/production/course_6027/datasets/churn_data.csv"
salesData <- "https://assets.datacamp.com/production/course_6027/datasets/salesData.csv"
salesData_2months <- "https://assets.datacamp.com/production/course_6027/datasets/salesDataMon2To4.csv"
SurvivalData <- "https://assets.datacamp.com/production/course_6027/datasets/survivalDataExercise.csv"

DefaultData <- "https://assets.datacamp.com/production/repositories/1861/datasets/0b0772985a8676c3613e8ac2c6053f5e60a3aebd/defaultData.csv"
load("newsData.rdata")

salesData <- read_csv(salesData)

# Visualization of correlation
salesData %>% 
  select_if(is.numeric) %>% 
  select(-id) %>% 
  cor() %>% 
  corrplot()

# Frequent Stores
ggplot(salesData) + 
  geom_boxplot(aes(x = mostFreqStore, 
                   y = salesThisMon))

# Preferred Brand
ggplot(salesData) + 
  geom_boxplot(aes(x = preferredBrand, 
                   y = salesThisMon))

#### Lecture 2. Simple Linear Regression ####
# Linear Relationship between x and y
# No measurement error in x (weak exogeneity)
# Independence of errors
# Expectation of errors is 0
# Constant Variance of prediction errors (homoscedasticity)
# Normality of errors

# Understanding Residuals 
# The residuals are the difference between the predicted and the actual values
# The residuals are also called prediction errors
# The residuals in a linear model should be uncorrelated
# Since the residuals are dependent on the model we are looking at we cannot say anything about their correlation in general. 

#### Chapter 2. Estimating simple linear regression ####
# Back to our sales dataset, salesData, which is already loaded in the workspace. We saw that the sales in the last three months are stongly positively correlated with the sales in this month. Hence we will start off including that as an explanatory variable in a linear regression.

# Instructions 
# Use the lm() function in order to specify the linear regression model. Assign it to an object salesSimpleModel.

# Then use the summary() function in order to look at the results.

# Look at the regression coefficient. Is there a positive or negative relationship between the two variables?

# About how much of the variation in the sales in this month can be explained by the sales of the previous three months?

# Model Specification using lm
salesSimpleModel <- lm(salesThisMon ~ salesLast3Mon, data = salesData)

# Looking at model summary
summary(salesSimpleModel)

# Since the regression coefficient is greater than 0, there exists a positive relationship between the explanatory variable salesLast3Mon and the dependent variable salesThisMon. It explains almost 60 percent of the variation in the sales of this month. 

#### Lecture 3. Multicollinearlity #### 

#### ~ Variance Inflation Factors ####
# library(rms)

#### Chapter 3. Avoiding Multicollinearity #####

# Back to our sales dataset salesData which is already loaded in the workspace. Additionally, the package rms is loaded.

# Let's estimate a multiple linear regression! Of course, we want to make use of all variables there are in the dataset.

# Instructions 
# Go ahead and calculate a model called salesModel1 using all variables but the id in order to explain the sales in this month. To do this, use the syntax response ~ . - excluded_variable. This can be read as "response modeled by all variables except excluded_variable."
# Estimate the variance inflation factors using the vif() function from the rms package.

# package install
pkgs <- c("readr", "dplyr", "corrplot", "ggplot2", "rms")

install_pkgs(pkgs)

# Estimating the full model
salesModel1 <- lm(salesThisMon ~ . - id, 
                  data = salesData)

# Checking variance inflation factors 
vif(salesModel1)

# Estimating new model by removing information on brand

salesModel2 <- lm(salesThisMon ~ . - id - preferredBrand - nBrands, 
                  data = salesData)

# Checking variance inflation factors 
vif(salesModel2)

# Hooray! We can certainly accept the second model. So let's move on to see what we have actually estimated. 
#### Lecture 4. Model Validation, Model Fit, and Prediction ####

#### (1) Coefficient of Determination R^2 ####
#### (2) R^2 and F-test ####

# If R^2 equals 0, then none of the variation is explained. 

# If R^2 equals 1, corresponds to a model that explains 100% of the dependent variable's variation. 

# F-Test is a test for the overall fit of the model. 

# It tests whether or not R^2 is equal to 0. That is to say, at least one regressor (or a set of regressors) has significant explanatory power. 

# In our model, the 'p-value' of the F-test is smaller than 0.05, hence, the hypothesis of an R^2 of zero is rejected. 

#### (3) Overfitting ####
# Methods to Avoid Overfitting 
# AIC() from stats package
# stepAIC() from mass package
# out-of-sample model validation
# cross-validation

pkgs <- c("readr", "dplyr", "corrplot", "ggplot2", "rms", "stats", "MASS")

install_pkgs(pkgs)

# AIC minimizing is preferred
AIC(salesModel2)

# Automatic model selection can be done using "stepAIC"

summary(salesModel2)
# The multiple R-Squared of 0.8236 tells you that 82.36% of the dependent variable's variation is explained by the explanatory variables. 

#### Chapter 4. Future Predictions of sales ####
# A new dataset called salesData2_4 is loaded in the working space. It contains information on the customers for the months two to four. We want to use this information in order to predict the sales for month 5.

# Instructions 
# Use the summary() command in order to get an overview of the new dataset.
salesData2_4 <- read_csv(salesData_2months)
summary(salesData2_4)

# Use the model salesModel2 and the new dataset salesData2_4 in the predict() function in order to predict the sales for month 5. Store the predictions in a vector called predSales5.
predSales5 <- predict(salesModel2, data = salesData2_4)

# Calculate the mean of the expected sales. Make sure to remove missing values.
mean(predSales5, na.rm = TRUE)
