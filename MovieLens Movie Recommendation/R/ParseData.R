library(data.table)


parse_movielens_1m_data <- function(
  data_path='https://raw.githubusercontent.com/ChicagoBoothML/DATA___MovieLens___1M/master') {

  cat('Parsing Movies... ')
  movies <- fread(
    file.path(data_path, 'movies.csv'),
    colClasses=c(
      movie_id='integer',
      movie='character',
      genres='character'),
    stringsAsFactors=FALSE,
    showProgress=FALSE)
  # movies_lines <- readLines(file.path(data_path, 'movies.dat'))
  # movies_lines[3776] <- '3845::And God Created Woman (1956)::Drama'
  # movies <- as.data.table(read.table(
  #   text=gsub('::', '\t', movies_lines),
  #   sep='\t',
  #   quote="",
  #   header=FALSE,
  #   col.names=c('movie_id', 'movie', 'genres'),
  #   colClasses=c(
  #     movie_id='integer',
  #     movie='character',
  #     genres='character'),
  #   stringsAsFactors=FALSE))
  # write.csv(movies, file.path(data_path, 'movies.csv'), row.names=FALSE)
  cat('done!\n')
  
  cat('Parsing Users... ')
  users <- fread(
    file.path(data_path, 'users.csv'),
    colClasses=c(
      user_id='integer',
      gender='character',
      age='character',
      occupation='character',
      zip_code='character'),
    stringsAsFactors=TRUE,
    showProgress=FALSE)
  # users_lines <- readLines(file.path(data_path, 'users.dat'))
  # users <- as.data.table(read.table(
  #   text=gsub('::', '\t', users_lines),
  #   sep='\t',
  #   quote="",
  #   header=FALSE,
  #   col.names=c('user_id', 'gender', 'age', 'occupation', 'zip_code'),
  #   colClasses=c(
  #     user_id='integer',
  #     gender='character',
  #     age='integer',
  #     occupation='integer',
  #     zip_code='character'),
  #   stringsAsFactors=FALSE))
  # users[ , `:=`(
  #   gender=factor(gender),
  #   age=factor(
  #     age,
  #     levels=c(1, 18, 25, 35, 45, 50, 56),
  #     labels=c('Under 18', '18-24', '25-34', '35-44', '45-49', '50-55', '56+')),
  #   occupation=factor(
  #     occupation,
  #     levels=0 : 20,
  #     labels=c(
  #       'other',
  #       'academic/educator',
  #       'artist',
  #       'clerical/admin',
  #       'college/grad student',
  #       'customer service',
  #       'doctor/health care',
  #       'executive/managerial',
  #       'farmer',
  #       'homemaker',
  #       'K-12 student',
  #       'lawyer',
  #       'programmer',
  #       'retired',
  #       'sales/marketing',
  #       'scientist',
  #       'self-employed',
  #       'technician/engineer',
  #       'tradesman/craftsman',
  #       'unemployed',
  #       'writer')))]
  # write.csv(users, file.path(data_path, 'users.csv'), row.names=FALSE)
  cat('done!\n')
  
  cat('Parsing Ratings... ')
  ratings <- fread(
    file.path(data_path, 'ratings.csv'),
    colClasses=c(
      user_id='integer',
      movie_id='integer',
      rating='numeric',
      timestamp='numeric'),
    stringsAsFactors=FALSE,
    showProgress=FALSE)
  # ratings_lines <- readLines(file.path(data_path, 'ratings.dat'))
  # ratings <- as.data.table(read.table(
  #   text=gsub('::', '\t', ratings_lines),
  #   sep='\t',
  #   quote="",
  #   header=FALSE,
  #   col.names=c('user_id', 'movie_id', 'rating', 'timestamp'),
  #   colClasses=c(
  #     user_id='integer',
  #     movie_id='integer',
  #     rating='numeric',
  #     timestamp='character'),
  #   stringsAsFactors=FALSE))
  # write.csv(ratings, file.path(data_path, 'rating.csv'), row.names=FALSE)
  cat('done!\n')
  
  list(movies=movies, users=users, ratings=ratings)
}


parse_movielens_20m_data <- function(
  data_path='https://raw.githubusercontent.com/ChicagoBoothML/DATA___MovieLens___20M/master') {

  cat('Parsing Movies... ')
  movies <- fread(
    file.path(data_path, 'movies.csv'),
    showProgress=FALSE)
  cat('done!\n')
  
  NB_RATINGS_FILES = 10
  
  cat('Parsing ', NB_RATINGS_FILES, ' Ratings Files... ', sep='')
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
