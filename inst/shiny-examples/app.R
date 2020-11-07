#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#setwd('../..')
#print(getwd())
#source("R/fetch_data.R",encoding = getOption("encoding"))
# loading libaries
library(ApiPkgLab5)
library(shiny)
library(leaflet.minicharts)
library(leaflet)
library(stringr)

df_crime <- get_crime_dataframe(200)

ui <- fluidPage(
    titlePanel("Crime Analytics", "Interactive Shiny Application"),
    sidebarLayout(
        sidebarPanel(
            textInput(inputId = "caption",
                      label = "Title:",
                      value = "Crimes Mayland City Map"),
            selectInput("selectcity",
                        h4("City"),
                        choices = list(),
                        )
        ),
        mainPanel(
            h3(textOutput("caption", container = span)),
            leafletOutput("map")
        )
    )
)
# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    output$caption <- renderText({
        input$caption
    })
    
    #colums <- colnames(data)
    # discard the observations with NA values 
    df_comp_crime <- df_crime[complete.cases(df_crime), ]
    #order_df <- df_comp_crime[order(City),]
    cities <- unique(as.vector(df_comp_crime["City"]))
    #cities <- as.list(cities)
    cities <- append("All Cities",cities) 
    
    loca_cities <- df_comp_crime[c("City","latitude","longitude")]
    #populate the list of cities
    updateSelectInput(session,
                      "selectcity",
                      label = paste("Select City"),
                      choices = cities)
    # add pins to map
    output$map <- renderLeaflet({
        
        
        datasetInput <- eventReactive({
            get_city_crimes_loc(as.character(input$selectcity))
        })
        
        leaflet() %>%
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            addMarkers(data = datasetInput())
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
