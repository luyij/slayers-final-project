#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("test.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$language <- renderUI({
    data <- full_data %>%
      filter(grepl(input$genre, genres))
    selectInput("language", "Choose a language:", choices = sort(data[, "language"]))
  }) 
  
  data <- reactive({
    full_data %>%
      filter(year>= min(input$yearRange) & year<= max(input$yearRange)) %>%
      select(title, year, director, imdb_score, keywords) %>%
      rename_all(toupper)
  })
  
  output$table <- renderTable({
    data()
  })
  
  output$plot <- renderPlot({
  })
  
})
