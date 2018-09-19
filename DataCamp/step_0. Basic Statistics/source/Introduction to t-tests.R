Sys.setlocale("LC_ALL", "en_US.UTF-8") 
# install.packages("extrafont")
library(extrafont) ## 잊지마세요 package 불러오기!
font_import() # // 설치된 모든 폰트 가져오기

#### t-분포와 정규분포 ####
# Generate a vector of 100 values between -4 and 4
t_distribution <- function (df1 = df1, df2 = df2, df3 = df3) {
  
x <- seq(-3, 3, length = 200)

# Simulate the t-distribution
y_1 <- dt(x, df = df1)
y_2 <- dt(x, df = df2)
y_3 <- dt(x, df = df3)
  
par(family="AppleGothic")
# Plot the t-distributions
plot(x, y_1, type = "l", lwd = 2, xlab = "t-value", ylab = "Density", 
       main = paste0("t-분포의 비교, df = ", as.character(df3)), col = "black", ylim = c(0, 0.4))
lines(x, y_2, col = "red")
lines(x, y_3, col = "blue")
  
  # Add a legend
legend("topright", c(paste0("df = ", as.character(df1)), 
                     paste0("df = ", as.character(df2)), 
                     paste0("df = ", as.character(df3))
                    ), 
         col = c("black", "red", "blue"), 
         title = "t-분포", lty = 1)
  return(print("Done!!"))
}

t_lengths <- c(6, 10, 20, 30)
for (i in t_lengths) {
  t_distribution(df1 = 2, df2 = 6, df3 = i)
  Sys.sleep(2)
}
lines(x, dnorm(x, mean = 0, sd = 1), lwd = 5, col = "purple")
legend("topleft", c("정규분포 X~N(0,1)"), col = c("purple"), lty = 1, lwd = 5)

#### Chapter 2. 대응표본 ####
# Take a look at the dataset
# install.packages("psych")
library(psych)
wm <- read.csv("wm.csv")

# Create training subset of wm
wm_t <- subset(wm, wm$train == 1)

# Summary statistics 
describe(wm_t)

# Create a boxplot with pre- and post-training groups 
boxplot(wm_t$pre, wm_t$post, main = "Boxplot",
        xlab = "Pre- and Post-Training", ylab = "Intelligence Score", 
        col = c("red", "green"))

## The training subset, wm_t, is available in your workspace
wm_t

# Define the sample size
n <- nrow(wm_t)

# Mean of the difference scores
mean_diff <- sum(wm_t$gain) / n

# Standard deviation of the difference scores
sd_diff <- sqrt(sum((mean_diff - wm_t$gain)^2) / (n-1))

# Observed t-value
t_obs <- mean_diff / (sd_diff / sqrt(n))

# Print observed t-value
t_obs

# Compute the critical value
t_crit <- qt(0.975, df = 79)

# Print the critical value
t_crit

# Print the observed t-value to compare 
t_obs

# Compute Cohen's d
cohens_d <- mean_diff / sd_diff

# View Cohen's d
cohens_d

## The lsr package has been loaded for you

# Apply the t.test function
t.test(wm_t$post, wm_t$pre, paired = TRUE)

# Calculate Cohen's d
# install.packages("lsr", dependencies = T)
library(lsr)
cohensD(wm_t$post, wm_t$pre, method = "paired")

# View the wm_t dataset
wm_t

# Create subsets for each training time
wm_t08 <- subset(wm_t, wm_t$cond == "t08")
wm_t12 <- subset(wm_t, wm_t$cond == "t12")
wm_t17 <- subset(wm_t, wm_t$cond == "t17")
wm_t19 <- subset(wm_t, wm_t$cond == "t19")

# Summary statistics for the change in training scores before and after training
describe(wm_t08)
describe(wm_t12)
describe(wm_t17)
describe(wm_t19)

# Create a boxplot of the different training times
# install.packages("tidyverse", dependencies = T)
library(tidyverse)
ggplot(wm_t, aes(x = cond, y = gain, fill = cond)) + geom_boxplot()

# Levene's test
# install.packages("car", dependencies = T)
library(car)
leveneTest(wm_t$gain ~ wm_t$cond)

