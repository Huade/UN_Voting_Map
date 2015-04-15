# Run only if need to update data

library(dplyr)
library(lubridate)
session <- read.csv("data/Session68.csv", stringsAsFactors = F)
vote <- read.csv("data/Session68votes.csv" , stringsAsFactors = F)

session$date <- mdy(session$date)
session$unres_title <- paste(session$unres, session$title, sep = " ")
vote$region <- tolower(vote$Country)
vote$Vote <- ifelse(vote$vote==1, "Yes",
                    ifelse(vote$vote==2, "Abstain",
                           ifelse(vote$vote==3, "No",
                                  ifelse(vote$vote==8, "Absent", "Not UN member"))))

vote <- vote %>% left_join(session)
save(session, vote, file = "data/UN_vote.RData")
