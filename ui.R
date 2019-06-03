#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("slate"),
  
  # Application title
  titlePanel(title = div(img(src="MHLogo.png", width = 200))),
  
  navbarPage("MovieHunter",
    tabPanel("Home",
        h2("About"),
        p("Movie Hunter was made for everyone to find a movie to watch. The 
          creators want to make finding and choosing a movie to watch be an 
          task."),
        HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/2L3Gvo40DzQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
    ),
    tabPanel("Find a Movie",
    # Sidebar with a slider input for number of bins 
      sidebarLayout(
        sidebarPanel(
          #Filters the movies by genre
          checkboxGroupInput("Genre", label = "Genre", inline = TRUE, 
                         choices = list("Comedy" = 1, "Romance" = 2, "Drama" = 3,
                                         "Animation" = 4, "Horror" = 5, "Action" = 6)),
          br(),
          #Filters the movies by year
          sliderInput("yearRange", label = "Year Range", min = 1916, 
                         max = 2017, value = c(1916, 2017), sep = ""),
          br(),
          #Filters the movies by language options available
          checkboxGroupInput("Language", label = "Language", 
                         choices = list("English" = 1, "Spanish" = 2, "French" = 3))
        ),
    
    # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Table", tableOutput("table")),
                    tabPanel("Plot", plotOutput("plot"))
        )
      )
      )
    ),
    tabPanel("Movie by Mood",
             h1("How are you feeling today?")
             #textOutput("random")
    ),
    tabPanel("Help",
           h2("How to use Movie Hunter"),
           h3("Find a Movie"),
           p("Use the filter to find the movies that you are interested in watching."), 
           tags$li("You can select the genres of the movies that you want to watch such as 
             comedy or action. The Movie Hunter app allows you to pick multiple genres
             so that you can be specific"),
           tags$li("After you pick your genre(s), you can select 
             the year the movie was produced. To do this, use the slider to pick the time 
             frame and if you want to find the movies of a specific year, you can drag 
             the sliders on top of each other"),
           tags$li("Choose the language that you want to watch the movie"),
           h3("Movie by Mood"),
           p("The Movie by Mood page is a great choice if you want to be adventurous and 
             pick a movie by chance. Click on the emoji that you are feeling and let us 
             choose a movie for you!")
    )
  )
))
