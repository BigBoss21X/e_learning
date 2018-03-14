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

#### Chapter 3. Filtering and plotting the data ####
# Examine the European countries vector
european_countries <- c("Finland", 
                        "France", 
                        "Italy", 
                        "Norway", 
                        "Spain", 
                        "Sweden", 
                        "Switzerland", 
                        "United Kingdom", 
                        "Belgium", 
                        "Ireland", 
                        "Luxembourg", 
                        "Portugal", 
                        "Netherlands", 
                        "Germany", 
                        "Hungary", 
                        "Austria", 
                        "Czech Rep.")

# Apply the filter() function to only retain countries which also appear in the european_countries vector. Use the %in% operator to retain only values that appear in the right-hand side of the operator.
ilo_data <- ilo_data %>% 
  filter(country %in% european_countries)

#### Chapter 4. Some Summary Statistics ####
# Examine the structure of ilo_data
str(ilo_data)

# Group and summarize the data
ilo_data %>%
  group_by(country) %>%
  summarize(mean_hourly_compensation = mean(hourly_compensation),
            mean_working_hours = mean(working_hours))

#### Chapter 5. A Basic Scatter Plot ####
# Filter for 2006
plot_data <- ilo_data %>%
  filter(year == 2006)

# Create the scatter plot
ggplot(plot_data) +
  geom_point(aes(x = working_hours, y = hourly_compensation))

# Add labels to the plot
# Create the scatter plot
ggplot(plot_data) +
  geom_point(aes(x = working_hours, y = hourly_compensation)) + 
  labs(
    x = "Working hours per week", 
    y = "Hourly compensation", 
    title = "The more people work, the less compensation they seem to receive",
    subtitle = "Working hours and hourly compensation in European countries, 2006", 
    caption = "Data source: ILO, 2017"
  )

#### Chapter 6. Apply a Default Theme ####
# Save your current plot into a variable: ilo_plot
ilo_plot <- ggplot(plot_data) +
  geom_point(aes(x = working_hours, y = hourly_compensation)) + 
  theme_bw(base_family = "AppleGothic") + 
  labs(
    x = "Working hours per week",
    y = "Hourly compensation",
    title = "The more people work, the less compensation they seem to receive",
    subtitle = "Working hours and hourly compensation in European countries, 2006",
    caption = "Data source: ILO, 2017"
  )

# Try out the theme_minimal ggplot2 theme on your just defined plot object. After this, try out another possible ggplot2 theme of your choosing.
# Try out theme_minimal
ilo_plot +
  theme_minimal()

# Try out any other possible theme function
ilo_plot +
  theme_classic()

#### Chapter 7. Change the appearance of titles ####
# Besides applying defined theme presets, you can tweak your plot even more by altering different style attributes of it. Hint: You can reuse and overwrite the ilo_plot variable generated in the previous exercise – the current plot is already shown in the window on the right.

ilo_plot <- ilo_plot +
  theme_minimal() +
  # Customize the "minimal" theme with another custom "theme" call
  theme(
    text = element_text(family = "NanumGothic"),
    title = element_text(color = "gray25"),
    plot.subtitle = element_text(size = 12),
    plot.caption = element_text(color = "gray30")
  )

# Render the plot object
ilo_plot

# http://blog.daum.net/_blog/BlogTypeView.do?blogid=0BnRF&articleno=13718306&categoryId=0&regdt=20160503202324

#### Chapter 7. Alter Background color and add margins ####
ilo_plot <- ilo_plot +
  theme_minimal() +
  # Customize the "minimal" theme with another custom "theme" call
  theme(
    text = element_text(family = "NanumGothic"),
    title = element_text(color = "gray25"),
    plot.subtitle = element_text(size = 12),
    plot.caption = element_text(color = "gray30"), 
    plot.background = element_rect(fill = "gray95"), 
    plot.margin = unit(c(5, 10, 5, 10), units = "mm")
  )

# Render the plot object
ilo_plot
?theme
?unit

