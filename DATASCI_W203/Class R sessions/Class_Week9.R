setwd("/Users/ceccarelli/MIDS/DATASCI_W203/Class R sessions")


# 1- Is there a difference between the amount of money a senator raises and the amount spent?
# 
# 2- Do female Democratic senators raise more or less money than female Republican senators?
# 
# 3- Do protestant Senators spend more or less money than non-protestant senators?


rm( list = ls() )
library(psych)
# Use the Countries dataset, including takedown variables
senate.df <- read.csv("united_states_senate_2014.csv")

summary(senate.df)
mean(senate.df$Campaign.Money.Raised..millions.of...)
mean(senate.df$Campaign.Money.Spent..millions.of...)

senate.df.females <- subset(senate.df, senate.df$Gender == 'Female')

t.test(senate.df.females$logmoneyraised ~ senate.df.females$Party, senate.df.females)

by(senate.df.females$Campaign.Money.Raised..millions.of..., senate.df.females$Party, mean, na.rm = TRUE)

qqnorm(senate.df.females$Campaign.Money.Raised..millions.of...)

hist(senate.df.females$Campaign.Money.Raised..millions.of...)

senate.df.females$logmoneyraised = log10(senate.df.females$Campaign.Money.Raised..millions.of...)

qqnorm(senate.df.females$logmoneyraised)

hist(senate.df.females$logmoneyraised)

wilcox.test(senate.df.females$Campaign.Money.Raised..millions.of... ~ senate.df.females$Party)

leveneTest(senate.df.females$logmoneyraised, senate.df.females$Party)

library(ggplot2)
library(car)
library(psych)