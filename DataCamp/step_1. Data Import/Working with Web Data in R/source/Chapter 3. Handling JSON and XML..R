# Part 1. JSON
# Lecture 1. JSON
# JSON, JavaScript Object Notation
# Plain text format
# Two structures:
  # objects:{"title" : "A New Hope", "year" : "1977"}
  # arrays:[1977, 1980]

# values: "string", 3, true, false, null, or another object or array

# Chpater 1. Parsing JSON
# While JSON is a useful format for sharing data, your first step will often be to parse it into an R object, so you can manipulate it with R.

# The content() function in httr retrieves the content from a request. It takes an as argument that specifies the type of output to return. You've already seen that as = "text" will return the content as a character string which is useful for checking the content is as you expect.

# If you don't specify as, the default as = "parsed" is used. In this case the type of content() will be guessed based on the header and content() will choose an appropriate parsing function. For JSON this function is fromJSON() from the jsonlite package. If you know your response is JSON, you may want to use fromJSON() directly.

# To practice, you'll retrieve some revision history from the Wikipedia API, check it is JSON, then parse it into a list two ways.

# Instructions
# (1) Get the revision history for the Wikipedia article for "Hadley Wickham", by calling rev_history("Hadley Wickham") (a function we have written for you), store it in resp_json.
library(httr)

rev_history <- function(title, format = "json"){
  if (title != "Hadley Wickham") {
    stop('rev_history() only works for `title = "Hadley Wickham"`')
  }
  if (format == "json"){
    resp <- readRDS("had_rev_json.rds")
  } else if (format == "xml"){
    resp <- readRDS("had_rev_xml.rds")
  } else {
    stop('Invalid format supplied, try "json" or "xml"')
  }
  resp  
}

url <- "https://en.wikipedia.org/w/api.php?action=query&titles=Hadley%20Wickham&prop=revisions&rvprop=timestamp%7Cuser%7Ccomment%7Ccontent&rvlimit=5&format=json&rvdir=newer&rvstart=2015-01-14T17%3A12%3A45Z&rvsection=0"

resp_json <- GET(url)

# (2) Check the http_type() of resp_json, to confirm the API returned a JSON object.
http_type(resp_json)

# (3) You can't always trust a header, so check the content looks like JSON by calling content() on resp_json with an additional argument, as.
# Examine returned text with content()
content(resp_json, as = "text")

# (4) Parse resp_json using content() by explicitly setting as = "parsed".
content(resp_json, as = "parsed")

# (5) Parse the returned text (from step 3) with fromJSON()
# Parse returned text with fromJSON()
library(jsonlite)
fromJSON(content(resp_json, as = "text"))

# Chapter 3. Manipulating parsed JSON
# As you saw in the video, the output from parsing JSON is a list. One way to extract relevant data from that list is to use a package specifically designed for manipulating lists, rlist.

# rlist provides two particularly useful functions for selecting and combining elements from a list: list.select() and list.stack(). list.select() extracts sub-elements by name from each element in a list. For example using the parsed movies data from the video (movies_list), we might ask for the title and year elements from each element:
# list.select(movies_list, title, year)
# The result is still a list, that is where list.stack() comes in. It will stack the elements of a list into a data frame. 

# list.stack(list.select(movies_list, title, year))

# In this exercise you'll use these rlist functions to create a data frame with the user and timestamp for each revision.

# Instructions
# install.packages("rlist")
library(rlist)

# (1) First, you'll need to figure out where the revisions are. Examine the output from the str() call. Can you see where the list of 5 revisions is? 
str(content(resp_json), max.level = 4)

# (2) Store the revisions in revs. 
revs <- content(resp_json)$query$pages$`41916270`$revisions

# (3) list.select() to pull out the user and timestamp elements from each revision, store in user_time. 
# Extract the user element
user_time <- list.select(revs, user, timestamp)

# (4) Print user_time to verify it's a list with one element 
# Print user_time
print(user_time)

