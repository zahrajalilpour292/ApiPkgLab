#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
setwd('../..')
#print(getwd())
source("R/fetch_data.R",encoding = getOption("encoding"))
data <- fetch_api_data()


library(shiny)
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
           textOutput("selected_var"),
           plotOutput("barplot1")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    colums <- colnames(data)
    
    output$barplot1 <- renderPlot(
        barplot(table(data[4]))
    )
    
    output$selected_var <- renderText({
       paste( "You have selected ", input$var)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
