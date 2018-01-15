# Chapter 1. How long has it been?
# To get finer control over a difference between datetimes use the base function difftime(). For example instead of time1 - time2, you use difftime(time1, time2).
# difftime() takes an argument units which specifies the units for the difference. Your options are "secs", "mins", "hours", "days", or "weeks".
# To practice you'll find the time since the first man stepped on the moon. You'll also see the lubridate functions today() and now() which when called with no arguments return the current date and time in your system's timezone.

# The date of landing and moment of step
library(lubridate)
date_landing <- mdy("July 20, 1969")
moment_step <- mdy_hms("July 20, 1969, 02:56:15", tz = "UTC")

# Apollo 11 landed on July 20, 1969. Use difftime() to find the number of days between today() and date_landing.
# How many days since the first man on the moon?
difftime(today(), date_landing, units = "days")

# Neil Armstrong stepped onto the surface at 02:56:15 UTC. Use difftime() to find the number of seconds between now() and moment_step.
# How many seconds since the first man on the moon?
difftime(now(), moment_step, units = "secs")

# Chapter 2. How many seconds are in a day?
# How many seconds are in a day? There are 24 hours in a day, 60 minutes in an hour, and 60 seconds in a minute, so there should be 24*60*60 = 86400 seconds, right?

# Not always! In this exercise you'll see a counter example, can you figure out what is going on?

# We've put code to define three times in your script - midnight on March 11th, March 12th and March 13th in 2017 in the US Pacific timezone.

# Three dates
mar_11 <- ymd_hms("2017-03-11 12:00:00", 
                  tz = "America/Los_Angeles")
mar_12 <- ymd_hms("2017-03-12 12:00:00", 
                  tz = "America/Los_Angeles")
mar_13 <- ymd_hms("2017-03-13 12:00:00", 
                  tz = "America/Los_Angeles")

# Find the difference in time between mar_13 and mar_12 in seconds. This should match your intuition.
# Difference between mar_13 and mar_12 in seconds
difftime(mar_13, mar_12, units = "secs")

# Now, find the difference in time between mar_12 and mar_11 in seconds. Surprised?
# Difference between mar_12 and mar_11 in seconds
difftime(mar_12, mar_11, units = "secs")

# Part 2. Time spans. 
# Chapter 1. Adding or subtracting a time span to a datetime
# A common use of time spans is to add or subtract them from a moment in time. For, example to calculate the time one day in the future from mar_11 (from the previous exercises), you could do either of:

mar_11 + days(1)
mar_11 + ddays(1)

# It's Monday Aug 27th 2018 at 2pm and you want to remind yourself this time next week to send an email. Add a period of one week to mon_2pm.
# Add a period of one week to mon_2pm
mon_2pm <- dmy_hm("27 Aug 2018 14:00")
mon_2pm + days(7)

# It's Tuesday Aug 28th 2018 at 9am and you are starting some code that usually takes about 81 hours to run. When will it finish? Add a duration of 81 hours to tue_9am.
# Add a duration of 81 hours to tue_9am
tue_9am <- dmy_hm("28 Aug 2018 9:00")
tue_9am + dhours(81)

# What were you doing five years ago? Subtract a period of 5 years from today().
# Subtract a period of five years from today()
today() - years(5)

# Subtract a duration of 5 years from today(). Will this give a different date?
# Subtract a duration of five years from today()
today() - dyears(5)

# Chapter 2. Arithmetic with timespans
# You can add and subtract timespans to create different length timespans, and even multiply them by numbers. For example, to create a duration of three days and three hours you could do: ddays(3) + dhours(3), or 3*ddays(1) + 3*dhours(1) or even 3*(ddays(1) + dhours(1)).

# There was an eclipse over North America on 2017-08-21 at 18:26:40. It's possible to predict the next eclipse with similar geometry by calculating the time and date one Saros in the future. A Saros is a length of time that corresponds to 223 Synodic months, a Synodic month being the period of the Moon's phases, a duration of 29 days, 12 hours, 44 minutes and 3 seconds.

# Do just that in this exercise!

# (1) Create a duration corresponding to one Synodic Month: 29 days, 12 hours, 44 minutes and 3 seconds.
# Time of North American Eclipse 2017
eclipse_2017 <- ymd_hms("2017-08-21 18:26:40")

# (2) Create a duration corresponding to one Saros by multiplying synodic by 223.
# Duration of 29 days, 12 hours, 44 mins and 3 secs
synodic <- ddays(29) + dhours(12) + dminutes(44) + dseconds(3)

# 223 synodic months
saros <- synodic * 223

# (3) Add saros to eclipse_2017 to predict the next eclipse.
# Add saros to eclipse_2017
eclipse_2017 + saros

# Chapter 3. Generating sequences of datetimes
# By combining addition and multiplication with sequences you can generate sequences of datetimes. For example, you can generate a sequence of periods from 1 day up to 10 days with,

# 1:10 * days(1)
# Then by adding this sequence to a specific datetime, you can construct a sequence of datetimes from 1 day up to 10 days into the future

# today() + 1:10 * days(1)
# You had a meeting this morning at 8am and you'd like to have that meeting at the same time and day every two weeks for a year. Generate the meeting times in this exercise.

# (1) Create today_8am() by adding a period of 8 hours to today()
# Add a period of 8 hours to today
today_8am <- today() + hours(8)

# (2) Create a sequence of periods from one period of two weeks, up to 26 periods of two weeks.
# Sequence of two weeks from 1 to 26
every_two_weeks <- 1:26 * weeks(2)

# (3) Add every_two_weeks to today_8am.
# Create datetime for every two weeks for a year
today_8am + every_two_weeks

