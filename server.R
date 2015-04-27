# server.R
# This script runs in the server (background).

# Load packages
library(shiny)
library(ggplot2)
library(ggthemes)

# Main server function
shinyServer(function(input, output) {
    
    # Session selector 
    Select_session <- reactive({
        df <- session
        
        # Search function
        # TODO: change from "or" to "and"
        if (length(input$keywords!=0)){
            kwd_pattern <- gsub(",", "|", input$keywords)
            df <- subset(df, grepl(kwd_pattern, df$descr, ignore.case = T))
        }
        
        # Date selector
        if (!is.null(input$DateRange)){
            df <- subset(df, 
                         as.Date(df$date)>=input$DateRange[1] & as.Date(df$date)<=input$DateRange[2])
        }
        
        # Area of interest selector
        if ("me" %in% input$IssueArea){
            df <- subset(df, df$me==1)
        }
        
        if ("nu" %in% input$IssueArea){
            df <- subset(df, df$nu==1)
        }
        
        if ("di" %in% input$IssueArea){
            df <- subset(df, df$di==1)
        }
        
        if ("hr" %in% input$IssueArea){
            df <- subset(df, df$hr==1)
        }
        
        if ("hr" %in% input$IssueArea){
            df <- subset(df, df$hr==1)
        }
        
        if ("ec" %in% input$IssueArea){
            df <- subset(df, df$ec==1)
        }
        
        if ("us" %in% input$IssueArea){
            df <- subset(df, df$importantvote==1)
        }
        
        return(df)
    })
    
    # Session table output 
    output$sessionTable <- renderDataTable({
        df <- Select_session()
        if (length(input$keywords!=0)){
            kwd_pattern <- gsub(",", "|", input$keywords)
            df <- subset(df, grepl(kwd_pattern, df$descr, ignore.case = T))
        }
        
        # Vote title selector
        if (!is.null(input$voteTitle)){
            df <- subset(df, df$unres_title==input$voteTitle)
        }
        
        # Date selector
        df <- subset(df, 
                     as.Date(df$date)>=input$DateRange[1] & as.Date(df$date)<=input$DateRange[2])
        
        # Select only following variables in data table and downloaded csv file
        vars <- c("date","session","unres_title", "descr", "yes", "no", "abstain")
        df <- df[,vars]
        return(df)}, 
        # Turn off searching function
        # List length, 3 options: 5/25/all
        # Page Length, default = 5
        options = list(searching = FALSE,
                       lengthMenu = list(c(5, 25, -1), c('5', '25', 'All')),
                       pageLength = 5)
    )
    
    # Voting selector
    Select_voting <- reactive({
        df <- vote
        
        # Link session data and vote data by rcid
        if (length(Select_session()$rcid)!=0){
            df <- subset(df, df$rcid %in% unique(Select_session()$rcid))
        }
        
        # Vote title selector
        if (!is.null(input$voteTitle)){
            df <- subset(df, df$unres_title==input$voteTitle)
        }
        
        return(df)
    })
    
    # Voting table output
    output$votingTable <- renderDataTable({
        df <- vote
        # Select voting data based on rcid
        df <- subset(df, df$rcid %in% unique(Select_voting()$rcid))
        vars <- c("unres", "Country", "CABB", "Vote")
        df <- df[,vars]
    }, 
    options = list(pageLength = 10)
    )
    
    # Session data downloader
    output$downloadSession <- downloadHandler(
        filename = "UN_Session.csv",
        content = function(file) {
            vars <- c("session","unres_title", "date", "yes", "no", "abstain")
            df <- Select_session()[,vars]
            write.csv(df, file)
        }
    )
    
    # Voting data downloader
    output$downloadVoting <- downloadHandler(
        filename = "UN_Voting.csv",
        content = function(file) {
            vars <- c("unres", "Country", "CABB", "Vote")
            df <- Select_voting()[,vars]
            write.csv(df, file)
        }
    )
    
    # Map visualization
    output$map <- renderPlot({
        if (length(unique(Select_voting()$rcid))==1){
            # Load map color
            color_for_map <- subset(colormatrix, 
                                    colormatrix$breaksvalue %in% unique(Select_voting()$vote))
            
            # Main function to visualize map
            ggplot()+
                # Base map, fill=white, line=gray
                geom_map(data=World.points, map = World.points, aes(map_id=region), 
                         fill="#ecf0f1", color="white")+ 
                # Vote map, fill based on vote, line = white
                geom_map(data=Select_voting(),map = World.points, 
                         aes(map_id=region, fill = as.character(vote)), 
                         color="white")+
                # Expand axis
                expand_limits(x = world_map$long, y = world_map$lat)+
                # Change fill color based on color matrix file
                scale_fill_manual(
                    values=color_for_map$colors, 
                    name="Vote",
                    breaks=color_for_map$breaksvalue,
                    labels=color_for_map$breakslabel)+
                # Stephen Few plot theme, require(ggthemes)
                theme_few()+
                # No axis line, axis text, axis title
                theme(axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank(),
                      axis.title.x=element_blank(),
                      axis.title.y=element_blank(),
                      #legend.position="none",
                      panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                      panel.grid.minor=element_blank(),plot.background=element_blank())
        }
        
        # Map without vote title selection
        else if (length(input$voteTitle)==0){
            ggplot()+
                geom_map(data=World.points, map = World.points, aes(map_id=region), fill="#ecf0f1", color="white")+
                expand_limits(x = world_map$long, y = world_map$lat)+
                theme_few()+
                geom_text(aes(x = mean(world_map$long), y = mean(world_map$lat)), label="Select the vote title to view map",
                          size = 10, colour = "#3498db")+
                theme(axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank(),
                      axis.title.x=element_blank(),
                      axis.title.y=element_blank(),legend.position="none",
                      panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                      panel.grid.minor=element_blank(),plot.background=element_blank())
        }
        
        # Map without voting data
        else{
            
            ggplot()+
                geom_map(data=World.points, map = World.points, aes(map_id=region), fill="#ecf0f1", color="white")+
                expand_limits(x = world_map$long, y = world_map$lat)+
                theme_few()+
                geom_text(aes(x = mean(world_map$long), y = mean(world_map$lat)), label="VOTING DATA UNAVAILABLE",
                          size = 10, colour = "#3498db")+
                theme(axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank(),
                      axis.title.x=element_blank(),
                      axis.title.y=element_blank(),legend.position="none",
                      panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                      panel.grid.minor=element_blank(),plot.background=element_blank())
        }
        
    }, height = 400, width = 800)
    
    # Title selection
    output$TitleSelectUI <- renderUI({ 
        selectizeInput("voteTitle", "Select the vote title", 
                       choices = Select_session()$unres_title,
                       multiple = T,
                       options = list(maxItems = 1))
    })
    
    # Official document link
    official_doc_link <- reactive({
        df <- Select_session()
        if (!is.null(input$voteTitle)){
                df <- subset(df, df$unres_title==input$voteTitle)
                if (df$session>30){
                # UN official document URL
                url_string <- paste("http://www.un.org/en/ga/search/view_doc.asp?symbol=%20A/RES/",
                                    gsub("\\D", "",strsplit(df$unres[1], split = "/")[[1]][2]),
                                    "/",
                                    gsub("\\D", "",strsplit(df$unres[1], split = "/")[[1]][3]),
                                    sep = "")
            }
            else {url_string = NULL}
        }
        else {
            url_string = NULL
        }
        return(url_string)
    })
    
    # Official document hyperlink
    output$OfficialDoc <- renderUI({
        h5(a("Click to view official document at un.org",href = official_doc_link(), target="_blank"))
    })
    
    
    
})
