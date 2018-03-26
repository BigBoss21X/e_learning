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

#### Chapter 3. Define your own theme function ####
# Using your new knowledge about function definitions, create a function named theme_ilo() that contains your personal theme settings.
# For a starter, let's look at what you did before: adding various theme calls to your plot object
ilo_plot +
  theme_minimal() +
  theme(
    text = element_text(family = "AppleGothic", color = "gray25"),
    plot.subtitle = element_text(size = 12),
    plot.caption = element_text(color = "gray30"),
    plot.background = element_rect(fill = "gray95"),
    plot.margin = unit(c(5, 10, 5, 10), units = "mm")
  )

# The function body should contain both theme() calls that you would normally apply directly to a plot object: theme_minimal() + your customized theme() function.
theme_ilo <- function(){
  theme_minimal() +
    theme(
      text = element_text(family = "AppleGothic", color = "gray25"),
      plot.subtitle = element_text(size = 12),
      plot.caption = element_text(color = "gray30"),
      plot.background = element_rect(fill = "gray95"),
      plot.margin = unit(c(5, 10, 5, 10), units = "mm")
    )
}

#### Chapter 4. Apply the new theme function to the plot ####
# From now on, you can just add theme_ilo() to any plot object you wish. Try it out! Overwrite the ilo_plot variable so theme_ilo is applied permanently.
ilo_plot + 
  theme_ilo()

# You can also combine your custom theme function with even further theme() calls to flexibly adjust settings for advanced plots.
# Here, change the background fill to "gray60" and the color of the facet labels to "white" by adding another theme() call after the theme_ilo() call.
ilo_plot + 
  theme_ilo() + 
  # Add another theme call
  theme(
    # Change the background fill to make it a bit darker
    strip.background = element_rect(
      fill = "gray60", 
      color = "gray95"
    ),
    
    # Make text a bit bigger and change its color
    strip.text = element_text(
      size = 11,
      colour = "white"
      )
  )

#### Part 3. A custom plot to emphasize change ####
#### ~ Lecture ####
ggplot(ilo_data %>% filter(year == 2006)) + 
  geom_dotplot(aes(x = working_hours)) + 
  labs(x = "Working hours per week", 
       y = "Share of countries")
# geom_path() connects the observations in the order in which they appear in the data. 

ilo_data %>% 
  arrange(country)

# function formular
# ggplot() + geom_path(aes(x = numeric_variable, y = numeric_variable))
# ggplot() + geom_path(aes(x = numeric_variable, y = factor_variable))
# ggplot() + geom_path(aes(x = numeric_variable, y = factor_variable), arrow = arrow())

#### ~ Chapter 1. A basic dot plot ####
# Create a new ggplot object which takes ilo_data as dataset. 
# Add a geom_path() aesthetic where the weekly working hours are mapped to the x-axis and countries to the y-axis. 
ggplot(ilo_data) + 
  geom_path(aes(x = working_hours, y = country))

#### ~ Chapter 2. Add arrows to the lines in the plot ####
# Instead of labeling years, use the arrow argument of the geom_path() call to show the direction of change. The arrows will point from 1996 to 2006, because that's how the data set is ordered. The arrow() function takes two arguments: The first is length, which can be specified with a unit() call, which you might remember from previous exercises. The second is type which defines how the arrow head will look.

# Instructions
# Use the arrow argument and an arrow() function call to add arrows to each line. 
ggplot(ilo_data) + 
  geom_path(aes(x = working_hours, y = country), 
            # Add an arrow to each path
            arrow = arrow(length = unit(1.5, "mm"), 
                          type = "closed")
            )
# For the arrows, specify a length of 1.5 "mm" and a type of "closed

# Great! Now it becomes implicitly clear that all the countries have seen a decrease in weekly working hours since 1996, because the arrows are always pointing to the left.

#### Chapter 3. Add some labels to each country ####
# A nice thing that can be added to plots are annotations or labels, so readers see the value of each data point displayed in the plot panel. This often makes axes obsolete, an advantage you're going to use in the last exercise of this chapter. These labels are usually added with geom_text() or geom_label(). The latter adds a background to each label, which is not needed here.

# Instructions 
# Label both points on the line with their respective working hours value. Use the geom_text() function for this, with the x - and y - aesthetic identical to the one in the geom_path() call. 
ggplot(ilo_data) + 
  geom_path(aes(x = working_hours, y = country), 
            arrow = arrow(length = unit(1.5, "mm"), 
                          type = "closed")) + 
  # Add a geom_text() geometry
  geom_text(
    aes(x = working_hours, 
        y = country, 
        label = round(working_hours, 1))
  )

# Cool, now the x-axis is obsolete and can be removed in the remainder of this chapter. The labels are still kind of misplaced, though… Let's fix this!

#### Lecture 3. Polishing the dot plot ####
# Factor Levels 
# The order of factor levels determine the order of appearance in ggplot2. 

