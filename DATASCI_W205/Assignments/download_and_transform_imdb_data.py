# -*- coding: utf-8 -*-

"""Contains full class definition for DirHandler."""

__author__ = "gregce@gmail.com"

import pandas as p
import random
import re

import json
from collections import OrderedDict
from urllib2 import urlopen
import urllib
from pprint import pprint

from imdb import IMDb


def print_details(mid):
    ia = IMDb()
    movie = ia.get_movie(mid)
    d = OrderedDict()
    d['imdb_id'] = movie.getID()
    d['imdb_url'] = 'http://www.imdb.com/title/tt' + mid + '/'
    d['title'] = movie['title']
    d['year'] = str(movie['year'])
    d['imdb_rating'] = str(movie['rating'])

    pprint(d)


def get_movie_id(title):
    link = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=' + \
           urllib.quote_plus("imdb {title}".format(title=title))
    url = urlopen(link).read()
    return json.loads(url)['responseData']['results'][0]['url'].rstrip('/')[-7:]


def main():
    while True:
        title = raw_input("Movie title: ")
        mid = get_movie_id(title)
        print_details(mid)

#########################

if __name__ == "__main__":
    main()