from __future__ import absolute_import, print_function, unicode_literals

from streamparse.bolt import Bolt

import json
import pyhs2
import re
import unicodedata

##################################

configs = {
    # Hive server info
    'host'     : '52.23.237.143',
    'port'     : 10000,
    'auth'     : 'PLAIN',
    'user'     : 'root',
    'database' : 'default',

    # Table with 3 columns (movie_id STRING, tweet_id BIGINT, text STRING)
    'tweet_data_tablename' : 'tweet_data',
    'verbose' : False,
}

def get_config(name):
    global configs
    if name in configs:
        return configs[name]
    else:
        raise Exception("Invalid config " + name)

##################################

class StoreTweets(Bolt):

    def initialize(self, conf, ctx):
        self.verbose = get_config('verbose')
        return

    def process(self, tup):
        movie_id = tup.values[0]
        # [{'field_name' : 'field_value', ...}, ....]
        tweets = json.loads(tup.values[1])
        self.log('Received %d tweets for movie %s' % (len(tweets), movie_id))
        if self.verbose:
            self.log(tweets)

        with pyhs2.connect(host = get_config('host'), port = get_config('port'), authMechanism = get_config('auth'),
                           user = str(get_config('user')), database = get_config('database')) as conn:
            with conn.cursor() as cur:
                query = "INSERT INTO " + get_config('tweet_data_tablename') + " VALUES "
                for t in tweets:
                    # Clean up the tweets before storing
                    text = unicodedata.normalize('NFKD', t['text']).encode('ascii','ignore')
                    text = re.sub(r'\'', '', text) 
                    text = re.sub(r'\\', ' ', text) 
                    text = re.sub(r'[\s\n\t\r]', ' ', text) 
                    query += "('" + movie_id + "', " + str(t['id']) + ", '" + text + "'),"
                if self.verbose:
                    self.log(query)
                cur.execute(query[:-1])  # -1 to remove last comma
