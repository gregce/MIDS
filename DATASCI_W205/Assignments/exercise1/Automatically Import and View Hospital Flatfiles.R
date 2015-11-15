rm(list=ls())

##set working directory
setwd("/Users/ceccarelli/MIDS/DATASCI_W205/Assignments/Hospital_Revised_Flatfiles/")

##store list of files in a vector
files<-list.files()

##test 
files[grep(".csv",files)]

for(i in 1:length(files[grep(".csv",files)]))
{
  oname = files[grep(".csv",files)][i]
  assign(gsub(".csv","",files[grep(".csv",files)])[i], read.csv(oname))
}