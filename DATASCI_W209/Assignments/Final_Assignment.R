
#############################
## Setup Info 
#############################

rm( list = ls())

## Set working directory
setwd("/Users/gregce/MIDS/DATASCI_W209/Assignments/")

##install.packages("RPostgreSQL")

libs<-c("httr", "stringr", "dplyr", "tidyr","data.table","ggmap","leaflet","shiny")
lapply(libs, library, character.only = TRUE)


#############################
## Function Definitions
#############################

## generic function to call API
strava.data <- function(u,...) {
  arguments <- list(...)
  if (!length(arguments)==0) {
    u <- paste0(u,"?ids=",arguments[[1]], collapse = "")
  }
  # Enter API Token interactively if it does not exist
  if (exists("bearerToken") && nchar(bearerToken)>0) {
    bearerToken <- bearerToken
  } else {
    token <- as.character(readline(prompt="Enter api token: "))
    bearerToken <- paste0("Bearer ", token, collapse = "")
  }
  req <- GET(url=u,
             add_headers(Authorization = bearerToken)
  )
  return(content(req))
}

#############################
## Get Data
#############################

bearerToken <- "XXXXX"

## This Segment ID corresponds to the activity that I tracked via 
url <- "https://www.strava.com/api/v3/activities/534705679/streams/latlng"

#call api
segment.data <- strava.data(url)

#############################
## Transform data
#############################

unlisted.latlong <- unlist(segment.data[[1]]$data)

odds <- seq(1,length(unlisted.latlong),2)
evens <- seq(2,length(unlisted.latlong),2)

lat <- (unlisted.latlong[odds])
long <- unlisted.latlong[evens]


df_plot <- data.frame(lat = lat, lng =long)

#############################
## Plot data using leaflet
#############################


leaflet(df_plot) %>%
  addProviderTiles("OpenStreetMap.Mapnik", options = providerTileOptions(noWrap = TRUE)) %>%
  addCircles(~lng, ~lat, popup="Greg running", weight = 3, radius=40, 
           color="#ffa500", stroke = TRUE, fillOpacity = 0.8) %>% 
  addLegend("bottomright", colors= "#ffa500", labels="Run'", title="Rock and Roll Marathon")