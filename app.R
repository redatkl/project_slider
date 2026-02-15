# Source global file
source("global.R")


# Define UI
ui <- tagList(
  
  # Custom CSS styling
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css"),
    # Add favicon in the head section
    tags$link(rel = "shortcut icon", type = "image/png", href = "favicon/favicon.ico"),
    # JavaScript for navigation button styling
    tags$script(src = "js/hamburger_sidebar.js")
  ),
  fluidPage(
    
    # Custom navigation bar using HTML tags
    tags$div(
      class = "navbar",
      
      # Hamburger button
      tags$button(
        id = "sidebarToggle",
        class = "hamburger-btn",
        tags$span(),
        tags$span(),
        tags$span()
      ),
      
      # add first logo 
      tags$div(
        class= "logo-left",
        tags$a(href = "", target = "_blank", tags$img(src = "logos/logo.png", height = "50px"))
      ),
      
      #center navigation buttons
      tags$div(
        class = "title-navbar",
        tags$h2("MapCompare")
      )
    ),
    
    # Sidebar
    tags$div(
      id = "sidebar",
      class = "sidebar",
      tags$h3("Map Configuration"),
      tags$hr(),
      
      tags$div(
        tags$h4("Map 1 (Left)"),
        fileInput("tif1", "Choose TIF file", accept = c(".tif", ".tiff"))
      ),
      
      tags$div(
        tags$h4("Map 2 (Right)"),
        fileInput("tif2", "Choose TIF file", accept = c(".tif", ".tiff"))
      )
    ),
    
    
  # Page content container
  #mainUi("main"),
  mapUi("map")

  ),
  
  # Footer
  tags$footer(
    class = "footer",
    tags$div(
      class = "footer-content",
      tags$h2("footer text")
    )
  )
  
  
)


# Define server
server <- function(input, output, session) {
  
  # Call module servers
  #mainServer("main")
  mapServer("map", 
            tif1_path = reactive(input$tif1),
            tif2_path = reactive(input$tif2))

}

# Run the application
shinyApp(ui = ui, server = server)