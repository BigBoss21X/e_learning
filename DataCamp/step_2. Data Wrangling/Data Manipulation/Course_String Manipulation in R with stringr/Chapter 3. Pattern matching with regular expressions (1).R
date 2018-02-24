rm(list = ls())
# Part 1. Regular Expressions
# ^.[\d]+
# "the start of the string, followed by any single character, followed by one or more digits"

library(stringr)
str_detect(c("R2-D2", "C-3P0"), 
           pattern = "^.\\d+")

# install.packages("rebus")
library(rebus)
str_detect(c("R2-D2", "C-3P0"), 
           pattern = START %R% 
                     ANY_CHAR %R% 
                     one_or_more(DGT))


# Chapter 1. Matching the start or end of the string
library(rebus)
library(stringr)

# Some strings to practice with
x <- c("cat", "coat", "scotland", "tic toc")

# Print START
START

# Print END
END

# Run me
str_view(x, pattern = START %R% "c")

# Match the strings that with "co"
str_view(x, pattern = START %R% "co")

# Match the strings that with "at"
str_view(x, pattern = "at" %R% END)

# Match the strings that with "cat"
str_view(x, pattern = START %R% "cat" %R% END)

# Nice job on your first regular expressions! For that last example, rebus also provides the function exactly(x) which is a shortcut for START %R% x %R% END that matches only if the string is exactly x.

# Chapter 2. Matching any character
x <- c("cat", "coat", "scotland", "tic toc")

# Sample
str_view(x, pattern = "c" %R% ANY_CHAR %R% "t")

# Match any character followed by a "t"
str_view(x, pattern = "t")

# Matcha a "t" followed by any character
str_view(x, pattern = "t" %R% ANY_CHAR)

# Match two characters
str_view(x, pattern = ANY_CHAR %R% ANY_CHAR)

# Match a string with exactlry three characters
str_view(x, pattern = START %R% ANY_CHAR %R% ANY_CHAR %R% ANY_CHAR %R% END)

# Chapter 3. Combining with stringr functions
# q followed by any character
pattern <- "q" %R% ANY_CHAR

# Test pattern 
str_view(c("Quentin", "Kaliq", "Jacques",  "Jacqes"), pattern)  

# Find names that have the pattern
library(babynames)
library(dplyr)
length(names_with_q)
data("babynames")
babynames_2014 <- filter(babynames, year == 2014)

boy_names <- filter(babynames_2014, sex == "M")$name
girl_names <- filter(babynames_2014, sex == "F")$name
# rm(list = "girls_names")

# Find names that have the pattern
names_with_q <- str_subset(boy_names, pattern)
length(names_with_q)

# Find part of name that matches pattern
part_with_q <- str_extract(boy_names, pattern)
table(part_with_q)

# Did any names have the pattern more than once?
count_of_q <- str_count(boy_names, pattern)
table(count_of_q)

# Which babies got these names?
with_q <- str_detect(boy_names, pattern)
boy_names[with_q == TRUE]

# What fraction of babies got these names?
mean(with_q)

# Part 2. More Regular Expressions
# Chapter 1. Alternation
# Match Jeffrey or Geoffrey
whole_names <- or("Jeffrey", "Geoffrey")
str_view(boy_names, pattern = whole_names, 
         match = TRUE)

# Match Jeffrey or Geoffrey, another way
common_ending <- or("Je", "Geo") %R% "ffrey" 
str_view(boy_names, pattern = common_ending, 
         match = TRUE)


# Match with alternate endings
by_parts <- or("Je", "Geo") %R% "ff" %R% or("ry", "ery", "rey", "erey")
str_view(boy_names, 
         pattern = by_parts, 
         match = TRUE)

# Match Jeffrey or Geoffrey
whole_names <- or("Jeffrey", "Geoffrey")
str_view(boy_names, pattern = whole_names, 
         match = TRUE)

# Match Jeffrey or Geoffrey, another way
common_ending <- or("Je", "Geo") %R% "ffrey" 
str_view(boy_names, pattern = common_ending, 
         match = TRUE)

# Match with alternate endings
by_parts <- or("Je", "Geo") %R% "ff" %R% or("ry", "ery", "rey", "erey")
str_view(boy_names, 
         pattern = by_parts, 
         match = TRUE)

# Match names that start with Cath or Kath
ckath <- START %R% or("C", "K") %R% "ath"
str_view(girl_names, pattern = ckath, match = TRUE)

# Astounding alternation! With a bit of thought, you can match very complicated variations of spellings.

# Chapter 2. Character classes
x <- c("grey sky", "gray elephant")

# Create character class containing vowels
vowels <- char_class("AaEeIiOoUu")

# Print vowels
print(vowels)

# See vowels in x with str_view()
str_view(x, pattern = vowels)

# See vowels in x with str_view_all()
str_view_all(x, pattern = vowels)

