# Part 1. Capturing
# Chapter 1. Capturing parts of a pattern
rm(list = "seperator")
hero_contacts <- c(
  "(wolverine@xmen.com)", 
  "wonderwoman@justiceleague.org", 
  "thor@avengers.com"
)

library(stringr)
# install.packages("rebus")
library(rebus)

# Capture part between @ and . and after .
email <- capture(one_or_more(WRD)) %R% 
  "@" %R% capture(one_or_more(WRD)) %R% 
  DOT %R% capture(one_or_more(WRD))

# Check match hasn't changed
str_view(hero_contacts, pattern = email)

# Pull out match and captures
email_parts <- str_match(hero_contacts, pattern = email)

# Print email_parts
email_parts

# Save host
host <- email_parts[,3]
host

# Chapter 2. Pulling out parts of a phone number
contact <- c(
  "Call me at 555-555-0191", 
  "123 Main St", 
  "(555) 555 0191", 
  "Phone: 555.555.0191 Mobile: 555.555.0192"
)

# Add capture() to get digit parts
three_digits <- DGT %R% DGT %R% DGT
four_digits <- three_digits %R% DGT
separator <- char_class("?:[-.()]| ")

# Add capture() to get digit parts
phone_pattern <- capture(three_digits) %R% zero_or_more(separator) %R% 
  capture(three_digits) %R% zero_or_more(separator) %R%
  capture(four_digits)

# Pull out the parts with str_match()
phone_numbers <- str_match(contact, phone_pattern)

# Put them back together
str_c(
  "(",
  phone_numbers[, 2],
  ")",
  phone_numbers[, 3],
  "-",
  phone_numbers[, 4])

# Great job! If you wanted to extract beyond the first phone number, e.g. The second phone number in the last string, you could use str_match_all(). But, like str_split() it will return a list with one component for each input string, and you'll need to use lapply() to handle the result.

# Chapter 3. Extracting age and gender again
narratives <- c(
  "19YOM-SHOULDER STRAIN-WAS TACKLED WHILE PLAYING FOOTBALL W/ FRIENDS "
  
)