# ui.R

library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("United Nations General Assembly Voting Data (Beta)"),
    
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
            selectizeInput("IssueArea",
                           label = "Select Issue Area of interest",
                           choices = c("All" = "all",
                                       "Middle East" = "me",
                                       "Nuclear" = "nu",
                                       "Disarmament" = "di",
                                       "Human Rights" = "hr",
                                       "Colonialism" = "co",
                                       "Economics" = "ec",
                                       "Vote on which US has lobbied" = "us")),
            
            htmlOutput("TitleSelectUI"
            ),
            
            downloadButton('downloadSession', 'Session Data'),
            br(),
            downloadButton('downloadVoting', 'Voting Data'),
            br(),
            br(),
            br(),
            htmlOutput("OfficialDoc"),
            img(src = "logo.gif",height = 50, width = 235),
            width = 3),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Session Data",dataTableOutput("sessionTable")),
                tabPanel("Voting Data",
                         dataTableOutput("votingTable")),
                tabPanel("Map" ,plotOutput("map"))
            ),
            
            p("Full data available at Voeten, Erik; Strezhnev, Anton; Bailey, Michael, 2013,",
              a("United Nations General Assembly Voting Data.", href = "http://hdl.handle.net/1902.1/12379")), 
              
            p("Visualized by Huade Huo. Code available on", 
              a("GitHub.",href = "https://github.com/Huade/UN_Voting_Map")
            ),
            
            p("Map reflects current (2015) borders. Map data provided by",
              a("Natural Earth Project", href = "http://www.naturalearthdata.com/"))
            
        )
    )
))