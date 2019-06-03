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
      filter(grepl(input$genre, genres)) %>%
      filter(year>= min(input$yearRange) & year<= max(input$yearRange)) %>%
      filter(language %in% input$language)
  })
  
  x <- reactive({
    data <- full_data %>%
      filter(grepl(input$genre, genres)) %>%
      filter(year>= min(input$yearRange) & year<= max(input$yearRange)) %>%
      filter(language %in% input$language)
    if(is.null(input$color) & is.null(input$type)){
      data %>% select(title, year, director, imdb_score, keywords) %>%
        rename_all(toupper)
    } else if(!is.null(input$type) & is.null(input$color)){
        data %>% filter(content_rating %in% input$type) %>%
        select(title, year, director, imdb_score, keywords) %>%
        rename_all(toupper)
    } else if(!is.null(input$color) & is.null(input$type)){
        data %>% filter(color %in% input$color) %>%
        select(title, year, director, imdb_score, keywords) %>%
        rename_all(toupper)
    } else if(!is.null(input$type) & !is.null(input$color)){
        data %>% filter(content_rating %in% input$type) %>%
        filter(color %in% input$color) %>%
        select(title, year, director, imdb_score, keywords) %>%
        rename_all(toupper)
      }
  })
  
  # print table if movies exist in the category
  output$table <- renderTable({
    if(nrow(x())==0){}
    else{
      x()
    }
  })
  
  # print an error message if no movie exists in the category
  output$text <- renderText({
    if(nrow(x())==0){
      "Sorry! There's no movie in this category."
    }
    else{}
  })

  
  url <- a("Google Homepage", href="https://www.google.com/")
  output$tab <- renderUI({
    tagList("URL link:", url)
  })
  
  output$plot <- renderPlot({
  })
  
  
  
})
