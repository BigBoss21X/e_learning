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

#### Chapter 1. Simulating the probability of A and B ####
