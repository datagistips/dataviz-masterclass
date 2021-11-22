library(rjson)
library(tidyverse)
library(glue)

# Sys.setenv(http_proxy="http://direct1.proxy.i2:8080")
# options(rsconnect.http.trace = TRUE, rsconnect.error.trace = TRUE, rsconnect.http.verbose = TRUE)

source("helpers.R")

options(warn=-1)

## SETTINGS -----------------
PLATFORM <- "prod"
APP_DIR         <<- "shinyapp"
APP_NAME        <<- "artif0920"
TOKEN_RSCONNECT <<- rjson::fromJSON(file="rsconnect.json")

## PLATFORMS -----------
deploy_myapp <- function(APP_NAME, PLATFORM) {
  
  if(PLATFORM != "prod") {
      APP_NAME <- glue("{APP_NAME}-{PLATFORM}")
  }
  message("Deploiement vers ", APP_NAME)
  deploy_app(APP_NAME, APP_DIR, TOKEN_RSCONNECT, launch_browser = FALSE)
}

## DEPLOY -----------
deploy_myapp(APP_NAME, "prod")