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

# Chapter 5. What can you extract?
# As you saw in the video, components of a datetime can be extracted by lubridate functions with the same name like year(), month(), day(), hour(), minute() and second(). They all work the same way just pass in a datetime or vector of datetimes.

# There are also a few useful functions that return other aspects of a datetime like if it occurs in the morning am(), during daylight savings dst(), in a leap_year(), or which quarter() or semester() it occurs in.

# Try them out by exploring the release times of R versions using the data from Chapter 1.

# We've put release_time, the datetime column of the releases dataset from Chapter 1, in your workspace.
# Use read_csv() to import rversions.csv
url <- "https://assets.datacamp.com/production/course_5348/datasets/rversions.csv"
releases <- read_csv(url)

# write csv
write.csv(releases, "rversions.csv", row.names = F)
rm(list = "releases")

url <- "https://assets.datacamp.com/production/course_5348/datasets/cran-logs_2015-04-17.csv"
logs <- read_csv(url)
write.csv(logs, "cran-logs_2015-04-17.csv", row.names = F)

# Use read_csv() to import cran-logs_2015-04-17.csv.
logs <- read_csv("cran-logs_2015-04-17.csv")

# import csv
releases <- read_csv("rversions.csv")

# Examine the structure of the date column
str(releases$date)

# (1) Examine the head() of release_time to verify this is a vector of datetimes.
# Examine the head() of release_time
release_time <- as.POSIXct("2015-04-16 07:13:33", tz = "UTC")
head(release_time)

# (2) Extract the month from release_time and examine the first few with head().
# Examine the head() of the months of release_time
head(month(release_time))

# (3) To see which months have most releases, extract the month then pipe to table().
# Extract the month of releases 
month(releases$datetime) %>% table()

# (4) Repeat, to see which years have the most releases.
# Extract the year of releases
year(releases$datetime) %>% table()

# (5) Do releases happen in the morning (UTC)? Find out if the hour of a release is less than 12 and summarise with mean().
# How often is the hour before 12 (noon)?
mean(table(releases$datetime) < 12)

# (6) Alternatively use am() to find out how often releases happen in the morning.
# How often is the release in am?
mean(am(releases$datetime))

# Chapter 6. Adding useful labels
# adding useful labels
head(month(release_time))

# and received numeric months in return. Sometimes it's nicer (especially for plotting or tables) to have named months. Both the month() and wday() (day of the week) functions have additional arguments label and abbr to achieve just that. Set label = TRUE to have the output labelled with month (or weekday) names, and abbr = FALSE for those names to be written in full rather than abbreviated.

# head(month(release_time, label = TRUE, abbr = FALSE))
# Practice by examining the popular days of the week for R releases.

# releases is now a data frame with a column called datetime with the release time.

# (1) First, see what wday() does without labeling, by calling it on the datetime column of releases and tabulating the result. Do you know if 1 is Sunday or Monday?
library(ggplot2)
# Use wday() to tabulate release by day of the week
wday((releases$datetime)) %>% table()
  
# (2) Repeat above, but now use labels by specifying the label argument. Better, right?
wday(releases$datetime, label = TRUE, abbr = FALSE) %>% table()
  
# (3) Now store the labelled weekdays in a new column called wday.
# Create column wday to hold labelled week days
releases$wday <- wday(releases$datetime, label = TRUE)

# (4) Create a barchart of releases by weekday, facetted by the type of release.
# Plot barchart of weekday by type of release
ggplot(releases, aes(wday)) +
  geom_bar() +
  facet_wrap(~ type, ncol = 1, scale = "free_y")

# Chapter 7. Extracting for plotting
# Extracting components from a datetime is particularly useful when exploring data. Earlier in the chapter you imported daily data for weather in Auckland, and created a time series plot of ten years of daily maximum temperature. While that plot gives you a good overview of the whole ten years, it's hard to see the annual pattern.

# In this exercise you'll use components of the dates to help explore the pattern of maximum temperature over the year. The first step is to create some new columns to hold the extracted pieces, then you'll use them in a couple of plots.
library(ggplot2)
library(dplyr)
# install.packages("ggridges")
library(ggridges)

# (1) Use mutate() to create three new columns: year, yday and month that respectively hold the same components of the date column. Don't forget to label the months with their names.
# Add columns for year, yday and month
akl_daily <- akl_daily %>%
  mutate(
    year = year(date),
    yday = yday(date),
    month = month(date, label = TRUE, abbr = TRUE))

