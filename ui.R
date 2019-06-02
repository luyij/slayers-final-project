#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)
library(shinythemes)
source("test.R")


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
          selectInput("genre", "Choose a genre:",
                      choices = sort(genres)),
          # Filter movies by language
          uiOutput("language"),
          # Filter movies by year
          sliderInput("yearRange", label = "Year Range", min = 1916, 
                         max = 2017, value = c(1916, 2016), sep = ""),
          checkboxGroupInput("type", label = "Content Rating", 
                             choices = sort(types)),
          checkboxGroupInput("color", label = "Color", 
                             choices = c("Color","Black & White"))
        ),
    
    # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Movies", tableOutput("table")),
                    tabPanel("Visualize", plotOutput("plot"))
        )
      )
      )
    ),
    tabPanel("Hunt for Fun",
             p("Random generator by mood")
    ),
    tabPanel("Help",
           p("About how to use the App")
    )
  )
))
