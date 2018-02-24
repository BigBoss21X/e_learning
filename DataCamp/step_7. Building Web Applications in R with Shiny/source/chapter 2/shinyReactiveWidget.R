library(shiny)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Chapter 1. Building a reactgive widget
# As we saw in the previous video, reactivity is established by linking an input with an output via a render*() function.

# Instructions
# Add a new input widget, a sliderInput, at line 27 that controls the transparency of the plotted points. This widget should have the ID alpha and its values should range between 0 and 1. 
# Set the label = "Alpha:" and the value = 0.5
# Make the associated update in the server function.

# Define UI for application that plots features of moviews 
ui <- fluidPage(
 
  # Sidebar layout with a input and output definitions 
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(
        inputId = "y", 
        label = "Y-axis:", 
        choices = c("imdb_rating", "imbd_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "audience_score"), 
      
      # Select variable for x-axis
      selectInput(
        inputId = "x", 
        label = "X-axis:", 
        choices = c("imdb_rating", "imbd_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "critics_score"), 
      
      # Set alpha level
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, 
                  max = 1, 
                  value = 0.5)
    ), 
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot"), 
      plotOutput(outputId = "densityplot", height = 200)
    )
  )
)

# Define servere function required to create the scatterplot
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) + 
      geom_point(alpha = input$alpha)
  })
  
  # Create densityplot
  output$densityplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x)) +
      geom_density()
  })
}

# Create the Shiny app object
shinyApp(ui = ui, server = server)
