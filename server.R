library(ggplot2)
library(shiny)
library(plotly)
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
      filter(language %in% input$language) %>%
      filter(grepl(input$search, director, ignore.case = TRUE))
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
  output$table <- renderDataTable({
    if(nrow(x())==0){}
    else{
      datatable(options = list(pageLength = 25),
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
  
  output$error <- renderText({
    if(nrow(x())==0){
      "Oops! There's no movie in this category."
    }
    else{}
  })
  
  l <- list(
    bgcolor = "#272b30")

  
  output$plot <- renderPlotly({
    if(nrow(x())==0){}
    else{
      p <- ggplot(x() %>% arrange(desc(imdb_score)), aes(factor(year), factor(imdb_score))) +
        geom_point(aes(text=title, language=language, colour = content_rating)) +
        theme(plot.background = element_rect(fill = "#272b30"),
              panel.background = element_rect(fill = "#272b30"),
              axis.line = element_line(colour = "#FFFFFF"),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              axis.text = element_text(colour = "#FFFFFF"),
              axis.title = element_text(colour = "#FFFFFF"),
              plot.title = element_text(colour = "#FFFFFF"),
              legend.title = element_text(colour = "white", size = 10),
              legend.text = element_text(colour = "white")) +
        labs(color = "Content Rating") +
        labs(title = paste0("IMDb Scores of ", input$genre, " movies from ", input$yearRange[1], " to ", input$yearRange[2])) +
        scale_x_discrete(name = "Year", seq(1916,2016,10)) +
        scale_y_discrete(name = "IMDb Scores", seq(0.0,10.0,0.5)) 
      ggplotly(p) %>% 
        config(displayModeBar = F) %>%
        layout(legend = l)
    }
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
  
  output$text1 <- renderText("You may want to watch ...")
  output$text2 <- renderText("Note: please space between first name and last name!")
  
  
})
