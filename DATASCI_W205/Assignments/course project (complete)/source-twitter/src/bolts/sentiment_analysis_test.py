from sentiment_analysis import TweetSentimentAnalysis
import json

se = TweetSentimentAnalysis()
se.initialize(None, None)

f = open('/data/storm/sentiment_analysis/Black_Mass.txt', 'r')
data = []
for line in f:
    data.append({'text':line})

se.process(('movie##3', json.dumps(data)))
