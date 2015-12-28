from __future__ import absolute_import, print_function, unicode_literals

from streamparse.bolt import Bolt

import json
import pyhs2
import re
import pickle
import nltk.classify, nltk.classify.util
import time
from sets import Set
from nltk.classify import NaiveBayesClassifier
from os.path import join
from scipy.sparse import lil_matrix


##################################

configs = {
    # Hive server info
    'host'     : '52.23.237.143',
    'port'     : 10000,
    'auth'     : 'PLAIN',
    'user'     : 'root',
    'database' : 'default',

    'base_dir' : '/data/storm/sentiment_analysis/',
    'stop_words_file' : 'stopwords.txt' ,
    'classifier_file' : 'classifier',
    'vocab_file' : 'vocab',

    # Hive table storing SentimentAnalysis scores
    'se_score_tablename' : 'movie_se_score',

    'verbose' : True
}

def get_config(name):
    global configs
    if name in configs:
        return configs[name]
    else:
        raise Exception("Invalid config " + name)

##################################

class TweetSentimentAnalysis(Bolt):
    def initialize(self, conf, ctx):
        self.verbose = get_config('verbose')

        #initialize stop_words. It is dictionary for fast lookups.
        self.stop_words = Set(['AT_USER', 'URL'])
        with open(join(get_config('base_dir'), get_config('stop_words_file')), 'r') as file:
            for line in file:
                word = line.strip()
                self.stop_words.add(word)
        self.log(self.stop_words)

        # Load classifier and feature list
        with open(join(get_config('base_dir'), get_config('classifier_file')), 'r') as file:
            self.classifier = pickle.load(file)
        with open(join(get_config('base_dir'), get_config('vocab_file')), 'r') as file:
            self.vocab = pickle.load(file)

    def processTweet(self, tweet):
        # process the tweets

        #Convert to lower case
        tweet = tweet.lower()
        #Convert www.* or https?://* to URL
        tweet = re.sub('((www\.[^\s]+)|(https?://[^\s]+))','URL',tweet)
        #Convert @username to AT_USER
        tweet = re.sub('@[^\s]+','AT_USER',tweet)
        #Remove additional white spaces
        tweet = re.sub('[\s]+', ' ', tweet)
        #Replace #word with word
        tweet = re.sub(r'#([^\s]+)', r'\1', tweet)
        tweet = tweet.strip('\'"')
        return tweet

    def replaceTwoOrMore(self, s):
        #look for 2 or more repetitions of character and replace with the character itself
        pattern = re.compile(r"(.)\1{1,}", re.DOTALL)
        return pattern.sub(r"\1\1", s)

    def getWordsSet(self, tweet):
        words_set = Set()
        #split tweet into words
        words = tweet.split()
        for w in words:
            #replace two or more with two occurrences
            w = w.lower()
            w = self.replaceTwoOrMore(w)
            #strip punctuation
            w = w.strip('\'"?,.')
            #check if the word stats with an alphabet
            val = re.search(r"^[a-z][a-z0-9]*$", w)
            #ignore if it is a stop word
            if (w in self.stop_words or val is None):
                continue
            else:
                words_set.add(w)
        return words_set

    def build_features(self, list_of_bow):
        features = lil_matrix((len(list_of_bow), len(self.vocab)), dtype = 'bool')
        for i in range(len(list_of_bow)):
            for word in list_of_bow[i]:
                if word in self.vocab:
                    features[i, self.vocab[word]] = True
        return features

    def process(self, tup):
        movie_id = tup.values[0]
        # [{'field_name' : 'field_value', ...}, ....]
        tweets = json.loads(tup.values[1])
        # For debugging.
        #movie_id = tup[0]
        #tweets = json.loads(tup[1])
        self.log('Received %d tweets for movie %s' % (len(tweets), movie_id))

        tweets_bow = []
        for t in tweets:
            text = self.processTweet(t['text'])
            bag_of_words = self.getWordsSet(text)
            tweets_bow.append(bag_of_words)

        features = self.build_features(tweets_bow)

        pred = self.classifier.predict(features)
        pos_count = sum(pred)
        neg_count = len(pred) - pos_count

        self.log('SE: %s   +ve:%d   -ve:%d' % (movie_id, pos_count, neg_count))

        with pyhs2.connect(host = get_config('host'), port = get_config('port'), authMechanism = get_config('auth'),
                           user = str(get_config('user')), database = get_config('database')) as conn:
            with conn.cursor() as cur:
                query = ("INSERT INTO " + get_config('se_score_tablename') + " VALUES (" + str(int(time.time()))
                         + ", '" + movie_id + "', " + str(pos_count) + ", " + str(neg_count) + ")")
                if self.verbose:
                    self.log(query)
                cur.execute(query)

