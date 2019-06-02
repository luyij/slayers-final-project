library(dplyr)
library(stringr)
library(R.utils)

full_data <- read.csv("data/movie_metadata.csv", stringsAsFactors=FALSE)

full_data <- full_data %>% 
  select(movie_title, title_year, genres, language, country, imdb_score,
         director_name, color, content_rating, budget, movie_imdb_link, 
         plot_keywords) %>%
  distinct(.keep_all = FALSE) %>%
  rename(title = movie_title, year = title_year, director = director_name, 
         link = movie_imdb_link, keywords = plot_keywords) %>%
  arrange(year)
  #mutate(keywords = paste(str_split(keywords, "[|]"), collapse = ","))

# content rating system has been changed in years
full_data$content_rating <- full_data$content_rating %>%
  str_replace_all("X", "NC-17") %>%
  str_replace_all("M", "PG") %>%
  str_replace_all("GP", "PG") %>%
  str_replace_all("Not Rated|Passed|Approved", "Unrated")

# categorize empty rows of 'language' and 'content_rating"
full_data$language <- ifelse(full_data$language == "", str_replace_all(full_data$language, "|", "Other"), full_data$language)
full_data$content_rating <- ifelse(full_data$content_rating == "", str_replace_all(full_data$content_rating, "|", "Unrated"), full_data$content_rating)



# edit format of 'color' column
full_data$color <- full_data$color %>%
  str_replace_all("and", "&") %>%
  str_replace(" ", "")

# determine how many different movie genres
genres <- unique(unlist(str_split(full_data$genres, "[|]")))

# determine how many different types of content rating
types <- unique(full_data$content_rating)

#data <- full_data %>%
    #filter(grepl("Action", genres), language == "English") %>%
    #select(title, year, director, imdb_score, keywords)
