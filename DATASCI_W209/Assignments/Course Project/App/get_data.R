#############################
## Setup Info
#############################

## Clear environment variables
rm( list = ls())

## Set working directory
#setwd("/Users/gregce/MIDS/DATASCI_W209/Assignments/Course Project/App/")

##install.packages("RPostgreSQL")

libs<-c("RPostgreSQL", "stringr", "dplyr", "tidyr","data.table","ggmap","leaflet","shiny")
lapply(libs, library, character.only = TRUE)


#############################
## Server Conn Info 
#############################

connParams <- list(host = "w209-redshift.cuhowxoyhxan.us-east-1.redshift.amazonaws.com",
port = "5439",
dbname = "dev",
user = "midsuser",
password = "Mids2016")

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host=connParams$host, port=connParams$port,dbname=connParams$dbname, user=connParams$user, password=connParams$password)

#############################
## Get Data 
#############################

alltrips <- dbGetQuery(con, "Select * from gregce.downsampled_trips_all")

save(file = "alltrips.rda", alltrips)

#load("trips.rda")
