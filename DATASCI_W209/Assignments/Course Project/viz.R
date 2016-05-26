#############################
## Setup Info
#############################

## Clear environment variables
rm( list = ls())

## Set working directory
setwd("/Users/gregce/MIDS/DATASCI_W209/Assignments/Course Project/")

##install.packages("RPostgreSQL")

libs<-c("RPostgreSQL", "stringr", "dplyr", "tidyr","data.table")
lapply(libs, library, character.only = TRUE)

host = "w209-redshift.cuhowxoyhxan.us-east-1.redshift.amazonaws.com"
port = "5439"
dbname = "dev"
user = "midsuser"
password = "Midsuser2016"

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host=host, port=port,dbname=dbname, user=user, password=password)


trips <- dbGetQuery(con, "Select * from gregce.downsampled_trips_1000 limit 100;")