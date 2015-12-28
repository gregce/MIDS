# Code snippet to search for tweets matching a query and dump the results in a file.
import tweepy
import io

# Number of tweet results per search request. Max is 100.
num_tweets_per_request = 100
# Num pages per movie. Max is 15. One request will be made for each page.
num_pages_per_movie = 15
movies = ["Black Mass", "Everest", "Maze Runner", "Sicario", "The Intern"]

# End of Configurations #
#########################

consumer_key = 'Vph7ucYleGA1jn844fv1P1AcN'
consumer_secret = 'jyjk5NBCB6WK15kMIbgLP7cskbsA5YBA2XG3BYG7fcUG0qxS8v'
# Access token of Appy's account.
access_token_key = '243603579-BPN47VAZVtV9mukRWLwzdssD4pIYFJRzQ6hVdGs9'
access_token_secret = 'rbkUcJH6D8ajV61BG6Gu9hqmaVHHhK7E50y5tpN9HxBOJ'

# TODO: verify if this is app-only auth. https://dev.twitter.com/oauth/application-only
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token_key, access_token_secret)
api = tweepy.API(auth)

# For each movie, collect tweets and dump to file with name same as movie's
# name. One line per tweet. Format of tweet is JSON.
for movie in movies:
    tweets = [status._json for status in tweepy.Cursor(api.search,  q=movie, lang = "en", count = num_tweets_per_request).items(num_tweets_per_request * num_pages_per_movie)]
    with open(movie + ".txt", 'a') as file:
        for t in tweets:
            file.write(str(t) + "\n")
