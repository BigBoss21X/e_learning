#### Lecture 1. Choices in model Design #### 
# A suitable training data set
# Specify response and explanatory variables
# Select a model architecture 
## Linear Model: lm()
## Recursive partitioning: rpart()

# Training a model
# Automatic process carried out by the computer 
# Tailors (i.e. "fits") the model to the data
# Model represents both your choices and data

# The CPS85 data
library(mosaicData)
library(tidyverse)
glimpse(CPS85)
data("CPS85")
head(CPS85)
data("Runners")

model_1 <- lm(wage ~ educ + exper, data = CPS85)
model_2 <- rpart::rpart(wage ~ educ + exper, data = CPS85)

#### Chapter 1. Modeling Running Times ####
