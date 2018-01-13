# Chapter 1. Selecting the right parsing function
# lubridate provides a set of functions for parsing dates of a known order. For example, ymd() will parse dates with year first, followed by month and then day. The parsing is flexible, for example, it will parse the m whether it is numeric (e.g. 9 or 09), a full month name (e.g. September), or an abbreviated month name (e.g. Sep).

# All the functions with y, m and d in any order exist. If your dates have times as well, you can use the functions that start with ymd, dmy, mdy or ydm and are followed by any of _h, _hm or _hms.

# To see all the functions available look at ymd() for dates and ymd_hms() for datetimes.

# Here are some challenges. In each case we've provided a date, your job is to choose the correct function to parse it.

# For each date the ISO 8601 format is displayed as a comment after it, to help you check your work
library(lubridate)

# Choose the correct function to parse x.
# Parse x 
x <- "2010 September 20th" # 2010-09-20
ymd(x)

# Choose the correct function to parse y.
# Parse y 
y <- "02.01.2010"  # 2010-01-02
dmy(y)

# Choose the correct function to parse z.
# Parse z 
z <- "Sep, 12th 2010 14:00"  # 2010-09-12T14:00
mdy_hm(z)

# Chapter 2. Specifying an order with `parse_date_time()`
# What about if you have something in a really weird order like dym_msh? There's no named function just for that order, but that is where parse_date_time() comes in. parse_date_time() takes an additional argument orders where you can specify the order of the components in the date.

# For example, to parse "2010 September 20th" you could say parse_date_time("2010 September 20th", orders = "ymd") and that would be equivalent to using the ymd() function from the previous exercise.

# One advantage of parse_date_time() is that you can use more format characters. For example, you can specify weekday names with a, I for 12 hour time, am/pm indicators with p and many others. You can see a whole list on the help page ?parse_date_time.

# Another big advantage is that you can specify a vector of orders, and that allows parsing of dates where multiple formats might be used.

# x is a trickier datetime. Use the clues in the instructions to parse x.
x <- "Monday June 1st 2010 at 4pm"
parse_date_time(x, orders = "AmdyIp")

# two_orders has two different orders, parse both by specifying the order to be c("mdy", "dmy").
# Specify order to include both "mdy" and "dmy"
two_orders <- c("October 7, 2001", "October 13, 2002", "April 13, 2003", 
                "17 April 2005", "23 April 2017")
parse_date_time(two_orders, orders = c("mdy", "dmy"))

# Parse short_dates with orders = c("dOmY", "OmY", "Y"). What happens to the dates that don't have months or days specified?
# Specify order to include "dOmY", "OmY" and "Y"
short_dates <- c("11 December 1282", "May 1372", "1253")
parse_date_time(short_dates, orders = c("dOmY", "OmY", "Y"))

# Chapter 3. Import daily weather data
# In practice you won't be parsing isolated dates and times, they'll be part of a larger dataset. Throughout the chapter after you've mastered a skill with a simpler example (the release times of R for example), you'll practice your lubridate skills in context by working with weather data from Auckland NZ.

# There are two data sets: akl_weather_daily.csv a set of once daily summaries for 10 years, and akl_weather_hourly_2016.csv observations every half hour for 2016. You'll import the daily data in this exercise and the hourly weather in the next exercise.

# You'll be using functions from dplyr, so if you are feeling rusty, you might want to review filter(), select() and mutate().

library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)

# Import the daily data, "akl_weather_daily.csv" with read_csv().
url <- "https://assets.datacamp.com/production/course_5348/datasets/akl_weather_daily.csv"
akl_daily_raw <- read_csv(url)
write_csv(akl_daily, "akl_weather_daily.csv")
akl_daily_raw <- read_csv("akl_weather_daily.csv")

# Print akl_daily_raw to confirm the date column hasn't been interpreted as a date. Can you see why?
akl_daily_raw

# Using mutate() overwrite the column date with a parsed version of date. You need to specify the parsing function. Hint: the first date should be September 1.
# Parse date 
akl_daily <- akl_daily_raw %>%
  mutate(date = as.Date(date))

# Print akl_daily to verify the date column is now a Date.
akl_daily

# Take a look at the data by plotting date on the x-axis and max_temp of the y-axis.
# Plot to check work
ggplot(akl_daily, aes(x = date, y = max_temp)) +
  geom_line() 

# Chapter 4. Import hourly weather data
# The hourly data is a little different. The date information is spread over three columns year, month and mday, so you'll need to use make_date() to combine them.

# Then the time information is in a separate column again, time. It's quite common to find date and time split across different variables. One way to construct the datetimes is to paste the date and time together and then parse them. You'll do that in this exercise.

# Import the hourly data, "akl_weather_hourly_2016.csv" with read_csv(), then print akl_hourly_raw to confirm the date is spread over year, month and mday.
# Import "akl_weather_hourly_2016.csv"
url <- "https://assets.datacamp.com/production/course_5348/datasets/akl_weather_hourly_2016.csv"
akl_hourly_raw <- read_csv(url)
write_csv(akl_hourly_raw, "akl_weather_hourly_2016.csv")
akl_hourly_raw <- read_csv("akl_weather_hourly_2016.csv")

# Using mutate() create the column date with using make_date().
# Use make_date() to combine year, month and mday 
akl_hourly  <- akl_hourly_raw  %>% 
  mutate(date = make_date(year = year, month = month, day = mday))

# We've pasted together the date and time columns. Create datetime by parsing the datetime_string column.
# Parse datetime_string 
akl_hourly <- akl_hourly  %>% 
  mutate(
    datetime_string = paste(date, time, sep = "T"),
    datetime = ymd_hms(datetime_string)
  )

# Take a look at the date, time and datetime columns to verify they match up.
# Print date, time and datetime columns of akl_hourly
akl_hourly %>% select(date, time, datetime)

# Take a look at the data by plotting datetime on the x-axis and temperature of the y-axis.
# Plot to check work
ggplot(akl_hourly, aes(x = datetime, y = temperature)) +
  geom_line()
