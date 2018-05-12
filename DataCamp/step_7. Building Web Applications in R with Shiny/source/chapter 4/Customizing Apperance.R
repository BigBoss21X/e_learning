#### Chapter 1. Add text with HTML tags in the main panel ####
# The following app does a bunch of things: allows users to customize the plot, subsets and samples the data, and reports simple summary statistics and displays the data table. Use HTML tags to add headers and visual separators to make it a bit more clear, at a first glance, what's happening in the app.

# In these exercises, use the convenient shortcuts for common HTML tags, like br() instead of tags$br().

#### ~ instructions ####
# Add third level headers with h3(). See the comments in the sample code for the text of the headers.
# Add visual separation with horizontal lines (hr()) and (br()) where indicated.
# Make the text reporting the number of movies a fourth level header with h4().

# 1. 패키지 설치 Function 
# function
install_pkgs <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])] 
  if (length(new.pkg)) {
    install.packages(new.pkg, dependencies = TRUE)
  } 
  sapply(pkg, require, character.only = TRUE)
}

# values
pkgs <- c("shiny", "tidyverse", "stringr", "DT", "tools", "shinythemes")

# use function wth values
install_pkgs(pkgs)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(
  
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
      
      hr(),      # Horizontal line for visual separation
      
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
      
      hr(),      # Horizontal line for visual separation
      
      h3("Sampling and Subsetting"),      # Third level header: Sampling and subsetting
      
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
      
      hr(),      # Horizontal line for visual separation
      
      # Show data table
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE)
      
    ),
    
    # Output:
    mainPanel(
      
      # Show scatterplot
      h3("Scatterplot"),         # Third level header: Scatterplot
      plotOutput(outputId = "scatterplot"),
      br(),          # Single line break for a little bit of visual separation
      
      # Print number of obs plotted
      h4(uiOutput(outputId = "n")),    # Fourth level header
      br(), br(),          # Two line breaks for a little bit of visual separation
      
      # Show data table
      h3("Data table"),          # Third level header: Data table
      DT::dataTableOutput(outputId = "moviestable")
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
  
  # Print data table if checked
  output$moviestable <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = movies_sample()[, 1:7], 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
  
}

# Create Shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 2. Add image with img tag ####
# Images can enhance the appearance of your app, and you can add images to a Shiny app with the img() tag.

#### ~ Instructions ####
# 1. Underneath the sidebar panel of the app, add a text that says "Built with Shiny by RStudio."

# 2. Instead of the word "Shiny" use the hex logo at https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png, specifying a height of 30px.

# 3. Instead of the word "RStudio" use the logo at https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png, specifying a height of 30px as well.

# 4. Format this text as a fifth level header.

#### ~ Source Code ####
# function
install_pkgs <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])] 
  if (length(new.pkg)) {
    install.packages(new.pkg, dependencies = TRUE)
  } 
  sapply(pkg, require, character.only = TRUE)
}

# values
pkgs <- c("shiny", "tidyverse", "stringr", "DT", "tools")

# use function wth values
install_pkgs(pkgs)

# data
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(
  
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
      
      hr(),                # Horizontal line for visual separation
      
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
      
      hr(),                # Horizontal line for visual separation
      
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
      
      hr(),                # Horizontal line for visual separation
      
      # Show data table
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE),
      
      # Built with Shiny by RStudio
      br(), br(),     # Two line breaks for visual separation
      h5("Built with",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
         "by",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
         ".")
    ),
    
    # Output:
    mainPanel(
      
      # Show scatterplot
      h3("Scatterplot"),    # Horizontal line for visual separation
      plotOutput(outputId = "scatterplot"),
      br(),                 # Single line break for a little bit of visual separation
      
      # Print number of obs plotted
      h4(uiOutput(outputId = "n")),
      br(), br(),           # Two line breaks for a little bit of visual separation
      
      # Show data table
      h3("Data table"),     # Third level header: Data table
      DT::dataTableOutput(outputId = "moviestable")
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
  
  # Print data table if checked
  output$moviestable <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = movies_sample()[, 1:7], 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
  
}

# Create Shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 3. Organize the sidebar with wellPanels #### 
# wellPanel()s are useful for grouping related UI widgets into one.

#### ~ Instructions ####
# Place all UI widgets under and including the heading "Plotting" into one wellPanel().

# Place all UI widgets under and including the heading "Subsetting and sampling" into another wellPanel().

# Place the checkbox input widget for showing/hiding the data table into yet another wellPanel().

# Remove additional breaks and horizontal lines separating these three groups, including after the last group.

