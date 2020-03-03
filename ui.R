
#Last modified: 08/04/2019


#libraries used
library(shiny)
library(leaflet)

ui <- fluidPage(
  
  # Application title
  headerPanel("Coral Bleaching across various sites"),
  
  # Sidebar with a dropdown input 
  sidebarLayout(
    sidebarPanel(
      #input for smoothing type 
      selectInput("variable", "Smoothing type", 
                  c("LM" = "lm", 
                    "Loess" = "loess",
                    "GAM" = "gam",
                    "GLM" = "glm",
                    "AUTO" = "auto")),
      
      #input for coral type selection
      selectInput("coraltype", "Coral type",
                  c(
                    "All" = 'all',
                    "Blue Coral" = "blue corals",
                    "Hard Coral" = "hard corals",
                    "Sea Fan" = "sea fans",
                    "Sea Pen" = "sea pens",
                    "Soft Coral" = "soft corals")),
      
      #width of sidebar panel
      width = 2
      
    ),
    
    mainPanel(
      
      # Show a plot of the generated smoothing 
      plotOutput("distPlot"),
      
      # create map canvas on the page
      leafletOutput("mymap")
      
    ),
    
    #sidepanel position
    position = c("left")
  )
)

