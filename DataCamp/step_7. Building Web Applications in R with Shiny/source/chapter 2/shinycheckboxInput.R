# library
pkgs <- c("shiny", "tidyverse", "DT")
sapply(pkgs, require, character.only = TRUE)

# Chapter 1. Add numericInput
# The app on the right allows users to randomly select a desired number of movies, and displays some information on the selected movies in a tabular output. This table is created using a new function, renderDataTable function from the DT package, but for now we will keep our focus on the numericInput widget. We will also learn to define variables outside of the app so that they can be used in multiple spots to make our code more efficient. 

# Instructions
# (1) Make sure entries in the sidebarPanel are separated by commas

# step 1. data load
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# step 2. Define UI for application that plots features of movies 

# total row
n_total <- nrow(movies)

ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Text Instructions
      HTML(paste("Enter a value between 1 and", n_total)),
      
      # Numeric input for sample size
      numericInput(inputId = "n", 
                   label = "Sample size:", 
                   value = 30, 
                   step  = 1, 
                   min = 1, 
                   max = n_total)
    ), 
    
    # Output: Show data table
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# step 3. Define server function required to create the scatterplot
server <- function(input, output) {
  
  # create data table
  output$moviestable <- DT::renderDataTable({
    movies_sample <- movies %>% 
      sample_n(input$n, 30) %>% 
      select(title:studio)
    
    DT::datatable(data = movies_sample, options = list(pageLength = 10), 
                  rownames = FALSE)
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
