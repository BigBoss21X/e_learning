#### Displaying text outputs ####
# The goal in this exercise is to develop an app where the user selects two variables and their relationship is visualized with a scatterplot, and averages of both variables are reported as well as the output of the linear regression predicting the variable on the y-axis from the variable in the x-axis. The code on the right only does some of these things.

# Instructions
# Add the appropriate output UI functions and output IDs to print the elements noted in the comments on lines 30 to 33 in the mainPanel of the UI and run the app. Check the server function to find the ouput IDs. Also add commas as needed.

# In the server function averages are calculated first and then the regression model is fit, but in the app the regression output comes before the averages. Make the necessary changes to the app UI so that averages are displayed above the regression output.

# Question source
library(shiny)
library(dplyr)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input(s)
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
                  selected = "critics_score")
      
    ),
    
    # Output(s)
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      ___(outputId = ___) # regression output
      ___(outputId = ___) # avg of x
      ___(outputId = ___) # avg of y
      
    )
  )
  
  # Server
  server <- function(input, output) {
    
    # Create scatterplot
    output$scatterplot <- renderPlot({
      ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
        geom_point()
    })
    
    # Calculate average of x
    output$avg_x <- renderText({
      avg_x <- movies %>% pull(input$x) %>% mean() %>% round(2)
      paste("Average", input$x, "=", avg_x)
    })
    
    # Calculate average of y
    output$avg_y <- renderText({
      avg_y <- movies %>% pull(input$y) %>% mean() %>% round(2)
      paste("Average", input$y, "=", avg_y)
    })
    
    # Create regression output
    output$lmoutput <- renderPrint({
      x <- movies %>% pull(input$x)
      y <- movies %>% pull(input$y)
      summ <- summary(lm(y ~ x, data = movies)) 
      print(summ, digits = 3, signif.stars = FALSE)
    })
    
  }
  
  # Create a Shiny app object
  shinyApp(ui = ui, server = server)