# Find the mean intelligence gain for both the 8 and 19 training day group
mean_t08 <- mean(wm_t08$gain)
mean_t19 <- mean(wm_t19$gain)

mean_t08
mean_t19
# Calculate mean difference by subtracting t08 by t19
mean_diff <- mean_t19 - mean_t08

# Determine the number of subjects in each sample
n_t08 <- nrow(wm_t08)
n_t19 <- nrow(wm_t19)

# Calculate degrees of freedom
df <- (n_t08 + n_t19) - 2

# Calculate variance for each group
var_t08 <- var(wm_t08$gain)
var_t19 <- var(wm_t19$gain)

# Compute pooled standard error
se_pooled <- sqrt(var_t08/n_t08 + var_t19/n_t19)
se_pooled

## All variables from the previous exercises are preloaded in your workspace

# Calculate the t-value
t_value <- mean_diff / se_pooled
t_value

# Calculate p-value
p_value <- 2 * (1 - pt(t_value, df = df))

# Calculate standard deviations
sd_t08 <- sd(wm_t08$gain)
sd_t19 <- sd(wm_t19$gain)

# Calculate the pooled stanard deviation
pooled_sd <- (sd_t08 + sd_t19) / 2

# Calculate Cohen's d
cohens_d <- (mean_t19 - mean_t08) / pooled_sd 

## The subsets wm_t08 and wm_t19 are preloaded in your workspace

# Conduct an independent t-test 
t.test(wm_t08$gain, wm_t19$gain, var.equal = TRUE)

# Calculate Cohen's d
cohensD(wm_t19$gain, wm_t08$gain, method = "pooled")

#### independent t-test easy example #### 
# Data in two numeric vectors
women_weight <- c(38.9, 61.2, 73.3, 21.8, 63.4, 64.6, 48.4, 48.8, 48.5)
men_weight <- c(67.8, 60, 63.4, 76, 89.4, 73.3, 67.3, 61.3, 62.4) 
# Create a data frame
my_data <- data.frame( 
  group = rep(c("Woman", "Man"), each = 9),
  weight = c(women_weight,  men_weight)
)

# Print all data
print(my_data)

# 연구주제는 다음과 같음
# 실제로 여성의 몸무게가 남성의 몸무게와 다른가? 비교하고 싶음
group_by(weight, group) %>%
  summarise(
    count = n(),
    mean = mean(weight, na.rm = TRUE),
    sd = sd(weight, na.rm = TRUE)
  )

ggplot(my_data, aes(x = group, y = weight, colour = group)) + geom_boxplot()

# t-test를 하기 위해서는 몇가지 사전 검증이 필요함
# 1. 남자와 여자가 독립성을 이루는가?
# 첫번째 대답은? 
# 2. 두 그룹 모두 정규분포를 이루는가? (Normal Distribution)
# shapiro.test()

# Shapiro-Wilk normality test for Men's weights
with(my_data, shapiro.test(weight[group == "Man"])) # p = 0.1

# Shapiro-Wilk normality test for Women's weights
with(my_data, shapiro.test(weight[group == "Woman"])) # p = 0.6

# 결론, 두 그룹 모두 정규성으로부터 통계적으로 유의하게 다르지 않다 = 두 그룹 모두 통계적으로 정규분포를 따른다

# 3. 두 그룹 모두 등분산성을 이루는가? 
leveneTest(weight ~ group, data = my_data)
# p-value가 0.05보다 높다는 것은 두 그룹 분산사이의 차이가 통계적으로 유의하게 다르지 않다 = 두 그룹 모두 통계적으로 등분산을 이룬다. 

# 위 3가지 조건을 만족할 때 t.test를 사용할 수 있다. 
# 만약 그렇지 않다면? 검색해보세요~~ 

# Compute t-test
res <- t.test(weight ~ group, data = my_data, var.equal = TRUE)
res

# t는 t-value (t = 2.784),
# df is 자유도 (df= 16) (왜 16일까???)
# p-value is the significance level of the t-test (p-value = 0.01327).
# conf.int is 평균의 신뢰구간 95% (conf.int = [4.0298, 29.748]).
