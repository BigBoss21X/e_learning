OlsonNames()
# Chapter 1. Setting the timezone

# If you import a datetime and it has the wrong timezone, you can set it with force_tz(). Pass in the datetime as the first argument and the appropriate timezone to the tzone argument. Remember the timezone needs to be one from OlsonNames().

# I wanted to watch New Zealand in the Women's World Cup Soccer games in 2015, but the times listed on the FIFA website were all in times local to the venues. In this exercise you'll help me set the timezones, then in the next exercise you'll help me figure out what time I needed to tune in to watch them.

# I've put the times as listed on the FIFA website for games 2 and 3 in the group stage for New Zealand in your code.

# Game2: CAN vs NZL in Edmonton
library(lubridate)
game2 <- mdy_hm("June 11 2015 19:00")

# Game3: CHN vs NZL in Winnipeg
game3 <- mdy_hm("June 15 2015 18:30")

# Game 2 was played in Edmonton. Use force_tz() to set the timezone of game 2 to "America/Edmonton".
# Set the timezone to "America/Edmonton"
game2_local <- force_tz(game2, tzone = "America/Edmonton")
game2_local

# Game 3 was played in Winnipeg. Use force_tz() to set the timezone of game 3 to "America/Winnipeg".
game3_local <- force_tz(game3, tzone = "America/Winnipeg")
game3_local

# Find out how long the team had to rest between the two games, by using as.period() on the interval between game2_local and game3_local.
# How long does the team have to rest?
as.period(game2_local %--% game3_local)

# Chapter 2. Viewing in a timezone
# To view a datetime in another timezone use with_tz(). The syntax of with_tz() is the same as force_tz(), passing a datetime and set the tzone argument to the desired timezone. Unlike force_tz(), with_tz() isn't changing the underlying moment of time, just how it is displayed.

# For example, the difference between now() displayed in the "America/Los_Angeles" timezone and and "Pacific/Auckland" timezone is 0:

# now <- now()
# with_tz(now, "America/Los_Angeles") - with_tz(now,  "Pacific/Auckland")
now <- now()
with_tz(now, "Japan")

# Help me figure out when to tune into the games from the previous exercise.
  
# (1) Most fans will tune in from New Zealand. Use with_tz() to display game2_local in New Zealand time. New Zealand is in the "Pacific/Auckland" timezone.
# What time is game2_local in NZ?
with_tz(game2_local, tzone = "Pacific/Auckland")
  
# (2) I'll be in Corvallis, Oregon. Use with_tz() to display game2_local my time. Corvallis is in the "America/Los_Angeles" timezone.
# What time is game2_local in Corvallis, Oregon?
with_tz(game2_local, tzone = "America/Los_Angeles")
  
# (3) Finally, use with_tz() to display game3_local in New Zealand time.
# What time is game3_local in NZ?
with_tz(game3_local, tzone = "Pacific/Auckland")
OlsonNames()

# Chapter 3. Timezones in the weather data
# Did you ever notice that in the hourly Auckland weather data there was another datetime column, date_utc? Take a look:
  
# tibble::glimpse(akl_hourly)

# The datetime column you created represented local time in Auckland, NZ. I suspect this additional column, date_utc represents the observation time in UTC (the name seems a big clue). But does it really?
  
# Use your new timezone skills to find out.
# data import
library(tidyverse)
library(readr)
akl_hourly_raw <- read_csv("akl_weather_hourly_2016.csv")
akl_hourly  <- akl_hourly_raw  %>% 
  mutate(date = make_date(year = year, month = month, day = mday))
akl_hourly <- akl_hourly  %>% 
  mutate(
    datetime_string = paste(date, time, sep = "T"),
    datetime = ymd_hms(datetime_string)
  )
akl_hourly <- akl_hourly %>%
  mutate(
    hour = hour(datetime),
    month = month(datetime, TRUE),
    rainy = weather == "Precipitation"
  )

# (1) What timezone are datetime and date_utc currently in? Examine the head of the datetime and date_utc columns to find out.
# Examine datetime and date_utc columns
glimpse(akl_hourly)
head(akl_hourly$datetime)
head(akl_hourly$date_utc)

# (2) Fix datetime to have the timezone for "Pacific/Auckland".
# Force datetime to Pacific/Auckland
akl_hourly <- akl_hourly %>%
  mutate(
    datetime = force_tz(datetime, tzone = "Pacific/Auckland"))

# (3) Reexamine the head of the datetime column to check the times have the same clocktime, but are now in the right timezone.
# Reexamine datetime
head(akl_hourly$datetime)

# (4) Now tabulate up the difference between the datetime and date_utc columns. It should be zero if our hypothesis was correct.
# Are datetime and date_utc the same moments
table(akl_hourly$datetime - akl_hourly$date_utc)

# Chapter 4. Times without dates
# For this entire course, if you've ever had a time, it's always had an accompanying date, i.e. a datetime. But sometimes you just have a time without a date.

# If you find yourself in this situation, the hms package provides an hms class of object for holding times without dates, and the best place to start would be with as.hms().

