#Part 2a. Variable Manipulations (10 points each)

#set up working envrionment
setwd('/Users/ceccarelli/MIDS/DATASCI_W203/Assignments/Labs/Lab 1')
rm( list = ls() )

#define function to omit row values where only certain columns are NA
data.complete <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}

##force R not to use scientific notation
options("scipen"=100, "digits"=4)

##load GDP data as a data frame
gdp.data <- read.csv("GDP_World_Bank1.csv", sep=",", header = TRUE)

#count number of rows with incomplete entries
nrow(gdp.data[!complete.cases(gdp.data),])
gdp.data_complete <- data.complete(gdp.data, c('gdp2011', 'gdp2012'))

#create new nominal variable based on gdp increase
gdp.data_complete$gdp_growth <- gdp.data_complete$gdp2012 - gdp.data_complete$gdp2011

#create and store mean of new variable
mx <- mean(gdp.data_complete$gdp_growth)
mx

#store histogram first as a variable to inspect its properties
histinfo <- hist(gdp.data_complete$gdp_growth, 100)
histinfo

# Question 11
#view the histogram and observe its shape
hist(gdp.data_complete$gdp_growth)
#change number of breaks to observe slightly different version
hist(gdp.data_complete$gdp_growth, breaks = 20)

# Question 12
#capture & print mean for review


#create new high_growth variable based on comparison of gdp_growth to population mean
gdp.data_complete$high_growth <- gdp.data_complete$gdp_growth > mx

#count TRUE / FALSE values
summary(gdp.data_complete$high_growth)

#add mean line to histogram to explain TRUE/FALSE breakdown
abline(v = mx, col = "blue", lwd = 2)

#Part 2b. Data Import (25 points)
patent.data <- read.csv("patent_applications_2012_2013_cleaned.csv", sep=",", header = TRUE)


