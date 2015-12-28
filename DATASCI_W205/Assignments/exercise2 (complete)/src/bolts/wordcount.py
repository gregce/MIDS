from __future__ import absolute_import, print_function, unicode_literals

from collections import Counter
from streamparse.bolt import Bolt
import psycopg2 as ps
import pandas as pd
import sqlalchemy as sa



class WordCounter(Bolt):

    def initialize(self, conf, ctx):
        #initialize a counter for tuples
        self.counts = Counter()
        self.engine = sa.create_engine('postgresql://postgres:MIDS@localhost:5432/tcount')
        self.conn   = ps.connect(database="tcount", user="postgres", password="MIDS", host="localhost", port="5432")

        #self.cur = self.conn.cursor()
            
    def process(self, tup):
        word = tup.values[0]
        self.counts[word] += 1
        self.emit([word, self.counts[word]])
        self.log('%s: %d' % (word, self.counts[word]))
        ## each time the dictionary grows to exceed 2000 words, write to sql
        if len(self.counts) > 2000:         
            #at the end of the process, write all the data from the self.counts dictionary into sql using pandas
            data = pd.DataFrame(self.counts.items(), columns=['word', 'count'])
            data = data.reset_index(drop=True)
            ## append all data to what is already there
            data.to_sql('tweetwordcount', self.engine, if_exists='append', index=False)
           
            ## read data back (will include dupes)
            data = pd.read_sql(('select word, count from tweetwordcount'), self.engine)
            
            ## replace table with deduped data table
            data_to_replace = data.groupby('word')['count'].sum()
            
            if not data_to_replace.empty:
                cur = self.conn.cursor()
                cur.execute("TRUNCATE TABLE tweetwordcount;")
                self.conn.commit()
            
            ## write deduped data to sql
            data_to_replace.to_sql('tweetwordcount', self.engine, if_exists='append')
            
            #reinitialize counter             
            self.counts = Counter()
        
            
   
