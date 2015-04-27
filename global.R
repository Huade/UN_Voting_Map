# global.r
# Code inside this file apply both ui and server

# Load dataframes
load("data/UN_vote.RData") # Vote data
load("data/WorldPoints.RData") # Map data
load("data/colormatrix.RData") # Map color matrix

# START NOT RUN
# Preprocessing vote and session data

# library(dplyr)
# library(lubridate)
# session <- read.csv("descriptions 9-29.csv", stringsAsFactors = F)
# vote <- read.csv("UNGAvotes.csv" , stringsAsFactors = F)
# ccode <- read.csv("ccode.csv", stringsAsFactors = F)
# 
# vote <- vote %>% left_join(ccode)
# 
# session$date <- mdy(session$date)
# session$unres_title <- paste(session$unres, session$short, sep = " ")
# vote$region <- tolower(vote$Country)
# vote$Vote <- ifelse(vote$vote==1, "Yes",
#                     ifelse(vote$vote==2, "Abstain",
#                            ifelse(vote$vote==3, "No",
#                                   ifelse(vote$vote==8, "Absent", "Not UN member"))))
# 
# vote <- vote %>% left_join(session)
# save(session, vote, file = "UN_vote.RData")
# 
# END NOT RUN