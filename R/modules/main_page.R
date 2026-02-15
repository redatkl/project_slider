# main page module

# main page UI
mainUi <- function(id) {
  ns <- NS(id)
  
    fluidPage(
      
      # content
      tags$div(
        class = "main-content",
        tags$h1("Welcome to the Map Slider Application"),
        tags$p("This application allows you to explore various geographical data through an interactive map slider interface. Use the navigation bar above to access different features and datasets.")
      )
      
    )
}


# main page server
mainServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    

    
  })
}