#### Chapter 1. Building a reactive widget ####
library(shiny)
library(tidyverse)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

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
        choices = c("imdb_rating", 
                    "imdb_num_votes", 
                    "critics_score", 
                    "audience_score", 
                    "runtime"
                    ), 
        selected = "audience_score"), 
      
      # Select Variable for x-axis
      selectInput(
        inputId = "x", 
        label = "X-axis:", 
        choices = c("imdb_rating", 
                    "imdb_num_votes", 
                    "critics_score", 
                    "audience_score", 
                    "runtime"
        ), 
        selected = "critics_score"),
      
      # Set alpha level
      sliderInput(
        inputId = "alpha", 
        label = "Alpha:", 
        min = 0, max = 1, 
        value = 0.5)
      ), 
    
    # Outputs
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
      geom_point(alpha = input$alpha)
  })
}

# create the shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 2.Dude, where's my plot ####
library(shiny)
library(tidyverse)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

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
        choices = c("imdb_rating", 
                    "imdb_num_votes", 
                    "critics_score", 
                    "audience_score", 
                    "runtime"
        ), 
        selected = "audience_score"), 
      
      # Select Variable for x-axis
      selectInput(
        inputId = "x", 
        label = "X-axis:", 
        choices = c("imdb_rating", 
                    "imdb_num_votes", 
                    "critics_score", 
                    "audience_score", 
                    "runtime"
        ), 
        selected = "critics_score")
    ), 
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot"), 
      plotOutput(outputId = "densityplot", height = 200)
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
  
  # Create Densityplot
  output$densityplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x)) + 
      geom_density()
  })
}

# create the shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 3. Add numericInput ####
library(shiny)
library(tidyverse)
library(DT)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies

n_total <- nrow(movies)

ui <- fluidPage(
  
  # Sidebar layout with a input and output
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Text Instructions
      HTML(paste("Enter a value between 1 and ", n_total)), 
      
      # Numeric input for sample size
      numericInput(inputId = "n", 
                   label = "Sample size:", 
                   value = 30, 
                   step = 1, 
                   min = 1, 
                   max = n_total)
    ), # sidebarPanel
    
    # Output: Show data table
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    ) # mainPanel
  ) # sidebarLayout
) # fluidPage

# Define Server function required to create the scatterplot
server <- function(input, output) {
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    movies_sample <- movies %>% 
      sample_n(input$n) %>% 
      select(title:studio)
    
    DT::datatable(data = movies_sample, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

# Instructions
# 1. Make sure entries in the sidebarPanel are seperated by commas

# 2. Calculate n_total(total number of movies in the dataset) as nrow(movies) before the UI definitions

# 3. Use n_total instead of the hard-coded "651" in the helper text on line 17.

# 4. Add min and max values to the numericInput widget on line 20, where min is 1 and max is n_total. Leave the values of inputId and label as they are. 

# 5. Change the default value of the sample size to 30. 

# 6. Change the step parameter of numericInput such that values increase by 1 (instead of 10) when the up arrow is clicked in the numeric input widget in the app UI.

#### Chapter 4. req, a.k.a. your best friend ####
library(shiny)
library(dplyr)
library(DT)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
n_total <- nrow(movies)

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Text instructions
      HTML(paste("Enter a value between 1 and", n_total)),
      
      # Numeric input for sample size
      numericInput(inputId = "n",
                   label = "Sample size:",
                   value = 30,
                   min = 1, max = n_total,
                   step = 1)
      
    ),
    
    # Output: Show data table
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    
    
    # Add a line with req(input$n) in the renderDataTable function in the server before movies_sample is calculated.
    req(input$n)
    
    movies_sample <- movies %>%
      sample_n(input$n) %>%
      select(title:studio)
    DT::datatable(data = movies_sample, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

# Instructions
# Add a line with req(input$n) in the renderDataTable function in the server before movies_sample is calculated. 

# Run your app again and delete input sample size to confirm that the error doesn't appear and neither does the output table

#### Chapter 5. Select to selectize ####
library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

all_studios <- sort(unique(movies$studio))

# UI 
ui <- fluidPage(
  
  # sidebarLayout
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      selectInput(
        inputId = "studio", 
        label = "Select studio:", 
        choices = all_studios, 
        selected = "20th Century Fox", 
        selectize = TRUE,
        multiple = TRUE
      ) # select
    ), # sidebarPanel
    
    # Output(s)
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    ) # mainPanel
    
  ) # sidebarLayout
) # fluidPage

