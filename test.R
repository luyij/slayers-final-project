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
  arrange(desc(year))


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

# format keywords
format <- function(x){
  for(i in 1:length(full_data$keywords))
  x[i] <- paste(unlist(str_split(full_data$keywords[i], "[|]")), collapse = ", ")
  x
}

full_data$keywords <- format(full_data$keywords)

full_data$id <- seq.int(nrow(full_data))

comedy <- filter(full_data, grepl("Comedy", genres)) 

comedy$id <- seq.int(nrow(comedy))

romance <- filter(full_data, grepl("Romance|Family", genres)) 

romance$id <- seq.int(nrow(romance))

fantasy <- filter(full_data, grepl("Sci-Fi|Fantasy", genres)) 

fantasy$id <- seq.int(nrow(fantasy))

horror <- filter(full_data, grepl("Horror", genres)) 

horror$id <- seq.int(nrow(horror))


