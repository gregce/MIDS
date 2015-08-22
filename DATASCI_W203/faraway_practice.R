
rm( list = ls() )
setwd("/Users/ceccarelli/MIDS/DATASCI_W203/Async Material and Sample Files /")

library("faraway")

data(eco,package="faraway")


plot(income ~ usborn, data=eco, xlab="Proportion US born", ylab="
Mean Annual Income")

lmod <- lm(income ~ usborn, data=eco)
summary(lmod)

plot(income ~ usborn, data=eco, xlab="Proportion US born", ylab="
Mean Annual Income",xlim=c(0,1),ylim=c(15000,70000),xaxs="i")

abline(coef(lmod))

coef(lmod)

predict(lmod,usborn=c(10))

require(ggplot2)

ggplot(chredlin,aes(race,involact)) + geom_point() +stat_smooth(
  method="lm")


sumary(lm(involact ~ race,chredlin))

ggplot(chredlin,aes(race,theft)) + geom_point() +stat_smooth(method="
lm")
