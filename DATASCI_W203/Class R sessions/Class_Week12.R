setwd("/Users/ceccarelli/MIDS/DATASCI_W203/Class R sessions")


load('GSS_daughters.rdata')
names(GSS)
cbind(names = colnames(GSS), labels = attr(GSS, "var.labels"))


table(GSS$kdsex1, useNA = 'always')
GSS$daughter1 = as.numeric( GSS$kdsex1=='female' )
table(GSS$daughter1, useNA = 'always')
#This is how you can add description for a variable if
# all previous variables in the data frame have descriptions
attr(GSS,'var.labels') = c( attr(GSS,'var.labels')  , 'first child is a girl')

table(GSS$partyid, as.numeric(GSS$partyid), useNA = 'always')


## CODE OTHER PARTY AS MISSING OR AS INDEPENDENT 
GSS$repub.partyid = ifelse( as.numeric(GSS$partyid)<=7, 
                            as.numeric(GSS$partyid), 
                            NA )
attr(GSS,'var.labels') = 
  c( attr(GSS,'var.labels')  , "party id; higher means more republican; 'other party' is dropped")


## MODEL 1
summary( model1<- lm(repub.partyid~daughter1 , data=GSS))



## MODEL 2
summary( model2<- lm(repub.partyid~daughter1+educ, data=GSS))


## MODEL 3
summary( model3<- lm(repub.partyid~daughter1+unclass(income), data=GSS))


### Comparison
selected.vars = c('repub.partyid','daughter1','educ')
GSSsub = subset(GSS, select = selected.vars)
GSSsub = subset(GSSsub, subset = complete.cases(GSSsub))

m1<- lm(repub.partyid~daughter1     , data=GSSsub) 
m2<- lm(repub.partyid~daughter1+educ, data=GSSsub) 
anova(m1,m2)
##Model 2 is better

## what happened to coeff(daughter1)?
lapply(list(m1,m2), FUN = function(x) coefficients(summary(x))['daughter1',] )

### there is not much change.
### this is because daughter1 is really not correlated with
### other independent variables. 
### Think about it: "daughter1" is as good as a coin toss 
### (unless, people abort babies based on gender)

####
### So, we could do a t-test, essentialy
t.test(repub.partyid~daughter1, data=GSS )

### or mann-whitney test, to be more careful about party-id
wilcox.test(repub.partyid~daughter1, data=GSS )


##### DIAGNOSTICS
library(lmtest)
bptest(m1)
bptest(m2)

plot(m1) 
### Nothing to worry about, except, of course, the fact that 
### the dependent variable is obviously an ordinal categorical
### which, among other things, means residuals won't be Normal