# Server
server <- function(input, output) {
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    
    req(input$studio)
    
    movies_from_selected_studios <- movies %>% 
      filter(studio %in% input$studio) %>% 
      select(title:studio)
    
    DT::datatable(data = movies_from_selected_studios, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  }) # DT::renderDataTable
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

# View the help function for the selectInput widget by typing ?selectInput in the console, and figure out how to enable the selectize and multiple selection options(or whether they are enabled by default). 

# Based on your findings add the necessary arguments to the selectInput widget on line 14.

# Add a call to the req function in the server, just like you did in the previous exercise but this time requiring that input$studio be available. Update the call to filter() to use the logical operator %in% (instead of ==) so that it works when multiple studios are selected.

# Run the app and (1) confirm that you can select multiple studios, (2) start typing "Warner Bros" to confirm selectize works, and (3) delete all selections to confirm req is preventing an error from being displayed.

#### Chapter 6. Convert dateInput to dateRangeInput ####
# Instructions
# Update dateInput on line 24 to dateRangeInput, replace the value argument with the arguments start = "2013-01-01" and end = "2014-01-01". Update the label to "Select dates:"

# Add a starview argument, and set it to "year" to make it a bit easier for the user to navigate the calendar. 

# The necessary changes have already been made in the server function and the explanatory text. 

library(shiny)
library(dplyr)
library(ggplot2)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

min_date <- min(movies$thtr_rel_date)
max_date <- max(movies$thtr_rel_date)

# UI
ui <- fluidPage(
  
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Explnatory text
      HTML(paste0("Movies released between the following dates will be plotted. Pick dates between ", min_date, " and ", max_date, ".")), 
      
      # Break for visual separation
      br(), br(), 
      
      # Date input
      dateRangeInput(
        inputId = "date", 
        label = "Select dates:", 
        start = "2013-01-01",
        end = "2014-01-01",
        startview = "year",
        min = min_date, max = max_date) # Date input
    ), # sidebarPanel
    
    # Output(s)
    mainPanel(
      plotOutput(outputId = "scatterplot")
    ) # mainPanel
    
  ) # sidebarLayout
)

glimpse(movies)
# Server
server <- function(input, output) {
  
  # Create the plot
  output$scatterplot <- renderPlot({
    req(input$date)
    movies_selected_date <- movies %>% 
      filter(thtr_rel_date >= as.POSIXct(input$date[1])) & thtr_rel_date <= as.POSIXct(input$date[2])
    
    ggplot(data = movies_selected_date, aes(x = critics_socre, y = audience_score, color = mpaa_rating)) + 
      geom_point()
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

#### Lecture 3. Rendering Functions ####
# renderTable
# Add a table beneath the plot displaying summary statistics for a new variable: score_ratio = audience_score / critics_score. 
# Calculate the new variable
# ui: Add an input widget that the user can interact with to check boxes for selected title types. 
# ui: Add an output defining where the summary table should appear. 
# server: Add a reactive expression that creates the summary table. 

#### ~ Chapter 7. Find the missing component #### 
# Instructions
# Fix the app code by adding the missing component, and run to confirm that it works. 

library(shiny)
library(tidyverse)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(
        inputId = "y", 
        label = "Y-axis:", 
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "audience_score"), # selectInput-y
      
      selectInput(
        inputId = "x", 
        label = "X-axis:", 
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "critics_score") # selectInput-x
    ), # sidebarPanel
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot")
    ) # mainPanel
  ) # sidebarLayout
) # fluidPage

# Server
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x= input$x, y = input$y)) + 
      geom_point()
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

