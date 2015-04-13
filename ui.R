
library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("United Nations General Assembly Voting Data"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            dateRangeInput("DateRange",
                           "Resolution date range:",
                           min = min(session$date),
                           max = max(session$date),
                           start = min(session$date),
                           end = max(session$date),
                           startview = "year"
            ),
            
            textInput("keywords",
                      "Keywords separated by commas:"
            ),
            
            htmlOutput("TitleSelectUI"
            ),
            
            downloadButton('downloadSession', 'Session Data'),
            
            downloadButton('downloadVoting', 'Voting Data')
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Session Data",dataTableOutput("sessionTable")),
                # TODO: voting data
                tabPanel("Voting Data",dataTableOutput("votingTable"))
                # TODO: map
                # tabPanel("Map" ,dataTableOutput("sessionTable"))
            )
            
        )
    )
))
