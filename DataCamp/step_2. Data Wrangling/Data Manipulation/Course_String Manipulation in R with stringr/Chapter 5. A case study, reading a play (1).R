# Part 1. A case study, reading a play
# Lecture 1. 
library(stringi)
library(stringr)
library(rebus)
getwd()
old_mac <- readLines("old_mac.txt")
str(old_mac)
old_mac[1:2]

str_detect(old_mac, "moo")
which(str_detect(old_mac, "moo"))

# Chapter 1. Getting the play into R
url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_2922/datasets/importance-of-being-earnest.txt"
Sys.getlocale()
Sys.setlocale(category = "LC_ALL", locale = "English")
rm(list = ls())
library(stringi)
library(stringr)
# Read play in using stri_read_lines()
earnest <- stri_read_lines("importance-of-being-earnest.txt")

# Detect start and end lines
start <- which(str_detect(earnest, fixed("START OF THE PROJECT")))
end <- which(str_detect(earnest, fixed("END OF THE PROJECT")))

# Get rid of gutenberg intro text
earnest_sub <- earnest[(start+1):(end-1)]

# Detect first act
lines_start <- which(str_detect(earnest_sub, fixed("FIRST ACT")))

# Set up index
intro_line_index <- 1:(lines_start - 1)

# Split play into intro and play
intro_text <- earnest_sub[intro_line_index]
play_text <- earnest_sub[-intro_line_index]

# Take a look at the first 20 lines
writeLines(play_text[1:20])

# You clearly understand the importance of being awesome! stri_read_lines() is a high performance alternative to readLines().

# Chapter 2. Identifying the lines, take 1
lines_quote <- which(play_text == "")
play_lines <- play_text[-lines_quote]

# Pattern for start word then .
pattern_1 <- START %R% one_or_more(WRD) %R% DOT

# Test pattern_2
str_view(play_lines, pattern_1, match = TRUE) 
str_view(play_lines, pattern_1, match = FALSE)

# Pattern for start, capital, word then .
pattern_2 <- START %R% ascii_upper() %R% one_or_more(WRD) %R% DOT

# View matches of pattern_2
str_view(play_lines, pattern_2, match = TRUE)

# View non-matches of pattern_2
str_view(play_lines, pattern_2, match = FALSE)

# Get subset of lines that match
lines <- str_subset(play_lines, pattern_2)

# Extract match from lines
who <- str_extract(lines, pattern_2)

# Let's see what we have
unique(who)

# Chapter 3. Identifying the lines, take 2
# Create vector of characters
characters <- c("Algernon", "Jack", "Lane", "Cecily", "Gwendolen", "Chasuble", 
                "Merriman", "Lady Bracknell", "Miss Prism")

# Match start, then character name, then .
pattern_3 <- START %R% or1(characters) %R% DOT

# View matches of pattern_3
str_view(play_lines, pattern_3, match = TRUE)

# View non-matches of pattern_3
str_view(play_lines, pattern_3, match = FALSE)

# Pull out matches
lines <- str_subset(play_lines, pattern_3)

# Extract match from lines
who <- str_extract(lines, pattern_3)

# Let's see what we have
unique(who)

# Count lines per character
table(who)

# You did it! Algernon and Jack get the most lines, more than ten times more than Merriman who has the fewest. If you were looking really closely you might have noticed the pattern didn't pick up the line Jack and Algernon [Speaking together.] which you really should be counting as a line for both Jack and Algernon. One solution might be to look for these "Speaking together" lines, parse out the characters, and add to your counts.

# Part 2. Case studies
# Chapter 1. Changing case to ease matching

catcidents <- c(
  "79yOf Fractured fingeR tRiPPED ovER cAT ANd fell to FlOOr lAst nIGHT AT HOME*", 
  "21 YOF REPORTS SUS LACERATION OF HER LEFT HAND WHEN SHE WAS OPENING A CAN OF CAT FOOD JUST PTA. DX HAND LACERATION%", 
  "87YOF TRIPPED OVER CAT, HIT LEG ON STEP. DX LOWER LEG CONTUSION ", 
  "bLUNT CHest trAUma, R/o RIb fX, R/O CartiLAgE InJ To RIB cAge; 32YOM walKiNG DOG, dog took OfF aFtER cAt,FelL,stRucK CHest oN STepS,hiT rIbS", 
  "42YOF TO ER FOR BACK PAIN AFTER PUTTING DOWN SOME CAT LITTER DX: BACK PAIN, SCIATICA", 
  "4YOf DOg jUst hAd PUpPieS, Cat TRIED 2 get PuPpIes, pT THru CaT dwn stA Irs, LoST foOTING & FELl down ~12 stePS; MInor hEaD iNJuRY", 
  "unhelmeted 14yof riding her bike with her dog when she saw a cat and sw erved c/o head/shoulder/elbow pain.dx: minor head injury,left shoulder", 
  "24Yof lifting a 40 pound bag of cat litter injured lt wrist; wrist sprain", 
  "3Yof-foot lac-cut on cat food can-@ home ", 
  "Rt Shoulder Strain.26Yof Was Walking Dog On Leash And Dot Saw A Cat And Pulled Leash."
)

# catcidents has been pre-defined
catcidents
head(catcidents)

# Construct pattern of DOG in boundaries
whole_dog_pattern <- whole_word("DOG")

# View matches to word "DOG"
str_view(catcidents, pattern = whole_dog_pattern, match = TRUE)

# Transform catcidents to upper case
catcidents_upper <- str_to_upper(catcidents) 

# View matches to word "DOG" again
str_view(catcidents_upper, whole_dog_pattern, match = TRUE)

# Which strings match?
has_dog <- str_detect(catcidents_upper, whole_dog_pattern)

# Pull out matching strings in original 
catcidents[has_dog]

# Chapter 2. Ignoring case when matching
# View matches to "TRIP"
str_view(catcidents, pattern = "TRIP", match = TRUE)

# Construct case insensitive pattern
trip_pattern <- regex("TRIP", ignore_case = TRUE)

# View case insensitive matches to "TRIP"
str_view(catcidents, pattern = trip_pattern, match = TRUE)

# Get subset of matches
trip <- str_subset(catcidents, trip_pattern)

# Extract matches
str_extract(trip, trip_pattern)

# Chapter 3. Fixing case problems
library(stringi)

# Get first five catcidents
cat5 <- catcidents[1:5]

# Take a look at original
writeLines(cat5)

# Transform to title case
writeLines(str_to_title(cat5))

# Transform to title case with stringi
stri_trans_totitle(cat5)

# Transform to sentence case with stringi
writeLines(stri_trans_totitle(cat5, type = "sentence"))
