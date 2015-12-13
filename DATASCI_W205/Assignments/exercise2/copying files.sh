#ensure right dir
cd /root

cp exercise_2/tweetwordcount/src/spouts/tweets.py EX2Tweetwordcount/src/spouts/
cp exercise_2/tweetwordcount/src/bolts/parse.py EX2Tweetwordcount/src/bolts/
cp exercise_2/tweetwordcount/src/bolts/wordcount.py EX2Tweetwordcount/src/bolts/
cp exercise_2/Twittercredentials.py EX2Tweetwordcount/
cp exercise_2/hello-stream-twitter.py EX2Tweetwordcount/
cp exercise_2/tweetwordcount/topologies/tweetwordcount.clj EX2Tweetwordcount/topologies/
cp exercise_2/psycopg-sample.py psycopg-sample.py/