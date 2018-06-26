#### Lecture 1. PCA ####

# CRM data can get very extensive. Each metric you collect could carry some interesting information about your customers. But handling a dataset with too many variables is difficult. Learn how to reduce the number of variables in your data using principal component analysis. Not only does this help to get a better understanding of your data. PCA also enables you to condense information to single indices and to solve multicollinearity problems in a regression analysis with many intercorrelated variables.

# PCA helps to 
# (1) handle multicollinearity 
# (2) create indices
# (3) visualize and understand high-dimensional data

#### ~ Quiz. Purpose of PCA ####
# PCA is a method you can use for a wide range of purposes. Which of the following is something PCA can NOT do?

# Possible Answers
# (1) Developing data-driven indices
# (2) Visualizing high-dimensional data
# (3) Testing hypotheses about the underlying structure of the data
# (4) Solving the problem of highly intercorrelated variables in a multiple regression. 

# The answer is "Purely Exploratory method and is not suited to test hypotheses."

#### ~ Chapter 1. Getting to know the data ####
# In the exercises of this chapter, you are going to work with a dataset containing metrics about online articles. They're stored in the object newsData in your environment. 

# The packages dplyr and corrplot have already been loaded for you. 

# Instructions 
# (1) Get an overview of the structure of your data
# Overview of data structure
# install.packages("corrplot", dependencies = TRUE)
library(corrplot)
library(tidyverse)
load("newsData.Rdata")
str(newsData, give.attr = FALSE)
# Reducing Dimensionality with Principal Component Analysis
newsData2 <- newsData[, -1]

# (2) Take a look at the correlation structure using corrplot(). 
newsData2 %>% cor() %>% corrplot()

# Well done! Did you notice the group of intercorrelated variables in the bottom right area of the plot? Let's see if this group reflects in the principal components. 

#### ~ Quiz. Exploring the correlation structure ####
# Why is it interesting to look at the correlation structure of the data before doing PCA?
# Answer the Question
# Possible Answers 
# (1) To identify redundant variables that can be dropped beforehand
# (2) To drop variables that are completely uncorrelated with the others
# (3) To check for possible multicollinearity problems
# (4) Because components are determined based on the correlations 

# The answer is (4), PCA uses the correlations to determine the components that cover as much as possible of the original variance. You may already be able to see groups in the correlation matrix which form a component later on. 

#### Lecture 2. PCA Computation ####
# Variances of all variables before any data preparation 
lapply(newsData2, var)

# Standardization 
standardizationNewsData <- newsData2 %>% scale() %>% as.data.frame()  

# Check variances of all variables 
lapply(standardizationNewsData, var)

# ~ Quiz. Standardization of data
# Why is it necessary to standardize variables before a PCA?
# Answer the question 
# Possible Answers
# (1) It makes it easier to understand the data structure by simply looking at it. 
# (2) Without standardization, variables with a higher variance would have a larger impact on the extracted components
# (3) It makes PCA computation faster because different variances of the variables slow down the computations
# (4) It helps to check if every variable has been measured in the same measurement unit. 

# The answer is (2).
# Exactly! Principal components are extracted such that they cover as much of the original variance as possible. If some variables had larger variance than others, they would be overrepresented in the components.

#### ~ Chapter 2. Compute a PCA ####
# Now it's your turn: Compute a PCA on the standardizationNewsData dataset which is already loaded in the workspace and look at the results. The stats package is loaded by default, the package dplyr has already been loaded for you.

# Instructions 
# First, standardize all variables in the dataset and save the result again in standardizationNewsData (it's ok to overwrite the existing standardizationNewsData object, we won't need it anymore)

# Compute a PCA and store the results in an object called pcaNews
# Standardize data
standardizationNewsData <- newsData2 %>% scale() %>% as.data.frame()

# Compute PCA
pcaNews <- standardizationNewsData %>% prcomp()

# Examine the results by looking at the eigenvalues 
pcaNews$sdev ^ 2 %>% round(2)

# Well done! The eigenvalues are the variances of the components, i.e., the squared standard deviations.

# The result object of a PCA
# Which of the following statements about the result of a PCA is wrong?

# Answer the questions
# Possible Answers 
# (1) The standard deviations of the components help to interpret the components.
# (2) The squared standard deviations of the components are called eigenvalues.
# (3) If you divide the variances of the components by the number of components, you get a measure of component importance.
# (4) The loadings are the correlations of the components and the original variables.

