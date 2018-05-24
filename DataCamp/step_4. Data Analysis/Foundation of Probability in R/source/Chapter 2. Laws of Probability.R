#### Lecture 1. Probability of eventA and eventB ####
# Event A: Coin is heads
# A = 1, A = 0

# Probability of A and B
# Pr(A and B) = Pr(A) * Pr(B)

# Simulating two coins
A <- rbinom(100000, 1, .5)
B <- rbinom(100000, 1, .5)

# A & B
A & B
mean(A & B) # Pr(A and B) = Pr(A) * Pr(B)
# Pr(A and B) = .5 * .5 = .25
A <- rbinom(100000, 1, .1)
B <- rbinom(100000, 1, .7)

mean(A & B)
# A & B
A & B
mean(A & B) # Pr(A and B) = Pr(A) * Pr(B)

#### ~ Chapter 1. Simulating the probability of A and B ####
# You can also use simulation to estimate the probability of two events both happening.

# Randomly simulate 100,000 flips of coin A, each of which has a 40% chance of being heads. Save this as a variable A.

# Simulate 100,000 flips of a coin with a 40% chance of heads
A <- rbinom(100000, 1, .4)

# Randomly simulate 100,000 flips of coin B, each of which has a 20% chance of being heads. Save this as a variable B.

# Simulate 100,000 flips of a coin with a 20% chance of heads
B <- rbinom(100000, 1, .2)

# Use the "and" operator (&) to combine the variables A and B to estimate the probability that both A and B are heads. 

# Estimate the probability both A and B are heads
mean(A & B)

#### ~ Chapter 2. Simulating the probability of A, B, and C ####

# Randomly simulate 100,000 flips of A (40% chance), B (20% chance), and C (70% chance). What fraction of the time do all three coins come up heads?

#### Instructions ####
# You've already simulated A and B. Now simulate 100,000 flips of coin C, where each has a 70% chance of coming up heads.

# You've already simulated 100,000 flips of coins A and B
A <- rbinom(100000, 1, .4)
B <- rbinom(100000, 1, .2)

# Use A, B, and C to estimate the probability that all three coins would come up heads.

# Simulate 100,000 flips of coin C (70% chance of heads)
C <- rbinom(100000, 1, .7)

# Estimate the probability A, B, and C are all heads
mean(A & B & C)

#### Lecture 2. Probability of A or B ####
# Pr(A or B) = Pr(A) + Pr(B) - Pr(A and B)
# Pr(A or B) = Pr(A) + Pr(B) - Pr(A) * Pr(B)

# Simulating two events
A <- rbinom(100000, 1, .5)
B <- rbinom(100000, 1, .5)

mean(A | B)

A <- rbinom(100000, 1, .2)
B <- rbinom(100000, 1, .6)

mean(A | B)

#### ~ Question 1. Solving for probability of A or B ####
# If coins A and B are independent, and A has a 60% chance of coming up heads, and event B has a 10% chance of coming up heads, what is the probability either A or B will come up heads?

# Possible Answers 
# (1) 6% (2) 50% (3) 64% (4) 70%

# The answer is 64%

#### ~ Chapter 1. Simulating probability of A or B ####
# In the last multiple choice exercise you found that there was a 64% chance that either coin A (60% chance) or coin B (10% chance) would come up heads. Now you'll confirm that answer using simulation.

# Instructions 
# Use rbinom() to simulate 100,000 flips of coin A, each having a 60% chance of being heads.

# Simulate 100,000 flips of a coin with a 60% chance of heads
A <- rbinom(100000, 1, .6)

# Use rbinom() to simulate 100,000 flips of coin B, each having a 10% chance of being heads.

# Simulate 100,000 flips of a coin with a 10% chance of heads
B <- rbinom(100000, 1, .1)

# Use these to estimate the probability that A or B is heads.
# Estimate the probability either A or B is heads
mean(A | B)

#### ~ Chapter 2. Probability either variable is less than or equal to 4 ####
# Suppose X is a random Binom(10, .6) variable (10 flips of a coin with 60% chance of heads) and Y is a random Binom(10, .7) variable (10 flips of a coin with a 70% chance of heads), and they are independent.

# What is the probability that either of the variables is less than or equal to 4?
  
# Instructions 
# (1) Simulate 100,000 draws from each of X (10 coins, 60% chance of heads) and Y (10 coins, 70% chance of heads) binomial variables, saving them as X and Y respectively.

# Use rbinom to simulate 100,000 draws from each of X and Y
X <- rbinom(100000, 10, .6)
Y <- rbinom(100000, 10, .7)

# (2) Use these simulations to estimate the probability that either X or Y is less than or equal to 4.

