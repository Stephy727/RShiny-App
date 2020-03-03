
#Assignment 2 - R visualization 
#Name: Stephy James
#Student ID: 29915651
#Last modified: 08/04/2019


#libraries used
library(ggplot2) 
library(scales)
library(shiny)
library(leaflet)


# Define server logic required to draw a the graphram
server <- function(input, output) {
  
  
  data <- read.csv("assignment-02-data-formated.csv", header=T)
  
  #the bleach value columnn is converted from fartor format to numeric format
  data$value1 <-as.numeric(sub("%","",data$value))
  
  #the facet are made on site names which are later relabelled using the below conditions
  loc_names = as_labeller(c(
    "-11.843"="site01",
    "-13.107"="site05",
    "-14.383"="site07",
    "-16.091"="site08",
    "-17.981"="site06",
    "-18.937"="site02",
    "-20.414"="site04",
    "-10.321"="site03"
  ))
  
  
  #Various smoothers fitting option has been provided in Shiny app  
  #Factes have been ordered by latitude using latitude~coralType
  #Ref: https://ggplot2.tidyverse.org/reference/geom_smooth.html
  output$distPlot <- renderPlot({
    
    #condition for all coral types selected 
    if ('all' %in% input$coraltype ) {
      
      
      ggplot(data, aes(x =year, y = value1, color = coralType)) + 
        facet_grid (latitude~coralType , labeller = labeller(latitude = loc_names)) + 
        geom_point(shape = 1, stat="identity") + scale_x_continuous(name="Year") + 
        scale_y_continuous(name="Bleach %", breaks = seq(0,100,50)) + 
        geom_smooth(method = input$variable )+ theme_bw() + theme(legend.position = "top", legend.direction = "horizontal") 
      
    }
    
    #default condition when no selection is made
    else if (is.null(input$coraltype ))
      
    {
      
      ggplot(data, aes(x =year, y = value1, color = coralType)) + 
        facet_grid (latitude~coralType , labeller = labeller(latitude = loc_names)) + 
        geom_point(shape = 1, stat="identity") + scale_x_continuous(name="Year") + 
        scale_y_continuous(name="Bleach %", breaks = seq(0,100,50)) + 
        geom_smooth(method = "lm" )+ theme_bw() + 
        theme(legend.position = "top", legend.direction = "horizontal")
      
    }
    
    #in case of a selection, data is subsetted for plot
    else 
    {
      
      data = subset(data, coralType %in% c(input$coraltype))
      
      ggplot(data, aes(x =year, y = value1, color = coralType)) + 
        facet_grid (latitude~coralType , labeller = labeller(latitude = loc_names)) + 
        geom_point(shape = 1, stat="identity") + scale_x_continuous(name="Year") + 
        scale_y_continuous(name="Bleach %", breaks = seq(0,100,50)) + 
        geom_smooth(method = input$variable )+ theme_bw() + theme(legend.position = "top", legend.direction = "horizontal") 
    }
    
  })
  
  # create leaflet map
  output$mymap <- renderLeaflet ({ # create leaflet map
    
    #map when all coral type option is chosen
    if ('all' %in% input$coraltype ) 
    {
      leaflet(data = data) %>% addTiles() %>%
        addMarkers(~longitude, ~latitude, popup = ~as.character(location),
                   label = ~as.character(location),
                   labelOptions = labelOptions(noHide = T) )
    }
    
    #default case when no coraltype is chosen, shows all
    else if (is.null(input$coraltype )) 
    { 
      leaflet(data = data) %>% addTiles() %>%
        addMarkers(~longitude, ~latitude, 
                   label = ~as.character(location),
                   labelOptions = labelOptions(noHide = T)) 
    }
    
    
    #case when coral type is chosen    
    #data is subsetted
    else
    {
      data = subset(data, coralType %in% c(input$coraltype))
      
      leaflet(data = data) %>% addTiles() %>%
        addMarkers(~longitude, ~latitude, 
                   label = ~as.character(location),
                   labelOptions = labelOptions(noHide = T)) 
      
    }
    
  })
  
  
}


