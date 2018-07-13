library(zoo)
library(xts)
dates <- seq(as.Date("2014-01-19"), length = 176, by = "weeks")
url <- "https://assets.datacamp.com/production/course_6021/datasets/Bev.csv"
bev <- read.csv(url)
bev_xts <- xts(bev, order.by = dates)

#### ~ Chapter 1. Importind Data ####
# There are a lot of ways to import data into R! Once the data is imported into R, we need to transform the data into an xts object to help with analysis. These xts objects are so much easier to plot and manipulate.

# In this exercise you are going to create a date index and then turn your data into an xts object. Your data has been imported for you into an object called bev.

# Instructions 
# (1) Load the xts object using the library() function.
# Load xts package
library(xts)

# (2) Create a date index object called dates that is 176 weeks long starting on Jan, 19, 2014.
# Create the dates object as an index for your xts object
dates <- seq(as.Date("2014-01-19"), length = 176, by = "weeks")

# (3) Create an xts object called bev_xts based on the dates object for your index and the bev object for your data.
bev_xts <- xts(bev, order.by = dates)

# Well done! Now you have your data ready for analysis!
