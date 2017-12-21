# Part 1. Common Text Minings
# Chapter 1. Frequent terms with tm
library(tm)
# data load
coffee.csv <- "https://assets.datacamp.com/production/course_935/datasets/coffee.csv"
tweets <- read.csv(coffee.csv, stringsAsFactors = FALSE)
# data selected
coffee_tweets <- tweets$text
# make the vector a VCorpus object
coffee_source <- VectorSource(coffee_tweets)
coffee_corpus <- VCorpus(coffee_source)

# Apply preprocessing steps to a corpus, Alter the function code to match the instructions
clean_corpus <- function(corpus){
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, c(stopwords("en"), "coffee", "mug"))
  return(corpus)
}

# Apply your customized function to the tweet_corp: clean_corp
clean_corp <- clean_corpus(coffee_corpus)
# Create a TDM from clean_corp: coffee_tdm
coffee_tdm <- TermDocumentMatrix(clean_corp)

## coffee_tdm is still loaded in your workspace
coffee_tdm

# Create a matrix: coffee_m
coffee_m <- as.matrix(coffee_tdm)

# Calculate the rowSums: term_frequency
term_frequency <- rowSums(coffee_m)

# Sort term_frequency in descending order
term_frequency <- sort(term_frequency, decreasing = TRUE)

# View the top 10 most common words
term_frequency[1:10]

# Plot a barchart of the 10 most common words
barplot(term_frequency[1:10], col = "tan", las = 2)

# Chapter 2. Frequent terms with qdap
# Create frequency
library(rJava)
# install.packages("qdap")
library(qdap)
frequency <- freq_terms(tweets$text, top = 10, at.least = 3, stopwords = "Top200Words")
# install.packages("ggplot2")
plot(frequency)

# Create frequency2
frequency2 <- freq_terms(tweets$text, top = 10, at.least = 3, 
                         stopwords = tm::stopwords("english"))
# Make a frequency2 barchart
plot(frequency2)

# Part 2. A Simple word cloud
# Chapter 1. A Simple Word Cloud
library(wordcloud)
# Print the first 10 entries in term_frequency
term_frequency[1:10]

# Create word_freqs
word_freqs <- data.frame(term = names(term_frequency), 
                         num = term_frequency)

# Create a WordCloud for the values in word_freqs
wordcloud(words = word_freqs$term, 
          freq = word_freqs$num, 
          max.words = 100, 
          colors = "red")

# Chapter 2. Plot the better word cloud
chardonnay_words_url <- "https://assets.datacamp.com/production/course_935/datasets/chardonnay.csv"

chardonnay_words_db <- read.csv(chardonnay_words_url, stringsAsFactors = FALSE)

# data selected
chardonnay_words_test <- chardonnay_words_db$text

# make the vector a VCorpus Object
chardonnay_source <- VectorSource(chardonnay_words_test)
chardonnay_corpus <- VCorpus(chardonnay_source)

# Cleaning Function
clean_chardonnay_corpus <- function(corpus) {
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, 
                   c(stopwords("en"), "amp", "chardonnay", "wine", "glass"))
  return(corpus)
}

# Apply your customized function to the tweet_corp: clean_chardonnay_corp
clean_chardonnay_corp <- clean_chardonnay_corpus(chardonnay_corpus)

# Create a TDM from clean_corp: chardonnay_tdm
chardonnay_tdm <- TermDocumentMatrix(clean_chardonnay_corp)

## coffee_tdm is still loaded in your workspace
chardonnay_tdm

# Create a matrix: coffee_m
chardonnay_m <- as.matrix(chardonnay_tdm)

# Chapter 3. Plot the better word cloud
# Calculate the rowSums: chardonnay_words
chardonnay_words <- rowSums(chardonnay_m)

# Sort chardonnay_words in descending order
chardonnay_words <- sort(chardonnay_words, decreasing = TRUE)
chardonnay_words[1:6]

# Create chardonnay_words
chardonnay_freqs <- data.frame(term = names(chardonnay_words), 
                         num = chardonnay_words)

# Create a WordCloud for the values in word_freqs
wordcloud(words = chardonnay_freqs$term, 
          freq = chardonnay_freqs$num, 
          max.words = 100, 
          colors = "red")

