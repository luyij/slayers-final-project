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
  titlePanel(img(src="exampleLogo.png", width = 200)),
  
  navbarPage("MovieHunter",
    tabPanel("Home",
        p("About the project page")
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
             tags$head(tags$style("
                       .jhr{
                       display: inline;
                       vertical-align: middle;
                       padding-left: 10px;
                       }")),
             pickerInput("mood",
                         label = "How do you feel today?",
                         choices = df$val,
                         choicesOpt = list(content = df$img))
    ),
    tabPanel("Help",
           p("About how to use the App")
    )
  )
))
