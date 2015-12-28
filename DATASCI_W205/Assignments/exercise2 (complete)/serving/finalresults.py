# -*- coding: utf-8 -*-
"""
Created on Thu Dec 10 11:53:13 2015

@author: GDC
"""
#Import Modules
from __future__ import absolute_import, print_function, unicode_literals
import pandas as pd
import argparse
#import psycopg2
from sqlalchemy import create_engine

#Initialize Db Conn
engine = create_engine('postgresql://postgres:MIDS@localhost:5432/tcount')

#Code to handle to parse command line inputs and return results 
parser = argparse.ArgumentParser()
parser.add_argument("words", nargs='?', help="displays the total number of word occurrences in the stream")
args = parser.parse_args()
if args.words:
    #Read in a data frame
    df = pd.read_sql(('select count from tweetwordcount '
                      'where word = %(word)s'),
                   engine,params={"word":args.words})
    #Print Results of just the returned scalar
    print('Total number of occurences of "%s": %s' % (args.words,df.iloc[0,0]))
else:
    df = pd.read_sql(('select word, count from tweetwordcount order by word asc '), engine)
    print([tuple(x) for x in df.values])
                