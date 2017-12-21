rm(list = ls())
# web: https://plot.ly/r/
# Chapter 1. Let's get started
# load the `plotly` package
library(plotly)

# This will create your very first plotly visualization
plot_ly(z = ~volcano)

# Chapter 2. Plotly diamonds are forever
# The diamonds dataset
str(diamonds)

# A firs scatterplot has been made for you
plot_ly(diamonds, x = ~carat, y = ~price)

# Replace ___ with the correct vector
plot_ly(diamonds, x = ~carat, y = ~price, color = ~carat)

# Replace ___ with the correct vector
plot_ly(diamonds, x = ~carat, y = ~price, color = ~carat, size = ~carat)

# Chapter 3. The interactive bar chart
library(dplyr)
# Calculate the numbers of diamonds for each cut<->clarity combination
diamonds_bucket <- diamonds %>% count(cut, clarity)

# Replace ___ with the correct vector
plot_ly(diamonds_bucket, x = ~cut, y = ~n, type = "bar", color = ~clarity) 
