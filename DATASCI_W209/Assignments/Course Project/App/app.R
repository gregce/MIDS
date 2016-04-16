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


ui <- fluidPage(navbarPage("RoutR", id="nav",
  tabPanel("RoutR",
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
                             
                             textInput(inputId = 'origin', label = 'Enter your Origin', value = "Times Square", placeholder ="e.g. 222 West 23rd"),
                             textInput(inputId = 'destination', label = 'Enter your Destination',  value = "Empire State Building", placeholder ="e.g. 2 Lexington Ave"),
                             selectInput('layer', 'Map Layer', choices = mapLayers, selected = mapLayers[1])
                             
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
          )
)
)


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
  
  
  #Create reactive element that updates and maps plots to be rendered on the map
  route_df <- reactive({decodeLine(route(input$origin, input$destination, structure = "route",
                                         output = "all")$routes[[1]]$overview_polyline$points)})
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      setView(lng = -73.985428, lat = 40.748817, zoom = 12) %>%
      addProviderTiles(input$layer, options = providerTileOptions(noWrap = TRUE)) %>%
      addPolylines(route_df()$lon, route_df()$lat, fill = FALSE) %>%
      addPopups(route_df()$lon[1], route_df()$lat[1], popup = origin.fa()) %>%
      addPopups(route_df()$lon[length(route_df()$lon)], 
                route_df()$lat[length(route_df()$lon)], popup = destination.fa()) %>%
      fitBounds(lng1 = max(route_df()$lon),lat1 = max(route_df()$lat),
                lng2 = min(route_df()$lon),lat2 = min(route_df()$lat))
    
  })
}

#############################
## Run App
#############################

shinyApp(ui = ui, server = server)
