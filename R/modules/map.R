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
      id = "map_container",
      class = "map-container",
      
      # Bottom map (full width)
      tags$div(
        class = "map-wrapper",
        leafletOutput("map1", height = "600px")
        ),
      
      # Top map (clipped, full width)
      tags$div(
        class = "map-wrapper", 
        id = "map2-wrapper", 
        leafletOutput("map2", height = "600px")
        ),
      
      tags$div(class = "slider-divider",
               id = "slider-divider",
               tags$div(class = "slider-handle")
      )
    )
  )
}

# map module server
mapServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Reactive value to store the slider position
    slider_position <- reactiveVal(50)
    
    # Render the first map (OpenStreetMap)
    output$map1 <- renderLeaflet({
      leaflet() %>%
        addTiles(group = "OSM") %>%
        setView(lng = -74.0060, lat = 40.7128, zoom = 12) %>%
        addMarkers(lng = -74.0060, lat = 40.7128, popup = "New York - Street Map")
    })
    
    # Render the second map (Satellite imagery)
    output$map2 <- renderLeaflet({
      leaflet() %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
        setView(lng = -74.0060, lat = 40.7128, zoom = 12) %>%
        addMarkers(lng = -74.0060, lat = 40.7128, popup = "New York - Satellite View")
    })
    
    # Sync map movements from map1 to map2
    observeEvent(input$map1_zoom, {
      if (!is.null(input$map1_zoom) && !is.null(input$map1_center)) {
        leafletProxy("map2") %>%
          setView(
            lng = input$map1_center$lng,
            lat = input$map1_center$lat,
            zoom = input$map1_zoom
          )
      }
    })
    
    # Sync map movements from map2 to map1
    observeEvent(input$map2_zoom, {
      if (!is.null(input$map2_zoom) && !is.null(input$map2_center)) {
        leafletProxy("map1") %>%
          setView(
            lng = input$map2_center$lng,
            lat = input$map2_center$lat,
            zoom = input$map2_zoom
          )
      }
    })
    
    # Handle slider position updates from JavaScript
    observeEvent(input$slider_pos, {
      slider_position(input$slider_pos)
    })
    
    # Initialize the slider functionality
    observe({
      session$sendCustomMessage(
        type = "initSlider",
        message = list()
      )
    })
  }
  )}
  