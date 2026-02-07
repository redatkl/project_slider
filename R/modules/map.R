# map  module
# map UI
mapUi <- function(id) {
  ns <- NS(id)

  tagList(
  # Custom CSS styling
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/slider.css"),
    # JavaScript for slider
    tags$script(src = "js/slider.js")
  ),
  
  fluidPage(
  div(
    style = "position: relative; height: 600px;",
    # Map 1 (left side)
    div(
      style = "position: absolute; top: 0; left: 0; right: 0; bottom: 0; clip-path: inset(0 50% 0 0);",
      id = "map1_container",
      leafletOutput("map1", height = "100%", width = "100%")
    ),
    # Map 2 (right side)
    div(
      style = "position: absolute; top: 0; left: 0; right: 0; bottom: 0; clip-path: inset(0 0 0 50%);",
      id = "map2_container",
      leafletOutput("map2", height = "100%", width = "100%")
    ),
    # Divider line
    div(
      style = "position: absolute; top: 0; bottom: 0; left: 50%; width: 4px; background: white; box-shadow: 0 0 10px rgba(0,0,0,0.5); cursor: ew-resize; z-index: 1000;",
      id = "divider"
    )
  )
  )
  )
}



# map server
mapServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    output$map1 <- renderLeaflet({
      leaflet() %>%
        setView(lng = -122.4194, lat = 37.7749, zoom = 12) %>%
        addTiles() %>%
        addMarkers(lng = -122.4194, lat = 37.7749, popup = "Map 1: OpenStreetMap") %>%
        htmlwidgets::onRender("
        function(el, x) {
          var map1 = this;
          window.map1 = map1;
          window.isSyncing = false;
          
          var waitForMap2 = setInterval(function() {
            if (window.map2) {
              clearInterval(waitForMap2);
              
              // Sync map2 when map1 moves
              map1.on('movestart', function() {
                if (!window.isSyncing) {
                  window.syncSource = 'map1';
                }
              });
              
              map1.on('move', function() {
                if (window.syncSource === 'map1' && !window.isSyncing) {
                  window.isSyncing = true;
                  var center = map1.getCenter();
                  var zoom = map1.getZoom();
                  window.map2.setView(center, zoom, {animate: false});
                  setTimeout(function() { window.isSyncing = false; }, 10);
                }
              });
              
              map1.on('zoomend', function() {
                if (window.syncSource === 'map1' && !window.isSyncing) {
                  window.isSyncing = true;
                  var center = map1.getCenter();
                  var zoom = map1.getZoom();
                  window.map2.setView(center, zoom, {animate: false});
                  setTimeout(function() { window.isSyncing = false; }, 10);
                }
              });
            }
          }, 100);
        }
      ")
    })
    
    output$map2 <- renderLeaflet({
      leaflet() %>%
        setView(lng = -122.4194, lat = 37.7749, zoom = 12) %>%
        addProviderTiles(providers$Esri.WorldImagery) %>%
        addMarkers(lng = -122.4194, lat = 37.7749, popup = "Map 2: Satellite Imagery") %>%
        htmlwidgets::onRender("
        function(el, x) {
          var map2 = this;
          window.map2 = map2;
          
          var waitForMap1 = setInterval(function() {
            if (window.map1) {
              clearInterval(waitForMap1);
              
              // Sync map1 when map2 moves
              map2.on('movestart', function() {
                if (!window.isSyncing) {
                  window.syncSource = 'map2';
                }
              });
              
              map2.on('move', function() {
                if (window.syncSource === 'map2' && !window.isSyncing) {
                  window.isSyncing = true;
                  var center = map2.getCenter();
                  var zoom = map2.getZoom();
                  window.map1.setView(center, zoom, {animate: false});
                  setTimeout(function() { window.isSyncing = false; }, 10);
                }
              });
              
              map2.on('zoomend', function() {
                if (window.syncSource === 'map2' && !window.isSyncing) {
                  window.isSyncing = true;
                  var center = map2.getCenter();
                  var zoom = map2.getZoom();
                  window.map1.setView(center, zoom, {animate: false});
                  setTimeout(function() { window.isSyncing = false; }, 10);
                }
              });
            }
          }, 100);
        }
      ")
    })
    
  })
}