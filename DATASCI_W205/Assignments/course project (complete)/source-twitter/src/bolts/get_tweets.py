from __future__ import absolute_import, print_function, unicode_literals

from streamparse.bolt import Bolt

import os
import json
import tweepy
from os.path import exists, isfile

###################################

configs = {
    'consumer_key' : 'Vph7ucYleGA1jn844fv1P1AcN',
    'consumer_secret' : 'jyjk5NBCB6WK15kMIbgLP7cskbsA5YBA2XG3BYG7fcUG0qxS8v',
    # Access token of Appy's account.
    'access_token_key' : '243603579-BPN47VAZVtV9mukRWLwzdssD4pIYFJRzQ6hVdGs9',
    'access_token_secret' : 'rbkUcJH6D8ajV61BG6Gu9hqmaVHHhK7E50y5tpN9HxBOJ',

    'num_tweets_per_request' : 500,

    # Base dir to persist 'since_id' for movies
    'persistent_timestamp_dir' : '/data/storm/timestamps/',

    # List of fields to keep from tweet data
    'tweet_fields' : ['id', 'text'],
}

def get_config(name):
    global configs
    if name in configs:
        return configs[name]
    else:
        raise Exception("Invalid config " + name)
    

###################################

class GetTweets(Bolt):

    # Number of tweet results per search request. Max is 100.
    num_tweets_per_request = get_config('num_tweets_per_request')

    base_dir = get_config('persistent_timestamp_dir')

    tweet_fields = get_config('tweet_fields')

    def initialize(self, conf, ctx):
                auth = tweepy.OAuthHandler(get_config('consumer_key'), get_config('consumer_secret'))
                auth.set_access_token(get_config('access_token_key'), get_config('access_token_secret'))
                self.api = tweepy.API(auth)
    
    def process(self, tup):
        movie_id = tup.values[0]
        search_term = tup.values[1]

        # Get tweet data for the movie.
        since_id = self.get_since_id_from_file(movie_id)
        tweets = []

        try:
            tweets = [status._json for status in tweepy.Cursor(
                self.api.search, q=search_term, lang = "en", since_id = since_id,
                count = self.num_tweets_per_request).items(self.num_tweets_per_request)]
        except tweepy.TweepError as e:
            self.log('TweepError, Code = %d' % (e.message[0]['code']))
        else: 
            if len(tweets) == 0:
                self.log("No new tweets for (%s, %s) since %s" % (movie_id, search_term, since_id))
                return
            cleaned_tweets = self.clean_tweets(tweets)
            self.emit([movie_id, json.dumps(cleaned_tweets)])
            new_since_id = tweets[0]['id']
            self.log("%d new tweets for (%s, %s) between %s and %s" % (len(tweets), movie_id, search_term, since_id, new_since_id))
            self.write_since_id_to_file(movie_id, new_since_id);

            
    def clean_tweets(self, tweets):
        cleaned_tweets = []
        for t in tweets:
            x = dict()
            for f in self.tweet_fields:
                x[f] = t[f]
            cleaned_tweets.append(x)
        return cleaned_tweets
    
    def write_since_id_to_file(self, movie_id, since_id):
        f = open(self.base_dir + movie_id, 'w+')
        f.write(str(since_id))
        f.close()

    def get_since_id_from_file(self, movie_id):
        filename = self.base_dir + movie_id
        if os.path.exists(filename):
            with open(filename, 'r') as f:
                return f.read()
        else:
            return "0"
