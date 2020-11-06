#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
setwd('../..')
#print(getwd())
source("R/fetch_data.R",encoding = getOption("encoding"))
df_crime <- fetch_api_data()

# loading libaries
library(shiny)
library(leaflet.minicharts)
library(leaflet)
library(stringr)

#r_colors <- rgb(t(col2rgb(colors()) / 255))
#names(r_colors) <- colors()

# Ui for shiny application
# ui <- navbarPage("Crime Analytics",
#                  tabPanel("Map"),
#                  tabPanel("Plots"),
#                  header = "Crime Data visulizatuin of Maryland Data",
#                  footer = "Made by Arslan and Zahra."
#                  #tabPanel("Component 3")
# )
ui <- fluidPage(
    titlePanel("Crime Analytics", "Interactive Shiny Application"),
    sidebarLayout(
        sidebarPanel(
            selectInput("selectcity",
                        h4("City"),
                        choices = list(),
                        )
        ),
        mainPanel(
            leafletOutput("map")
        )
    )
)
# Define server logic required to draw a histogram
server <- function(input, output, session) {
    #colums <- colnames(data)
    # discard the observations with NA values 
    df_comp_crime <- df_crime[complete.cases(df_crime), ]
    #order_df <- df_comp_crime[order(City),]
    cities <- unique(as.vector(df_comp_crime["City"]))
    cities <- as.list(cities)
    cities <- append("All Cities",cities[1]) 
    #populate the list of cities
    updateSelectInput(session,
                      "selectcity",
                      label = paste("Select City"),
                      choices = cities)
    # add pins to map
    output$map <- renderLeaflet({
        
        points <- eventReactive(input$recalc, {
            cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
        }, ignoreNULL = FALSE)
        
        leaflet() %>%
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            addMarkers(data = points())
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
