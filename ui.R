#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(markdown)
library(shinythemes)
library(shinyWidgets)
source("test.R")

df <- data.frame(
  val = c("HAPPY","SAD", "LOVED", "FANTASY", "TRICKY")
)

df$img = c(
  sprintf("<img src='happy.png' width=25px><div class='jhr'>%s</div></img>", df$val[1]),
  sprintf("<img src='sad.png' width=25px><div class='jhr'>%s</div></img>", df$val[2]),
  sprintf("<img src='kiss.png' width=25px><div class='jhr'>%s</div></img>", df$val[3]),
  sprintf("<img src='robot.png' width=25px><div class='jhr'>%s</div></img>", df$val[4]),
  sprintf("<img src='ghost.png' width=25px><div class='jhr'>%s</div></img>", df$val[5])
)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("slate"),
  
  # Application title
  titlePanel(title = div(img(src="MHLogo.png", width = 200))),
  
  navbarPage("MovieHunter",
    tabPanel("Home",
        h2("About"),
        p("MovieHunter was made for everyone to find a movie to watch. The 
          creators want to make finding and choosing a movie to watch be an 
          task."),
        HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/2L3Gvo40DzQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
    ),

    tabPanel("Hunt a Movie",
    # Sidebar with a slider input for number of bins 
      sidebarLayout(
        sidebarPanel(
          # Filter movies by genre
          selectInput("genre", "Choose a Genre:",
                      choices = sort(genres)),
          # Filter movies by language
          uiOutput("language"),
          uiOutput("tab"),
          # Filter movies by year
          sliderInput("yearRange", label = "Year Range", min = 1916, 
                         max = 2017, value = c(1916, 2016), sep = ""),
          checkboxGroupInput("type", label = "Content Rating", 
                             choices = sort(types)),
          checkboxGroupInput("color", label = "Color", 
                             choices = c("Color","Black & White")),
          helpText('Note: content rating starting with "TV-" is based on television content rating system.')
        ),
    
    # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Movies", tableOutput("table"), textOutput("text")),
                    tabPanel("Visualize", plotlyOutput("plot"))
        )
      )
      )
    ),

    tabPanel("Hunt for Fun",
             sidebarPanel(
               tags$head(tags$style("
                       .jhr{
                       display: inline;
                       vertical-align: middle;
                       padding-left: 10px;
                       }")),
               pickerInput("mood",
                           label = h4("How do you feel today?"),
                           choices = df$val,
                           choicesOpt = list(content = df$img)
                           ),
               actionButton("button", "Update")
             ),
             mainPanel(
               h4("You may want to watch ..."),
               tags$style(type='text/css', '#random {background-color: rgba(180, 180, 180, 0.3); color: white; font-size: 18px}'),
               h4(verbatimTextOutput("random"))
               )
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
