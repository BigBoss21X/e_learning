#### 4. Download data with downloadButton ####

# In this app you get to specify the file type and the variables included in the file you will download. For downloading from a Shiny app we use the downloadHandler function in the server and downloadButton or downloadLink function in the UI. Download the selected data with downloadButton using instructions and help files to figure out exactly how it works

# Instructions
# In the server function, add the name of the output for file download, the function for setting up a file download, and fill in other blanks. Looking in the help file for the function may be useful.

# In the UI, add the name of the function for displaying a button for downloading.

library(shiny)
library(dplyr)
library(readr)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Select filetype
      radioButtons(inputId = "filetype",
                   label = "Select filetype:",
                   choices = c("csv", "tsv"),
                   selected = "csv"),
      
      # Select variables to download
      checkboxGroupInput(inputId = "selected_var",
                         label = "Select variables:",
                         choices = names(movies),
                         selected = c("title"))
      
    ),
    
    # Output(s)
    mainPanel(
      HTML("Select filetype and variables, then hit 'Download data'."),
      downloadButton("download_data", "Download data")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Download file
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("movies.", input$filetype)
    },
    content = function(file) { 
      if(input$filetype == "csv"){ 
        write_csv(movies %>% select(input$selected_var), file) 
      }
      if(input$filetype == "tsv"){ 
        write_tsv(movies %>% select(input$selected_var), file) 
      }
    }
  )
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
