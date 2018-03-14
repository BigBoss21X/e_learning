library(tidyverse)

# load rdata
load("data/ilo_hourly_compensation.rdata")
load("data/ilo_working_hours.rdata")

ilo_data <- ilo_hourly_compensation %>%
  inner_join(ilo_working_hours, by = c("country", "year"))

ilo_data <- ilo_data %>% 
  mutate(year = as.factor(as.numeric(year)))

ilo_data <- ilo_data %>%
  mutate(country = as.factor(country))

#### Chapter 1. Prepare the data set for the faceted plot ####
# "You're now going to prepare your data set for producing the faceted scatter plot in the next exercise, as mentioned in the video. For this, the data set needs to contain only the years 1996 and 2006, because your plot will only have two facets. ilo_data has been pre-loaded for you."

# Instructions
# Use filter() to only retain the years 1996 and 2006 in the data set.
glimpse(ilo_data)
ilo_data <- ilo_data %>%
  filter(year == "1996" | year == "2006")

# Use the OR operator in your filter() function call. 
ilo_data

#### Chapter 2. Add facets to the plot ####
# Specify the correct formula in facet_grid() to generate two separate scatter plots with one function call.
ilo_plot <- ggplot(ilo_data, aes(x = working_hours, y = hourly_compensation)) + 
  geom_point() +
  labs(
    x = "Working hours per week",
    y = "Hourly compensation",
    title = "The more people work, the less compensation they seem to receive",
    subtitle = "Working hours and hourly compensation in European countries, 2006",
    caption = "Data source: ILO, 2017"
  ) + 
  facet_grid(facets = . ~ year)

# Arrange the plots horizontally, so the year 1996 is on the left side, the year 2006 on the right side.
ilo_plot

