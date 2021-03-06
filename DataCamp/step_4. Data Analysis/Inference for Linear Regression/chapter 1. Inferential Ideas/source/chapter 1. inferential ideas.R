#### Chapter 1. Regression Output: Example I ####
# The following code provides two equivalent methods for calculating the most important pieces of the linear model output. Recall that the p-value is the probability of the observed data (or more extreme) given the null hypothesis is true. As with inference in other settings, you will need the sampling distribution for the statistic (here the slope) assuming the null hypothesis is true. You will generate the null sampling distribution in later chapters, but for now, assume that the null sampling distribution is correct. Additionally, notice that the standard error of the slope and intercept estimates describe the variability of those estimates.

# Instructions
# (1) Load the mosaicData package and load the RailTrail data. The RailTrail data contains information about the number of users of a trail in Florence, MA and the weather for each day.
# (2) Using the lm() function, run a linear model regressing the volume of riders on the hightemp for the day. Assign the output of the lm() function to the object ride_lm.
# (3) Use the summary() function on the linear model output to see the inferential analysis (including the p-value for the slope).
# (4) Additionally, tidy() the linear model output to make it easier to use later.

# Load the mosaicData Package and the RailTrail Data
library(mosaicData)
library(broom)
library(tidyverse)
data("RailTrail")

# Fit a linear model 
ride_lm <- lm(volume ~ hightemp, data = RailTrail)

# View the summary of your model
summary(ride_lm)

# Print the tidy model output
ride_lm %>% tidy()

#### Chapter 2. First Random Sample, Second Random Sample ####
# Now, you will dive in to understanding how linear models vary from sample to sample. Here two random samples from a population are plotted onto the scatterplot. The population data (called popdata) already exists and is pre-loaded, along with ggplot and dplyr.

# Instructions
# Using ggplot, make a scatter plot of the entire population of data, add a least squares regression line (use geom_smooth).

# Using the function sample_n from dplyr, select a random sample of size 50 from the population, create a scatter plot for that sample, and add a least squares regression line.

# Select an additional random sample of size 50 from the population, and add the scatter plot and least squares regression line to the plot of the first random sample.

# Plot the whole dataset
set.seed(4747)
popdata <- data.frame(
  explanatory = rnorm(1000, mean = 0.06844817, sd = 4.954416), 
  response = rnorm(1000, mean = 39.94918, sd = 14.1127)
)

ggplot(popdata, aes(x = explanatory, y = response)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE)

# Take 2 samples of size 50
set.seed(4747)
sample1 <- popdata %>% sample_n(50)

sample2 <- popdata %>% sample_n(50)

# Plot sample1
plot1 <- ggplot(sample1, aes(x = explanatory, y = response)) + 
  geom_point(color = "blue") + 
  geom_smooth(method = "lm", se = FALSE, color = "blue")

plot1 

# Plot sample2 over sample1
plot1 + geom_point(data = sample2, 
                   aes(x = explanatory, y = response),
                   color = "red") + 
  geom_smooth(data = sample2, 
              aes(x = explanatory, y = response), 
              method = "lm", 
              se = FALSE, 
              color = "red")

#### Chapter 3. Superimpose lines ####
# Building on the previous exercise, you will now repeat the process 100 times in order to visualize the sampling distribution of regression lines generated by 100 different random samples of the population.

#### Instructions ####
# Using rep_sample_n (from oilabs), take 100 random samples each of size 50 from the population. The population is called popdata and the repeated samples should be called manysamples.

# Recall the arguments to rep_sample_n() are the data you want to sample, the size of the samples, and the number of samples (or replicates) you want to take.

# Within ggplot use group = replicate to plot each of the 100 sampled regression lines separately.

# Fit and tidy a linear model for each replicate by first using group_by(), then do().

# Within do() use lm() and tidy() to fit and tidy the models. Model the response variable as a function of the explanatory variable.
rep_sample_n <- function (tbl, size, replace = FALSE, reps = 1) 
{
  n <- nrow(tbl)
  i <- unlist(replicate(reps, sample.int(n, size, replace = replace), 
                        simplify = FALSE))
  rep_tbl <- cbind(replicate = rep(1:reps, rep(size, reps)), 
                   tbl[i, ])
  dplyr::group_by(rep_tbl, replicate)
}

# Repeatedly sample the population
manysamples <- popdata %>% rep_sample_n(size = 50, reps = 100)

