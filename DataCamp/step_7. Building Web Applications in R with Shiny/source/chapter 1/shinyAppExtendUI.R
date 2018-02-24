# Chapter 1. First peek under the hood
# On the right you can see the complete code to reproduce the app we demoed in the previous video. Don't be intimidated by how much code there is! Soon you'll be able to make this app yourself. Now you get to interact with the app on your own, and make small adjustments to it.

# install.packages("shiny")
library(shiny)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies. 
ui <- fluidPage(
  # Sidebar layout with a input and output definitions 
  sidebarLayout(
    # Inputs
    sidebarPanel(
      # select variable for y-axis
      selectInput(
        inputId = "y", 
        label = "Y-axis:", 
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "audience_score"
      ),
      
      # Select variable for x-axis
      selectInput(
        inputId = "x", 
        label = "X-axis:", 
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "critics_score"
      ), 
      
      # Select Variable for Color
      selectInput(inputId = "z", 
                  label = "Color by:", 
                  choices = c("title_type", "genre", "mpaa_rating", "critics_rating", "audience_rating"), 
                  selected = "mpaa_rating")
    ), 
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Define Server function required to create the scatterplot
server <- function(input, output) {
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y, color = input$z)) + 
      geom_point()
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

# Chapter 2. Extend the UI further
# The potential variables the user can select for the x and y axes and color currently appear in the UI of the app the same way that they are spelled in the data frame header. However we might want to label them in a way that is more human readable. We can achieve this using named vectors for the choices argument, in the format of "Human readable label" = "variable_name". As you're going through this exercise, watch out for typos!

library(shiny)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("IMDB rating"          = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics score"        = "critics_score", 
                              "Audience score"       = "audience_score", 
                              "Runtime"              = "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("IMDB rating"          = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics score"        = "critics_score", 
                              "Audience score"       = "audience_score", 
                              "Runtime"              = "runtime"), 
                  selected = "critics_score"),
      
      # Select variable for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Title type" = "title_type", 
                              "Genre" = "genre", 
                              "MPAA rating" = "mpaa_rating", 
                              "Critics rating" = "critics_rating", 
                              "Audience rating" = "audience_rating"),
                  selected = "mpaa_rating")
    ),
    
    # Output
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create the scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y,
                                     color = input$z)) +
      geom_point()
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