library(shiny)
library(ggplot2)
library(stringr)
library(dplyr)
library(DT)
library(tools)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      wellPanel(
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
                  placeholder = "Enter text to be used as plot title")
        
      ),
      
      wellPanel(
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
                     value = 50)        
      ),
      
      wellPanel(
        # Show data table
        checkboxInput(inputId = "show_data",
                      label = "Show data table",
                      value = TRUE)
      ),
      
      # Built with Shiny by RStudio
      h5("Built with",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
         "by",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
         ".")
      
    ),
    
    # Output:
    mainPanel(
      
      # Show scatterplot
      h3("Scatterplot"),    # Horizontal line for visual separation
      plotOutput(outputId = "scatterplot"),
      br(),                 # Single line break for a little bit of visual separation
      
      # Print number of obs plotted
      h4(uiOutput(outputId = "n")),
      br(), br(),           # Two line breaks for a little bit of visual separation
      
      # Show data table
      h3("Data table"),     # Third level header: Data table
      DT::dataTableOutput(outputId = "moviestable")
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
  
  # Print data table if checked
  output$moviestable <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = movies_sample()[, 1:7], 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
  
}

# Create Shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 4. Further customize panels ####
# Giving your app a title can quickly communicate what it does, and depending on how your app is structured, you might consider adjusting the width of your sidebar and main panels.

#### ~ Instructions ####

# Add the title "Movie browser, 1970 - 2014" to your app, and a shorter title ("Movies") as the windowTitle argument.

# Increase the sidebar panel width by one and accordingly adjust the main panel width.

library(shiny)
library(ggplot2)
library(stringr)
library(dplyr)
library(DT)
library(tools)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # App title
  titlePanel("Movie browser, 1970 - 2014", windowTitle = "Movies"),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      wellPanel(
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
                  placeholder = "Enter text to be used as plot title")
        
      ),
      
      wellPanel(
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
                     value = 50)        
      ),
      
      wellPanel(
        # Show data table
        checkboxInput(inputId = "show_data",
                      label = "Show data table",
                      value = TRUE)
      ),
      
      # Built with Shiny by RStudio
      br(),
      h5("Built with",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
         "by",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
         "."),
      
      width = 5
      
    ),
    
    # Output:
    mainPanel(
      
      # Show scatterplot
      h3("Scatterplot"),    # Horizontal line for visual separation
      plotOutput(outputId = "scatterplot"),
      br(),                 # Single line break for a little bit of visual separation
      
      # Print number of obs plotted
      h4(uiOutput(outputId = "n")),
      br(), br(),           # Two line breaks for a little bit of visual separation
      
      # Show data table
      h3("Data table"),     # Third level header: Data table
      DT::dataTableOutput(outputId = "moviestable"),
      
      width = 7
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
  
  # Print data table if checked
  output$moviestable <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = movies_sample()[, 1:7], 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
  
}

# Create Shiny app object
shinyApp(ui = ui, server = server)





#### Chapter 5. Add a conditional Panel ####
# The app we've been working with has a checkbox input that the user can use to display/hide the data table. However the heading "Data table" is displayed on the app regardless of whether the table is displayed or not. We can fix this with a conditionalPanel().

#### ~ Instructions ####
# The heading "Data table" should now be in the conditionalPanel function, as its second argument.

# The first argument in this function is the condition, which is a JavaScript expression that will be evaluated repeatedly to determine whether the panel should be displayed. The condition should be stated as input.show_data == true. Note that we use true instead of TRUE because this is a Javascript expression, as opposed to an R expression.


#### ~ Source Code ####
library(shiny)
library(ggplot2)
library(stringr)
library(dplyr)
library(DT)
library(tools)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  titlePanel("Movie browser, 1970 - 2014", windowTitle = "Movies"),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      wellPanel(
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
                  placeholder = "Enter text to be used as plot title")
        
      ),
      
      wellPanel(
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
                     value = 50)        
      ),
      
      wellPanel(
        # Show data table
        checkboxInput(inputId = "show_data",
                      label = "Show data table",
                      value = TRUE)
      ),
      
      # Built with Shiny by RStudio
      br(),
      h5("Built with",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
         "by",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
         "."),
      
      width = 5
      
    ),
    
    # Output:
    mainPanel(
      
      # Show scatterplot
      h3("Scatterplot"),    # Horizontal line for visual separation
      plotOutput(outputId = "scatterplot"),
      br(),                 # Single line break for a little bit of visual separation
      
      # Print number of obs plotted
      h4(uiOutput(outputId = "n")),
      br(), br(),           # Two line breaks for a little bit of visual separation
      
      # Show data table
      conditionalPanel(condition = "input.show_data == true", h3("Data table")),     # Third level header: Data table
      DT::dataTableOutput(outputId = "moviestable"),
      
      width = 7
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
  
  # Print data table if checked
  output$moviestable <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = movies_sample()[, 1:7], 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
  
}

# Create Shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 6. Reorganize your app with tabs ####
# The app that we have been working with got pretty complex. We can organize the outputs a bit better using tabs.

#### ~ Instructions ####
# Reorganize your app into two tabs.

# Tab 1 should be called "Plot" and should contain the scatterplot and the text for number of observations, separated by a line break.

# Tab 2 should be called "Data" and should contain the data table. Use a line break on top to place the table a little below the top of the tab.