# (2) Create a plot of yday on the x-axis, max_temp of the y-axis where lines are grouped by year. Each year is a line on this plot, with the x-axis running from Jan 1 to Dec 31.
# Plot max_temp by yday for all years
ggplot(akl_daily, aes(x = yday, y = max_temp)) +
  geom_line(aes(group = 1), alpha = 0.5)

# (3) To take an alternate look, create a ridgeline plot(formerly known as a joyplot) with max_temp on the x-axis, month on the y-axis, using geom_density_ridges() from the ggridges package.
# Examine distribtion of max_temp by month
ggplot(akl_daily, aes(x = max_temp, y = month, height = ..density..)) +
  geom_density_ridges(stat = "density")

# Chapter 8. Extracting for filtering and summarizing
# Another reason to extract components is to help with filtering observations or creating summaries. For example, if you are only interested in observations made on weekdays (i.e. not on weekends) you could extract the weekdays then filter out weekends, e.g. wday(date) %in% 2:6.

# In the last exercise you saw that January, February and March were great times to visit Auckland for warm temperatures, but will you need a raincoat?
  
# In this exercise you'll find out! You'll use the hourly data to calculate how many days in each month there was any rain during the day.

# (1) Create new columns for the hour and month of the observation from datetime. Make sure you label the month.
# Create new columns hour, month and rainy
akl_hourly <- akl_hourly %>%
  mutate(
    hour = hour(datetime),
    month = month(datetime, TRUE),
    rainy = weather == "Precipitation"
  )

# (2) Filter to just daytime observations, where the hour is greater than 8 and less than 22.
# Filter for hours between 8am and 10pm (inclusive)
akl_day <- akl_hourly %>% 
  filter(hour > 8, hour < 22)


# (3) Group the observations first by month, then by date, and summarise by using any() on the rainy column. This results in one value per day
# Summarise for each date if there is any rain
rainy_days <- akl_day %>% 
  group_by(month, date) %>%
  summarise(
    any_rain = any(rainy)
  )

# (4) Summarise again by summing any_rainy. This results in one value per month
# Summarise for each month, the number of days with rain
rainy_days %>% 
  summarise(
    days_rainy = sum(any_rain)
  )

# Chapter 9. Rounding datetimes
# As you saw in the video, round_date() rounds a date to the nearest value, floor_date() rounds down, and ceiling_date() rounds up.

# All three take a unit argument which specifies the resolution of rounding. You can specify "second", "minute", "hour", "day", "week", "month", "bimonth", "quarter", "halfyear", or "year". Or, you can specify any multiple of those units, e.g. "5 years", "3 minutes" etc.

# Try them out with the release datetime of R 3.4.1.

r_3_4_1 <- ymd_hms("2016-05-03 07:13:28 UTC")

# Round down to day
round_date(r_3_4_1, unit = "day")

# Round to nearest 5 minutes
round_date(r_3_4_1, unit = "5 minutes")

# Round up to week 
ceiling_date(r_3_4_1, unit = "week")

# Subtract r_3_4_1 rounded down to day
r_3_4_1 - floor_date(r_3_4_1, unit = "day")

# Chapter 10. Rounding with the weather data
# When is rounding useful? In a lot of the same situations extracting date components is useful. The advantage of rounding over extracting is that it maintains the context of the unit. For example, extracting the hour gives you the hour the datetime occurred, but you lose the day that hour occurred on (unless you extract that too), on the other hand, rounding to the nearest hour maintains the day, month and year.

# As an example you'll explore how many observations per hour there really are in the hourly Auckland weather data.

# (1) Create a new column called day_hour that is datetime rounded down to the nearest hour.
# Create day_hour, datetime rounded down to hour
akl_hourly <- akl_hourly %>%
  mutate(
    day_hour = floor_date(datetime, unit = "hour")
  )

# (2) Use count() on day_hour to count how many observations there are in each hour. What looks like the most common value?
# Count observations per hour  
akl_hourly %>% 
  count(day_hour) 

# (3) Extend the pipeline, so that after counting, you filter for observations where n is not equal to 2.
# Find day_hours with n != 2  
akl_hourly %>% 
  count(day_hour) %>%
  filter(n != 2) %>% 
  arrange(desc(n))

# 구서영 내 사랑, 영원히 사랑한다고~ 꺄~~~~
# 구서영, 너 지훈이 얼마나 좋아하니??? 
