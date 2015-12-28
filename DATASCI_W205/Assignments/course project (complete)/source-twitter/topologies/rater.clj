(ns rater
  (:use     [streamparse.specs])
  (:gen-class))

(defn rater [options]
   [
    ;; spout configuration
    {"movie-spout" (python-spout-spec
          options
          "spouts.movie.MovieSpout"
          ["movie_id" "search_term"]
          )
    }
    {"get-tweets" (python-bolt-spec
          options
          {"movie-spout" :shuffle}
          "bolts.get_tweets.GetTweets"
          ["movie_id" "tweet_data"]
          :p 2
          )
     "store-tweets" (python-bolt-spec
          options
          {"get-tweets" :shuffle}
          "bolts.store_tweets.StoreTweets"
          []
          :p 2
          )
     "se-tweets" (python-bolt-spec
          options
          {"get-tweets" :shuffle}
          "bolts.sentiment_analysis.TweetSentimentAnalysis"
          []
          :p 2
          )
    }
  ]
)
