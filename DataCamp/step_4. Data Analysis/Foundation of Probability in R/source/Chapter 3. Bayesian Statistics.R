#### Lecture 1. Updating with evidence ####
# 20 flips of a coin 
# result is 14 heads, 6 tails <- 현재 기준

# if cois is fair
fair <- rbinom(50000, 20, .5)
sum(fair == 14)

# if cois is biased
biased <- rbinom(50000, 20, .75)
sum(biased == 14)

1825 + 8363

# Pr(Biased|14Heads) = # biased w/14 Heads divided by # total w/14 Heads
8363 / (1825 + 8363) 
# 82%, coin is biased. 

#### ~ Exercise 1. Updating ####
# Suppose you have a coin that is equally likely to be fair (50% heads) or biased (75% heads). You then flip the coin 20 times and see 11 heads.

# Without doing any math, which do you now think is more likely- that the coin is fair, or that the coin is biased?
fair <- rbinom(10000, 20, .5)
biased <- rbinom(10000, 20, .75)
sum(fair == 11)
sum(biased == 11)

298 / (1631 + 298)

# 15%, coin is biased

#### ~ Chapter 1. Updating with simulation ####
# We see 11 out of 20 flips from a coin that is either fair (50% chance of heads) or biased (75% chance of heads). How likely is it that the coin is fair? Answer this by simulating 50,000 fair coins and 50,000 biased coins.

# Instructions 
# Simulate 50,000 cases of flipping 20 coins from a fair coin (50% chance of heads), as well as from a biased coin (75% chance of heads). Save these variables as fair and biased respectively.
fair <- rbinom(50000, 20, 0.5)
biased <- rbinom(50000, 20, 0.75)

# Find the number of fair coins where exactly 11/20 came up heads, then the number of biased coins where exactly 11/20 came up heads. Save them as fair_11 and biased_11 respectively.
(fair_11 <- sum(fair == 11))
(biased_11 <- sum(biased == 11))

# Find the fraction of all coins that came up heads 11 times that were fair coins- this is the posterior probability that a coin with 11/20 is fair.
fair_11 / (fair_11 + biased_11)

#### ~ Chapter 2. Updating with simulation after 16 heads ####
# We see 16 out of 20 flips from a coin that is either fair (50% chance of heads) or biased (75% chance of heads). How likely is it that the coin is fair? 

# Instructions 
# Simulate 50,000 cases of flipping 20 coins from a fair coin (50% chance of heads), as well as from a biased coin (75% chance of heads). Save these variables as fair and biased respectively.
fair <- rbinom(50000, 20, 0.5)
biased <- rbinom(50000, 20, 0.75)

# Find the number of fair coins where exactly 16/20 came up heads, then the number of biased coins where exactly 16/20 came up heads. Save them as fair_16 and biased_16 respectively.
(fair_16 <- sum(fair == 16))
(biased_16 <- sum(biased == 16))

# Find the fraction of all coins that came up heads 16 times that were fair coins- this is the posterior probability that a coin with 16/20 is fair.
fair_16 / (fair_16 + biased_16)
