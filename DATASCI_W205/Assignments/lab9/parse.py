# -*- coding: utf-8 -*-
"""
Created on Tue Nov  3 18:50:32 2015

@author: ceccarelli
"""

from __future__ import absolute_import, print_function,unicode_literals
import re
from streamparse.bolt import Bolt

def ascii_string(s):
    return all(ord(c) < 128 for c in s)

class ParseTweet(Bolt):
    def process(self, tup):
        tweet = tup.values[0] # extract the tweet
        # Split the tweet into words
        words = tweet.split()
        valid_words = []
        for word in words:
            if word.startswith("#"): continue
            # Filter the user mentions
            if word.startswith("@"): continue
            # Filter out retweet tags
            if word.startswith("RT"): continue
            # Filter out the urls
            if word.startswith("http"): continue
            # Strip leading and lagging punctuations
            aword = word.strip("\"?><,'.:;)")
            # now check if the word contains only ascii
            if len(aword) > 0 and ascii_string(word):
                valid_words.append([aword])
        if not valid_words: return
        # Emit all the words
        self.emit_many(valid_words)
 # tuple acknowledgment is handled automatically