#### ~ Chapter 8. Add renderText #### 
# Instructions 
# On line 43, create the text to be printed using the paste0() function: 
# "Correlation = ___. Note: If the relationship between the two variable is not linear, the correlation coefficient will not be meaningful."
# First use the cor() function to calculate the correlation. Use cor(movies[, input$x], movies[, input$y], use = "pairwise"). Save this as r

# Use the paste0() function to construct the text output. 
# Place the text within the renderText function, and assign to output$correlation. 

library(shiny)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI 
ui <- fluidPage(
  
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(
        inputId = "y", 
        label = "Y-axis:", 
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "audience_score"), # selectInput-y
      
      selectInput(
        inputId = "x", 
        label = "X-axis:", 
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "critics_score") # selectInput-x 
      
    ), # sidebarPanel
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot"), 
      textOutput(outputId = "correlation")
    ) # mainPanel
    
  ) # sidebarLayout
  
) # fluidPage

# server
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) + 
      geom_point()
  }) # scatterplot

  # Create text output statting the correlation between the two ploted 
  output$correlation <- renderText({
    
    r <- round(cor(movies[, input$x], movies[, input$y], use = "pairwise"), 3)
    paste0("Correlation = ", r, ". Note: If the relationship between the two variables is not linear, the correlation coefficient will not be meaningful.")
  }) # correlation
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

#### Lecture 4. UI outputs ####
# plotOutput, 
# description, Select points on the plot via brushing, and report the selected points in a data table underneath the plot

# 1. ui: Add functionality to plotOutput to select points via brushing
# 2. ui: Add an output defining where the data table should appear. 
# 3. server: Add a reactive expression that creates the data table for the selected points

#### ~ Chapter 9. Hovering ####
# Instructions
# Change the brush argument to hover in the plotOutput on line 32 and update the passed value to be "plot_hover"

# Read the article on Selecting rows of data to determine what change needs to be made in the renderDataTable function to list the data points that the user hovers on. 

# Implement this change. 

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
  sidebarPanel(
    # Select variable for y-axis
    selectInput(inputId = "y", 
                label = "Y-axis:",
                choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
                selected = "audience_score"), 
    
    selectInput(inputId = "x", 
                label = "X-axis:",
                choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
                selected = "critics_score")
  ), 
  
  # Output:
  mainPanel(
    # show scatterplot with brushing capability
    plotOutput(
      outputId = "scatterplot", hover = "plot_hover"
    ), 
    
    # show data table
    dataTableOutput(outputId = "moviestable"), 
    br()
  )
) # fluidPage

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) + 
      geom_point()
  })
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    nearPoints(movies, input$plot_hover) %>% 
      select(title, audience_score, critics_score)
  })
}

shinyApp(ui = ui, server = server)

#### ~ Chapter 10. Displaying text outputs ####
# Add the appropriate output UI functions and output IDs to print the elements noted in the comments on lines 30 to 33 in the mainPanel of the UI and run the app. Check the server function to find the output IDs. Also add commas as needed. 

# In the server function averages are calculated first and then the regression model is fit, but in the app the regression output comes before the averages. Make the neccessary changes to the app UI so that averages are displayed above the regression output. 

library(shiny)
library(dplyr)
library(ggplot2)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# ui
ui <- fluidPage(
  
  sidebarLayout(
    
    # inputs
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(
        inputId = "y", 
        label = "Y-axis:",
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "audience_score"
      ), # selectInput - "y"
      
      selectInput(
        inputId = "x", 
        label = "X-axis:", 
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
        selected = "critics_score"
      )
      
    ), # sidebarPanel
    
    # outputs
    mainPanel(
      plotOutput(outputId = "scatterplot"), 
      textOutput(outputId = "avg_x"), # avg of x
      textOutput(outputId = "avg_y"), # avg of y
      verbatimTextOutput(outputId = "lmoutput") # regression output
    ) # mainPanel
  ) # sidebarLayout
) # fluidPage 

