# Part 1. GET and POST requests in theory
# Chapter 1. GET requests in practice
# To start with you're going to make a GET request. As discussed in the video, this is a request that asks the server to give you a particular piece of data or content (usually specified in the URL). These make up the majority of the requests you'll make in a data science context, since most of the time you'll be getting data from servers, not giving it to them.

# To do this you'll use the httr package, written by Hadley Wickham (of course), which makes HTTP requests extremely easy. You're going to make a very simple GET request, and then inspect the output to see what it looks like.

# Load the httr package.
library(httr)

# Use the GET() function to make a request to http://httpbin.org/get, saving the result to get_result.
# Make a GET request to http://httpbin.org/get
get_result <- GET("http://httpbin.org/get")

# Print get_result to inspect it.
print(get_result)

# Chapter 2. POST requests in practice
# Next we'll look at POST requests, also made through httr, with the function (you've guessed it) POST(). Rather than asking the server to give you something, as in GET requests, a POST request asks the server to accept something from you. They're commonly used for things like file upload, or authentication. As a result of their use for uploading things, POST() accepts not just a url but also a body argument containing whatever you want to give to the server.

# You'll make a very simple POST request, just uploading a piece of text, and then inspect the output to see what it looks like.

# INSTRUCTIONS
# Load the httr package.
library(httr)

# Make a POST request with the URL http://httpbin.org/post and the body "this is a test", saving the result to post_result.
post_result <- POST(url = "http://httpbin.org/post", body = "this is a test")

# Print post_result to inspect it.
post_result

# Nicely done. The output for POST requests looks pretty similar to that for GET requests, although (in this case) the body of your message is included - this is a test. Again, we'll dig into certain elements of the output in just a bit.

# Chapter 3. Extracting the response
# Making requests is all well and good, but it's also not why you're here. What we really want to do is get the data the server sent back, which can be done with httr's content() function. You pass it an object returned from a GET (or POST, or DELETE, or...) call, and it spits out whatever the server actually sent in an R-compatible structure.

# We're going to demonstrate that now, using a slightly more complicated URL than before - in fact, using a URL from the Wikimedia pageviews system you dealt with through the pageviews package, which is stored as url. Without looking too much at the structure for the time being (we'll get to that later) this request asks for the number of pageviews to the English-language Wikipedia's "Hadley Wickham" article on 1 and 2 January 2017.

# (1) Make a GET request using the url object as the URL. Save the results as "pageview_response"
# Make a GET request to url and save the results 
url <- "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia.org/all-access/all-agents/Hadley_Wickham/daily/20170101/20170102"
pageview_response <- GET(url)


# (2) Call content() on pageview_response to retrieve the data the server has sent back. Save the data as pageview_data.
# Call content() to retrieve the data the server sent back
pageview_data <- content(pageview_response)

# (3) Examine pageview_data with str()
# Examine the results with str()
str(pageview_data)

# Great! As you can see, the result of extracting the content is a list, which is pretty common (but not uniform) to API responses. We'll talk through how to manipulate returned data later on.

# Quiz 1. Multiple Choice: GET and POST requests
# We've now discussed multiple types of HTTP request - including GET requests, for retrieving data, and POST requests, for transmitting it - as well as how to extract the server response once a request is complete. What sort of request would you use to send a server data?

# The answer is POST request
# POST requests send data - GET requests retrieve it."

# Part 2. Graceful httr
# Chapter 1. Handling http failures

# As mentioned, HTTP calls can go wrong. Handling that can be done with httr's http_error() function, which identifies whether a server response contains an error.

# If the response does contain an error, calling http_error() over the response will produce TRUE; otherwise, FALSE. You can use this for really fine-grained control over results. For example, you could check whether the request contained an error, and (if so) issue a warning and re-try the request.

# For now we'll try something a bit simpler - issuing a warning that something went wrong if http_error() returns TRUE, and printing the content if it doesn't.

# INSTRUCTIONS

# (1) Make a httr GET() request to the URL stored as fake_url, and store the result as request_result.
fake_url <- "http://google.com/fakepagethatdoesnotexist"

# (2) If http_error() returns TRUE, use warning() to issue the warning "The request failed".
# Make the GET request
request_result <- GET(fake_url)

# (3) If not, use content() (as demonstrated in previous exercises) to print the contents of the result.
# Check request_result
if(http_error(request_result)){
  warning("The request failed")
} else {
  content(request_result)
}

# Chapter 2. Constructing queries (Part I)
# As briefly discussed in the previous video, the actual API query (which tells the API what you want to do) tends to be in one of the two forms. The first is directory-based, where values are separated by / marks within the URL. The second is parameter-based, where all the values exist at the end of the URL and take the form of key=value.

# Constructing directory-based URLs can be done via paste(), which takes an unlimited number of strings, along with a separator, as sep. So to construct http://swapi.co/api/vehicles/12 we'd call:

# paste("http://swapi.co", "api", "vehicles", "12", sep = "/")

# Let's do that now! We'll cover parameter-based URLs later. In the mean time we can play with SWAPI, mentioned above, which is an API chock full of star wars data. This time, rather than a vehicle, we'll look for a person.

# instruction
# (1)  Construct a directory-based API URL to http://swapi.co/api, looking for person 1 in people.