# The answer is (1), Yes, this is the wrong statement! It's the loadings and not the standard deviations that help to interpret the components. The standard deviations can be used to compute the importance of the components.

#### Lecture 3. PCA model specification ####
#### ~ Chapter 3. How many components are relevant? ####
# The results that you stored in pcaNews contain as many components as variables. But your goal is a dimension reduction. It's time to find out how many components you should extract. Use several approaches to take your decision.

# The results of the pca pcaNews are still loaded in your workspace. All necessary packages are loaded.

# Instructions 
# (1) Create a screeplot. How many components does it suggest?
# Screeplot:
screeplot(pcaNews)
screeplot(pcaNews, type = "lines", npcs = length(pcaNews$sdev))
box()
abline(h = 1, lty = 2)

# (2) How many components would you need to meet the criterion of 70% variance explained (take a look at the summary())?
# Cumulative explained variance:
summary(pcaNews)

# (3) How many components would you extract according to the Kaiser-Guttmann criterion?
# Kaiser-Guttmann (number of components with eigenvalue larger than 1):
sum(pcaNews$sdev ^ 2 > 1)

# Well done! The screeplot suggests 22 or 24 components. To explain 70% of the variance, you need as many as 18 components. The Kaiser-Guttmann criterion suggests 23 components, but the eigenvalues of PC7 and PC8 are already very close to 1. Therefore, 22 would be a good compromise.

#### ~ Chapter 4. Interpretation of components ####
# Now that you decided how many components you need to cover a sufficient amount of the structure in the data, you are probably curious about the meaning of these components. Which contents do they reflect? Which of the variables form a component?
# Print loadings of the first six components
pcaNews$rotation[,1:23] %>% round(2)  

# The object pcaNews, which is a list of several elements, is loaded in your workspace.

# Very good! Here are some ideas for the interpretation: PC1 reflects “Subjectivity” (high global_subjectivity and avg_positive_polarity, negative loading on avg_negative_polarity). PC2 contains “Positivity” (high global_sentiment_polarity, low global_rate_negative_words; even negative words are not very negative as you can see from the positive loading on avg_negative_polarity). Here you meet again the group of intercorrelated variables from the corrplot, but they split into two components.

#### ~ Chapter 5. Visualization with a biplot ####
# Now visualize your PCA results. Maybe you can find groups in the data? The object pcaNews is loaded in your workspace.

# Instructions
# Create a biplot of the first two components.
pcaNews %>% biplot(cex = .5)
# Scale the text with the factor 0.5.
# Very good! You can see a separated small group of articles with low values on PC1 and low variance in their PC2 values. These articles have a low subjectivity and are neither positive nor negative (which makes sense, because a very positive or negative article would probably also be higher in subjectivity).

#### Lecture 4. Principal components in a regression analysis ####
#### ~ Quiz. Regression Analysis with many variables ####
# What is the danger of having too many variables in a regression?
# Possible Answers 
# (1) Wrong test results: More and more coefficients become significant although there is no actual effect
# (2) Danger of multicollinearity: The regression estimates become very unstable
# (3) Performance: Printing the regression output takes too long
# (4) Model fit: The R squared decreases with every variable added
# Correct! If there are many predictors, it is likely that some of them can be explained to a large extent by others. This leads to lower precision in terms of higher standard errors.
#### ~ Chapter 6. Linear regression with principal components ####
# The object newsData now contains an additional variable: logShares. The number of shares tell you how often the news articles have been shared. This distribution, however, would be highly skewed, so you are going to work with the logarithm of the number of shares. Apply what you just learned and predict the log shares!

# Instructions 
# (1) Compute a model to predict the log shares with all other variables. Store it as mod1.
# Predict log shares with all original variables
glimpse(newsData2)
mod1 <- lm(shares ~ ., data = newsData2)

# (2) Create a new dataframe dataNewsComponents with the log shares and the values on the first 22 components. The object pcaNews again contains the PCA results.
# Create dataframe with log shares and first 22 components
dataNewsComponents <- cbind(shares = newsData2[, "shares"],
                            pcaNews$x[, 1:22]) %>%
  as.data.frame()

# (3) Compute a second model (mod2) that predicts the log shares with just the 22 components.
# Predict log shares with first six components
mod2 <- lm(shares ~ ., data = dataNewsComponents)

# (4) Compare the adjusted R squared of the models. How did the value change by using only the principal components? How good is your model?
# Print adjusted R squared for both models
summary(mod1)$adj.r.squared
summary(mod2)$adj.r.squared







