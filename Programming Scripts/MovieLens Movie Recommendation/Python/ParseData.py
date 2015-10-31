from pandas import concat, read_csv
from os.path import join

from ChicagoBoothML_Helpy.Print import printflush


def parse_movielens_20m_data(
        data_path='https://raw.githubusercontent.com/ChicagoBoothML/DATA___MovieLens___20M/master'):

    movies = read_csv(join(data_path, 'movies.csv'))

    NB_RATINGS_FILES = 10
    printflush('Parsing %i Ratings Files:' % NB_RATINGS_FILES, end=' ')
    ratings = []
    for i in range(NB_RATINGS_FILES):
        ratings_file_name = 'ratings%02d.csv' % (i + 1)
        ratings.append(read_csv(join(data_path, ratings_file_name)))
        printflush(ratings_file_name, end=', ')
    printflush()
    ratings = concat(ratings, ignore_index=True)

    return dict(movies=movies, ratings=ratings)
