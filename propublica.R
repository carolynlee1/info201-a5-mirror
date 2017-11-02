source("api-keys.R")
print(propublica.key)
library("httr")
library(knitr)
library(dplyr)
library(jsonlite)
chamber <- "house"
state <- "CA"
endpoint <- paste0("https://api.propublica.org/congress/v1/members/",chamber, "/", state, "/current.json")
response.propublica <- GET(endpoint, add_headers("X-API-Key" = propublica.key))
body.propublica <- content(response.propublica, "text")
propublica.parsed <- fromJSON(body.propublica)
names(propublica.parsed)
results <- propublica.parsed$results

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
