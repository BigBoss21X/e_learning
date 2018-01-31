#### Part 1. CSS Web Scrapting ####
#### Chapter 1. Using CSS to scrape nodes ####
# As mentioned in the video, CSS is a way to add design information to HTML, that instructs the browser on how to display the content. You can leverage these design instructions to identify content on the page. 
# You've already used html_node(), but it's more common with CSS selectors to use html_nodes() since you'll often want more that one node returned. Both functions allow you to specify a css argument to use a CSS selector, instead of specifying the xpath argument. 

# What do CSS selectors look like?
# Try these examples to see a few possibilities. 

# Instructions
# We've read in the same HTML page from Chapter 4, the Wikipedia page for Hadley Wickham, into test_xml. 
# From chapter 4. 
library(rvest)

# step 1. get html
test_url <- "https://en.wikipedia.org/wiki/Hadley_Wickham"
test_xml <- read_html(test_url)
class(test_xml)

# step 2. get xml from html

# (1) Use the CSS selector "table" to select all elements that are a "table" tag. 
# Select the table elements
html_nodes(test_xml, css = "table")

# (2) Use the CSS selector ".infobox" to select all elements that have the attribute class = "infobox". 
html_nodes(test_xml, css = ".infobox")

# (3) Use the CSS selector "#firstHeading" to select all elements that have the attribute. id = "firstHeading". 
html_nodes(test_xml, css = "#firstHeading")

#### Chapter 2. Scraping Names ####
# You might have noticed in the previous exercise, to select elements with a certain class, you add a . in front of the class name. If you need to select an element based on its id, you add a # in front of the id name.

# For example if this element was inside your HTML document:
# <h1 class = "heading" id = "intro">
#   Introduction
# </h1>

# You could select it by its class using the CSS selector ".heading", or by its id using the CSS selector "#intro".

# Once you've selected an element with a CSS selector, you can get the element tag name just like you did with XPATH selectors, with html_name(). Try it!

# Instructions 
# (1) The infobox you extracted in Chapter 4 has the class infobox. Use html_nodes() and the appropriate CSS selector to extract the infobox element to infobox_element.
# Extract element with class infobox
infobox_element <- html_nodes(test_xml, css = ".infobox")

# (2) Use html_name() to extract the tag name of infobox_element and store it in element_name
# Get tag name of infobox_element
# Terrific! This is the same element you selected in Chapter 4 with an XPATH statement, and unsurprisingly it has the same tag, it's a table
element_name <- html_name(infobox_element)

# Print element_name
print(element_name)

#### Chapter 3. Scraping text ####
# Of course you can get the contents of a node extracted using a CSS selector too, with html_text().
# Can you put the pieces together to get the page title like you did in Chapter 4?

# Instructions
# The Infobox HTML element is stored in infobox_element in your workplace. 
# (1) Use html_node() to extract the element from infobox_element with the css class fn
# Extract element with class fn 
page_name <- html_node(x = infobox_element, css = ".fn")

# (2) Use html_text() to extract the contents of page_name. 
# Get contents of page_name
page_title <- html_text(page_name)

# (3) Print page_title
page_title

#### Part 2. Final case Study: Introduction #### 
#### Chapter 1. API calls ####
# Your first step is to use the Wikipedia API to get the page contents for a specific page. We'll continue to work with the Hadley Wickham page, but as your last exercise, you'll make it more general.

# To get the content of a page from the Wikipedia API you need to use a parameter based URL. The URL you want is

# https://en.wikipedia.org/w/api.php?action=parse&page=Hadley%20Wickham&format=xml

# which specifies that you want the parsed content (i.e the HTML) for the "Hadley Wickham" page, and the API response should be XML.

# In this exercise you'll make the request with GET() and parse the XML response with content().

# Instructions
# We've already defined base_url for you. 
# load httr
library(httr)
# THE API url
base_url <- "https://en.wikipedia.org/w/api.php"

# (1) Create a list for the query parameters, setting action = "parse", page = "Hadley Wickham" and format = "xml". 
# Set query parameters
query_params <- list(action = "parse", 
                     page = "Hadley Wickham", 
                     format = "xml")

# (2) Use GET() to call the API by specifying url and query. 
resp <- GET(url = base_url, query = query_params)

# (3) Parse the response using content(). 
# Parse response
resp_xml <- content(resp) # API stiyle

