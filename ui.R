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

png(filename = "www/happy.png")
png(filename = "www/sad.png")
png(filename = "www/kiss.png")
png(filename = "www/robot.png")
png(filename = "www/ghost.png")


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
             selectizeInput(
               'mood', 'How do you feel today?',
               choices = c(" " = "happy.png", " " = "sad.png", " " = "kiss.png", " " = "robot.png", " " = "ghost.png"),
               options = list(
                 render = I(
                   "{
      option: function(item, escape) {
      return '<div><img src=\"' + item.value + '\" width = 40 />' + escape(item.label) + '</div>'
      }
      }")
               )
             )
    ),
    tabPanel("Help",
           p("About how to use the App")
    )
  )
))
