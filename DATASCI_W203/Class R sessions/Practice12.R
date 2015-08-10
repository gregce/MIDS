#clear workspace
rm( list = ls() )
setwd("/Users/ceccarelli/MIDS/DATASCI_W203/Async Material and Sample Files ")

#Load relevant packages
library(ggplot2)
library(car)
library(psych)
library(gmodels)
library(MASS)

#read in data
df<- read.csv("Happiness.csv", header = TRUE)
summary(df)
#View(df)

#inspecting variables
describe(df$How.often.do.you.try.to.make.other.people.happy)
hist(df$How.often.do.you.try.to.make.other.people.happy)
summary(df$How.often.do.you.try.to.make.other.people.happy)

describe(df$How.often.are.you.outdoors)
hist(df$How.often.are.you.outdoors)
summary(df$How.often.are.you.outdoors)


#correlation between both variables
cor.results <- cor.test(df$How.often.do.you.try.to.make.other.people.happy
                        , df$How.often.are.you.outdoors., 
                        use = "complete.obs", method = "pearson")
#R
cor.results**2

# compute r^2
cor.results$estimate**2

scatterplot(df$How.often.do.you.try.to.make.other.people.happy.
     , df$How.often.are.you.outdoors.,jitter=list(x=1, y=1))

# Creating a linear model
model = lm(How.often.do.you.try.to.make.other.people.happy. ~  
             How.often.are.you.outdoors., data = df)

#Output model to console
summary(model)

#Plot model
plot(model,jitter=list(x=1, y=1))


### Go again





describe(df$How.often.do.you.argue.with.people.who.are.close.to.you.)
hist(log(df$How.often.do.you.argue.with.people.who.are.close.to.you.))
summary(df$How.often.do.you.argue.with.people.who.are.close.to.you.)
