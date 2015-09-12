## pick partners 
## please email the individuals in the class that have the same value for
## "groups" 
## email alex with any questions @ d.alex.hughes@gmail.com

## install.packages("data.table", dependencies = TRUE)

library(data.table)
set.seed(1)

n <- data.table(names = c("greg", "derek", "kyle", "cory", "jonathan", 
                          "william", "jason", "michael", "raja", "daniel", 
                          "max", "shelly", "stephane"))
n[, groups := sample(1:floor(.N / 3), size = .N, replace = T)]
setkey(n, "groups")
n