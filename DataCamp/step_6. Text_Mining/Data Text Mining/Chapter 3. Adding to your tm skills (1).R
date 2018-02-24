# Part 1. Simple Word Clustering
# Chapter 1. Distance matrix and dendrogram
rain <- data.frame(city = c("Cleveland", "Portland", "Boston", "New Orleans"), 
                   rainfall = c(39.14, 39.14, 43.77, 62.45))

# Create dist_rain
dist_rain <- dist(rain[, 2])

# View the distance matrix
dist_rain

# Create hc
hc <- hclust(dist_rain)

# Plot hc
plot(hc, labels = rain$city)

# Chapter 2. Make a distance matrix and dendrogram from a TDM
# Setup
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

# Chapter 2. Make a distance matrix and dendrogram from a TDM
# Print the dimensions of tweets_tdm
dim(coffee_tdm)

# Create tdm1
tdm1 <- removeSparseTerms(coffee_tdm, sparse = 0.95)

# Create tdm2
tdm2 <- removeSparseTerms(coffee_tdm, sparse = 0.975)

# Print tdm1
tdm1

# Print tdm2
tdm2

# Chapter 3. Put it all together: a text based dendrogram
# Create tweets_tdm2
coffee_tdm2 <- removeSparseTerms(coffee_tdm, sparse= 0.975)

# Create tdm_m
tdm_m <- as.matrix(coffee_tdm2)

# Create tdm_df
tdm_df <- as.data.frame(tdm_m)

# Create tweets_dist
tweets_dist <- dist(tdm_df)

# Create hc
hc <- hclust(tweets_dist)

# Plot the dendrogram
plot(hc)

# Chapter 4. Dendrogram aesthetics
# install.packages("dendextend")
library(dendextend)
library(qdap)
library(ggplot2)
library(ggthemes)

# Create hc
hc <- hclust(tweets_dist)

# Create hcd
hcd <- as.dendrogram(hc)

# Print the labels in hcd
labels(hcd)

# Change the branch color to red for "marvin" and "gaye"
hcd <- branches_attr_by_labels(hcd, c("cup", "just"), "red")

# Plot hcd
plot(hcd, main = "Better Dendrogram")

# Add cluster rectangles 
rect.dendrogram(hcd, k = 2, border = "grey50")

# Chapter 5. Using word association
# Create associations
associations <- findAssocs(coffee_tdm, "cup", 0.2)

# View the venti associations
associations

# Create associations_df
associations_df <- list_vect2df(associations)[, 2:3]

# Plot the associations_df values (don't change this)
ggplot(associations_df, aes(y = associations_df[, 1])) + 
  geom_point(aes(x = associations_df[, 2]), 
             data = associations_df, size = 3) + 
  theme_gdocs()

# Part 2. Getting past single words
# Chapter 1. Changing n-grams
# Make tokenizer function
library(RWeka)

tokenizer <- function(x) {
  NGramTokenizer(x, Weka_control(min = 2, max = 2))
}

# Create unigram_dtm
unigram_dtm <- DocumentTermMatrix(clean_corp)

# Create bigram_dtm
bigram_dtm <- DocumentTermMatrix(clean_corp, 
                                 control = list(tokenize = tokenizer))

# Examine unigram_dtm
unigram_dtm

# Examine bigram_dtm
bigram_dtm

# Chapter 2. How do bigrams affect word clouds?
coffee_dtm <- DocumentTermMatrix(clean_corp)

# Create coffee_dtm_m
coffee_dtm_m <- as.matrix(coffee_dtm)

# Create freq
freq <- colSums(coffee_dtm_m)

# Create coffee_words 
coffee_words <- names(freq)

# Examine part of coffee_words
coffee_words[2577:2587]

# Plot a wordCloud
wordcloud::wordcloud(coffee_words, freq, max.words = 15)

# Part 3. Different Frequency Criteria
# Chapter 1. Changing frequency weights
# Create tf_tdm
tf_tdm <- TermDocumentMatrix(clean_corp)

# Create tfidf_tdm
tfidf_tdm <- TermDocumentMatrix(clean_corp, control = list(weighting = weightTfIdf))

# Create tf_tdm_m
tf_tdm_m <- as.matrix(tf_tdm)

# Create tfidf_tdm_m 
tfidf_tdm_m <- as.matrix(tfidf_tdm)

# Examine part of tf_tdm_m
tf_tdm_m[508:509, 5:10]

# Examine part of tfidf_tdm_m
tfidf_tdm_m[508:509, 5:10]

# Chapter 2. Capturing metadata in tm
# Add author to custom reading list
custom_reader <- readTabular(mapping = list(content = "text", 
                                            id = "num", 
                                            author = "screenName", 
                                            date = "created"))

# Make corpus with custom reading
text_corpus <- VCorpus(
  DataframeSource(tweets), 
  readerControl = list(reader = custom_reader)
)

# Clean corpus
text_corpus <- clean_corpus(text_corpus)

# Print data
text_corpus[[1]][1]

# Print metadata
text_corpus[[1]][2]