# (5) Use list.stack() to stack the lists into a data frame. 
# Stack to turn into a data frame
list.stack(user_time)

# Chapter 4. Reformatting JSON
# Of course you don't have to use rlist. You can achieve the same thing by using functions from base R or the tidyverse. In this exercise you'll repeat the task of extracting the username and timestamp using the dplyr package which is part of the tidyverse.
# Conceptually, you'll take the list of revisions, stack them into a data frame, then pull out the relevant columns.
# dplyr's bind_rows() function takes a list and turns it into a data frame. Then you can use select() to extract the relevant columns. And of course if we can make use of the %>% (pipe) operator to chain them all together.

# Try it!

# Instructions
# Load dplyr
library(dplyr)
# Pipe the list of revisions into bind_rows()
# Pull out revision list
revs <- content(resp_json)$query$pages$`41916270`$revisions
# Use select() to extract the user and timestamp columns
# Extract user and timestamp
revs %>% 
  bind_rows() %>% 
  select(user, timestamp)

# Part 3. XML structure
# Chapter 1. Examining XML documents
# Just like JSON, you should first verify the response is indeed XML with http_type() and by examining the result of content(r, as = "text"). Then you can turn the response into an XML document object with read_xml().

# One benefit of using the XML document object is the available functions that help you explore and manipulate the document. For example xml_structure() will print a representation of the XML document that emphasizes the hierarchical structure by displaying the elements without the data.

# In this exercise you'll grab the same revision history you've been working with as XML, and take a look at it with xml_structure().

# Instructions
# Load xml2 
library(xml2)

# (1) Get the XML version of the revision history for the Wikipedia article for "Hadley Wickham", by calling rev_history("Hadley Wickham", format = "xml"), store it in resp_xml.
# Get XML revision history
urlXml <- "https://en.wikipedia.org/w/api.php?action=query&titles=Hadley%20Wickham&prop=revisions&rvprop=timestamp%7Cuser%7Ccomment%7Ccontent&rvlimit=5&format=xml&rvdir=newer&rvstart=2015-01-14T17%3A12%3A45Z&rvsection=0"

resp_xml <- GET(urlXml)

# (2) Check the response type of resp_xml to confirm the API returned an XML object.
http_type(resp_xml)

# (3) You can't always trust a header, so check the content looks like XML by calling content() on resp_xml with as = "text", store in rev_text.
# Examine returned text with content()
rev_text <- content(resp_xml, as = "text")

# (4) Turn rev_text into an XML object with read_xml() from the xml2 package, store as rev_xml.
# Turn rev_text into an XML document
rev_xml <- read_xml(rev_text)

# (5) Call xml_structure() on rev_xml to see the structure of the returned XML. Can you see where the revisions are?
# Examine the structure of rev_xml
xml_structure(rev_xml)

# Part 5. XPATHs
# Chapter 1. Extracting XML data
# XPATHs are designed to specifying nodes in an XML document. Remember /node_name specifies nodes at the current level that have the tag node_name, where as //node_name specifies nodes at any level below the current level that have the tag node_name.

# xml2 provides the function xml_find_all() to extract nodes that match a given XPATH. For example, xml_find_all(rev_xml, "/api") will find all the nodes at the top level of the rev_xml document that have the tag api. Try running that in the console. You'll get a nodeset of one node because there is only one node that satisfies that XPATH.

# The object returned from xml_find_all() is a nodeset (think of it like a list of nodes). To actually get data out of the nodes in the nodeset, you'll have to explicitly ask for it with xml_text() (or xml_double() or xml_integer()).

# Use what you know about the location of the revisions data in the returned XML document extract just the content of the revision.

# Instructions 
# (1) Use xml_find_all() on rev_xml to find all the nodes that describe revisions by using the XPATH, "/api/query/pages/page/revisions/rev".
# Find all nodes using XPATH "/api/query/pages/page/revisions/rev"
xml_find_all(rev_xml, "/api/query/pages/page/revisions/rev")

