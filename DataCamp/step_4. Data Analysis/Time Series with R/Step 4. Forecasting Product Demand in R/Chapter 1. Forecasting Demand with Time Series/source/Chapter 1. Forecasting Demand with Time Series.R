library(zoo)
library(xts)
dates <- seq(as.Date("2014-01-19"), length = 176, by = "weeks")
url <- "https://assets.datacamp.com/production/course_6021/datasets/Bev.csv"
bev <- read.csv(url)
write.csv(bev, file = "bev.csv")
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

#### ~ Chapter 2. Plotting / visualizing data ####
# In the videos we are working with the mountain region of the beverage data. Here in the exercises you will be working with the metropolitan areas of the state to forecast their products.

# There are three products in the metropolitan areas - high end, low end, and specialty. The specialty product is not sold any where else in the state. The column names for the sales of these three products are MET.hi, MET.lo, and MET.sp respectively. Before looking at each one of these products individually, let's plot how total sales are going in the metropolitan region. The object bev_xts has been preloaded into your workspace.

# Instructions 
# (1) Create three objects called MET_hi, MET_lo, and MET_sp from the three columns MET.hi, MET.lo, and MET.sp respectively from your xts object bev_xts.
# Create the individual region sales as their own objects
MET_hi <- bev_xts[,"MET.hi"]
MET_lo <- bev_xts[,"MET.lo"]
MET_sp <- bev_xts[,"MET.sp"]

# (2) Sum these three regions sales together into one object called MET_t
MET_t <- MET_hi + MET_lo + MET_sp

# (3) Plot the MET_t object to visualize the sales of the metropolitan region of the state.
plot(MET_t)

# Well done! Now let's forecast that sales data you just looked at!
