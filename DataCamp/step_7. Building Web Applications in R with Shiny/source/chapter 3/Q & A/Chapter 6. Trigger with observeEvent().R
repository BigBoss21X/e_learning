library(shiny)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input
    sidebarPanel(
      
      # Numeric input for number of rows to show
      numericInput(inputId = "n_rows",
                   label = "How many rows do you want to see?",
                   value = 10),
      
      # Action button to show
      actionButton(inputId = "button", 
                   label = "Show")
      
    ),
    
    # Output:
    mainPanel(
      tableOutput(outputId = "datatable")
    )
  )
)

# Define server function required to create the scatterplot-
server <- function(input, output, session) {
  
  # Print a message to the console every time button is pressed
  ___(input$___, {
    cat("Showing", input$n_rows, "rows\n")
  })
  
  # Take a reactive dependency on input$button, but not on any other inputs
  df <- ___(input$___, {
    head(movies, input$n_rows)
  })
  output$___ <- ___({
    df()
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

# In this app we want two things to happen when an action button is clicked: (1) A message printed to the console stating how many records are shown and (2) A table output of those records.

# Instructions
# 1. Use observeEvent to print a message to the console when the action button is clicked.

# 2. Set up a table output that will print only when action button is clicked, but not when other inputs that go into the creation of that output changes. Note that the corresponding render function for tableOutput is renderTable