# Remove the third level headings above each of these components, since the tab titles serve the same purpose.

#### ~ Source Code ####
library(shiny)
library(ggplot2)
library(stringr)
library(dplyr)
library(DT)
library(tools)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

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
                           DT::dataTableOutput(outputId = "moviestable"))
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
  
  # Print data table if checked
  output$moviestable <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = movies_sample()[, 1:7], 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
  
}

# Create Shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 7. Add a new tab with the codebook ####

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
                           dataTableOutput(outputId = "moviestable")),
                  # New tab panel for Codebook
                  tabPanel("Codebook", 
                           br(),
                           dataTableOutput(outputId = "codebook"))
                  
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
  output$codebook <- renderDataTable({
    datatable(data = movies_codebook,
              options = list(pageLength = 10, lengthMenu = c(10, 25, 40)), 
              rownames = FALSE)
  })
  
}

# Create Shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 8. Create new conditional tab for displaying data table ####

#### ~ Instructions ####
# In the UI: Add an id argument to tabsetPanel. This is a text string, use "tabspanel".

# In the server: Update how output$moviestable is calculated so that it is calculated regardless of the current state of input$show_data, i.e. regardless of whether the box is checked or not.

# In the server: Add an observeEvent handler that depends on the show_data input. If show_data is TRUE, the "Data" tab should be displayed. If not, it should be hidden. See the fill in the blanks spaces in the sample code as well as the function documentation for showTab() and hideTab() functions. Also, in the showTab() function, set up the tab so that it is selected when show_data is TRUE.

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
      
      tabsetPanel(id = "tabspanel", type = "tabs",
                  tabPanel(title = "Plot", 
                           plotOutput(outputId = "scatterplot"),
                           br(),
                           h4(uiOutput(outputId = "n"))),
                  tabPanel(title = "Data", 
                           br(),
                           DT::dataTableOutput(outputId = "moviestable")),
                  # New tab panel for Codebook
                  tabPanel("Codebook", 
                           br(),
                           DT::dataTableOutput("codebook"))
                  
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
  
  # Update code below to render data table regardless of current state of input$show_data
  output$moviestable <- DT::renderDataTable({
    DT::datatable(data = movies_sample()[, 1:7], 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
  # Display data table tab only if show_data is checked
  observeEvent(input$show_data, {
    if(input$show_data){
      showTab(inputId = "tabspanel", target = "Data", select = TRUE)
    } else {
      hideTab(inputId = "tabspanel", target = "Data")
    }
  })
  
  # Render data table for codebook
  output$codebook <- DT::renderDataTable({
    DT::datatable(data = movies_codebook,
                  options = list(pageLength = 10, lengthMenu = c(10, 25, 40)), 
                  rownames = FALSE)
  })
  
}

# Create Shiny app object
shinyApp(ui = ui, server = server)

#### Chapter 9. Customize the appearance of your app with shinythemes ####
# As we saw in the previous video, one quick and easy way of customizing the appearance of your app is to apply a theme to it from the shinythemes package. You can view theme options at https://rstudio.github.io/shinythemes/.

#### ~ Instructions ####
# First, add a themeSelector() widget to your app to see how these themes look on your app.
# Then, select a theme you like, apply it to your app using the argument theme in the fluidPage() function, and remove the theme selector.

#### ~ Source Code ####
library(shiny)
# install.packages("shinythemes")
library(shinythemes)
library(readr)
library(ggplot2)
library(stringr)
library(dplyr)
library(DT)
library(tools)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
movies_codebook <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies_codebook.csv")

# Define UI for application that plots features of movies

ui <- fluidPage(theme = shinytheme("united"),
                
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
                    
                    tabsetPanel(id = "tabspanel", type = "tabs",
                                tabPanel(title = "Plot", 
                                         plotOutput(outputId = "scatterplot"),
                                         br(),
                                         h4(uiOutput(outputId = "n"))),
                                tabPanel(title = "Data", 
                                         br(),
                                         DT::dataTableOutput(outputId = "moviestable")),
                                # New tab panel for Codebook
                                tabPanel("Codebook", 
                                         br(),
                                         DT::dataTableOutput("codebook"))
                                
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
  
  # Update code below to render data table regardless of current state of input$show_data
  output$moviestable <- DT::renderDataTable({
    DT::datatable(data = movies_sample()[, 1:7], 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
  # Display data table tab only if show_data is checked
  observeEvent(input$show_data, {
    if(input$show_data){
      showTab(inputId = "tabspanel", target = "Data", select = TRUE)
    } else {
      hideTab(inputId = "tabspanel", target = "Data")
    }
  })
  
  # Render data table for codebook
  output$codebook <- DT::renderDataTable({
    DT::datatable(data = movies_codebook,
                  options = list(pageLength = 10, lengthMenu = c(10, 25, 40)), 
                  rownames = FALSE)
  })
  
}

# Create Shiny app object
shinyApp(ui = ui, server = server)
