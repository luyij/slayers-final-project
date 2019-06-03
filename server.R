library(ggplot2)
library(shiny)
library(plotly)
source("test.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$language <- renderUI({
    data <- full_data %>%
      filter(grepl(input$genre, genres))
    selectInput("language", "Choose a Language:", choices = sort(data[, "language"]))
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
      data
    } else if(!is.null(input$type) & is.null(input$color)){
        data %>% filter(content_rating %in% input$type)
    } else if(!is.null(input$color) & is.null(input$type)){
        data %>% filter(color %in% input$color)
    } else if(!is.null(input$type) & !is.null(input$color)){
        data %>% filter(content_rating %in% input$type) %>%
        filter(color %in% input$color) 
      }
  })
  
  # print table if movies exist in the category
  output$table <- renderTable({
    if(nrow(x())==0){}
    else{
      x() %>% 
        select(title, year, director, imdb_score, keywords) %>%
        rename_all(toupper)
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
  
  output$plot <- renderPlotly({
      p <- ggplot() +
        geom_point(data = x(), aes(x=year, y=imdb_score, colour = imdb_score, key = title, stat = "identity")) +
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        labs(title = "IMDB Score", x = "Year", y ="IMDB Scores")
      ggplotly(p) 
  })
  
  
})
