#### Hovering & Brushing #### 
# In addition to brushing, users can also interact with plots by hovering over them.

# Instructions 
# Change the brush argument to hover in the plotOutput on line 39 and update the passed value to be "plot_hover".

# Read the article on Selecting rows of data to determine what change needs to be made in the renderDataTable function to list the data points that the user hovers on.

# Implement this change.
?plotOutput
# Load packages
library(shiny)
library(ggplot2)
library(tidyverse)
library(DT)

# Load data
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  br(),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    # Inputs
    sidebarPanel(
      # Select variable for y-axis
      selectInput(inputId = "y", label = "Y-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
                  selected = "audience_score"),
      # Select variable for x-axis
      selectInput(inputId = "x", label = "X-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
                  selected = "critics_score")
    ),
    
    # Output:
    mainPanel(
      # Show scatterplot with brushing capability
      plotOutput(outputId = "scatterplot", hover = "plot_hover"),
      # Show data table
      dataTableOutput(outputId = "moviestable"),
      br()
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point() + 
      theme_classic()
  })
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    nearPoints(movies, coordinfo = input$plot_hover) %>% 
      select(title, audience_score, critics_score)
  })
}



# Create a Shiny app object
shinyApp(ui = ui, server = server)
