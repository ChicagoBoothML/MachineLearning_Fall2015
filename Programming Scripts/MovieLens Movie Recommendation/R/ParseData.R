parse_movielens_20m_data <- function(
  data_path='https://raw.githubusercontent.com/ChicagoBoothML/DATA___MovieLens___20M/master') {

  library(data.table)
  
  movies <- fread(file.path(data_path, 'movies.csv'))
  
  NB_RATINGS_FILES = 10
  
  cat('Parsing ', NB_RATINGS_FILES, ' Ratings Files: ', sep='')
  ratings <- data.table(
    userId=integer(),
    movieId=integer(),
    rating=numeric(),
    timestamp=character())
  for (i in 1 : NB_RATINGS_FILES) {
    ratings_file_name <- paste('ratings', formatC(i, width=2, flag=0), '.csv', sep='')
    r <- fread(file.path(data_path, ratings_file_name),
               colClasses=c(
                 userId='integer',
                 movieId='integer',
                 rating='numeric',
                 timestamp='character'),
               stringsAsFactors=FALSE,
               showProgress=FALSE)
    ratings = rbind(ratings, r)
    cat(ratings_file_name, ', ', sep='')
  }
  cat('done!\n')
    
  list(movies=movies, ratings=ratings)
}







