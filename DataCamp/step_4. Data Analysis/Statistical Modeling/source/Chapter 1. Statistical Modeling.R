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

pkgs <- c("mosaicData", "mosaicModel", "ggplot2", "dplyr", "tidyr", "readr", "purrr", "tibble", "stringr", "forcats", "mosaic")

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