# Good work! You now have a response, but can you find the HTML for the page in that response?

#### Chapter 2. Extracting Information ####
# Now we have a response from the API, we need to extract the HTML for the page from it. It turns out the HTML is stored in the contents of the XML response.
# Take a look, by using xml_text() to pull out the text from the XML response:

# xml_text(resp_xml)

# In this exercise, you'll read this text as HTML, then extract the relevant nodes to get the infobox and page title. 

library(rvest)
# Instructions
# Code from the previous exercise has already been run, so you have resp_xml available in your workspace. 
# (1) Use read_html() to read the contents of the XML response(xml_text(resp_xml)) as HTML. # Read page contents as HTML
page_html <- read_html(xml_text(resp_xml))
page_html

# (2) Use html_node() to extract the infobox element (having the class infobox) from page_html with a CSS selector. 
# Extract infobox element
infobox_element <- html_node(page_html, css = ".infobox")

# (3) Use html_node() to extract the page title element(having the class fn) from infobox_element with a CSS selector. 
# Extract page name element from infobox
page_name <- html_node(infobox_element, css = ".fn")

# (4) Extract the title text from page_name with html_text(). 
# Extract page name as text
page_title <- html_text(page_name)
page_title

# Fantastic! You have the info you need you just need to return it in a nice format.

#### Chapter 3. Normalising Informaiton ####
# Now it's time to put together the information in a nice format. You've already seen you can use html_table() to parse the infobox into a data frame. But one piece of important information is missing from that table: who the information is about!

# In this exercise, you'll parse the infobox in a data frame, and add a row for the full name of the subject.

# Instructions 
# (1) Create a new data frame where key is the string "Full name" and value is our previously stored page_title.
# Your code from earlier exercises
wiki_table <- html_table(infobox_element)
colnames(wiki_table) <- c("key", "value")
cleaned_table <- subset(wiki_table, !key == "")

# (2) Combine name_df with cleaned_table using rbind() and assign it to wiki_table2.
# Create a dataframe for full name
name_df <- data.frame(key = "Full name", value = page_title)
# Combine name_df with cleaned_table
wiki_table2 <- rbind(name_df, cleaned_table)

# (3) Print wiki_table2.
print(wiki_table2)

#### Chapter 4. Reproducibility ####
# Now you've figured out the process for requesting and parsing the infobox for the Hadley Wickham page, it's time to turn it into a function that does the same thing for anyone.

# You've already done all the hard work! In the sample script we've just copied all your code from the previous three exercises, with only one change: we've wrapped it in the function definition syntax, and chosen the name get_infobox() for this function.

# It doesn't quite work yet, the argument title isn't used inside the function. In this exercise you'll fix that, then test it out with some other personalities.

# Instructions 
# (1) Fix the function, by replacing the string "Hadley Wickham" with title, so that the title argument of the function will be used for the query.
get_infobox <- function(title) {
  pkgs <- c("httr", "rvest", "xml2")
  sapply(pkgs, require, character.only = T)
  base_url <- "https://en.wikipedia.org/w/api.php"
  
  # Change "Hadley Wickham" to title
  query_params <- list(action = "parse", 
                       page = title, 
                       format = "xml")
  
  resp <- GET(url = base_url, query = query_params)
  resp_xml <- content(resp)
  
  page_html <- read_html(xml_text(resp_xml))
  infobox_element <- html_node(x = page_html, css =".infobox")
  page_name <- html_node(x = infobox_element, css = ".fn")
  page_title <- html_text(page_name)
  
  wiki_table <- html_table(infobox_element)
  colnames(wiki_table) <- c("key", "value")
  cleaned_table <- subset(wiki_table, !wiki_table$key == "")
  name_df <- data.frame(key = "Full name", value = page_title)
  wiki_table <- rbind(name_df, cleaned_table)
  
  wiki_table
}

# (2) Test get_infobox() with title = "Hadley Wickham".
get_infobox(title = "Hadley Wickham")

# (3) Now, try getting the infobox for "Ross Ihaka".
get_infobox(title = "Ross Ihaka")

# (4) Finally, try getting the infobox for "Grace Hopper".
get_infobox(title = "Grace Hopper")

# (5) Finally, try getting the infobox for "Donald Trump"
get_infobox(title = "Donald Trump")