# In fact, you've already seen an object of the hms class, but I didn't point it out to you. Take a look in this exercise.

# (1) Use read_csv() to read in "akl_weather_hourly_2016.csv". readr knows about the hms class, so if it comes across something that looks like a time it will use it.
# Import auckland hourly data 
akl_hourly <- read_csv("akl_weather_hourly_2016.csv")

# (2) In this case the time column has been parsed as a time without a date. Take a look at the structure of the time column to verify it has the class hms.
str(akl_hourly$time)

# (3) hms objects print like times should. Take a look by examining the head of the time column.
# Examine head of time column
head(akl_hourly$time)

# (4) You can use hms objects in plots too. Create a plot with time on the x-axis, temperature on the y-axis, with lines grouped by date.
# A plot using just time
ggplot(akl_hourly, aes(x = time, y = temperature)) +
  geom_line(aes(group = make_date(year, month, mday)), alpha = 0.2)
# Terrific! Using time without date is a great way to examine daily patterns.

# Part 2. More on importing and exporting datetimes
# Chapter 1. Fast parsing with `fasttime`
# install.packages("microbenchmark")
# install.packages("fasttime")
library(microbenchmark)
library(fasttime)

# The fasttime package provides a single function fastPOSIXct(), designed to read in datetimes formatted according to ISO 8601. Because it only reads in one format, and doesn't have to guess a format, it is really fast!

# You'll see how fast in this exercise by comparing how fast it reads in the dates from the Auckland hourly weather data (over 17,000 dates) to lubridates ymd_hms().

# To compare run times you'll use the microbenchmark() function from the package of the same name. You pass in as many arguments as you want each being an expression to time.
  
# We've loaded the datetimes from the Auckland hourly data as strings into the vector dates.
akl_hourly <- read_csv("akl_weather_hourly_2016.csv")
akl_hourly  <- akl_hourly_raw  %>% 
  mutate(date = make_date(year = year, month = month, day = mday))
akl_hourly <- akl_hourly  %>% 
  mutate(
    datetime_string = paste(date, time, sep = "T"),
    datetime = ymd_hms(datetime_string)
  )
akl_hourly <- akl_hourly %>%
  mutate(
    hour = hour(datetime),
    month = month(datetime, TRUE),
    rainy = weather == "Precipitation"
  )

glimpse(akl_hourly)
dates <- akl_hourly$datetime_string
# (1) Examine the structure of dates to verify it is a string and in the ISO 8601 format.
str(dates)

# (2) Parse dates with fasttime and pipe to str() to verify fastPOSIXct parses them correctly.
# Use fastPOSIXct() to parse dates
fastPOSIXct(dates) %>% str()

# (3) Now to compare timing, call microbenchmark where the first argument uses ymd_hms() to parse dates and the second uses fastPOSIXct().
# Compare speed of fastPOSIXct() to ymd_hms()
microbenchmark(
  ymd_hms = ymd_hms(dates),
  fasttime = fastPOSIXct(dates),
  times = 20)

# Chapter 2. Fast parsing with `lubridate::fast_strptime`
# lubridate provides its own fast datetime parser: fast_strptime(). Instead of taking an order argument like parse_date_time() it takes a format argument and the format must comply with the strptime() style.

# As you saw in the video that means any character that represents a datetime component must be prefixed with a % and any non-whitespace characters must be explicitly included.

# Try parsing dates with fast_strptime() and then compare its speed to the other methods you've seen.

# dates is in your workspace again.

# (1) Examine the head of dates. What components are present? What separators are used?
# Head of dates
head(dates)

# (2) Parse dates with fast_strptime() by specifying the appropriate format string.
# Parse dates with fast_strptime
fast_strptime(dates, 
              format = "%Y-%m-%dT%H:%M:%SZ") %>% str()

# (3) Compare the timing of fast_strptime() to fasttime and ymd_hms().
# Comparse speed to ymd_hms() and fasttime
microbenchmark(
  ymd_hms = ymd_hms(dates),
  fasttime = fastPOSIXct(dates),
  fast_strptime = fast_strptime(dates, 
                                format = "%Y-%m-%dT%H:%M:%SZ"),
  times = 20)

# Chapter 3. Outputting pretty dates and times
# An easy way to output dates is to use the stamp() function in lubridate. stamp() takes a string which should be an example of how the date should be formatted, and returns a function that can be used to format dates.

# In this exercise you'll practice outputting today() in a nice way.

# (1) Create a stamp() based on the string "Sep 20 2017".
# Create a stamp based on "Sep 20 2017"
finished <- "I finished 'Dates and Times in R' on Thursday, September 20, 2017!"
date_stamp <- stamp("Sep 20 2017")

# (2) Print date_stamp. Notice it is a function.
date_stamp

# (3) Pass today() to date_stamp to format today's date.
# Call date_stamp on today()
date_stamp(today())

# (4) Now output today's date in American style MM/DD/YYYY.
# Create and call a stamp based on "09/20/2017"
stamp("09/20/2017")(today())


# (5) Finally, use stamp based on the finished string I've put in your workspace to format today().
# Use string finished for stamp()
stamp(finished)(today())
