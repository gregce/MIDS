# -*- coding: utf-8 -*-
"""
Created on Fri Dec 11 13:16:31 2015

@author: GDC
"""

import sqlalchemy as sa
import pandas as pd
import matplotlib as plt
plt.use('Agg') 

#import pylab


#plt.style.use('ggplot')
engine = sa.create_engine('postgresql://postgres:MIDS@localhost:5432/tcount')
data = pd.read_sql(('select word, count from tweetwordcount order by count desc limit 20'), engine)
ax = data.plot.bar(x='word', y='count')
fig = ax.get_figure()
fig.savefig('plot.png')
