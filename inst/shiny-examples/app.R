#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#setwd('../..')
#print(getwd())
#source("R/crime_data.R",encoding = getOption("encoding"))
#source("R/crime_data.R",encoding = getOption("encoding"))
# loading libaries
require(devtools)
install_github("zahrajalilpour292/ApiPkgLab",force = TRUE)
require(shiny)
require(leaflet.minicharts)
require(leaflet)
require(stringr)

df_crime <- ApiPkgLab5::get_crime_dataframe(200)

ui <- fluidPage(
    titlePanel("Crime Analytics", "Interactive Shiny Application"),
    sidebarLayout(
        sidebarPanel(
            textInput(inputId = "caption",
                      label = "Title:",
                      value = "Crimes Mayland City Map"),
            selectInput("selectcity",
                        h4("City"),
                        choices = list()
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
        
        observeEvent(input$selectcity, {
            input_name <- as.character(input$selectcity)
            #browser()
            lat <- ApiPkgLab5::get_city_crimes_loc(as.character(input_name),df_comp_crime)[,1]
            long <- ApiPkgLab5::get_city_crimes_loc(as.character(input_name),df_comp_crime)[,2]
            
            leafletProxy("map") %>%
                addCircleMarkers(lng = long,
                                 lat = lat,
                                 
                )
            
        })
        
        # get_lat <- eventReactive({
        #     get_city_crimes_loc(as.character(input$selectcity),df_comp_crime)[,1]
        # })
        # get_long <- eventReactive({
        #     get_city_crimes_loc(as.character(input$selectcity),df_comp_crime)[,2]
        # })
        
        
        leaflet() %>%
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            addMarkers(lat =39.0458 ,lng = -76.6413)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
