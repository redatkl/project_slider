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
      id = "map-container",
      class = "map-container",
      
      # Bottom map (full width)
      tags$div(
        class = "map-wrapper",
        leafletOutput(ns("map1"), height = "100%")
        ),
      
      # Top map (clipped, full width)
      tags$div(
        class = "map-wrapper", 
        id = "map2-wrapper", 
        leafletOutput(ns("map2"), height = "100%")
        ),
      
      tags$div(class = "slider-divider",
               id = "slider-divider",
               tags$div(class = "slider-handle")
      )
    )
  )
}

# map module server
mapServer <- function(id, tif1_path, tif2_path) {
  moduleServer(id, function(input, output, session) {
    
    # Reactive value to store the slider position
    slider_position <- reactiveVal(50)
    
    # Render map 1
    output$map1 <- renderLeaflet({
      leaflet(options = leafletOptions(attributionControl = FALSE)) %>%
        addTiles(group = "OSM")%>%
        setView(lng = 0, lat = 0, zoom = 2)
    })
    
    # Render map 2
    output$map2 <- renderLeaflet({
      leaflet(options = leafletOptions(attributionControl = FALSE)) %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
        setView(lng = 0, lat = 0, zoom = 2)
    })
    
    # Update map1 with TIF
    observeEvent(tif1_path(), {
      req(tif1_path())
      
      tryCatch({
        r <- raster(tif1_path()$datapath)
        pal <- colorNumeric("RdYlBu", values(r), na.color = "transparent")
        
        leafletProxy("map1") %>%
          clearImages() %>%
          addRasterImage(r, colors = pal, opacity = 0.8) %>%
          fitBounds(
            lng1 = extent(r)@xmin, lat1 = extent(r)@ymin,
            lng2 = extent(r)@xmax, lat2 = extent(r)@ymax
          )
      }, error = function(e) {
        showNotification(paste("Error loading TIF 1:", e$message), type = "error")
      })
    })
    
    # Update map2 with TIF
    observeEvent(tif2_path(), {
      req(tif2_path())
      
      tryCatch({
        r <- raster(tif2_path()$datapath)
        pal <- colorNumeric("RdYlBu", values(r), na.color = "transparent")
        
        leafletProxy("map2") %>%
          clearImages() %>%
          addRasterImage(r, colors = pal, opacity = 0.8) %>%
          fitBounds(
            lng1 = extent(r)@xmin, lat1 = extent(r)@ymin,
            lng2 = extent(r)@xmax, lat2 = extent(r)@ymax
          )
      }, error = function(e) {
        showNotification(paste("Error loading TIF 2:", e$message), type = "error")
      })
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
  