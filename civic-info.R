source("api-keys.R")
print(civic.key)
library("httr")
library(knitr)
library(dplyr)
query.params <- list(key = print(civic.key), address = "4348 9th Avenue, Seattle WA 98105")
response <- GET("https://www.googleapis.com/civicinfo/v2/representatives", query = query.params)
body <- content(response, "text")
print(body)

library(jsonlite)

parsed.data <- fromJSON(body)
names(parsed.data)

offices <- parsed.data$offices
officies <- flatten(offices)
officials <- parsed.data$officials
officials <- flatten(officials)

officials <- select(officials, name, party, emails, phones, urls, photoUrl)

