library(shiny)
library(shinydashboard)
library(DBI)
library(RMySQL)
library(DT)
library(dplyr)
library(stringr)


con <- DBI::dbConnect(RSQLite::SQLite(), 'sxy.sqlite')
authors <- dbGetQuery(con, 'select author from articles')[,1]
author_list <- unique(authors)
dbDisconnect(con)

host <-  Sys.getenv('HOST')
user <- 'root'
password <- Sys.getenv('password')
port <- 3306
dbname="sxy"
