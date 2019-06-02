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

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("MovieHunter"),
  
  
  navbarPage(img(src="exampleLogo.png", width = "45px"),
    tabPanel("Home",
        p("About the project page")
    ),
    tabPanel("Filter",
    # Sidebar with a slider input for number of bins 
      sidebarLayout(
        sidebarPanel(
          #Filters the movies by genre
          checkboxGroupInput("Genre", label = "Genre", 
                         choices = list("Comedy" = 1, "Romance" = 2, "Drama" = 3)),
          #Filters the movies by year
          sliderInput("yearRange", label = "Year Range", min = 1916, 
                         max = 2017, value = c(1916, 2017), sep = ""),
          #Filters the movies by language options available
          checkboxGroupInput("Language", label = "Language", 
                         choices = list("English" = 1, "Spanish" = 2, "French" = 3))
        ),
    
    # Show a plot of the generated distribution
      mainPanel(
       # plotOutput("distPlot")
      )
      )
    ),
    tabPanel("Help",
           p("About how to use the App")
    )
  )
))
