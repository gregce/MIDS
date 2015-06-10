#Part 2a. Variable Manipulations (10 points each)

#set up working envrionment
setwd('/Users/ceccarelli/MIDS/DATASCI_W203/Assignments/Labs/Lab 1')
rm( list = ls() )

##load GDP data as a data frame
gdp.data <- read.csv("GDP_World_Bank.csv", sep=",", header = TRUE)

table(gdp.data)