# Chapter 4. The tricky thing about months
# What should ymd("2018-01-31") + months(1) return? Should it be 30, 31 or 28 days in the future? Try it. In general lubridate returns the same day of the month in the next month, but since the 31st of February doesn't exist lubridate returns a missing value, NA.

# There are alternative addition and subtraction operators: %m+% and %m-% that have different behavior. Rather than returning an NA for a non-existent date, they roll back to the last existing date.

# You'll explore their behavior by trying to generate a sequence for the last day in every month this year.

# We've put jan_31, the date for January 31st this year in your workspace.
jan_31 <- ymd("2018-Jan-31")

# (1) Start by creating a sequence of 1 to 12 periods of 1 month.
# A sequence of 1 to 12 periods of 1 month
month_seq <- 1:12 * months(1)

# (2) Add month_seq to jan_31. Notice what happens to any month where the 31st doesn't exist
# Add 1 to 12 months to jan_31
jan_31 + month_seq

# (3) Now add month_seq to jan_31 using the %m+% operator.
# Replace + with %m+%
jan_31 %m+% month_seq

# (4) Try subtracting month_seq from jan_31 using the %m-% operator.
# Replace + with %m-%
jan_31 %m-% month_seq

# Part 3. Intervals
# install.packages("learningr")

# Lecture
# Creating Intervals 
# datetime1 %--% datetime2, or
# interval(datetime1, datetime2)
dmy("5 January 1961") %--% dmy("30 January 1969")
interval(dmy("5 January 1961"), dmy("30 January 1969"))

# Operating on an interval
beatles <- dmy("5 January 1961") %--% dmy("30 January 1969")
int_start(beatles)
int_end(beatles)
int_length(beatles)
as.period(beatles)
as.duration(beatles)

# Comparing Intervals
hendrix_at_woodstock <- mdy("August 17 1969")
hendrix_at_woodstock %within% beatles
hendrix <- dmy("01 October 1966") %--% dmy("16 September 1970")
int_overlaps(beatles, hendrix)

# Chapter 1. Examining intervals. Reigns of kings and queens
# create table
library(XML)
library(RCurl)

url <- "https://en.wikipedia.org/wiki/List_of_monarchs_in_Britain_by_length_of_reign"
webPage <- getURL(url)
monarchs <- readHTMLTable(webPage, header = F, which = 2)
monarchs <- monarchs[-c(1:2), 1:4]
names(monarchs) <- c("name", "from", "to", "")


# You can create an interval by using the operator %--% with two datetimes. For example ymd("2001-01-01") %--% ymd("2001-12-31") creates an interval for the year of 2001.

# Once you have an interval you can find out certain properties like its start, end and length with int_start(), int_end() and int_length() respectively.

# Practice by exploring the reigns of kings and queens of Britain (and its historical dominions).

# We've put the data monarchs in your workspace.
library(tidyverse)
# (1) Print monarchs to take a look at the data
# Print monarchs
monarchs

# (2) Create a new column called reign that is an interval between from and to.
# Create an interval for reign
monarchs <- monarchs %>%
  mutate(reign = from %--% to) 

# (3) Create another new column, length, that is the interval length of reign. The rest of the pipeline we've filled in for you, it arranges by decreasing length and selects the name, length and dominion columns.
# Find the length of reign, and arrange
monarchs %>%
  mutate(length = int_length(reign)) %>% 
  arrange(desc(length)) %>%
  select(name, length, dominion)

# Chapter 2. Comparing intervals and datetimes
# A common task with intervals is to ask if a certain time is inside the interval or whether it overlaps with another interval.

# The operator %within% tests if the datetime (or interval) on the left hand side is within the interval of the right hand side. For example, if y2001 is the interval covering the year 2001,

y2001 <- ymd("2001-01-01") %--% ymd("2001-12-31")
# Then ymd("2001-03-30") %within% y2001 will return TRUE and ymd("2002-03-30") %within% y2001 will return FALSE.

# int_overlaps() performs a similar test, but will return true if two intervals overlap at all.

# Practice to find out which monarchs saw Halley's comet around 1066.

# We've put halleys a data set describing appearances of Halley's comet in your workspace.

# Print halleys to examine the date. perihelion_date is the date the Comet is closest to the Sun. start_date and end_date are the range of dates the comet is visible from Earth.
# Print halleys
halleys

# Create a new column, visible, that is an interval from start_date to end_date.
# New column for interval from start to end date
halleys <- halleys %>% 
  mutate(visible = start_date %--% end_date)

# You'll work with one appearance, extract the 14th row of halleys.
# The visitation of 1066
halleys_1066 <- halleys[14, ] 

# Filter monarchs to those where halleys_1066$perihelion_date is within reign.
# Monarchs in power on perihelion date
monarchs %>% 
  filter(halleys_1066$perihelion_date %within% reign) %>%
  select(name, from, to, dominion)

# Filter monarchs to those where halleys_1066$visible overlaps reign.
# Monarchs whose reign overlaps visible time
monarchs %>% 
  filter(int_overlaps(halleys_1066$visible, reign)) %>%
  select(name, from, to, dominion)

# Chapter 3. Converting to durations and periods
# Intervals are the most specific way to represent a span of time since they retain information about the exact start and end moments. They can be converted to periods and durations exactly: it's possible to calculate both the exact number of seconds elapsed between the start and end date, as well as the perceived change in clock time.

# To do so you use the as.period(), and as.duration() functions, parsing in an interval as the only argument.

# Try them out to get better representations of the length of the monarchs reigns.

# Create new columns for duration and period that convert reign into the appropriate object.
# New columns for duration and period
monarchs <- monarchs %>%
  mutate(
    duration = as.duration(reign),
    period = as.period(reign)) 

# Examine the name, duration and period columns.
# Examine results    
monarchs %>%
  select(name, duration, period)