# Number of vowels in boy_names
num_vowels <- str_count(boy_names, pattern = vowels)
mean(num_vowels)

# Proportion of vowels in boy_names
name_length <- str_length(boy_names)
mean(num_vowels/name_length)

# Nice work! The names in boy_names are on average about 40% vowels.

# Chapter 3. Repetition. 
# Vowels from last exercise
vowels <- char_class("aeiouAEIOU")

# Use `negated_char_class()` for everything but vowels
not_vowels <- negated_char_class("aeiouAEIOU")

# See names with only vowels
str_view(boy_names, 
         pattern = exactly(one_or_more(vowels)), 
         match = TRUE)

# See names with no vowels
str_view(boy_names, 
         pattern = exactly(one_or_more(not_vowels)), 
         match = TRUE)

# Part 3. Shortcuts
# Chapter 1. Hunting for phone numbers
contact <- c("Call me at 555-555-0191", "123 Main St", "(555) 555 0191", "Phone: 555.555.0191 Mobile: 555.555.0192")

# Take a look at ALL digits
str_view_all(contact, pattern = DGT)

# Create a three digit pattern and test
three_digits <- DGT %R% DGT %R% DGT
str_view_all(contact,
             pattern = three_digits)

# Create four digit pattern
four_digits <- three_digits %R% DGT

# Create a separator pattern and test
separator <-  char_class("-.() ")
str_view_all(contact,
             pattern = separator)

# Create phone pattern
phone_pattern <- optional(OPEN_PAREN) %R%
  three_digits %R%
  zero_or_more(separator) %R%
  three_digits %R% 
  zero_or_more(separator) %R%
  four_digits

# Test pattern           
str_view(contact, phone_pattern)

# Extract phone numbers
str_extract(contact, phone_pattern)

# Extract ALL phone numbers
str_extract_all(contact, phone_pattern)

# Wow! Great job. We'll see an easy way to extract parts of our match (the numbers for example) in the next chapter. rebus also provides the functions number_range() when you want to extract numbers in a certain range, and datetime() to specify common date patterns.

# Chapter 2. Extracting age and gender from accident narratives
narratives <- c(
  "19YOM-SHOULDER STRAIN-WAS TACKLED WHILE PLAYING FOOTBALL W/ FRIENDS ", 
  "31 YOF FELL FROM TOILET HITITNG HEAD SUSTAINING A CHI ", 
  "ANKLE STR. 82 YOM STRAINED ANKLE GETTING OUT OF BED ", 
  "TRIPPED OVER CAT AND LANDED ON HARDWOOD FLOOR. LACERATION ELBOW, LEFT. 33 YOF*", 
  "10YOM CUT THUMB ON METAL TRASH CAN DX AVULSION OF SKIN OF THUMB ", 
  "53 YO F TRIPPED ON CARPET AT HOME. DX HIP CONTUSION ", 
  "13 MOF TRYING TO STAND UP HOLDING ONTO BED FELL AND HIT FOREHEAD ON RADIATOR DX LACERATION",
  "14YR M PLAYING FOOTBALL; DX KNEE SPRAIN ",
  "55YOM RIDER OF A BICYCLE AND FELL OFF SUSTAINED A CONTUSION TO KNEE ",
  "55YOM RIDER OF A BICYCLE AND FELL OFF SUSTAINED A CONTUSION TO KNEE "
)

# Look for two digits
str_view(narratives, DGT %R% DGT)

# Pattern to match one or two digits
age <- DGT %R% optional(DGT)
str_view(narratives, 
         pattern = age)

# Pattern to match units 
unit <- optional(SPC) %R% or("YO", "YR", "MO")

# Test pattern with age then units
str_view(narratives, 
         pattern = age %R% unit)

# Pattern to match gender
gender <- optional(SPC) %R% or("M", "F")

# Test pattern with age then units then gender
str_view(narratives, 
         pattern = age %R% unit %R% gender)

# Extract age_gender, take a look
age_gender <- str_extract(narratives,  age %R% unit %R% gender)
age_gender

# Fantastic! You have the wisdom of a 99 YOF. You can also use dgt(1, 2) to match one or two digits.

# Chapter 3. 
# Extract age and make numeric
# age_gender, age, gender, unit are pre-defined
ls.str()

# Extract age and make numeric
ages_numeric <- as.numeric(str_extract(narratives, pattern = age))

# Replace age and units with ""
genders <- str_replace(age_gender, 
                       pattern = age %R% unit, 
                       replacement = "")

# Replace extra spaces
genders_clean <- str_replace_all(genders, 
                                 pattern = one_or_more(SPC), 
                                 replacement = "")

# Extract units 
time_units <- str_extract(age_gender, pattern = unit)

# Extract first word character
time_units_clean <- str_extract(time_units, pattern = WRD)

# Turn ages in months to years
ages_years <- ifelse(time_units_clean == "Y", ages_numeric, ages_numeric/12)
age_years
