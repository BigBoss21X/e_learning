# Part 1. Introduction
# Chapter 1. Downloading files and reading them into R
# In this first exercise we're going to look at reading already-formatted datasets - CSV or TSV files, with which you'll no doubt be familiar! - into R from the internet. This is a lot easier than it might sound because R's file-reading functions accept not just file paths, but also URLs.

# Here are the URLs! As you can see they're just normal strings
csv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1561/datasets/chickwts.csv"
tsv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_3026/datasets/tsv_data.tsv"

# (1) Read the CSV file stored at csv_url into R using read.csv(). Assign the result to csv_data.

# Here are the URLs! As you can see they're just normal strings
csv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1561/datasets/chickwts.csv"
tsv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_3026/datasets/tsv_data.tsv"

# (2) Read the CSV file stored at csv_url into R using read.csv(). Assign the result to csv_data.
# Read a file in from the CSV URL and assign it to csv_data
csv_data <- read.csv(csv_url)

# (3) Do the same for the TSV file stored at tsv_url using read.delim(). Assign the result to tsv_data.
tsv_data <- read.delim(tsv_url)

# (4) Examine each object using head().
head(csv_data)
head(tsv_data)

# Excellent work! As you can see, read.csv() and read.delim() work nicely with URLs, reading the contents in just as they would if the URLs were instead paths to files on your computer.

# Chapter 2. Saving raw files to disk
# Sometimes just reading the file in from the web is enough, but often you'll want to store it locally so that you can refer back to it. This also lets you avoid having to spend the start of every analysis session twiddling your thumbs while particularly large files download.

# Helpfully, R has download.file(), a function that lets you do just that: download a file to a location of your choice on your computer. It takes two arguments; url, indicating the URL to read from, and destfile, the destination to write the downloaded file to. In this case, we've pre-defined the URL - once again, it's csv_url.

# (1) Download the file at csv_url with download.file(), naming the destination file "feed_data.csv".
# Download the file with download.file()
download.file(url = csv_url, destfile = "feed_data.csv")

# (2) Read "feed_data.csv" into R with read.csv()
# Read it ""feed_data.csv" into R with read.csv()
csv_data <- read.csv("feed_data.csv")

# Good job. Now the file has been downloaded, you can refer back to it however many times you like without having to grab it from the internet anew each time.

# Chapter 3. Saving formatted files to disk
# (1) Modify csv_data to add the column square_weight, containing the square of the weight column.
# Add a new column: square_weight
csv_data$square_weight <- csv_data$weight^2

# (2) Save it to disk as "modified_feed_data.RDS" with saveRDS().
# Save it to disk with saveRDS()
saveRDS(csv_data, "modified_feed_data.RDS")

# (3) Read it back in as modified_feed_data with readRDS().
# Read it back in with readRDS()
modified_feed_data <- readRDS("modified_feed_data.RDS")

# (4) Examine modified_feed_data
str(modified_feed_data)

# Part 2. Understanding Application Programming Interfaces
# Quiz. API test
# In the last video you were introduced to Application Programming Interfaces, or APIs, along with their intended purpose (as the computer equivalent of the visible web page that you and I might interact with) and their utility for data retrieval. What are APIs for?

# Possible Answers?
# Correct! Websites let you and I interpret and interface with a server, APIs allow computers to do the same.

# Chapter 1. Using API clients
# So we know that APIs are server components to make it easy for your code to interact with a service and get data from it. We also know that R features many "clients" - packages that wrap around connections to APIs so you don't have to worry about the details.

# Let's look at a really simple API client - the pageviews package, which acts as a client to Wikipedia's API of pageview data. As with other R API clients, it's formatted as a package, and lives on CRAN - the central repository of R packages. The goal here is just to show how simple clients are to use: they look just like other R code, because they are just like other R code.
# Load pageviews
# install.packages("pageviews")
library(pageviews)

# (1) Use the article_pageviews() function to get the pageviews for the article "Hadley Wickham".
# Get the pageviews for "Hadley Wickham"
hadley_pageviews <- article_pageviews(project = "en.wikipedia", "Hadley Wickham")

# Examine the resulting object
str(hadley_pageviews)

# Part 3. Access tokens and APIs
# Chapter 1. Using access tokens
# Load birdnik
# install.packages("birdnik")
library(birdnik)

# As we discussed in the last video, it's common for APIs to require access tokens - unique keys that verify you're authorised to use a service. They're usually pretty easy to use with an API client.

# To show how they work, and how easy it can be, we're going to use the R client for the Wordnik dictionary and word use service - 'birdnik' - and an API token we prepared earlier. Birdnik is fairly simple (I wrote it!) and lets you get all sorts of interesting information about word usage in published works. For example, to get the frequency of the use of the word "chocolate", you would write:

# word_frequency(api_key, "chocolate")
# In this exercise we're going to look at the word "vector" (since it's a common word in R!) using a pre-existing API key (stored as api_key)

# Using the pre-existing API key and word_frequency(), get the frequency of the word "vector" in Wordnik's database. Assign the results to vector_frequency.
# Get the word frequency for "vector", using api_key to access it
api_key <- "d8ed66f01da01b0c6a0070d7c1503801993a39c126fbc3382"
vector_frequency <- word_frequency(api_key, "vector")
