
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
    # TODO: Change search result
    
    Select_session <- reactive({
        df <- session
        if (length(input$keywords!=0)){
            kwd_pattern <- gsub(",", "|", input$keywords)
            df <- subset(df, grepl(kwd_pattern, df$descr, ignore.case = T))
        }
        #df <- subset(df, df$date %in% input$DateRange)
        return(df)
    })
    
    output$sessionTable <- renderDataTable({
        df <- session
        if (length(input$keywords!=0)){
            kwd_pattern <- gsub(",", "|", input$keywords)
            df <- subset(df, grepl(kwd_pattern, df$descr, ignore.case = T))
        }
        #df <- subset(df, df$date %in% input$DateRange)
        vars <- c("session","title", "date", "yes", "no", "abstain")
        df <- df[,vars]
        return(df)}, 
        options = list(searching = FALSE,
                       pageLength = 10)
        )
    
    output$downloadData <- downloadHandler(
        filename = "UN_Voting.csv",
        content = function(file) {
            write.csv(Select_session(), file)
        }
    )
    
    # Title selection
    output$TitleSelectUI <- renderUI({ 
        if (input$sum_opt == 1){
            selectizeInput("voteTitle", "Select vote title", choices = Select_session()$title)
        }
        else {
            selectizeInput("voteTitle", "Select vote title(s)", 
                           choices = SessionData()$title,
                           multiple = T)
        }
    })
    
    
    
})
