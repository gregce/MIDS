import numpy as np
import pandas as pd
import statsmodels.api as sm

df=pd.read_csv('sentimentanalysis.csv',index_col=0)

df.head()

x=df.se
y=df.imdb

est=sm.OLS(y,x)

est=est.fit()

est.summary()

est.params

import plotly.plotly as py
import plotly.graph_objs as go
import plotly.tools as tls
from plotly.graph_objs import Data, Layout, Figure
from plotly.graph_objs import XAxis, YAxis

tls.set_credentials_file(username='talieh', api_key='xhh7wkzy0k')
# We pick 100 hundred points equally spaced from the min to the max
x_prime = np.linspace(x.min(), x.max(), 100)

# Now we calculate the predicted values
y_hat = est.predict(x_prime)

trace= go.Scatter(x=x,y=y,mode ='markers',name='raw_data')# Plot the raw data

layout=Layout(title='Regression',xaxis1=XAxis(title='Positive to Negative Ratio'),yaxis1=YAxis(title='IMDB Rating'))


trace1= go.Scatter(x=x_prime,y=y_hat, mode='lines',name='regression')

data=Data([trace,trace1])

fig=Figure(data=data, layout=layout)

py.plot(fig,filename='regression')


