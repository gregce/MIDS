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

#trips <- dbGetQuery(con, "Select * from gregce.downsampled_trips_1000")
#save(file = "trips.rda", trips)

load("trips.rda")

#############################
## Functions 
#############################

decodeLine <- function(encoded){
  require(bitops)
  
  vlen <- nchar(encoded)
  vindex <- 0
  varray <- NULL
  vlat <- 0
  vlng <- 0
  
  while(vindex < vlen){
    vb <- NULL
    vshift <- 0
    vresult <- 0
    repeat{
      if(vindex + 1 <= vlen){
        vindex <- vindex + 1
        vb <- as.integer(charToRaw(substr(encoded, vindex, vindex))) - 63  
      }
      
      vresult <- bitOr(vresult, bitShiftL(bitAnd(vb, 31), vshift))
      vshift <- vshift + 5
      if(vb < 32) break
    }
    
    dlat <- ifelse(
      bitAnd(vresult, 1)
      , -(bitShiftR(vresult, 1)+1)
      , bitShiftR(vresult, 1)
    )
    vlat <- vlat + dlat
    
    vshift <- 0
    vresult <- 0
    repeat{
      if(vindex + 1 <= vlen) {
        vindex <- vindex+1
        vb <- as.integer(charToRaw(substr(encoded, vindex, vindex))) - 63        
      }
      
      vresult <- bitOr(vresult, bitShiftL(bitAnd(vb, 31), vshift))
      vshift <- vshift + 5
      if(vb < 32) break
    }
    
    dlng <- ifelse(
      bitAnd(vresult, 1)
      , -(bitShiftR(vresult, 1)+1)
      , bitShiftR(vresult, 1)
    )
    vlng <- vlng + dlng
    
    varray <- rbind(varray, c(vlat * 1e-5, vlng * 1e-5))
  }
  coords <- data.frame(varray)
  names(coords) <- c("lat", "lon")
  coords
}


