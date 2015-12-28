from __future__ import absolute_import, print_function, unicode_literals

import itertools
import time
import pyhs2
import re
import unicodedata
from streamparse.spout import Spout

##################################

configs = {
    # Hive server info
    'host'     : '52.23.237.143',
    'port'     : 10000,
    'auth'     : 'PLAIN',
    'user'     : 'root',
    'database' : 'default',

    'time_between_emits_in_seconds' : 30,
    'movies_list_tablename' : 'movies_list', 
}

def get_config(name):
    global configs
    if name in configs:
        return configs[name]
    else:
        raise Exception("Invalid config " + name)

##################################

class MovieSpout(Spout):

    def initialize(self, stormconf, context):
        # FOR DEBUG:self.words = [('BlackMass', '#BlackMass'), ('Everest', '#Everest'), ('The Night Before', '#TheNightBefore')]
        records = []
        with pyhs2.connect(host = get_config('host'), port = get_config('port'), authMechanism = get_config('auth'),
                             user = str(get_config('user')), database = get_config('database')) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM " + get_config('movies_list_tablename'))
                records = cur.fetchall()
        # List of tuples (movie name, search term)
        self.words = []
        for i in records:
            movie_name = i[0]
            # Ignore movies which do not have simple alpha-numeric name
            cleaned_movie_name = re.sub(r'[^a-zA-Z0-9\s]', '', movie_name)
            if (len(movie_name) != len(cleaned_movie_name)):
                continue
            # Maybe do better processing of movie name to search term?
            #search_term = re.sub("['!@#$%^&*()_+=:\"\s\-]", '', movie_name)
            search_term = re.sub(r"\s", '', movie_name)
            self.log('Movie: ' +  movie_name + ' Search term : ' + search_term)
            self.words.append((movie_name, search_term))
        self.pos = 0
        self.last_emit = 0

    def next_tuple(self):
        cur_time = time.time()
        if cur_time - self.last_emit < get_config('time_between_emits_in_seconds'):
            time.sleep(2)
            return
        self.log("Emitting %s,%s" % (self.words[self.pos][0], self.words[self.pos][1]))
        self.emit(self.words[self.pos])
        self.last_emit = cur_time
        self.pos = (self.pos + 1) % len(self.words)

    def ack(self, tup_id):
        pass # if a tuple is processed properly, do nothing

    def fail(self, tup_id):
        pass # if a tuple fails to process, do nothing