# Estimate the probability either X or Y is <= to 4
mean(X <= 4 | Y <= 4)

# (3) Use the pbinom() function to calculate the exact probability that X is less than or equal to 4, then the probability that Y is less than or equal to 4.
prob_X_less <- pbinom(4, 10, .6)
prob_Y_less <- pbinom(4, 10, .7)

# Combine these two exact probabilities to calculate the exact probability that either variable is less than or equal to 4.
prob_X_less + prob_Y_less - prob_X_less * prob_Y_less

#### Simulation is a great way of avoiding difficult calculations

#### Lecture 3. Multiplying random variables ####
# X ~ Binomial(10, .5)

# Multiplying a random variable 
# Y ~ 3 * X

X <- rbinom(100000, 10, .5)
mean(X)

Y <- 3 * X
mean(Y)

# Simulation: Effect of multiplying on expected value
# E[k * X] = k * E[X]

# Simulation: Effect of multiplying on variance
X <- rbinom(100000, 10, .5)
var(X)

Y <- 3 * X
var(Y)

# Var[k*X] = k^2 * Var[X]

# Rules of manipulating random variables
# E[k * X] = k * E[X]
# Var(k * Y) = K^2 * Var(X)

#### ~ Exercise. Expected value of multiplying a random variable ####
# If X is a binomial with size 50 and p = .4, what is the expected value of 3 * X?

X <- rbinom(100000, 50, .4)
3 * mean(X)
#### ~ Chapter 1. Simulating multiplying a random variable ####
# In this exercise you'll use simulation to confirm the rule you just learned about how multiplying a random variable by a constant effects its expected value.

# Instructions
# Simulate 100,000 draws of X, a binomial random variable with size 20 and p = .1. Save this as X
X <- rbinom(100000, 20, .1)

# Use this simulation to estimate the expected value of X.
mean(X)

# Use this simulation to estimate the expected value of 5*X, as well.
mean(5 * X)

#### ~ Chapter 2. Variance of a multiplied random variable ####
# In the last exercise you simulated X from a binomial with size 20 and p = .1 and now you'll use this same simulation to explore the variance.

# Instructions 
# X is simulated from 100,000 draws of a binomial with size 20 and p = .1
X <- rbinom(100000, 20, .1)

# Use this simulation to estimate the variance of X.
var(X)

# Estimate the variance of 5 * X
var(5 * X)

#### Lecture 4. Adding two random variables ####
# Adding two random variables 
X ~ Binom(10, .5)
Y ~ Binom(100, .2)

Z ~ X + Y

# Simulation: expected value of X + Y
X <- rbinom(100000, 10, .5)
mean(X)

Y <- rbinom(100000, 100, .2)
mean(Y)

Z <- X + Y
mean(Z)

# Rules for combining random variables 
# E[X + Y] = E[X] + E[Y]
# (Even if X and Y aren't independent)
# Var[X + Y] = Var[X] + Var[Y]
# (Only if X and Y are independent)

#### ~ Exercise Solving for the sum of two binomial variables ####
# If X is drawn from a binomial with size 20 and p = .3, and Y from size 40 and p = .1, what is the expected value (mean) of X + Y?

X <- rbinom(100000, 20, .3)
Y <- rbinom(100000, 40, .1)

Z <- X + Y
mean(Z)

#### ~ Chapter 1. Simulating adding two binomial variables ####
# In the last multiple choice exercise, you found the expected value of the sum of two binomials. In this problem you'll use a simulation to confirm your answer.

# Instructions 
# Simulate 100,000 draws from X, a binomial with size 20 and p = .3, and Y, with size 40 and p = .1.

# Simulate 100,000 draws of X (size 20, p = .3) and Y (size 40, p = .1)
X <- rbinom(100000, 20, .3)
Y <- rbinom(100000, 40, .1)

# Use this simulation to estimate the expected value of X + Y. 
# Estimate the expected value of X + Y
mean(X + Y)

# Great Job! The fact that you can add the means makes stuff much simpler. 

#### ~ Chapter 2. Simulating variance of sum of two binomial variables ####
# In the last multiple choice exercise, you examined the expected value of the sum of two binomials. Here you'll estimate the variance.

#### Instructions ####
# Use your simulation of the variables X and Y to estimate the variance of X + Y.

# Simulation from last exercise of 100,000 draws from X and Y
X <- rbinom(100000, 20, .3) 
Y <- rbinom(100000, 40, .1)

# Find the variance of X + Y
var(X + Y)

# Find the variance of 3 * X + Y
var(3 * X + Y)

# Great simulating! Remember this rule only works when X and Y are independent.
