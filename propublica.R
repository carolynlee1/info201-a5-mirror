source('api-keys.R')
library("httr")
library(knitr)
library(dplyr)
library(jsonlite)
chamber <- "house"
which.state <- state.input
endpoint <- paste0("https://api.propublica.org/congress/v1/members/",chamber, "/", which.state, "/current.json")
response.propublica <- GET(endpoint, add_headers("X-API-Key" = propublica.key))
body.propublica <- content(response.propublica, "text")
propublica.parsed <- fromJSON(body.propublica)
results <- propublica.parsed$results

member <- results$id
member.endpoint <- paste0("https://api.propublica.org/congress/v1/members/", member[1], ".json")
votes.endpoint <- paste0("https://api.propublica.org/congress/v1/members/", member[1], "/votes.json")
members.response <- GET(member.endpoint, add_headers("X-API-Key" = propublica.key))
votes.response <- GET(votes.endpoint, add_headers("X-API-Key" = propublica.key))
members.body <- content(members.response, "text")
members.parsed <- fromJSON(members.body)
members.results <- members.parsed$results

birth <- members.results$date_of_birth
this.year <- as.numeric(substring(Sys.Date(), 1, 4))
age <- this.year - as.numeric(substring(birth, 1, 4))
twitter <- paste0("http://www.twitter.com/", members.results$twitter_account)

votes.body <- content(votes.response, "text")
votes.parsed <- fromJSON(votes.body)
votes.results <- votes.parsed$results
votes.info <- flatten(as.data.frame(votes.results$votes))
votes.position <- select(votes.info, position, result)
no.num <- votes.position %>%
  filter(position == "No", result == "Failed") %>%
  count() %>%
  as.numeric()
yes.num <- votes.position %>%
  filter(position == "Yes", result == "Passed") %>%
  count() %>%
  as.numeric()
no.percent <- round(no.num / count(votes.position) * 100, digits = 0)
yes.percent <- round(yes.num / count(votes.position) * 100, digits = 0)
total.percent <- paste0(no.percent + yes.percent, "%")

member.name <- paste(members.results$first_name, members.results$last_name)

female.count <- results %>%
  filter(gender == "F") %>%
  count() %>%
  as.numeric()

male.count <- results %>% 
  filter(gender == "M") %>%
  count() %>%
  as.numeric()

gender.data <- c(female.count, male.count)

dem.count <- results %>%
  filter(party == "D") %>%
  count() %>%
  as.numeric()

rep.count <- results %>%
  filter(party == "R") %>%
  count() %>%
  as.numeric()

party.data <- c(dem.count, rep.count)
