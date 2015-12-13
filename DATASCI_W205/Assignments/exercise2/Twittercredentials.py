# -*- coding: utf-8 -*-
"""
Created on Wed Dec  9 12:26:17 2015

@author: GDC
"""

import tweepy

consumer_key = "WPqfx9BH7FkgRqmpLAGPR3Nih";
#eg: consumer_key = "YisfFjiodKtojtUvW4MSEcPm";

consumer_secret = "Pd0omCHuiYWj7Rc83ZgYFOgao9bBGFbNQVZGWTCEGLwuWmkPXW";
#eg: consumer_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token = "3783995172-GnVvAID7FGUhe9RpNYYaRTcMBDRGZQY66LZxllB";
#eg: access_token = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token_secret = "wOVJgY1KspUa7kEc67fOmhnjx4ukM0vzCj2LS90v8K2Is";
#eg: access_token_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";


auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)