# (2) Use xml_find_all() on rev_xml to find all the nodes that are in a rev node anywhere in the document, store in rev_nodes.
# Find all rev nodes anywhere in document
rev_nodes <- xml_find_all(rev_xml, "//rev")

# (3) Extract the contents from each node in rev_nodes, by passing rev_nodes to xml_text().
xml_text(rev_nodes)

# Chapter 2. Extracting XML attributes
# Extracting XML attributes
# Not all the useful data will be in the content of a node, some might also be in the attributes of a node. To extract attributes from a nodeset, xml2 provides xml_attrs() and xml_attr().
# xml_attrs() takes a nodeset and returns all of the attributes for every node in the nodeset. xml_attr() takes a nodeset and an additional argument attr to extract a single named argument from each node in the nodeset.
# In this exercise you'll grab the user and anon attributes for each revision. You'll see xml_find_first() in the sample code. It works just like xml_find_all() but it only extracts the first node it finds.

# Instructions
# All rev nodes
rev_nodes <- xml_find_all(rev_xml, "//rev")

# (1) Use xml_attrs() on first_rev_node to see all the attributes of the first revision node.
# The first rev node
first_rev_node <- xml_find_first(rev_xml, "//rev")

# (2) Use xml_attr() on first_rev_node along with an appropriate attr argument to extract the user attribute from the first revision node.
# Find all attributes with xml_attrs()
xml_attrs(first_rev_node)

# (3) Now use xml_attr() again, but this time on rev_nodes to extract the user attribute from all revision nodes.
# Find user attribute with xml_attr()
xml_attr(first_rev_node, "user")

# (4) Use xml_attr() on rev_nodes to extract the anon attribute from all revision nodes.
# Find user attribute for all rev nodes
xml_attr(rev_nodes, "user")

# (5) Use xml_attr() on rev_nodes to extract the anon attribute from all revision nodes.
xml_attr(rev_nodes, "anon")

# Chapter 5. Wrapup: returning nice API output
# How might all this work together? A useful API function will retrieve results from an API and return them in a useful form. In Chapter 2, you finished up by writing a function that retrieves data from an API that relied on content() to convert it to a useful form. To write a more robust API function you shouldn't rely on content() but instead parse the data yourself.

# To finish up this chapter you'll do exactly that: write get_revision_history() which retrieves the XML data for the revision history of page on Wikipedia, parses it, and returns it in a nice data frame.

# So that you can focus on the parts of the function that parse the return object, you'll see your function calls rev_history() to get the response from the API. You can assume this function returns the raw response and follows the best practices you learnt in Chapter 2, like using a user agent, and checking the response status.

# (1) Use read_xml() to turn the content() of rev_resp as text into an XML object.

# (2) Use xml_find_all() to find all the rev nodes in the XML.

# (3) Parse out the "user" attribute from rev_nodes.

# (4) Parse out the content from rev_nodes using xml_text().

# (5) Finally, call get_revision_history() with article_title = "Hadley Wickham".
get_revision_history <- function(url){
  # Get raw revision response
  resp_xml <- GET(url)
  
  # Turn the content() of rev_resp into XML
  rev_text <- content(resp_xml, as = "text")
  rev_xml <- read_xml(rev_text)
  
  # Find revision nodes
  rev_nodes <- xml_find_all(rev_xml, "//rev")
  
  # Parse out usernames
  user <- xml_attr(rev_nodes, "user")
  
  # Parse out timestamps
  timestamp <- readr::parse_datetime(xml_attr(rev_nodes, "timestamp"))
  
  # Parse out content
  content <- xml_text(rev_nodes)
  
  # Return data frame 
  data.frame(user = user,
             timestamp = timestamp,
             content = substr(content, 1, 40))
}

# Call function for "Hadley Wickham"
get_revision_history(urlXml)
