#### Chapter 1. Join the two data sets together ####

library(tidyverse)

# load rdata
load("data/ilo_hourly_compensation.rdata")
load("data/ilo_working_hours.rdata")
glimpse(ilo_working_hours)

# Join both data frames
ilo_data <- ilo_hourly_compensation %>%
  inner_join(ilo_working_hours, by = c("country", "year"))

#### Chapter 2. Change variable types ####
# Turn year into a factor
ilo_data <- ilo_data %>% 
  mutate(year = as.factor(as.numeric(year)))

# Turn country into a factor
ilo_data <- ilo_data %>%
  mutate(country = as.factor(country))

#### Chapter 3. 
