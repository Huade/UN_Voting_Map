# Run only if need to update data

library(lubridate)
session <- read.csv("data/Session68.csv", stringsAsFactors = F)
vote <- read.csv("data/session68votes.csv" , stringsAsFactors = F)

session$date <- mdy(session$date)
vote$region <- tolower(vote$Country)

save(session, vote, file = "data/UN_vote.RData")
