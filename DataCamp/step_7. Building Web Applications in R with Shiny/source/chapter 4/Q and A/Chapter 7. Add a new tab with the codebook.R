# Given that the users get to choose which variables to plot, it might be a good idea to provide a codebook along with the app so that they can refer to it to make their selection. We can put this information in a new tab.

# The file called movies_codebook.csv at this link has been loaded. This file has three columns: Column, Variable name, and Description.

#### Instructions ####
# In the UI: Add a new tab titled "Codebook" that uses the dataTableOutput function from the DT package to display the codebook. Use the output ID "codebook".

# In the server: Render the table with the following options: pageLength = 10, lengthMenu = c(10, 25, 40), and rownames = FALSE.

library(shiny)
library(readr)
library(ggplot2)
library(stringr)
library(dplyr)
library(DT)
library(tools)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
movies_codebook <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies_codebook.csv")

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  titlePanel("Movie browser, 1970 - 2014", windowTitle = "Movies"),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      h3("Plotting"),      # Third level header: Plotting
      
      # Select variable for y-axis 
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis 
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "critics_score"),
      
      # Select variable for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Title Type" = "title_type", 
                              "Genre" = "genre", 
                              "MPAA Rating" = "mpaa_rating", 
                              "Critics Rating" = "critics_rating", 
                              "Audience Rating" = "audience_rating"),
                  selected = "mpaa_rating"),
      
      hr(),
      
      # Set alpha level
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5),
      
      # Set point size
      sliderInput(inputId = "size", 
                  label = "Size:", 
                  min = 0, max = 5, 
                  value = 2),
      
      # Enter text for plot title
      textInput(inputId = "plot_title", 
                label = "Plot title", 
                placeholder = "Enter text to be used as plot title"),
      
      hr(),
      
      # Header
      h3("Subsetting and sampling"),
      
      # Select which types of movies to plot
      checkboxGroupInput(inputId = "selected_type",
                         label = "Select movie type(s):",
                         choices = c("Documentary", "Feature Film", "TV Movie"),
                         selected = "Feature Film"),
      
      # Select sample size
      numericInput(inputId = "n_samp", 
                   label = "Sample size:", 
                   min = 1, max = nrow(movies), 
                   value = 50),
      
      hr(),
      
      # Show data table
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE),
      
      br(),
      
      # Built with Shiny by RStudio
      br(),
      h5("Built with",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
         "by",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
         ".")
      
    ),
    
    # Output:
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  tabPanel(title = "Plot", 
                           plotOutput(outputId = "scatterplot"),
                           br(),
                           h4(uiOutput(outputId = "n"))),
                  tabPanel(title = "Data", 
                           br(),
                           dataTableOutput(outputId = "moviestable"))
                  # New tab panel for Codebook
                  ___
      )
      
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output, session) {
  
  # Create a subset of data filtering for selected title types
  movies_subset <- reactive({
    req(input$selected_type) # ensure availablity of value before proceeding
    filter(movies, title_type %in% input$selected_type)
  })
  
  # Update the maximum allowed n_samp for selected type movies
  observe({
    updateNumericInput(session, 
                       inputId = "n_samp",
                       value = min(50, nrow(movies_subset())),
                       max = nrow(movies_subset())
    )
  })
  
  # Create new df that is n_samp obs from selected type movies
  movies_sample <- reactive({ 
    req(input$n_samp) # ensure availablity of value before proceeding
    sample_n(movies_subset(), input$n_samp)
  })
  
  # Create scatterplot object the plotOutput function is expecting 
  output$scatterplot <- renderPlot({
    ggplot(data = movies_sample(), aes_string(x = input$x, y = input$y,
                                              color = input$z)) +
      geom_point(alpha = input$alpha, size = input$size) +
      labs(x = toTitleCase(str_replace_all(input$x, "_", " ")),
           y = toTitleCase(str_replace_all(input$y, "_", " ")),
           color = toTitleCase(str_replace_all(input$z, "_", " ")),
           title = toTitleCase(input$plot_title))
  })
  
  # Print number of movies plotted 
  output$n <- renderUI({
    types <- movies_sample()$title_type %>% 
      factor(levels = input$selected_type) 
    counts <- table(types)
    
    HTML(paste("There are", counts, input$selected_type, "movies in this dataset. <br>"))
  })
  
  # Render data table if checked
  output$moviestable <- renderDataTable(
    if(input$show_data){
      datatable(data = movies_sample()[, 1:7], 
                options = list(pageLength = 10), 
                rownames = FALSE)
    }
  )
  
  # Render data table for codebook
  ___
  
}

# Create Shiny app object
shinyApp(ui = ui, server = server)
