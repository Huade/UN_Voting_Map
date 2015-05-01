# ui.R
# This script builds user interface of data product

library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("United Nations General Assembly Voting Data Viewer (Beta)"),
    
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
                      "Keywords of interest:"
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
                tabPanel("Map" ,plotOutput("map")),
                # Help tab panel
                tabPanel(
                    "Help",
                    h3("Make Locating and visualizing UNGA Voting easier"),
                    p("Locating an UNGA resolution is straightforward."),
                    p("First, specify date range of the resolution. This data viewer currently support resulution from the first UNGA voting to 2014-9-9."),
                    p("Then, you may want to input keywords to search resolution description. You can separate different keywords by comma (upcoming)."),
                    p("You can also select issue area of interest (optional)."),
                    p("Finally, select UNGA resolution title to locate vote."),
                    p("Now, you can view voting record by clicking the 'Voting Data' tab, or view map by clicking the 'Map' tab, or retrive official document by clicking 'Click to view official document at un.org' (if available)"),
                    p("Enjoy!")
                    
                )
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