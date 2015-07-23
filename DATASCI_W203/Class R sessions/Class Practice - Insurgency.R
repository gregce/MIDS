setwd('/Users/gdc/Documents/MIDS/DATASCI_W203/Assignments/Labs/Lab 1')
rm( list = ls() )

#load libraries
library(foreign)
library(psych)

# Tomorrow we are mainly going to:
#   
#   A) discuss "upper-body strength" paper that you have received before. 
# (you have already received this)
# 
# B) use the attached data set to practice correlation and chi-squared tests to test a couple of hypotheses as discussed below.
# 
# ========
#   Insurgency Data Set Exercise (see insurgency.dta)
# 1) Each observation is an insurgency (with a state fighting an insurgent)
# -dur: duration of war in months 
# -wdl: win/draw/lose variable showing outcome from the point of view of the state
# -pol2: polity2 score for how democratic the state is. it ranges from -10 to +10 (fully democratic)
# -occ: whether the state is an occupier fighting the insurgent on foreign land or is it fighting a domestic insurgency.
# 
# 2) Directions
# -use the "foreign" library and then "read.dta" to read the data 
# (e.g., insurgency.stata <- read.dta("blah\blah\Insurgency.dta")
# 
# 
# 3) Questions: 
#   
#   3a) What type of variable are each of the four variables mentioned above?
# 3b) 	How can we test these hypotheses:
#   * Occupation has an effect on the outcome of war.
# * Democracies fight shorter wars.
# 
# 3c)  What did you find? 

insurgency.stata <- read.dta("lyall2010.dta")
insurgency.stata.limited <- insurgency.stata[,c("dur","wdl","pol2","occ")]

describe(insurgency.stata.limited)
summary(insurgency.stata.limited)

scatterplot(insurgency.stata.limited$occ,insurgency.stata.limited$wdl)
scatterplot(insurgency.stata.limited$dur,insurgency.stata.limited$pol2)


cor.test(insurgency.stata.limited$occ,insurgency.stata.limited$wdl)

cor.test(insurgency.stata.limited$dur,insurgency.stata.limited$pol2)
