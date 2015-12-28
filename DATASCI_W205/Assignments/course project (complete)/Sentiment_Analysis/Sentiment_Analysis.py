#import regex
import re
import nltk.classify, nltk.classify.util
from nltk.classify import NaiveBayesClassifier

#start process_tweet
def processTweet(tweet):
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
    #trim
    tweet = tweet.strip('\'"')
    return tweet
#end


#initialize stopWords
stopWords = []

#start replaceTwoOrMore
def replaceTwoOrMore(s):
    #look for 2 or more repetitions of character and replace with the character itself
    pattern = re.compile(r"(.)\1{1,}", re.DOTALL)
    return pattern.sub(r"\1\1", s)
#end

#start getStopWordList
def getStopWordList(stopWordListFileName):
    #read the stopwords file and build a list
    stopWords = []
    stopWords.append('AT_USER')
    stopWords.append('URL')

    fp = open(stopWordListFileName, 'r')
    line = fp.readline()
    while line:
        word = line.strip()
        stopWords.append(word)
        line = fp.readline()
    fp.close()
    return stopWords
#end

#start getfeatureVector
def getFeatureVector(tweet , stopWords):
    featureVector = []
    #split tweet into words
    words = tweet.split()
    for w in words:
        #replace two or more with two occurrences
        w = replaceTwoOrMore(w)
        #strip punctuation
        w = w.strip('\'"?,.')
        #check if the word stats with an alphabet
        val = re.search(r"^[a-zA-Z][a-zA-Z0-9]*$", w)
        #ignore if it is a stop word
        if(w in stopWords or val is None):
            continue
        else:
            featureVector.append(w.lower())
    return featureVector
#end

#Read the tweets one by one and process it
fp = open('rt-polarity-pos.txt', 'r')
linep = fp.readline()

st = open('stopwords.txt', 'r')
stopWords = getStopWordList('stopwords.txt')
postweets=[]
negtweets=[]
featureList=[]

while linep:
    processedTweet = processTweet(linep)
    featureVector = getFeatureVector(processedTweet, stopWords)
    featureList.extend(featureVector)
    postweets.append((featureVector, "pos"))
    #print (postweets)
    linep = fp.readline()
#end loop
fp.close()


fn=open('rt-polarity-neg.txt', 'r')
linen=fn.readline()


while linen:
    processedTweet = processTweet(linen)
    featureVector = getFeatureVector(processedTweet, stopWords)
    featureList.extend(featureVector)
    negtweets.append((featureVector, "neg"))
    #print (negtweets)
    linen = fn.readline()
#end loop
fn.close()

traintweets=postweets+negtweets

# Remove featureList duplicates
featureList = list(set(featureList))

#start extract_features
def extract_features(tweet):
    tweet_words = set(tweet)
    features = {}
    for word in featureList:
        features['contains(%s)' % word] = (word in tweet_words)
    return features
#end

# Generate the training set
training_set = nltk.classify.util.apply_features(extract_features, traintweets)

# Train the Naive Bayes classifier
NBClassifier = nltk.NaiveBayesClassifier.train(training_set)

#classifier = NaiveBayesClassifier.train(traintweets)

# Test the classifier
ft=open('Black_Mass.txt', 'r')
linet=ft.readline()
poscount=0
negcount=0
while linet:
    processedtestTweet = processTweet(linet)
    featuretestVector = getFeatureVector(processedtestTweet, stopWords)
    extracttestfeature=extract_features(featuretestVector)
    # counting the number of positive tweets
    if NBClassifier.classify(extracttestfeature)== "pos":
        poscount+=1
    #counting the number of negative tweets
    elif NBClassifier.classify(extracttestfeature)== "neg":
        negcount+=1
    linet = ft.readline()
#end loop
ft.close()
print(poscount)
print(negcount)
print(poscount/negcount)

#processedTestTweet = processTweet(testTweet)
#print (NBClassifier.classify(extract_features(getFeatureVector(processedTestTweet, stopWords))))

