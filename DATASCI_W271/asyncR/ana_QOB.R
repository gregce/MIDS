

library(foreign)
library(stargazer)
df <- read.dta("C:/Users/K/Google Drive/MIDS/Applied Regression and Time Series Analysis/Lec07 - Identification 2/QOB_full.dta")
  str(df)
  stargazer(df, type="text", title="Descriptive Stats", digits=1)
    # Note that some of these variables are binary and should not 
    # be summarized using this function; I am just doing this
    # for illustration
  table(df$v3)
  table(df$v5)
  table(df$v10)