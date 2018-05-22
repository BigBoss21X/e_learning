#### Chapter 1. Null Sampling Distribution of the slope #### 

# In the previous chapter, you investigated the sampling distribution of the slope from a population where the slope was non-zero. Typically, however, to do inference, you will need to know the sampling distribution of the slope under the hypothesis that there is no relationship between the explanatory and response variables. Additionally, in most situations, you don't know the population from which the data came, so the null sampling distribution must be derived from only the original dataset.

# In the mid-20th century, a study was conducted that tracked down identical twins that were separated at birth: one child was raised in the home of their biological parents and the other in a foster home. In an attempt to answer the question of whether intelligence is the result of nature or nurture, both children were given IQ tests. The resulting data is given for the IQs of the foster twins (Foster is the response variable) and the IQs of the biological twins (Biological is the explanatory variable).

# In this exercise you'll use the pull() function. This function takes a data frame and returns a selected column as a vector (similar to $).

#### Instructions ####
# Load the infer package.

# Using the twins data and the tidy function from the broom package, run a linear model regressing the IQ of the Foster twin against the Biological twin.

# Using the infer package, permute the response variable and run the same function to get a slope value on a dataset where there is no link between the explanatory and response variables. (Note: use hypothesize(null = "independence") for the regression hypothesis test.)

# Repeat the previous step 10 times to find 10 different slope values on 10 different permuted datasets.

library(infer)
library(broom)
library(tidyverse)
twins <- read_csv("data/twins.csv")
glimpse(twins)

# Calculate the observed slope
obs_slope <- lm(Foster ~ Biological, twins) %>%
  tidy() %>%   
  filter(term == "Biological") %>%
  pull(estimate)    

# Simulate 10 slopes with a permuted dataset
set.seed(4747)
perm_slope <- twins %>%
  specify(Foster ~ Biological) %>%
  hypothesize(null = "independence") %>%
  generate(reps = 10, type = "permute") %>%
  calculate(stat = "slope") 

# Print the observed slope and the 10 permuted slopes
obs_slope
perm_slope

#### Chapter 2. SE of the slope ####
# The previous exercise generated 10 different slopes under a model of no (i.e., null) relationship between the explanatory and response variables. Now repeat the null slope calculations 1000 times to derive a null sampling distribution for the slope coefficient. The null sampling distribution will be used as a benchmark against which to compare the original data. calculate the average and SE of the sampling distribution

# Instructions
# 1. Using the infer steps, generate 500 permuted slope statistics.

# 2. Plot the null slopes using geom_density.

# 3. Find the mean and the standard deviation of the null slopes.

# Make a dataframe with replicates and plot them!
set.seed(4747)
perm_slope <- twins %>% 
  specify(Foster ~ Biological) %>% 
  hypothesize(null = "independence") %>% 
  generate(reps = 500, type = "permute") %>% 
  calculate(stat = "slope")

ggplot(perm_slope, aes(x = stat)) + 
  geom_density()

# Calculate the mean and the standard deviation of the slopes
perm_slope %>% 
  ungroup() %>% 
  summarise(mean(stat), sd(stat))

#### Chapter 3. p-value #### 
# Now that you have created the null sampling distribution, you can use it to find the p-value associated with the original slope statistic from the twins data. Although you might first consider this to be a one-sided research question, instead, use the absolute value function for practice performing two-sided tests on a slope coefficient.

# Instructions 
# Calculate the absolute value of the observed test statistic. Use pull() to create a numeric value with which to work.

# Compare the observed statistic to the perm_slopes calculated in the previous exercise.

# The p-value will be the proportion of times (out of 1000) that the absolute value of the permuted statistics is greater than the absolute value of the observed statistic.

# Calculate the absolute value of the slope
abs_obs_slope <- lm(Foster ~ Biological, data = twins) %>%
  tidy() %>%   
  filter(term == "Biological") %>%
  pull(estimate) %>%
  abs()

# Compute the p-value  
perm_slope %>% 
  mutate(abs_perm_slope = abs(stat)) %>%
  summarize(p_value = mean(abs_perm_slope > abs_obs_slope))

obs_slope <- lm(Foster ~ Biological, data = twins) %>% 
  tidy() %>% 
  filter(term == "Biological") %>% 
  select(estimate) %>% 
  pull()

ggplot(data = perm_slope, aes(x = stat)) + 
  geom_histogram() + 
  geom_vline(xintercept = obs_slope, color = "red") + 
  xlim(-1, 1)

# Inference on Slope
# What can we conclude based on the p-value associate with the twins data?

# Instructions 
# 1. If there were no association between foster and biological twin IQ (no nature) in the population, we would be extremely unlikely to have collected a sample of data like we did.

# 2. A biological twin's IQ being higher causes a foster twin's IQ to be higher.

# 3. Biological twins' IQs are higher than foster twins' IQs, on average.

# 4. Given the data, the probability of biological and foster twins' IQs being unrelated is close to zero.

# The answer is 1. 