# Reordering factors with the forcats package
# Needs to be loaded with library(forcats)
# fct_drop for dropping levels
# fct_rev for reversing factor levels
# fct_reorder for reordering them. 
# references. http://forcats.tidyverse.org/
ilo_data <- ilo_data %>% 
  mutate(country = fct_reorder(country, working_hours, mean))
ilo_data

# Nudging labels with hjust and vjust
ggplot(ilo_data) + 
  geom_path(aes(x = working_hours, y = country), 
            arrow = arrow(length = unit(1.5, "mm"), type = "closed")) + 
  geom_text(aes(x = working_hours, 
                y = country, 
                label = round(working_hours, 1), 
                hjust = ifelse(year == "2006", 1.4, -0.4)))

# Let's say you add median as third argument to the fct_reorder() function. What does it do?
# The median of all values in the second argument (for each factor level) is taken for reordering the factor. 

#### ~ Chapter 1. Reordering elements in the plot ####
# Use fct_reorder() in the forcats package to reorder the country factor variable by weekly working hours in the year 2006.
library(forcats)

# To do that, specify the correct summary function as the third argument of fct_reorder. It should arrange the country factor levels by the last element in the working_hours variable.

# In order to do the above, you first need to arrange() the data set by year – so 1996 is always first in each country group, 2006 always last.


# Reorder country factor levels
ilo_data <- ilo_data %>% 
  # arrange data frame
  arrange(year) %>% 
  mutate(country = fct_reorder(
    country, 
    working_hours, 
    last
  ))

# plot again
ggplot(ilo_data) + 
  geom_path(aes(x = working_hours, y = country), 
            arrow = arrow(length = unit(1.5, "mm"), type = "closed")) + 
  geom_text(
    aes(x = working_hours, 
        y = country, 
        label = round(working_hours, 1))
  )

#### ~ Chapter 2. Correct ugly label positions ####

# Give the hjust aesthetic in the geom_text() function call a value of 1.4, if it concerns the label for the year "2006", and -0.4 if not. Use the ifelse() function for this.

# Change font size, family and color to 3, "Bookman" and "gray25" respectively, also in the geom_text() call, but outside of the aes() function since these values are not data-driven.

#### ~ Chapter 3. Correct ugly label positions ####
# The labels still kind of overlap with the lines in the dot plot. Use a conditional hjust aesthetic in order to better place them, and change their appearance.

# Instructions
# Give the hjust aesthetic in the geom_text() function call a value of 1.4, if it concerns the label for the year "2006", and -0.4 if not. Use the ifelse() function for this.
# Save plot into an object for reuse
# Nudging labels with hjust and vjust
ilo_dot_plot <- ggplot(ilo_data) + 
  geom_path(aes(x = working_hours, y = country), 
            arrow = arrow(length = unit(1.5, "mm"), type = "closed")) + 
  geom_text(aes(x = working_hours, 
                y = country, 
                label = round(working_hours, 1), 
                hjust = ifelse(year == "2006", 1.4, -0.4)
                ), 
            size = 3, 
            family = "AppleGothic", 
            color = "gray25"
            )

# Change font size, family and color to 3, "Bookman" and "gray25" respectively, also in the geom_text() call, but outside of the aes() function since these values are not data-driven.

#### Lecture 4. Finalizing the plot for different audiences and devices ####
#### ~ Chapter 1. Change the viewport so labels don't overlap with plot border ####
# Instructions
# Fix the label overlap problem by resetting the x-limits of the cartesian coordinate system to 25 and 41. Make sure to use a function that doesn't clip the geometries in your plot. 

ilo_dot_plot <- ilo_dot_plot + 
  # Add labels to the plot
  labs(
    x = "Working hours per week", 
    y = "Country", 
    title = "People work less in 2006 compared to 1996", 
    subtitle = "Working hours in European countries, development since 1996", 
    caption = "Data source: ILO, 2017"
  ) + 
  # Apply your theme
  theme_ilo() + 
  # Change the viewport
  coord_cartesian(xlim = c(25, 41))

ilo_dot_plot

#### ~ Chapter 2. Optimizing the plot for mobile devices ####

# Instructions
# A new data set median_working_hours was created so there will only be one label per country. Have a look at the structure of it with str()
# Compute temporary data set for optimal label placement
median_working_hours <- ilo_data %>% 
  group_by(country) %>% 
  summarise(median_working_hours_per_country = median(working_hours)) %>% 
  ungroup()
median_working_hours

# Have a look at the structure of this data set
str(median_working_hours)

ilo_dot_plot + 
  # Add label for country
  geom_text(data = median_working_hours, 
            aes(y = country, 
                x = median_working_hours_per_country, 
                label = country), 
            vjust = 2, 
            family = "AppleGothic", 
            color = "gray25") + 
  # remove axes and grids 
  theme(
    axis.ticks = element_blank(), 
    axis.title = element_blank(), 
    axis.text = element_blank(), 
    panel.grid = element_blank(), 
    
    # Also, let's reduce the font size of the subtitle
    plot.subtitle = element_text(size = 9)
  )
