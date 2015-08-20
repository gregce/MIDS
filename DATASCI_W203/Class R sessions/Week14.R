##clear screen and set working variables

rm( list = ls() )
setwd("/Users/ceccarelli/MIDS/DATASCI_W203/Async Material and Sample Files /")

## load library and view data
library(PASWR)

## review data
?titanic3

# pclass
# a factor with levels 1st, 2nd, and 3rd
# 
# survived
# Survival (0 = No; 1 = Yes)
# 
# name
# Name
# 
# sex
# a factor with levels female and male
# 
# age
# age in years
# 
# sibsp
# Number of Siblings/Spouses Aboard
# 
# parch
# Number of Parents/Children Aboard
# 
# ticket
# Ticket Number
# 
# fare
# Passenger Fare
# 
# cabin
# Cabin
# 
# embarked
# a factor with levels Cherbourg, Queenstown, and Southampton
# 
# boat
# Lifeboat
# 
# body
# Body Identification Number
# 
# home.dest
# Home/Destination

summary(titanic3)

##check issues with data
summary(complete.cases(titanic3$survived, titanic3$parch, titanic3$boat))

attach(titanic3)

model1 <- glm(survived ~ parch, family=binomial())
summary(model1)

plot(model1)

plot(survived,parch)

View(survived)

mat<-as.matrix(table(parch,survived))

as.numeric(mat[,1:2])

names(by(titanic3$survived, titanic3$parch, FUN = mean))

transform(mat, sum=rowsum(mat))
       
data.frame(table(parch,survived))

df<-data.frame(table(parch,survived)/sum(table(parch,survived)))

plot(df$)

plot(parch,survived,col="black",pch=1,main="Relationship ",xlab="Parents Children",
     ylab="Survived")

lines(parch,predict(model1,type="response"))

View(data.frame(predict(model1,type="response")))


###next model

titanic3$boat2 <- ifelse(nchar(as.character(titanic3$boat))>0,1,0)

View(titanic3$boat2)

model2 <- glm(survived ~ parch+titanic3$boat2, family=binomial())
summary(model2)

plot(model2)

plot(survived,parch)

View(survived)


plot(parch,titanic3$boat2,col="black",pch=1,main="Relationship ",xlab="Parents Children", ylab="Survived")

lines(parch,predict(model2,type="response"))

data.frame(predict(model2,type="response"))

model.matrix(~factor(boat))