# Chapter 4. Improve word cloud colors
# Print the list of colors
colors()

# Create chardonnay_words
chardonnay_freqs <- data.frame(term = names(chardonnay_words), 
                               num = chardonnay_words)

# Print the wordcloud with the specified colors
wordcloud(chardonnay_freqs$term, 
          chardonnay_freqs$num, 
          max.words = 50, 
          colors = c("grey80", "darkgoldenrod1", "tomato"))

# Chapter 5. Use prebuilt color palettes
# List the available colors
display.brewer.all()

# Create purple_orange
purple_orange <- brewer.pal(10, "PuOr")

# Drop 2 faintest colors
purple_orange <- purple_orange[-(1:2)]

# Create a wordcloud with purple_orange palette
wordcloud(chardonnay_freqs$term, 
          chardonnay_freqs$num, 
          max.words = 100, 
          colors = purple_orange)

# Part 3. Other word clouds and word networks
# Chapter 1. Find common words
# Create all_coffee
all_coffee <- paste(coffee_tweets, collapse = " ")

# Create all_chardonnay
all_chardonnay <- paste(chardonnay_words_test, collapse = " ")

# Create all_tweets
all_tweets <- c(all_coffee, all_chardonnay)

# Convert to a vector source
all_tweets <- VectorSource(all_tweets)

# Create all_corpus
all_corpus <- VCorpus(all_tweets)

# Chapter 2. Visualize common words
# Clean the corpus
all_clean <- clean_chardonnay_corpus(all_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_clean)

# Create all_m
all_m <- as.matrix(all_tdm)

# Print a commonality cloud
commonality.cloud(all_m, max.words = 100, colors = "steelblue1")

# Chapter 3. Visualize dissimilar words
# Clean the corpus
all_clean <- clean_chardonnay_corpus(all_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_clean)

# Give the columns distinct names
colnames(all_tdm) <- c("coffee", "chardonnay")

# Create all_m
all_m <- as.matrix(all_tdm)

# Create comparison cloud
comparison.cloud(all_m, colors = c("orange", "blue"), max.words = 50)

# Chapter 4. Polarized tag cloud
# create all_tdm_m
# Cleaning Function
clean_both_corpus <- function(corpus) {
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, 
                   c(stopwords("en"), "coffee", "mug", "amp", "chardonnay", "wine", "glass"))
  return(corpus)
}

# Clean the corpus
all_clean <- clean_both_corpus(all_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_clean)

# Give the columns distinct names
colnames(all_tdm) <- c("coffee", "chardonnay")

# Create all_tdm_m
all_tdm_m <- as.matrix(all_tdm)
dim(all_tdm_m)
# Create common_words
common_words <- subset(all_tdm_m, all_tdm_m[, 1] > 0 & all_tdm_m[, 2] > 0)

# Create difference
difference <- abs(common_words[, 1] - common_words[, 2])

# Combine common_words and difference
common_words <- cbind(common_words, difference)

# Order the data frame from most differences to least
common_words <- common_words[order(common_words[, 3], decreasing = TRUE), ]
dim(common_words)

# Create top25_df
top25_df <- data.frame(x = common_words[1:25, 1], 
                       y = common_words[1:25, 2], 
                       labels = rownames(common_words[1:25, ]))

library(plotrix)
# Create the pyramid plot
pyramid.plot(top25_df$x, 
             top25_df$y,
             labels = top25_df$labels, 
             gap = 8, 
             top.labels = c("Coffee", "Words", "Chardonnay"), 
             main = "Words in Common", laxlab = NULL, 
             raxlab = NULL, unit = NULL)

# Chapter 5. Visualize word networks
library(qdap)
# Before Word association
word_associate(chardonnay_words_test, match.string = c("marvin"), 
               stopwords = c(Top200Words, "chardonnay", "amp"), 
               network.plot = TRUE, cloud.colors = c("gray85", "darkred"))

# Add title
title(main = "Chardonnay Tweets Associated with Marvin")

# After Word association
word_associate(coffee_tweets, match.string = c("barista"), 
               stopwords = c(Top200Words, "coffee", "amp"), 
               network.plot = TRUE, cloud.colors = c("gray85", "darkred"))

# Add title
title(main = "Barista Coffee Tweet Associations")
