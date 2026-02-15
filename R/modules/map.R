# map module "R/modules/map.R"

# map module UI
mapUi <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/map_slider.css"),
      tags$script(src = "js/map_slider.js")
    ),
    tags$div(
      id = ns("map_container"),
      class = "map-slider-container",
      `data-ns` = id,  # Pass namespace to JS
      
      tags$div(
        class = "map-left-container",
        leafletOutput(ns("map_left"), width = "100%", height = "100%")
      ),
      
      tags$div(
        class = "map-right-container",
        leafletOutput(ns("map_right"), width = "100%", height = "100%")
      ),
      
      tags$div(class = "map-slider-divider")
    )
  )
}


# map module server
mapServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$map_left <- renderLeaflet({
      leaflet() %>%
        setView(lng = -122.4194, lat = 37.7749, zoom = 12) %>%
        addTiles() %>%
        addMarkers(lng = -122.4194, lat = 37.7749, popup = "OpenStreetMap") %>%
        htmlwidgets::onRender("
          function(el, x) {
            var map = this;
            setTimeout(function() { map.invalidateSize(); }, 100);
            window.mapLeft = map;
          }
        ")
    })
    
    output$map_right <- renderLeaflet({
      leaflet() %>%
        setView(lng = -122.4194, lat = 37.7749, zoom = 12) %>%
        addProviderTiles(providers$Esri.WorldImagery) %>%
        addMarkers(lng = -122.4194, lat = 37.7749, popup = "Satellite") %>%
        htmlwidgets::onRender("
          function(el, x) {
            var map = this;
            setTimeout(function() { map.invalidateSize(); }, 100);
            window.mapRight = map;
          }
        ")
    })
  })
}