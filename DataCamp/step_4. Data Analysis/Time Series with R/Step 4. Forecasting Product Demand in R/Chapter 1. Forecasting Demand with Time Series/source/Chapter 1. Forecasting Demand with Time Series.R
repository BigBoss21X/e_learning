library(zoo)
library(xts)
dates <- seq(as.Date("2014-01-19"), length = 176, by = "weeks")
url <- "https://assets.datacamp.com/production/course_6021/datasets/Bev.csv"
bev <- read.csv(url)
bev_xts <- xts(bev, order.by = dates)
