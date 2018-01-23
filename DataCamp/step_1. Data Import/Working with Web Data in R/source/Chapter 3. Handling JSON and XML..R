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
