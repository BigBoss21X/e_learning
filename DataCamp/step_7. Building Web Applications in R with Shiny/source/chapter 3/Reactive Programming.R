library(shiny)
library(tidyverse)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

#### Chapter 1. Add reactive data frame ####

# UI 
ui <- fluidPage(
  
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Select filetype
      radioButtons(
        inputId = "filetype", 
        label = "Select filetype:", 
        choices = c("csv", "tsv"), 
        selected = "csv"
      ), # radio button 
      
      # Select variables to download
      checkboxGroupInput(
        inputId = "selected_var", 
        label = "Select variables:", 
        choices = names(movies), 
        selected = c("title")
      ) # checkboxGroupInput
    ), # sidebarPanel (Inputs)
    
    # Output(s)
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable"), 
      downloadButton("download_data", "Download data")
    )
  ) # sidebarLayout
) # fluidPage

# Server
server <- function(input, output) {
  
  # Create reactive data frame
  movies_selected <- reactive({
    req(input$selected_var)
    movies %>% select(input$selected_var)
  })
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    req(input$selected_var)
    DT::datatable(data = movies_selected(), 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
  # Download file
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("movies.", input$filetype)
    }, 
    content = function(file) {
      if(input$filetype == "csv") {
        write_csv(movies_selected(), file)
      }
      if(input$filetype == "tsv") {
        write_csv(movies_selected(), file)
      }
    }
  )
}

# Create a shiny app object
shinyApp(ui = ui, server = server)
