# Part 1. Introduction to stringr
# Chapter 1. Putting strings together with stringr
rm(list = ls())
library(stringr)
my_toppings <- c("cheese", NA, NA)
my_toppings_and <- paste(c("", "", "and "), my_toppings, sep = "")

# Print my_toppings_and
print(my_toppings_and)

# Use str_c() instead of paste(): my_toppings_str
my_toppings_str <- str_c(c("", "", "and "), my_toppings)

# Print my_toppings_str
print(my_toppings_str)

# paste() my_toppings_and with collapse = ", "
paste(my_toppings_and, collapse = ", ")

# paste() my_toppings_str with collapse = ", "
str_c(my_toppings_and, collapse = ", ")

# Nice work! This behavior is nice because you learn quickly when you might have missing values, rather than discovering later weird "NA"s inside your strings. Another stringr function that is useful when you may have missing values, is str_replace_na() which replaces missing values with any string you choose.

# Chapter 2. String length
library(stringr)
# install.packages("babynames")
library(babynames)
library(dplyr)

# Extracting vectors for boys' and girls' names
data("babynames")

# Extracting vectors for boys' and girls' names
babynames_2014 <- filter(babynames, year == 2014)
str(babynames_2014)
boy_names <- babynames_2014 %>% 
              filter(sex == "M") %>% 
              select(name)

boy_names2 <- filter(babynames_2014, sex == "M")$name

girl_names <- babynames_2014 %>% 
                filter(sex == "F") %>% 
                select(name)

girl_names2 <- filter(babynames_2014, sex == "F")$name

# Take a look at a few boy_names
head(boy_names)
head(boy_names2)
head(girl_names)
head(girl_names2)

# Find the length of all boy_names
boy_length <- str_length(boy_names)
boy_length2 <- str_length(boy_names2)

girl_length <- str_length(girl_names)
girl_length2 <- str_length(girl_names2)

# Find the difference in mean length
mean(girl_length) - mean(boy_length)
mean(girl_length2) - mean(boy_length2)

# Confirm str_length() works with factors
# head(str_length(factor(boy_names)))
head(str_length(factor(boy_names2)))

# Fantastic! The average length of the girls' names in 2014 is about 1/3 of a character longer. Just be aware this is a naive average where each name is counted once, not weighted by how many babies recevied the name. A better comparison might be an average weighted by the n column in babynames.

# Chapter 3. Extracting substrings
# Extract first letter from boy_names
boy_first_letter <- str_sub(boy_names2, 1, 1)

# Tabulate occurrences of boy_first_letter
table(boy_first_letter)

# Extract the last letter in boy_names, then tabulate
boy_last_letter <- str_sub(boy_names2, -1, -1)
table(boy_last_letter)

# Extract the first letter in girl_names, then tabulate
girl_first_letter <- str_sub(girl_names2, 1, 1)
table(girl_first_letter)

# Extract the last letter in girl_names, then tabulate
girl_last_letter <- str_sub(girl_names2, -1, -1)
table(girl_last_letter)

# Great job! Did you see that "A" is the most popular first letter for both boys and girls, and the most popular last letter for girls. However, the most popular last letter for boys' names was "n". You might have seen substr() a base R function that is similar to str_sub(). The big advantage of str_sub() is the ability to use negative indexes to count from the end of a string.

# Part 2. Hunting for matches
# Lectures
pizzas <- c("cheese", "pepperoni", "sausage and green peppers")

str_detect(string = pizzas, pattern = "pepper")

str_detect(string = pizzas, 
           pattern = fixed("pepper"))

str_subset(string = pizzas, 
           pattern = fixed("pepper"))

str_count(string = pizzas, 
          pattern = fixed("pepper"))

# Chapter 1. Detecting matches
# Look for pattern "zz" in boy_names
contains_zz <- str_detect(boy_names2, pattern = "zz")

# Examine str() of contains_zz
str(contains_zz)

# How many names contain "zz"?
sum(contains_zz == TRUE)

# Which names contain "zz"?
boy_names2[contains_zz == TRUE]

# Which rows in boy_df have names that contain "zz"?
boy_df <- babynames_2014 %>% 
  filter(sex == "M") %>% 
  select(1:5)
boy_df[contains_zz == TRUE, ]

# That last example is another common use of str_detect() subsetting a data frame to rows where the values in a column contain the pattern of interest. In this case it lets us see these double-z names are pretty rare. For example, even the most popular, Uzziah, only accounted for 0.003% of boys born in 2014.

# Chapter 2. Subsetting strings based on match
# Find boy_names that contain "zz"
str_subset(boy_names2, pattern = "zz")

# Find girl_names that contain "zz"
str_subset(girl_names2, pattern = "zz")

