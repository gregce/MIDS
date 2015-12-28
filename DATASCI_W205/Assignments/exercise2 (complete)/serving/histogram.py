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
parser.add_argument("bound", help="enter two integers separated by a a comma as an upper and lower bound")
args = parser.parse_args()
lower, upper = map(int,args.bound.split(','))
if lower and upper:
    df = pd.read_sql(('select word, count from tweetwordcount '
                      'where count >= %(lower)s and count <= %(upper)s order by count desc')
                      ,engine,params={"lower":lower,"upper":upper})
    #Print results of the dataframe
    print(df.iloc[:,0:2].to_string(index=False))

   