# routr.nyc

#############################
## Setup Info 
#############################

#Set Palette of Colors
palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
  "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

#Load Libraries
library(shiny)
library(leaflet)
library(ggmap)
library(memisc)
library(dplyr)
library(geosphere)
library(plyr)

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


#############################
## Shiny UI
#############################

mapLayers = c("OpenStreetMap.Mapnik","Stamen.TonerLite","Esri.WorldStreetMap","CartoDB.DarkMatter")
zipPrecision = c("Very Precise", "Precise", "Semi Precise")


ui <- fluidPage(navbarPage("RoutR", id="nav",
  tabPanel("Map",
           div(class="outer",
               
               tags$head(
                 # Include some custom CSS
                 includeCSS("www/styles.css")
               ),
               
               leafletOutput("mymap", height = "100%"),
               
               absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                             width = 330, height = "auto",
                             
                             h2("Route Explorer"),
                             
                             textInput(inputId = 'origin', label = 'Enter your Origin', value = "Times Square NYC", placeholder ="e.g. 222 West 23rd"),
                             textInput(inputId = 'destination', label = 'Enter your Destination',  value = "Empire State Building", placeholder ="e.g. 2 Lexington Ave"),
                             selectInput("precision", "Level of Zip Precision", zipPrecision, selected = zipPrecision[3]),
                             selectInput('layer', 'Map Layer', choices = mapLayers, selected = mapLayers[1]),
                             
                             textOutput("route_count")
               ),
               
               
               
               tags$div(id="cite",
                        'Data compiled from ', tags$em('NYC FOIL'), ' by James, Greg & Drew'
               )
           )
  ),
  
  tabPanel("Data explorer",
           fluidRow(
             column(3,
                    selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
             )
           )
          ),
  tabPanel("About",
           fluidRow(" (a) an interactive visualization, and (b) explanatory text to accompany the interactive visualization. Text should include the names of team members, the visualization’s goals, its intended audience, and the data source(s). This may be included as an About page or integrated with the visualization itself, as appropriate."
           )
  )
)
)

#############################
## Load data for Server
#############################

load("data/trips2.rda")

deg2rad <- function(deg) return(deg*pi/180)

gcd.slc <- function(long1, lat1, long2, lat2) {
  # Convert degrees to radians
  long1 <- deg2rad(long1)
  lat1 <- deg2rad(lat1)
  long2 <- deg2rad(long2)
  lat2 <- deg2rad(lat2)
  
  R <- 6371.0002161 # Earth mean radius [km]
  d <- acos(sin(lat1)*sin(lat2) + cos(lat1)*cos(lat2) * cos(long2-long1)) * R
  return(d) # Distance in km
}


#############################
## Shiny Server
#############################

server <- function(input, output) {
  
  ## Grab list of geocoded information once in a reactive expression
  origin <- reactive({geocode(input$origin, output = "all")})
  destination<- reactive({geocode(input$destination, output = "all")})
  
  # Create formatted addresses for popup
  origin.fa <- reactive({paste0(sep = "",  "<b>Origin</b><br>", origin()$results[[1]]$formatted_address)})
  destination.fa <- reactive({paste0(sep = "",  "<b>Destination</b><br>", destination()$results[[1]]$formatted_address)})
  
  # Create and round lat long formatting based on selected input precsision
  precision <- reactive({as.numeric(as.character(cases(
    '50'=input$precision==zipPrecision[1],
    '100'=input$precision==zipPrecision[2],
    '200'=input$precision==zipPrecision[3])))})
  
  # origin.long <- reactive({as.numeric(round(origin()$results[[1]]$geometry$location$lng, precision()))})
  # origin.lat <- reactive({as.numeric(round(origin()$results[[1]]$geometry$location$lat, precision()))})
  
  # destination.long <- reactive({as.numeric(round(destination()$results[[1]]$geometry$location$lng, precision()))})
  # destination.lat <- reactive({as.numeric(round(destination()$results[[1]]$geometry$location$lat, precision()))})
  
  origin.long <- reactive({as.numeric(origin()$results[[1]]$geometry$location$lng)})
  origin.lat <- reactive({as.numeric(origin()$results[[1]]$geometry$location$lat)})
  
  destination.long <- reactive({as.numeric(destination()$results[[1]]$geometry$location$lng)})
  destination.lat <- reactive({as.numeric(destination()$results[[1]]$geometry$location$lat)})
  
  t<- reactive({ 
    p <- precision()
    olo <- origin.long()
    ola <- origin.lat()
    dlo <- destination.long()
    dla <- destination.lat()
    
    t <- trips2 %>%
      mutate(pickup_distance_away = gcd.slc(olo, ola, pickup_longitude, pickup_latitude)
            , dropoff_distance_away = gcd.slc(dlo, dla, dropoff_longitude, dropoff_latitude)
            ) %>%
      filter(pickup_distance_away <= p/1000, dropoff_distance_away <= p/1000)
    t
  })

  
  #Create reactive element that updates and maps plots to be rendered on the map
  route_df <- reactive({decodeLine(route(input$origin, input$destination, structure = "route",
                                         output = "all")$routes[[1]]$overview_polyline$points)})
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      setView(lng = -73.985428, lat = 40.748817, zoom = 12) %>%
      addProviderTiles(input$layer, options = providerTileOptions(noWrap = TRUE)) %>%
      addPolylines(route_df()$lon, route_df()$lat, fill = FALSE) %>%
      addMarkers(route_df()$lon[1], route_df()$lat[1], popup = (origin.fa())) %>%
      addMarkers(route_df()$lon[length(route_df()$lon)], route_df()$lat[length(route_df()$lon)]
                 ,popup = destination.fa()) %>%
      addCircles(route_df()$lon[1], route_df()$lat[1], radius = precision()) %>%
      addCircles(route_df()$lon[length(route_df()$lon)], route_df()$lat[length(route_df()$lon)], radius = precision()) %>%
#       addPopups(route_df()$lon[1], route_df()$lat[1], popup = origin.fa()) %>%
#       addPopups(route_df()$lon[length(route_df()$lon)], 
#                 route_df()$lat[length(route_df()$lon)], popup = destination.fa()) %>%
      fitBounds(lng1 = max(route_df()$lon),lat1 = max(route_df()$lat),
                lng2 = min(route_df()$lon),lat2 = min(route_df()$lat))
  })
  
  output$route_count <- renderText({paste("Number of Trips: ",nrow(t()))})
  
}


