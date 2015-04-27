# ui.R
# This script builds user interface of data product

library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("United Nations General Assembly Voting Data (Beta)"),
    
    # Sidebar Layout includes sidebar Panel and Main Panel
    sidebarLayout(
        sidebarPanel(
            # Data range selector
            dateRangeInput("DateRange",
                           "Resolution date range:",
                           min = min(session$date),
                           max = max(session$date),
                           start = "2013-01-01 UTC",
                           end = max(session$date),
                           startview = "decade"
            ),
            
            # Key word input
            textInput("keywords",
                      "Keywords separated by commas:"
            ),
            
            # Issue area selector
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
            
            # Vote title selector
            htmlOutput("TitleSelectUI"
            ),
            
            # Download button (session data)
            downloadButton('downloadSession', 'Session Data'),
            br(),
            # Download button (voting data)
            downloadButton('downloadVoting', 'Voting Data'),
            br(),
            br(),
            br(),
            # Official document link
            htmlOutput("OfficialDoc"),
            # Georgetown Logo. inside "www" folder
            img(src = "logo.gif",height = 50, width = 235),
            width = 3),
        
        # Main panel
        mainPanel(
            # Tab panel
            tabsetPanel(
                # Session data table tab panel
                tabPanel("Session Data",dataTableOutput("sessionTable")),
                # Voting data table tab panel
                tabPanel("Voting Data",
                         dataTableOutput("votingTable")),
                # Map tab panel
                tabPanel("Map" ,plotOutput("map"))
            ),
            
            # Footnotes
            p("Full data available at Voeten, Erik; Strezhnev, Anton; Bailey, Michael, 2013,",
              a("United Nations General Assembly Voting Data.", href = "https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/12379")), 
              
            p("Visualized by Huade Huo. Code available on", 
              a("GitHub",href = "https://github.com/Huade/UN_Voting_Map"), "under the MIT License."
            ),
            
            p("Map reflects current (2015) borders. Map data provided by the",
              a("Natural Earth", href = "http://www.naturalearthdata.com/"))
            
        )
    )
))