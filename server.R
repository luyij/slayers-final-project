library(ggplot2)
library(shiny)
library(plotly)
library(DT)
source("test.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$language <- renderUI({
    data <- full_data %>%
      filter(grepl(input$genre, genres))
    languages <- unique(data[, "language"])
    pickerInput("language", "Choose a Language:", choices = sort(languages), selected = "English")
  }) 
  
  
  x <- reactive({
    data <- full_data %>%
      filter(grepl(input$genre, genres)) %>%
      filter(year>= min(input$yearRange) & year<= max(input$yearRange)) %>%
      filter(duration>= min(input$duration) & duration<= max(input$duration)) %>%
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
  output$table <- DT::renderDataTable({
    if(nrow(x())==0){}
    else{
      DT::datatable(options = list(pageLength = 25),
        x() %>% select(title, year, director, imdb_score, keywords) %>%
                rename_all(toupper))
    }
  })
  
  # print an error message if no movie exists in the category
  output$text <- renderText({
    if(nrow(x())==0){
      "Oops! There's no movie in this category."
    }
    else{}
  })

  
  url <- a("Google Homepage", href="https://www.google.com/")
  output$tab <- renderUI({
    url
  })
  
  output$plot <- renderPlotly({
    if(nrow(x())==0){}
    else{
      p <- ggplot() +
        geom_point(data = x(), aes(x=year, y=imdb_score, colour = content_rating, key = title, stat = "identity")) +
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        labs(title = "IMDB Score", x = "Year", y ="IMDB Scores")
      ggplotly(p)} 
  })
  
  output$random <- renderUI({
    input$button
    if(input$mood == "HAPPY"){
      movie <- full_data %>% 
        filter(id == sample(1:nrow(full_data),1))
    }else if(input$mood == "UPSET"){
      movie <- comedy %>% 
        filter(id == sample(1:nrow(comedy),1))
    }else if(input$mood == "LOVED"){
      movie <- romance %>% 
        filter(id == sample(1:nrow(romance),1))
    }else if(input$mood == "IMAGINATIVE"){
      movie <- fantasy %>% 
        filter(id == sample(1:nrow(fantasy),1))
    }else if(input$mood == "PLAYFUL"){
      movie <- horror %>% 
        filter(id == sample(1:nrow(horror),1))
    }
    url <- a(movie$title[1], href=full_data[full_data$title == movie$title[1],'link'])
    url
  })
  
  output$text1 <- renderText({
    "You may want to watch ..."
  })
  
})
