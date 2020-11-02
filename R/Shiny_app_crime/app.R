#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(jsonlite)
library(shiny)
source("R/api.R")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Uniform Crime Reporting"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("var",
                        "select crime type:",
                        list("crime_type1","crime_type2", "crime_type3"))
                        
        ,),

        # Show a plot of the generated distribution
        mainPanel(
           textOutput("selected_var")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$selected_var <- renderText({
       paste( "You have selected ", input$var)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
