#### Lecture 1. Statistical Models are used for ####
# Identifying patterns in data
# Classifying events
# Untangling multiple influences
# Assessing Strength of evidence

# The t-test: a statistical skateboard
# A statistical model? 

# The t-test in practice
# Defining "model"
# A model is a resentation for a purpose
# Representation: it stands for something in the real world
# Purpose: your particular use for the model
# Some everyday models

# Statistical Model
# A special type of mathematical model
# Informed by data
# Incorporates uncertainty and randomness

#### Chapter 1. From Experimental Results to a prediction ####
test_scores <- function(school = "public", acad_motivation = 0, relig_motivation = 0) {
  if(school == "public") {
    100 + (acad_motivation * 15) + (relig_motivation * 0)
  } else if(school == "private") {
    100 - 5 + (acad_motivation * 15) + (relig_motivation * 0)
  } else {
    message(paste0("your input message on 'school' is '"), school, "'. please enter 'public' or 'private'")
  }
}


# Baseline run
test_scores(school = "public", acad_motivation = 0, relig_motivation = 0)

# Change school input, leaving others at baseline
test_scores(school = "private", acad_motivation = 0, relig_motivation = 0)

# Change acad_motivation input, leaving others at baseline
test_scores(school = "public", acad_motivation = 1, relig_motivation = 0)

# Change relig_motivation input, leaving others at baseline
test_scores(school = "public", acad_motivation = 0, relig_motivation = 1)

# Use results above to estimate output for new inputs
my_prediction <- 100 - 5 + 2 * 15 + 2 * 0
my_prediction

# Check prediction by using test_scores() directly
test_scores(school = "private", acad_motivation = 2, relig_motivation = 2)

#### Lecture 2. R Objects for statistical modeling ####
# A model is a representation for a purpose
# A mathematical model is built from mathematical stuff
# A statistical model is trained on data, built on objects

# Data frames 
# columns are variables, which have names
# contents of variables are values
# rows are cases
# the case is the object from which values for variables are measured

# function
install_pkgs <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])] 
  if (length(new.pkg)) {
    install.packages(new.pkg, dependencies = TRUE)
  } 
  sapply(pkg, require, character.only = TRUE)
}

pkgs <- c("mosaicData", "mosaicModel", "ggplot2", "dplyr", "tidyr", "readr", "purrr", "tibble", "stringr", "forcats", "mosaic", "lattice")

install_pkgs(pkgs)

data("Trucking_jobs")
data("Riders")
data("diamonds")

#### Chapter 2. Accessing Data ####

#### Instructions ####
# Since the focus of this course is statistical modeling, we'll assume you already know how to get data into R. Many of the datasets will come from a package written specifically for this course: statisticalModeling. This package is already installed on the DataCamp servers. To use it on your own computer, you'll have to install it there.

# To access data contained in an R package, you have a few options:
  
# 1. Use the data() function: data("CPS85", package = "mosaicData")
# 2. Refer to the package using double-colon notation: mosaicData::CPS85
# 3. Load the package, then refer to the dataset by name: library(mosaicData); CPS85
# Let's get some quick practice with these three approaches before moving on.

# Instructions 
# Use the data() function to load the Trucking_jobs data frame from statisticalModeling. Both the name of the dataset and the package it's coming from should be surrounded with double quotes (see example above).
# Use nrow() to find the number of rows in Trucking_jobs.
# Use names() to find the names of variables in the mosaicData::Riders data (using double-colon notation).
# Load the ggplot2 package.
# Look at the head() of the the diamonds dataset, which is contained in ggplot2. You can refer to the dataset directly by name, since the package is loaded.

# # Use data() to load Trucking_jobs
data("Trucking_jobs", package = "statisticalModeling")

# View the number rows in Trucking_jobs
nrow(Trucking_jobs)

# Use names() to find variable names in mosaicData::Riders
names(mosaicData::Riders)

# Load ggplot2 package
library(ggplot2)

# Look at the head() of diamonds
head(diamonds)

#### Chapter 3. Starting with formulas #### 
# Formulas such as wage ~ age + exper are used to describe the form of relationships among variables. In this exercise, you are going to use formulas and functions to summarize data on the cost of life insurance policies. The data are in the AARP data frame, which has been preloaded from the statisticalModeling package.

# The mosaic package augments simple statistical functions such as mean(), sd(), median(), etc. so that they can be used with formulas. For instance, mosaic::mean(wage ~ sex, data = CPS85) will calculate the mean wage for each sex. In contrast, the "built-in" mean() function (part of the base package) doesn't accept formulas, making it unnecessarily hard to do things like calculate groupwise means.

# Note that we explicitly reference the mean() function from the mosaic package using double-colon notation (i.e. package::function()) to make it clear that we're not using the base R version of mean(). If you'd like, you can watch a supplemental video here to learn more about formulas and functions in R.

#### ~ Instructions ####

# Find the variable names in the AARP data frame, which has been preloaded in your workspace from the statisticalModeling package. AARP contains life insurance prices for the two sexes at different ages.

# Construct a formula using the variable names from the AARP data frame with an eye toward calculating the insurance cost broken down by sex. Use that formula as the first argument to mosaic::mean() to find the mean cost by sex.

# Find the variable names in AARP
data("AARP")
names(AARP)

# Find the mean cost broken down by sex
mosaic::mean(Cost ~ Sex, data = AARP)

### Chapter 4. Graphics with forumals #### 

# Formulas can be used to describe graphics in each of the three popular graphics systems: base graphics, lattice graphics, and in ggplot2 with the statisticalModeling package. Most people choose to work in one of the graphics systems. I recommend ggplot2 with the formula interface provided by statisticalModeling.

#### ~ Instructions ####
# 1. Make a boxplot of insurance cost broken down by sex in one of the three graphics systems. All can use the same syntax: function(formula, data = AARP).

# 2. In base graphics, the appropriate function is boxplot().
boxplot(Cost ~ Age, data = AARP)

# 3. In lattice graphics, use bwplot() to make the boxplot. As always, you will have to load the lattice package.
bwplot(Cost ~ Age, data = AARP)

# 4. In the formula interface to ggplot2, use gf_boxplot(). The statisticalModeling package (which communicates with ggplot2), has been loaded for you.
gf_boxplot(Cost ~ Age, data = AARP)

# 5. Make a scatterplot of Cost versus Age in one of the graphics packages.

# 6. In base graphics: plot().
plot(Cost ~ Age, data = AARP)
# 7. In lattice graphics: xyplot().
xyplot(Cost ~ Age, data = AARP)

# 8. For ggplot graphics: gf_point().
gf_point(Cost ~ Age, data = AARP)