# Plot the regression lines
ggplot(manysamples, aes(x = explanatory, y = response, group = replicate)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE)

manylms <- manysamples %>% 
  group_by(replicate) %>% 
  do(lm(response ~ explanatory, data = .) %>% 
       tidy()) %>% 
  filter(term == "explanatory")

# Plot a histogram of the slope coefficients
ggplot(manylms, aes(x = estimate)) + 
  geom_histogram()

#### Chapter 4. Original population - change sample size ####
# In order to understand the sampling distribution associated with the slope coefficient, it is valuable to visualize the impact changes in the sample and population have on the slope coefficient. Here, changing the sample size directly impacts how variable the slope is.

#### Instructions ####
# The dataset popdata is already loaded in your workplace.

# Generate 100 samples of size 50 from popdata. Plot all the lines on the same plot using group = replicate.

# Now, generate 100 samples of size 10 from the same population. Plot the 100 lines on the same plot and notice the difference in variability of lines from samples of size 10 as compared to lines from samples of size 50.

# Case 1. Take 100 samples of size 50
# get sample
manysamples1 <- popdata %>% rep_sample_n(size = 50, reps = 100)

# plot
ggplot(manysamples1, aes(x = explanatory, y = response, group = replicate)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE)

# Case 2. Take 100 samples of size 10
manysamples2 <- popdata %>% rep_sample_n(size = 10, reps = 100)

# plot
ggplot(manysamples2, aes(x = explanatory, y = response, group = replicate)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE)

#### Chapter 5. Hypothetical Population - less variability around the line ####

# In order to understand the sampling distribution associated with the slope coefficient, it is valuable to visualize the impact changes in the sample and population have on the slope coefficient. Here, reducing the variance associated with the response variable around the line changes the variability associated with the slope statistics.

# Instructions 
# 1. The new popdata is already loaded in your workspace.

# 2. The previous (more variable) population is plotted for you with regression lines from samples of size 50 super-imposed.

# 3. Take 100 samples of size 50 from the new population -- where the new population has much less variability of points around the line. That is, the new population is now different in that the points are closer to the line.

# 4. Plot the 100 lines on the same plot and notice the difference in variability of lines from the new samples as compared to lines from samples with larger variance around the line.

# Take 100 samples of size 50
manysamples <- popdata %>%
  rep_sample_n(size=50, reps=100)

# Plot a regression line for each sample
ggplot(manysamples, aes(x=explanatory, y=response, group=replicate)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) 

# Notice that the farther the points are from the line (the more variable the points are), the more variable the slope coefficients will be.

#### Chapter 6. Hypothetical Population - less variability in x direction ####

# In order to understand the sampling distribution associated with the slope coefficient, it is valuable to visualize the impact changes in the sample and population have on the slope coefficient. Here, reducing the variance associated with the explanatory variable around the line changes the variability associated with the slope statistics.

# Instructions

# (1) The new version of popdata is loaded in your workspace
# (2) Again, the previous (more variable in the x-direction) population is plotted for you with regression lines from samples of size 50 super-imposed.

# (3) Take 100 samples of size 50 from the new population -- where the new population has a smaller range of values for the explanatory variable. That is, the new population is now different in that the points are all closer to one another along the x-axis.

# (4) Plot the 100 lines on the same plot and notice the difference in variability of lines from the new samples as compared to lines from samples with a larger range of the explanatory variable.

# Take 100 samples of size 50
manysamples <- popdata %>%
  rep_sample_n(size = 50, reps = 100)

# Plot a regression line for each sample
ggplot(manysamples, aes(x=explanatory, y=response, group=replicate)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE)  +
  xlim(-17, 17)

#### Chapter 7. What changes the variability of the coefficients? ####

# The last three exercises have demonstrated how the variability in the slope coefficient can change based on changes to the population and the sample. Which of the following combinations increases the variability in the sampling distribution of the slope coefficient?

# Possible Answers 
# (1) Bigger sample size, larger variability around the line, increased range of explanatory variable.
# (2) Bigger sample size, larger variability around the line, decreased range of explanatory variable.
# (3) Smaller sample size, smaller variability around the line, increased range of explanatory variable.
# (4) Smaller sample size, larger variability around the line, decreased range of explanatory variable.
# (5) Smaller sample size, smaller variability around the line, decreased range of explanatory variable.
