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
      )
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
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) + 
      geom_point()
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
