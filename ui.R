#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(R.utils)
library(shiny)
library(plotly)
library(markdown)
library(shinythemes)
library(shinyWidgets)
source("test.R")

df <- data.frame(
  val = c("HAPPY","UPSET", "LOVED", "IMAGINATIVE", "PLAYFUL")
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
  titlePanel(title = div(img(src="MHLogo.png", width = "20%"))),
  
  navbarPage("MovieHunter",
    tabPanel("Home", 
        align = "center",
        style = "font-size: 120%",
        h3("MovieHunter"),
        p("MovieHunter was made for everyone to find a movie to watch. The 
          creators want to make finding and choosing a movie to watch be an easy
          task. Use the 'Hunt a Movie' feature to find a movie with your preferences.
          Use the 'Hunt for Fun' feature to find a movie that fits with your mood. 
          The data used is from", a("Kaggle", href="https://www.kaggle.com/tmdb/tmdb-movie-metadata"),"and sourced from The Movie Database (TMDb)."),
        br(), br(),
        p("Here is a Movie you might be interested in watching:"),
        HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/2L3Gvo40DzQ" 
             frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
             allowfullscreen></iframe>'),
        br(), br(), br(),
        h2("About the Creators"),
        fluidRow(
          column(4,
                 h4("Isabella Garcia"),
                 p("Year: Junior"),
                 p("Favorite Movie:", a("She's the Man", href="https://www.imdb.com/title/tt0454945/")),
                 tags$img(src = "https://m.media-amazon.com/images/M/MV5BNTE0NDk1YzAtNTUwZC00NmViLWI3YjgtY2ZjYWI2YjYzZjkyXkEyXkFqcGdeQXVyMTkzODUwNzk@._V1_.jpg", width = "30%")
          ),
          column(4,
                 h4("Johnny Zou"),
                 p("Year: Sophomore"),
                 p("Favorite Movie:", a("Godzilla", href="https://www.imdb.com/title/tt3741700/")),
                 tags$img(src= "https://m.media-amazon.com/images/M/MV5BOGFjYWNkMTMtMTg1ZC00Y2I4LTg0ZTYtN2ZlMzI4MGQwNzg4XkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_SY1000_CR0,0,674,1000_AL_.jpg", width = "30%")
          ),
          column(4,
                 h4("Luyi Jia"),
                 p("Year: Senior"),
                 p("Favorite Movie:", a("Green Book", href="https://www.imdb.com/title/tt6966692/")),
                 tags$img(src = "https://m.media-amazon.com/images/M/MV5BYzIzYmJlYTYtNGNiYy00N2EwLTk4ZjItMGYyZTJiOTVkM2RlXkEyXkFqcGdeQXVyODY1NDk1NjE@._V1_SY1000_CR0,0,666,1000_AL_.jpg", width = "30%")
          )
        ),
        br(), br()
    ),

    tabPanel("Hunt a Movie",
    # Sidebar with a slider input for number of bins 
      sidebarLayout(
        sidebarPanel(
          # Filter movies by genre
          pickerInput("genre", "Choose a Genre:",
                      choices = sort(genres)),
          # Filter movies by language
          uiOutput("language"),
          # Filter movies by year
          sliderInput("yearRange", label = "Year Range", min = 1916, 
                         max = 2016, value = c(1916, 2016), sep = ""),
          sliderInput("duration", label = "Duration (min)", min = 0, 
                      max = 520, value = c(7, 511), sep = ""),
          checkboxGroupInput("type", label = "Content Rating", 
                             choices = sort(types)),
          checkboxGroupInput("color", label = "Color", 
                             choices = c("Color","Black & White")),
          helpText('Note: content rating starting with "TV-" is based on television content rating system.')
        ),
    
    # Show a plot of the generated distribution
      mainPanel(

        tabsetPanel(type = "tabs",
                    tabPanel("Movies", DT::dataTableOutput("table") , textOutput("text")),

                    tabPanel("Visualize", br(), textOutput("error"), plotlyOutput("plot"))

        )     
      )

      )
    ),

    tabPanel("Hunt for Fun",
             align = "center",
               tags$head(tags$style("
                       .jhr{
                       display: inline;
                       vertical-align: middle;
                       padding-left: 10px;
                       }")),
               pickerInput("mood",
                           label = h3("How do you feel today?"),
                           choices = df$val,
                           choicesOpt = list(content = df$img)
                           ),
             tags$head(tags$style("#note{color: #CCCCCC;
                                 font-size: 15px;
                                 }"
             )
             ),
             textOutput("note"),
             h4(""),
               actionButton("button", "Try Another"), 
              tags$head(tags$style("#text1{color: #FF9966;
                                 font-size: 20px;
                                 font-style: italic;
                                 }"
               )
               ),
             h4(""),
               textOutput("text1"),
               h2(uiOutput("random"))
    ),
    tabPanel("Help", 
           align = "center",
           style = "font-size: 120%",
           h2("How to use MovieHunter"),
           h3("Hunt a Movie"),
           p("Use the filter to find the movies that you are interested in watching."), 
           tags$li(align = "left", "You can select the genres of the movies that you want to watch such as 
             comedy or action"),
           tags$li(align = "left", "Choose the language that you want to watch the movie"),
           tags$li(align = "left", 
          "Select the year the movie was produced. To do this, use the slider to pick the time 
             frame and if you want to find the movies of a specific year, you can drag 
             the sliders on top of each other"),
          tags$li(align = "left","The duration filter allows you to pick the movies that you have time to watch"),
          tags$li(align = "left","Content Rating lets you choose an appropriate movie for your scope of preferences"),
          tags$li(align = "left","The color option allows you to filter to a more specific viewing experience"),
           h3("Hunt For Fun"),
           p("The 'Hunt For Fun' page is a great choice if you want to be adventurous and 
             pick a movie by chance. Choose an emoji that you are feeling and let us 
             choose a movie for you!"),
          h3("Analysis"),
          p("In general, there is more data in the recent years than from 1916, the earliest movie in the data. 
            When looking at the visualize feature keep that in mind. There are more movies in English than any other language.
            Before 1968, film ratings were nonexistent so there is a trend of having more content ratings as the years 
            become closer to present time."),
           h3("Visualization Source"),
           p("Visualizations are base on IMDb scores of the movies. IMDb is an online database 
            of information related to films, television programs, home videos and video games, 
            and internet streams, including cast, production crew and personnel biographies, 
            plot summaries, trivia, and fan reviews and ratings.")
    )
  )
))