# Server
server <- function(input, output) {
  
  # Create scatterplot
  output$scatterplot <- renderPlot({
    # R 코드
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) + 
      geom_point()
  }) # scatterplot
  
  # Calculate average of x
  output$avg_x <- renderText({
    # R코드
    mean_x <- movies %>% pull(input$x) %>% mean()
    avg_x <- round(mean_x, 2)
    paste("Average", input$x, "=", avg_x)
  })
  
  # Calculate average of y
  output$avg_y <- renderText({
    mean_y <- movies %>% pull(input$y) %>% mean()
    avg_y <- round(mean_y, 2)
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

# Create a shiny app object
shinyApp(ui = ui, server = server)
  
#### ~ Chapter 11. Creating and formatting HTML output ####
library(shiny)
library(dplyr)
library(ggplot2)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# ui
ui <- fluidPage(
  
  sidebarLayout(
    
    # inputs
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(
        inputId = "y", 
        label = "Y-axis:",
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
        selected = "audience_score"
      ), # selectInput - "y"
      
      selectInput(
        inputId = "x", 
        label = "X-axis:", 
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
        selected = "critics_score"
      )
      
    ), # sidebarPanel
    # outputs
    mainPanel(
      plotOutput(outputId = "scatterplot"), 
      textOutput(outputId = "avg_x"), # avg of x
      textOutput(outputId = "avg_y"), # avg of y
      htmlOutput(outputId = "avgs"), # avgs
      verbatimTextOutput(outputId = "lmoutput") # regression output
    ) # mainPanel
  ) # sidebarLayout
) # fluidPage 

# Server
server <- function(input, output) {
  
  # Create scatterplot
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) + 
      geom_point()
  }) # scatterplot
  
  # Calculate average of x
  output$avg_x <- renderText({
    mean_x <- movies %>% pull(input$x) %>% mean()
    avg_x <- round(mean_x, 2)
    paste("Average", input$x, "=", avg_x)
  })
  
  # Calculate average of y
  output$avg_y <- renderText({
    mean_y <- movies %>% pull(input$y) %>% mean()
    avg_y <- round(mean_y, 2)
    paste("Average", input$y, "=", avg_y)
  })
  
  # Create htmlOutput
  output$avgs <- renderUI({
    # avg_x
    mean_x <- movies %>% pull(input$x) %>% mean()
    avg_x <- round(mean_x, 2)
    # avg_y
    mean_y <- movies %>% pull(input$y) %>% mean()
    avg_y <- round(mean_y, 2)
    
    # str
    str_x <- paste("Average", input$x, " = ", avg_x)
    str_y <- paste("Average", input$y, " = ", avg_y)
    
    HTML(paste(str_x, str_y, sep = '<br/>'))
  })
  
  # Create regression output
  output$lmoutput <- renderPrint({
    x <- movies %>% pull(input$x)
    y <- movies %>% pull(input$y)
    summ <- summary(lm(y ~ x, data = movies))
    print(summ, digits = 3, signif.stars = FALSE)
  })
}

# Create a shiny app object
shinyApp(ui = ui, server = server)

#### ~ 12. Download data with downloadButton #### 
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
    
    # inputs
    sidebarPanel(
      
      # Select filetype
      radioButtons(
        inputId = "filetype", 
        label = "Select filetype:", 
        choices = c("csv", "tst"), 
        selected = "csv"
      ), 
      
      # Select variables to download
      checkboxGroupInput(
        inputId = "selected_var", 
        label = "Select variables:", 
        choices = names(movies), 
        selected = c("title")
      )
      
    ), # sidebar Panel
    
    # outputs
    mainPanel(
      HTML("Select filetype and variables, then hit 'Download data'."), 
      downloadButton("download_data", "Download data")
    )# mainPanel
  ) # Layout
) # fluidPage

# Server
server <- function(input, output) {
  
  # Download file
  output$download_data <- downloadHandler(
    # step 1. filename
    filename = function(){
      paste0("movies.", input$filetype)
    },
    # step 2. content (csv, tsv)
    content = function(file) {
      if(input$filetype == "csv") {
        write_csv(movies %>% select(input$selected_var), file)
      } # if
      if(input$filetype == "tsv") {
        write_tsv(movies %>% select(input$selected_var), file)
      } # if
    } # content
  ) # download handler
} # server

# create Shiny app object
shinyApp(ui = ui, server = server)