# (2) Assign the URL to directory_url
directory_url <- paste("http://swapi.co/api", "people", "1", sep = "/")

# (3) Use GET to make an API call with directory_url.
# Well done! Since the url mentioned in fake_url doesn't exist, the code threw the warning message you mentioned. Error handling is really important for writing robust code, and it looks like you've got a good handle on it.
# Make a GET call with it
result <- GET(directory_url)

# Constructing these kinds of queries is very simple, but also extremely important. Now you know how to write automated or semi-automated code for more modern APIs.

# Chapter 2. Constructing queries (Part II)
# As mentioned (albeit briefly) in the last exercise, there are also parameter based URLs, where all the query values exist at the end of the URL and take the form of key=value - they look something like 
# "http://fakeurl.com/foo.php?country=spain&food=goulash"
# Constructing parameter-based URLs can also be done with paste(), but the easiest way to do it is with GET() and POST() themselves, which accept a query argument consisting of a list of keys and values. So, to continue with the food-based examples, we could construct 
# fakeurl.com/api.php?fruit=peaches&day=thursday
# GET("fakeurl.com/api.php", query = list(fruit = "peaches", day = "thursday"))
# In this exercise you'll construct a call to 
# https://httpbin.org/get?nationality=americans&country=antigua

# (1) Start by contructing the query_params list, with a nationality parameter of "americans" and a country parameter of "antigua".
# Create list with nationality and country elements
query_params <- list(nationality = "americans", country = "antigua")

# (2) Construct a parameter-based call to https://httpbin.org/get, using GET() passing query_params to the query arugment.
# Make parameter-based call to httpbin, with query_params
parameter_response <- GET("https://httpbin.org/get", query = query_params)

# (3) Print the response parameter_response. 
# Print parameter_response
parameter_response

# Part 3. Using httr to interact with APIs directly
# Chapter 1. Using user agents
# As discussed in the video, informative user-agents are a good way of being respectful of the developers running the API you're interacting with. They make it easy for them to contact you in the event something goes wrong. I always try to include: 
# My Email Address;
# A URL for the project the code is a part of, if it's got a URL.

# Building user agents is done by passing a call to user_agent() into the GET() or POST() request; something like:
# GET("http://url.goes.here/", user_agent("somefakeemail@domain.com http://project.website"))

# In the event you don't have a website, a short one-sentence description of what the project is about serves pretty well.

# Instructions
# Make a GET() request to url.
# Do not change the url
url <- "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/Aaron_Halfaker/daily/2015100100/2015103100"

# Include a user agent that has a fake email adress "my@email address" followed by the sentence "this is a test."
# Assign the response to server_response
# Add the email address and the test sentence inside user_agent()
server_response <- GET(url = url, user_agent("my@email.address this is a test"))

# Chapter 2. Rate-limiting
# The next stage of respectful API usage is rate-limiting: making sure you only make a certain number of requests to the server in a given time period. What limit is expected will vary from server to server, but the implementation is always pretty much the same and involves a call to Sys.sleep(). This function takes one argument, a number, which represents the number of seconds to "sleep" (pause) the R session for. So if you call Sys.sleep(15), it'll pause for 15 seconds before allowing further code to run.

# As you can imagine, this is really useful for rate-limiting. Only allowed 4 requests a minute? No problem! Just pause for 15 seconds between each request and you're guaranteed to never exceed it. Let's demonstrate now by putting together a little loop that sends multiple requests, on a 10-second time delay.

# (1) Construct a vector of 2 URLs, http://fakeurl.com/api/1.0/ and http://fakeurl.com/api/2.0/
# Construct a vector of 2 URLs
urls <- c("http://fakeurl.com/api/1.0/", "http://fakeurl.com/api/2.0/")

# (2) Write a for-loop that sends a GET() request to each one. 
for(url in urls){
  # Send a GET request to url
  # Write a for-loop that sends a GET() request to each one.
  result <- GET(url)
  # Ensure that the for-loop uses Sys.sleep() to delay for 5 seconds between request.
  # Delay for 5 seconds between requests
  Sys.sleep(5)
}

# Chapter 3. Tying it all together
# Using everything that you learned in the chapter, let's make a simple replica of one of the 'pageviews' functions - building queries, sending GET requests (with an appropriate user agent) and handling the output in a fault-tolerant way. To do this, you will use the function stop(), which takes a string as an argument, and stops the execution of the program.

# Using the example function structure: Construct a URL pointing at
# https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/**YOUR_ARTICLE_TITLE**/daily/2015100100/2015103100

# dynamically inserting **YOUR_ARTICLE_TITLE**.

# Make the request with a user agent containing a fake email address followed by a sample string: ("my@email.com this is a test").

# Check the result for errors with http_error(), throwing an alert of "the request failed" with stop() if there was one.

# Extract the body of the request with content() before returning it.
get_pageviews <- function(article_title){
  
  url <- paste0("https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents", 
                article_title, 
                "daily/2015100100/2015103100", 
                sep = "/") 
  
  response <- GET(url, user_agent("my@email.com this is a test")) 
  if(http_error(response)){ 
    stop(http_error()) 
  } else { 
    result <- content(response) 
    return(result) 
  }
}

# Congratulations! You've finished the chapter, and should now have a good handle on how to work with httr. Our next chapter will cover digging into the results you get back from your requests.