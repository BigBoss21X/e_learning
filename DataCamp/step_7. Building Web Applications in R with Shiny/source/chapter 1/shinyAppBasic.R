#### Chapter 1. First peek under the hood ####
# On the right you can see the complete code to reproduce the app we demoed in the previous video. Don't be intimidated by how much code there is! Soon you'll be able to make this app yourself. Now you get to interact with the app on your own, and make small adjustments to it.

# install.packages("shiny")
library(shiny)
library(tidyverse)

# 데이터 가져오기
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# 데이터 구조보기
glimpse(movies)
#### Chpater 1. First peek under the hood

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # inputs 
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(
        inputId = "y", 
        label = "Y-axis:",
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "imdb_rating"), 
      
      selectInput(
        inputId = "x", 
        label = "X-axis:", 
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "imdb_num_votes")
      ),
    # outputs
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) + 
      geom_point()
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 2. Extend the UI ####
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Question 1. Add a new selectInput widget at line 27 to color the points by a choice of the following variables: "title_type", "genre", "mpaa_rating", "critics_rating", "audience_rating". Set the inputId = "z" and the label = "Color by:"

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                  selected = "critics_score"),
      
      # Select variable for color
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

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create the scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y,
                                     color = input$z)) +
      geom_point() + 
      theme_classic()
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 3. Extend the UI further ####

# 데이터 가져오기
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Question 1. Fill in the blanks starting at line 17 with human readable labels for x and y inputs. 
# Use the labels "IMDB rating", "IMDB number of votes", "Critics score", "Audience score", and "Runtime"

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs 
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(
        inputId = "y", 
        label = "Y-axis:", 
        choices = c("IMDB rating" = "imdb_rating",
                    "IMDB number of votes" = "imdb_num_votes",
                    "Critics score" = "critics_score",
                    "Audience score" = "audience_score",
                    "Runtime" = "runtime"),
        selected = "audience_score"), 
      
      # Select variable for x-axis
      selectInput(
        inputId = "x", 
        label = "X-axis:", 
        choices = c("IMDB rating" = "imdb_rating",
                    "IMDB number of votes" = "imdb_num_votes",
                    "Critics score" = "critics_score",
                    "Audience score" = "audience_score",
                    "Runtime" = "runtime"),
        selected = "audience_score"),
      
      # select variable for color
      selectInput(
        inputId = "z", 
        label = "Color by:", 
        choices = c("Title type" = "title_type", 
                    "Genre" = "genre", 
                    "MPAA rating" = "mpaa_rating", 
                    "Critics rating" = "critics_rating", 
                    "Audience rating" = "audience_rating"), 
        selected = "audience_rating")
  ), 
  
  # Output
    mainPanel(
      plotOutput(outputId = "scatterplot", width = "100%", height =   "400px") 
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create the scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y, color = input$z)) + 
      geom_point() + 
      theme_classic()
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 4. Server function ####
# Review the app and identify erros in the code
# Fix the errors and test out the app

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
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create the scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, 
                                     y = input$y,
                                     color = input$z)) +
      geom_point()
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
