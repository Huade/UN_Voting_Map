# server.R

library(shiny)
library(ggplot2)
library(ggthemes)

shinyServer(function(input, output) {
   
    # Session selector 
    Select_session <- reactive({
        df <- session
        
        if (length(input$keywords!=0)){
            kwd_pattern <- gsub(",", "|", input$keywords)
            df <- subset(df, grepl(kwd_pattern, df$descr, ignore.case = T))
        }
        
        if (!is.null(input$DateRange)){
            df <- subset(df, 
                         as.Date(df$date)>=input$DateRange[1] & as.Date(df$date)<=input$DateRange[2])
        }
        
        return(df)
    })
    
    # Session table output 
    output$sessionTable <- renderDataTable({
        df <- session
        if (length(input$keywords!=0)){
            kwd_pattern <- gsub(",", "|", input$keywords)
            df <- subset(df, grepl(kwd_pattern, df$descr, ignore.case = T))
        }
        
        if (!is.null(input$voteTitle)){
            df <- subset(df, df$unres_title==input$voteTitle)
        }
        
        df <- subset(df, 
                     as.Date(df$date)>=input$DateRange[1] & as.Date(df$date)<=input$DateRange[2])
        vars <- c("session","unres_title", "date", "yes", "no", "abstain")
        df <- df[,vars]
        return(df)}, 
        options = list(searching = FALSE,
                       pageLength = 10)
    )
    
    # Voting selector
    Select_voting <- reactive({
        df <- vote
        
        if (length(Select_session()$rcid)!=0){
            df <- subset(df, df$rcid %in% unique(Select_session()$rcid))
        }
        
        if (!is.null(input$voteTitle)){
            df <- subset(df, df$unres_title==input$voteTitle)
        }
        
        return(df)
    })
    
    # Voting table output
    output$votingTable <- renderDataTable({
        df <- vote
        df <- subset(df, df$rcid %in% unique(Select_voting()$rcid))
        vars <- c("Country", "CABB", "Vote")
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
            vars <- c("Country", "CABB", "Vote")
            df <- Select_voting()[,vars]
            write.csv(df, file)
        }
    )
    
    # Map visualization
    output$map <- renderPlot({
        if (length(unique(Select_voting()$rcid))==1){
            
            ggplot()+
                geom_map(data=World.points, map = World.points, aes(map_id=region), fill="#ecf0f1", color="white")+ 
                geom_map(data=Select_voting(),map = World.points, aes(map_id=region, fill = as.character(vote)), color="white")+
                expand_limits(x = world_map$long, y = world_map$lat)+
                scale_fill_manual(values=c("#2ecc71", "#f39c12", "#e74c3c","#bdc3c7","#bdc3c7"), 
                                  name="Vote",
                                  breaks=c("1", "2", "3", "8","9"),
                                  labels=c("Yes", "Abstain", "No", "Absent","Not an UN member"))+
                theme_few()+
                theme(axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank(),
                      axis.title.x=element_blank(),
                      axis.title.y=element_blank(),
                      #legend.position="none",
                      panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                      panel.grid.minor=element_blank(),plot.background=element_blank())
        }
        
        else if (length(input$voteTitle)==0){
            ggplot()+
                geom_map(data=World.points, map = World.points, aes(map_id=region), fill="#ecf0f1", color="white")+
                expand_limits(x = world_map$long, y = world_map$lat)+
                theme_few()+
                geom_text(aes(x = mean(world_map$long), y = mean(world_map$lat)), label="Select vote title to view map",
                          size = 10, colour = "#3498db")+
                theme(axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank(),
                      axis.title.x=element_blank(),
                      axis.title.y=element_blank(),legend.position="none",
                      panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                      panel.grid.minor=element_blank(),plot.background=element_blank())
        }
        
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
        selectizeInput("voteTitle", "Select vote title", 
                       choices = Select_session()$unres_title,
                       multiple = T,
                       options = list(maxItems = 1))
    })
    
    
    
})
