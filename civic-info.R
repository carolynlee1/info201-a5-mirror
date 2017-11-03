source('api-keys.R')
library("httr")
library(knitr)
library(dplyr)
library(jsonlite)
query.params <- list(key = print(civic.key), address = "Phoenix, Arizona")
response <- GET("https://www.googleapis.com/civicinfo/v2/representatives", query = query.params)
body <- content(response, "text")



parsed.data <- fromJSON(body)
offices <- parsed.data$offices
offices <- flatten(offices)
officials <- parsed.data$officials
officials <- flatten(officials)

input <- parsed.data$normalizedInput

state.input <- input$state


officials <- select(officials, name, party, emails, phones, urls, photoUrl)

