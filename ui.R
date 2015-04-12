
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
            
            selectizeInput("sum_opt",
                           "Choose summary option",
                           choices = c("None" = 1,
                                       "Yes percentage" = 2,
                                       "No Percentage" = 3,
                                       "Abstain Percentage" = 4),
                           selected = 1
            ),
            
            htmlOutput("TitleSelectUI"
            ),
            
            selectInput("output_opt",
                        "Choose output formate",
                        choices = c("Table" = 1,
                                    "Map" = 2)
            ),
            
            downloadButton('downloadData', 'Download Data')
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabPanel("Table",dataTableOutput("sessionTable"))
        )
    )
))
