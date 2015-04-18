
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
                           start = "2013-01-01 UTC",
                           end = max(session$date),
                           startview = "decade"
            ),
            
            textInput("keywords",
                      "Keywords separated by commas:"
            ),
            
            htmlOutput("TitleSelectUI"
            ),
            
            downloadButton('downloadSession', 'Session Data'),
            
            downloadButton('downloadVoting', 'Voting Data'),
            br(),
            br(),
            br(),
            br(),
            br(),
            img(src = "http://visualidentity.georgetown.edu/sites/visualidentity/files/files/upload/logo-banner.jpg")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Session Data",dataTableOutput("sessionTable")),
                tabPanel("Voting Data",
                         dataTableOutput("votingTable")),
                tabPanel("Map" ,plotOutput("map")),
                p("Bailey, Michael, Anton  Strezhnev and Erik Voeten. Forthcoming.'Estimating Dynamic State Preferences from United Nations Voting Data.' Journal of Conflict Resolution. Visualized by Huade Huo. Code available on", 
                  a("GitHub.",href = "https://github.com/Huade/UN_Voting_Map"))
            )
            
        )
    )
))
