# In these exercises, you'll practice using the rbinom() function, which generates random "flips" that are either 1 ("heads") or 0 ("tails").

# Flipping a coin in R
rbinom(1, 1, .5)

# Flipping multiple coins
?rbinom(n, size, prob)
rbinom(10, 1, .5)
rbinom(1, 10, .5)
rbinom(10, 10, .5)

# Unfair coins
rbinom(10, 10, .8)
rbinom(10, 10, .2)

#### Chapter 1. Simulating coin flips ####
# With one line of code, simulate 10 coin flips, each with a 30% chance of coming up 1 ("heads").
rbinom(10, 1, .3)

#### Chapter 2. Simulating draws from a binomial ####
# Use the rbinom() function to simulate 100 separate occurrences of flipping 10 coins, where each coin has a 30% chance of coming up heads.
rbinom(100, 10, .3)

#### Lecture 2. Density and Cumulative Density ####
# Simulating many outcomes
# X ~ Binomial(10, .5) --> Pr(x = 5)
flips <- rbinom(100000, 10, .5)
flips == 5
mean(flips == 5)

# Calculating exact probability density
dbinom(5, 10, .5)
dbinom(6, 10, .5)
dbinom(10, 10, .5)

# X ~ Binomial(10, .5) --> Pr(x <= 4)
# Cumulative Density
flips <- rbinom(100000, 10, .5)
mean(flips <= 4)
pbinom(4, 10, .5)

#### ~ Chapter 1. Calculating density of a binomial ####
# If you flip 10 coins each with a 30% probability of coming up heads, what is the probability exactly 2 of them are heads?

# Instructions
# Answer the above question using the dbinom() function. This function takes almost the same arguments as rbinom(). The second and third arguments are size and prob, but now the first argument is x instead of n. Use x to specify where you want to evaluate the binomial density.
# Calculate the probability that 2 are heads using dbinom
dbinom(2, 10, .3)

# Confirm your answer using the rbinom() function by creating a simulation of 10,000 trials. Put this all on one line by wrapping the mean() function around the rbinom() function.

# Confirm your answer with a simulation using rbinom
mean(rbinom(10000, 10, .3) == 2)

#### ~ Chapter 2. Calculating cumulative density of a binomial ####
# If you flip ten coins that each have a 30% probability of heads, what is the probability at least five are heads?

# Instructions
# Answer the above question using the pbinom() function. (Note that you can compute the probability that the number of heads is less than or equal to 4, then take 1 - that probability).

# Calculate the probability that at least five coins are heads
1 - pbinom(4, 10, .3)

# Confirm your answer with a simulation of 10,000 trials by finding the number of trials that result in 5 or more heads.
mean(rbinom(10000, 10, .3) >= 5)

#### ~ Chapter 3. Varying the number of trials ####
# In the last exercise you tried flipping ten coins with a 30% probability of heads to find the probability at least five are heads. You found that the exact answer was 1 - pbinom(4, 10, .3) = 0.1502683, then confirmed with 10,000 simulated trials.
# Did you need all 10,000 trials to get an accurate answer? Would your answer have been more accurate with more trials?

# Here is how you computed the answer in the last problem
mean(rbinom(10000, 10, .3) >= 5)

# Try answering this question with simulations of 100, 1000, 10000, 100000 trials
mean(rbinom(100, 10, .3) >= 5)
mean(rbinom(1000, 10, .3) >= 5)
mean(rbinom(10000, 10, .3) >= 5)
mean(rbinom(100000, 10, .3) >= 5)

#### Lecture 3. Expected value and variance ####
# Expected Value
# X ~ Binomial(size, p)
flips <- rbinom(100000, 10, .5)
mean(flips)
mean(rbinom(1000000, 100, .2))
# Variance
# X ~ Binomial(10, .5)

x <- rbinom(1000000, 10, .5)
var(x)
# Var(X) = size * p * (1-p)
# Var(X) X ~ Binomial(size, p)
# E[X] = size * p
# Var(X) = size * p * (1-p)

#### ~ Chapter 1. Calculating the expected value ####
# Calculating the expected value
# What is the expected value of a binomial distribution where 25 coins are flipped, each having a 30% chance of heads?

# Instructions
# Calculating this using the exact formula you learned in the lecture: the expected value of the binomial is size * p. Print this result to the screen. 
# Calculate the expected value using the exact formula
25 * 0.3

# Confirm with a simulation of 10,000 draws from the binomial. 
mean(rbinom(10000, 25, 0.3))

#### ~ Chapter 2. Calculating the variance ####

# What is the variance of a binomial distribution where 25 coins are flipped, each having a 30% chance of heads?

# Instructions 
# Calculate this using the exact formula you learned in the lecture: the variance of the binomial is size * p * (1 - p). Print this result to the screen.
# Calculate the variance using the exact formula
25 * 0.3 * 0.7

# Confirm with a simulation of 10,000 trials.
# Confirm with a simulation using rbinom
var(rbinom(10000, 25, 0.3))