# Find girl_names that contain "U"
starts_U <- str_subset(girl_names2, pattern = fixed("U"))
starts_U

# Find girl_names that contain "U" and "z"
str_subset(starts_U, pattern = "z")

# Chapter 3. Counting matches
# Count occurrences of "a" in girl_names
number_as <- str_count(girl_names2, pattern = fixed("a"))

# Count occurrences of "A" in girl_names
number_As <- str_count(girl_names2, pattern = fixed("A"))

# Histograms of number_as and number_As
hist(number_as)
hist(number_As)

# Find total "a" + "A"
total_as <- number_as + number_As

# girl_names with more than 4 a's
girl_names2[total_as > 4]

# Part 3. Splitting strings
# Lectures
# str_split returns a list
str_split(string = "Tom & Jerry", pattern = " & ")

chars <- c("Tom & Jerry", 
           "Alvin & Simon & Theodore")

str_split(chars, pattern = " & ") # compare below

# str_split can returns a matrix
str_split(chars, pattern = " & ", simplify = TRUE)

# combining with lapply
split_chars <- str_split(chars, pattern = " & ")
lapply(split_chars, length)

# Chapter 1. Parsing strings into variables 
date_ranges <- c("23.01.2017 - 29.01.2017", "30.01.2017 - 06.02.2017")

# Split dates using " - "
split_dates <- str_split(date_ranges, pattern = fixed(" - "))

# Print split_dates
print(split_dates)

# Split dates with n and simplify specified
split_dates_n <- str_split(date_ranges, pattern = fixed(" - "), simplify = TRUE, n = 2)
split_dates_n

# Subset split_dates_n into start_dates and end_dates
start_dates <- split_dates_n[, 1]
end_dates <- split_dates_n[, 2]

# Split start_dates into day, month and year pieces
str_split(start_dates, pattern = fixed("."), simplify = TRUE, n = 3)

# Split both_names into first_names and last_names
both_names <- c("Box, George", "Cox, David")
both_names_split <- str_split(both_names, pattern = fixed(", "), simplify = TRUE, n = 2)
both_names_split
first_names <- both_names_split[,2]
last_names <- both_names_split[,1]

# Super splitting! Use the simplify = TRUE argument when you want to split each string into the same number of pieces.

# Chapter 2. Some simple text statistics
line1 <- "The table was a large one, but the three were all crowded together at one corner of it:"
line2 <- "\"No room! No room!\" they cried out when they saw Alice coming."
line3 <- "\"There’s plenty of room!\" said Alice indignantly, and she sat down in a large arm-chair at one end of the table."

lines <- c(line1, line2, line3)
lines

# Split lines into words
words <- str_split(lines, pattern = " ")

# Number of words per line
lapply(words, length)

# Number of characters in each word
word_lengths <- lapply(words, str_length)

# Average word length per line
lapply(word_lengths, mean)

# Part 4. Replacing matches in strings
# Chapter 1. Replacing to tidy strings
ids <- c("ID#: 192", "ID#: 118", "ID#: 001")

# Replace "ID#: " with ""
id_nums <- str_replace(ids, pattern = "ID#: ", replacement = "")

# Turn id_nums into numbers
id_ints <- as.numeric(id_nums)

# Some (fake) phone numbers
phone_numbers <- c("510-555-0123", "541-555-0167")

# Use str_replace() to replace "-" with " "
str_replace(phone_numbers, pattern = "-", replacement = " ")

# Use str_replace_all() to replace "-" with " "
str_replace_all(phone_numbers, pattern = "-", replacement = " ")

# Turn phone numbers into the format xxx.xxx.xxxx
str_replace_all(phone_numbers, pattern = "-", replacement = ".")

# Nice work! If you need to replace multiple different characters you could use str_replace_all() more than once, but you'll see a better way of specifying a range of characters to replace once you've learned about regular expressions in Chapter 3.

# Chapter 2. Review. 
YPO0001 <- "TTAGAGTAAATTAATCCAATCTTTGACCCAAATCTCTGCTGGATCCTCTGGTATTTCATGTTGGATGACGTCAATTTCTAATATTTCACCCAACCGTTGAGCACCTTGTGCGATCAATTGTTGATCCAGTTTTATGATTGCACCGCAGAAAGTGTCATATTCTGAGCTGCCTAAACCAACCGCCCCAAAGCGTACTTGGGATAAATCAGGCTTTTGTTGTTCGATCTGTTCTAATAATGGCTGCAAGTTATCAGGTAGATCCCCGGCACCATGAGTGGATGTCACGATTAACCACAGGCCATTCAGCGTAAGTTCGTCCAACTCTGGGCCATGAAGTATTTCTGTAGAAAACCCAGCTTCTTCTAATTTATCCGCTAAATGTTCAGCAACATATTCAGCACTACCAAGCGTACTGCCACTTATCAACGTTATGTCAGCCAT"

