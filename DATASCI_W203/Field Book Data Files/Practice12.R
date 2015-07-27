

rnorm(c(1:100),20,2)

df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),
                 y = rnorm(30))
plot(df)
library(plyr)

#load ggplot2 library for graphing
library(ggplot2)
library(psych)
library(pastecs)
#ensure directory is correct
setwd("/Users/gdc/Documents/MIDS/DATASCI_W203/Field Book Data Files/") 

#load delimited data into memory
dlf <- read.delim("DownloadFestival(No Outlier).dat",TRUE)

#draw regular histogram on day data
hist(dlf$day1)

#draw fancy histogram on day data
hist.day1 <- ggplot(dlf, aes(day1)) + geom_histogram(aes(y = ..density..)) 
hist.day1dn

q <- qplot(sample = dlf$day1,stat = "qq")
q
describe(dlf$day1)
cbind?

?cbind
describe(cbind(dlf$day1,dlf$day2,dlf$day3))
round(stat.desc(dlf[, c("day1", "day2", "day3")], basic = FALSE, norm = TRUE),3)


r.exam <- read.delim("RExam.dat",TRUE)

View(r.exam)

summary(r.exam)
length(letters[1:14])

r.exam$num_letters <- factor(r.exam$numeracy, levels = c(1:14), labels=letters[1:14])
factor(r.exam$num_letters)


by(r.exam$exam,r.exam$num_letters,mean)

shapiro.test(r.exam$exam)
hist(r.exam$exam)


###-------------------------------------##
### Correlation Chapter


cov(r.exam$exam,r.exam$computer)
sd(r.exam$exam)
sd(r.exam$computer)

##calculating the correlation coefficient (aka standardized covariance)
cov(r.exam$exam,r.exam$computer) / (sd(r.exam$exam)*sd(r.exam$computer))

##correlation coefficient!
cor(r.exam$exam,r.exam$computer)

plot(r.exam$exam,r.exam$computer)

# 
# install.packages("Hmisc"); install.packages("ggm");
# install.packages("ggplot2"); install.packages("polycor")
#install.packages("gmodels")

library(ggm)
library(ggplot2)
library(Hmisc)
library(polycor)
library(gmodels)

factor(data$sex)


bl <- read.delim("The Biggest Liar.dat",TRUE)
View(bl)
table(bl)
describe(bl)

cor(bl$Position, bl$Creativity, method = "spearman")

bootTau<-function(liarData,i) {
  cor(liarData$Position[i], liarData$Creativity[i], use = "complete.obs", method = "kendall")
}

library(boot)
boot_kendall<-boot(bl, bootTau, 2000)
boot_kendall

purr <- read.csv("pbcorr.csv", TRUE)
View(purr)
cor.test(purr$time,purr$gender)
prop.table(table(purr$gender))

DF1 <- data.frame(
gender<-factor(floor(runif(1000, 1,3)),levels = c(1,2),labels = c("Male","Female")),
education<-factor(floor(runif(1000, 1,4)),levels = c(1,2,3),labels = c("High School","Undergrad","Graduate")))

attach(DF1)
table(gender,education)


mat=matrix(addmargins(table(gender,education)),nrow = 3, ncol = 4)
mat.copy <- mat
mat.copy2 <- mat

for(i in 1:2){
  for(j in 1:3){
  #print(mat[i,j])
    mat.copy[i,j]<-mat[i,j]-((mat[i,4]*mat[3,j])/mat[3,4])^2/(((mat[i,4]*mat[3,j])/mat[3,4]))
  }
}
mat.copy
CrossTable(table(gender,education), fisher = TRUE, chisq = TRUE, expected = TRUE, sresid = TRUE, format = "SPSS")
