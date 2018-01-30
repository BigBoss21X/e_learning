#### Part 1. Web scraping 101 ####
# 1. Selectors
# (1) Little browser extensions
# (2) Identify the specific bit(s) you want 
# (3) Give you a unique ID to grab them with
# (4) Not used in this course (but worth grabbing after)

# 2. rvest
# (1) rvest is a dedicated web scraping package
# (2) Makes things shockingly easy
# (3) Read HTML page with read_html(url = ___)

# 3. Parsing HTML
# (1) read_html() returns an XML document
# (2) Use html_node() to extract contents with XPATHs

#### Chapter 1. Reading HTML ####
# The first step with web scraping is actually reading the HTML in. This can be done with a function from xml2, which is imported by rvest - read_html(). This accepts a single URL, and returns a big blob of XML that we can use further on.

# We're going to experiment with that by grabbing Hadley Wickham's wikipedia page, with rvest, and then printing it just to see what the structure looks like.

# INSTRUCTIONS

# (1) Load the rvest package.
library(rvest)

# (2) Use read_html() to read the URL stored at test_url. Store the results as test_xml.
# Hadley Wickham's Wikipedia page
test_url <- "https://en.wikipedia.org/wiki/Hadley_Wickham"
# Read the URL stored as "test_url" with read_html()
test_xml <- read_html(test_url)

# (3) Print test_xml.
print(test_xml)

#### Chapter 2. Extracting nodes by XPATH ####
# Now you've got a HTML page read into R. Great! But how do you get individual, identifiable pieces of it?

# The answer is to use html_node(), which extracts individual chunks of HTML from a HTML document. There are a couple of ways of identifying and filtering nodes, and for now we're going to use XPATHs: unique identifiers for individual pieces of a HTML document.

# These can be retrieved using a browser gadget we'll talk about later - in the meanwhile the XPATH for the information box in the page you just downloaded is stored as test_node_xpath. We're going to retrieve the box from the HTML doc with html_node(), using test_node_xpath as the xpath argument.

# Instructions
# (1) Use html_node() to retrieve the node with the XPATH stored at test_node_xpath from test_xml document you grabbed in the last exercise.
# Use html_node() to grab the node with the XPATH stored as `test_node_xpath`
test_node_xpath <- "//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"vcard\", \" \" ))]"

node <- html_node(x = test_xml, xpath = test_node_xpath)

# (2) Print the first element of the results. 
print(node[[1]])
# Good job! XML nodes are the building block of an XML document - extracting them leads to everything else. At the moment, they're still kind of abstract objects: we'll dig into their contents later on.

#### Part 2. HTML structure ####
#### Chapter 1. Extracting names ####
# The first thing we'll grab is a name, from the first element of the previously extracted table (now stored as table_element). We can do this with html_name(). As you may recall from when you printed it, the element has the tag <table>...</table>, so we'd expect the name to be, well, table.

# INSTRUCTIONS

# (1) Extract the name of table_element using the function html_name(). Save it as element_name.
element_name <- html_name(node)

# (2) Print element_name.
print(element_name)

# Nice work! You've started extracting components from HTML and XML nodes. The tag might not seem important (and most of the time, it's not) but it's a good first step, and the actual node contents (text, say) is something we'll move on to next.

#### Chapter 2. Extracting values ####
# Just knowing the type of HTML object a node is isn't much use, though (although it can be very helpful). What we really want is to extract the actual text stored within the value.

# We can do that with (shocker) html_text(), another convenient rvest function that accepts a node and passes back the text inside it. For this we'll want a node within the extracted element - specifically, the one containing the page title. The xpath value for that node is stored as second_xpath_val.

# Using this xpath value, extract the node within table_element that we want, and then use html_text to extract the text, before printing it.

# Instructions
# (1) Extract the element of table_element referred to by second_xpath_val and store it as page_name.
# Extract the element of table_element referred to by second_xpath_val and store it as page_name
second_xpath_val <- "//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"fn\", \" \" ))]"
page_name <- html_node(x = node, xpath = second_xpath_val)

# (2) Extract the text from page_name using html_text(), saving it as page_title
# Extract the text from page_name
page_title <- html_text(page_name)

# (3) Print page_title
print(page_title)

# Test: HTML reading and extraction
# Time for a quick  test of what we've learned about HTML. What would you use to extract the type of HTML tag a value is wrapped in? html_name()
# Correct! The type of tag is the tag name - so html_name() is the right function.

#### Part 3. Reformatting Data ####
#### Chapter 1. Extracting tables ####
# The data from Wikipedia that we've been playing around with can be extracted bit by bit and cleaned up manually, but since it's a table, we have an easier way of turning it into an R object. rvest contains the function html_table() which, as the name suggests, extracts tables. It accepts a node containing a table object, and outputs a data frame.

# Let's use it now: take the table we've extracted, and turn it into a data frame.

# Instructions 
# (1) Turn table_element into a data frame and assign it to wiki_table
wiki_table <- html_table(node)

# (2) Print the resulting object.
print(wiki_table)

#### Chapter 2. Cleaning a data frame ####
# In the last exercise, we looked at extracting tables with html_table(). The resulting data frame was pretty clean, but had two problems - first, the column names weren't descriptive, and second, there was an empty row.

# In this exercise we're going to look at fixing both of those problems. First, column names. Column names can be cleaned up with the colnames() function. You call it on the object you want to rename, and then assign to that call a vector of new names.

# The missing row, meanwhile, can be removed with the subset() function. subset takes an object, and a condition. For example, if you have a data frame df containing a column x, you could run

# subset(df, !x == "")

# to remove all rows from df consisting of empty strings ("") in the column x.

# Instructions 

# Rename the columns of wiki_table to "key" and "value" using colnames().
# Remove the empty row from wiki_table using subset(), and assign the result to cleaned_table.
# Print cleaned_table.