asnC <- "TTAAGGAACGATCGTACGCATGATAGGGTTTTGCAGTGATATTAGTGTCTCGGTTGACTGGATCTCATCAATAGTCTGGATTTTGTTGATAAGTACCTGCTGCAATGCATCAATGGATTTACACATCACTTTAATAAATATGCTGTAGTGGCCAGTGGTGTAATAGGCCTCAACCACTTCTTCTAAGCTTTCCAATTTTTTCAAGGCGGAAGGGTAATCTTTGGCACTTTTCAAGATTATGCCAATAAAGCAGCAAACGTCGTAACCCAGTTGTTTTGGGTTAACGTGTACACAAGCTGCGGTAATGATCCCTGCTTGCCGCATCTTTTCTACTCTTACATGAATAGTTCCGGGGCTAACAGCGAGGTTTTTGGCTAATTCAGCATAGGGTGTGCGTGCATTTTCCATTAATGCTTTCAGGATGCTGCGATCGAGATTATCGATCTGATAAATTTCACTCAT"

asnA <- "ATGAAAAAACAATTTATCCAAAAACAACAACAAATCAGCTTCGTAAAATCATTCTTTTCCCGCCAATTAGAGCAACAACTTGGCTTGATCGAAGTCCAGGCTCCTATTTTGAGCCGTGTGGGTGATGGAACCCAAGATAACCTTTCTGGTTCTGAGAAAGCGGTACAGGTAAAAGTTAAGTCATTGCCGGATTCAACTTTTGAAGTTGTACATTCATTAGCGAAGTGGAAACGTAAAACCTTAGGGCGTTTTGATTTTGGTGCTGACCAAGGGGTGTATACCCATATGAAAGCATTGCGCCCAGATGAAGATCGCCTGAGTGCTATTCATTCTGTATATGTAGATCAGTGGGATTGGGAACGGGTTATGGGGGACGGTGAACGTAACCTGGCTTACCTGAAATCGACTGTTAACAAGATTTATGCAGCGATTAAAGAAACTGAAGCGGCGATCAGTGCTGAGTTTGGTGTGAAGCCTTTCCTGCCGGATCATATTCAGTTTATCCACAGTGAAAGCCTGCGGGCCAGATTCCCTGATTTAGATGCTAAAGGCCGTGAACGTGCAATTGCCAAAGAGTTAGGTGCTGTCTTCCTTATAGGGATTGGTGGCAAATTGGCAGATGGTCAATCCCATGATGTTCGTGCGCCAGATTATGATGATTGGACCTCTCCGAGTGCGGAAGGTTTCTCTGGATTAAACGGCGACATTATTGTCTGGAACCCAATATTGGAAGATGCCTTTGAGATATCTTCTATGGGAATTCGTGTTGATGCCGAAGCTCTTAAGCGTCAGTTAGCCCTGACTGGCGATGAAGACCGCTTGGAACTGGAATGGCATCAATCACTGTTGCGCGGTGAAATGCCACAAACTATCGGGGGAGGTATTGGTCAGTCCCGCTTAGTGATGTTATTGCTGCAGAAACAACATATTGGTCAGGTGCAATGTGGTGTTTGGGGCCCTGAAATCAGCGAGAAAGTTGATGGCCTGCTGTAA"

genes <- c(YPO0001, asnC, asnA)

# Find the number of nucleotides in each sequence
str_length(genes)

# Find the number of A's occur in each sequence
str_count(genes, fixed("A"))

# Return the sequences that contain "TTTTTT"
str_subset(genes, fixed("TTTTTT"))

# Replace all the "A"s in the sequences with a "_"
str_replace_all(genes, pattern = "A", replacement = "-")

# Chapter 3. Final challenges
# --- Task 1 ----
# Define some full names
rm(list = ls())
# --- Task 1 ----
# Define some full names
names <- c("Diana Prince", "Clark Kent")

# Split into first and last names
names_split <- str_split(names, pattern = fixed(" "), simplify = TRUE, n = 2)
names_split

# Extract the first letter in the first name
abb_first <- str_sub(names_split[,1], 1, 1)

# Combine the first letter ". " and last name
str_c(abb_first, ". ", names_split[, 2])

# --- Task 2 ----
# Use all names in babynames_2014
all_names <- babynames_2014$name

# Get the last two letters of all_names
last_two_letters <- str_sub(all_names, -2,-1)

# Does the name end in "ee"?
ends_in_ee <- str_detect(last_two_letters, pattern = fixed("ee"))

# Extract rows and "sex" column
sex <- babynames_2014$sex[ends_in_ee == TRUE]

# Display result as a table
table(sex)