#############################
## Run App
#############################

shinyApp(ui = ui, server = server)

# 
# input <- "Times Square"
# output <- "The Empire State Building"
# 
# precision <- 3
# 
# origin <- geocode(input, output = "all")
# destination<- geocode(output, output = "all")
# 
# origin.long <- round(origin$results[[1]]$geometry$location$lng, precision)
# origin.lat <- round(origin$results[[1]]$geometry$location$lat, precision)
# 
# destination.long <- round(destination$results[[1]]$geometry$location$lng, precision)
# destination.lat <- round(destination$results[[1]]$geometry$location$lat, precision)
# 
# # Match input lat long pairs
# df <- trips2 %>%
#   dplyr::mutate(pickup_longitude_r = round(pickup_longitude, precision)
#               , pickup_latitude_r = round(pickup_latitude, precision)
#               , dropoff_longitude_r = round(dropoff_longitude, precision)
#               , dropoff_latitude_r = round(dropoff_latitude, precision)) %>%
#     dplyr::filter(pickup_longitude_r == origin.long,
#                   pickup_latitude_r == origin.lat,
#                   dropoff_longitude_r == destination.long,
#                   dropoff_latitude_r == destination.lat)
#                   
# 
# 
# df.trips <- reactive({
#   # Due to dplyr issue #318, we need temp variables for input values
#   p <- precision()
#   olo <- origin.long()
#   ola <- origin.lat()
#   dlo <- destination.long()
#   dla <- destination.lat()
#   
#   

# output$route_count <- renderText({
#   # Apply filters
#   p <- precision()
#   olo <- origin.long()
#   ola <- origin.lat()
#   dlo <- destination.long()
#   dla <- destination.lat()
#   
#     t <- trips2 %>%
#        dplyr::mutate(pickup_longitude_r <- round(pickup_longitude, p)
#                      , pickup_latitude_r <- round(pickup_latitude, p)
#                      , dropoff_longitude_r <- round(dropoff_longitude, p)
#                      , dropoff_latitude_r <- round(dropoff_latitude, p)) %>%
#         dplyr::filter(pickup_longitude_r == olo,
#                       pickup_latitude_r == ola,
#                       dropoff_longitude_r == dlo,
#                       dropoff_latitude_r == dla)
#   
#   length(t)})
# }
#   # Apply filters
#   t <- trips2 %>%
#     dplyr::mutate(pickup_longitude_r <- round(pickup_longitude, p)
#                   , pickup_latitude_r <- round(pickup_latitude, p)
#                   , dropoff_longitude_r <- round(dropoff_longitude, p)
#                   , dropoff_latitude_r <- round(dropoff_latitude, p)) %>%
#     dplyr::filter(pickup_longitude_r == olo,
#                   pickup_latitude_r == ola,
#                   dropoff_longitude_r == dlo,
#                   dropoff_latitude_r == dla)
#   t
# )