# server.R

library(shiny)

shinyServer(function(input, output) {
    
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
    
    output$sessionTable <- renderDataTable({
        df <- session
        if (length(input$keywords!=0)){
            kwd_pattern <- gsub(",", "|", input$keywords)
            df <- subset(df, grepl(kwd_pattern, df$descr, ignore.case = T))
        }
        
        if (!is.null(input$voteTitle)){
            df <- subset(df, df$title==input$voteTitle)
        }
        
        df <- subset(df, 
                     as.Date(df$date)>=input$DateRange[1] & as.Date(df$date)<=input$DateRange[2])
        vars <- c("session","title", "date", "yes", "no", "abstain")
        df <- df[,vars]
        return(df)}, 
        options = list(searching = FALSE,
                       pageLength = 10)
    )
    
    Select_voting <- reactive({
        df <- vote
        
        if (length(Select_session()$rcid)!=0){
            df <- subset(df, df$rcid == Select_session()$rcid)
        }
        
        if (!is.null(input$voteTitle)){
            df <- subset(df, df$title==input$voteTitle)
        }
        
        return(df)
    })
    
    output$votingTable <- renderDataTable({
        df <- vote
        # TODO: Fixit
        df <- subset(df, df$rcid %in% Select_voting()$rcid)
        vars <- c("Country", "CABB", "Vote")
        df <- df[,vars]
        }, 
        options = list(pageLength = 10)
    )
    
    output$downloadSession <- downloadHandler(
        filename = "UN_Session.csv",
        content = function(file) {
            write.csv(Select_session(), file)
        }
    )
    
    output$downloadVoting <- downloadHandler(
        filename = "UN_Voting.csv",
        content = function(file) {
            write.csv(Select_voting(), file)
        }
    )
    
    # Title selection
    output$TitleSelectUI <- renderUI({ 
        selectizeInput("voteTitle", "Select vote title", 
                       choices = Select_session()$title,
                       multiple = T,
                       options = list(maxItems = 1))
    })
    
    
    
})
