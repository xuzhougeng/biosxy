
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

loadDataMySQL <- function(){
   con <- dbConnect(RMySQL::MySQL(),
                    host=host,
                    user=user,
                    port=3306,
                    password=password,
                    dbname="sxy")
   dbExecute(con, 'SET NAMES utf8')
   df <- as.tbl(dbReadTable(con,'articles'))
   Encoding(df$content) <- "UTF-8"
   Encoding(df$author) <- "UTF-8"
   Encoding(df$title) <- "UTF-8"
   df$time <- as.Date(df$time)
   dbDisconnect(con)
   return(df)
}

## author name modification
mysql2sqlite <- function(){
  con <- DBI::dbConnect(RSQLite::SQLite(), 'sxy.sqlite')
  df <- loadDataMySQL()
  df$time = as.character(df$time)
  df$author[df$author=='hoptop'] <- "徐洲更"
  df$author[df$author=='hoptop就是徐洲更'] <- "徐洲更"
  df$author[df$author=="hoptop是徐洲更" ] <- "徐洲更"
  df$author[df$author=="hoptpop" ] <- "徐洲更"
  df$author[df$author=="奔跑的天地本无心" ] <- "天地本无心"
  df$author[df$author=='Chevy'] <- "徐春晖"
  DBI::dbWriteTable(con, 'articles', df)
  dbDisconnect(con)
}


loadDataSQL <- function(){
  con <- DBI::dbConnect(RSQLite::SQLite(), 'sxy.sqlite')
  df <- as.tbl(dbReadTable(con,'articles'))
  df$time <- as.Date(df$time)
  DBI::dbDisconnect(con)
  return(df)
}

# create a link from title and url
createLink <- function(x){
  url = x[1]
  title =x[2]
  sprintf('<a href="%s" taget="_blank" class="btn btn-primary">%s</a>', url, title )
  
}


fileds <- c("author","beginDate","endDate","keywords") 
server <- function(input, output) {
  formData <- reactive({
    # validate(
    #   need(input$keywords, label = "keywords")
    # )
    data <- sapply(fileds, function(x) as.character(input[[x]]))
    data
  })
  
  results <- eventReactive(input$sure,{
    df <- loadDataSQL()
    
    if (! formData()[4] == ''){
      df <- df[str_detect(df$content,regex(formData()[4], ignore_case = TRUE) ),]
    }
    if (! formData()[1] ==''){
      df <- filter(df, author == formData()[1])
    }
    
    df <-  filter(df, time > as.Date(formData()[2]) & time < as.Date(formData()[3]))
    df <- df[,2:5]
    df
  })
  
  output$dataViews <- DT::renderDataTable({
    links <- apply(results()[3:4],1,createLink)
    mytbl <- data.frame(post_data = results()[1], author=results()[2], links=links)
    return(mytbl)
    
  }, escape=FALSE)

}


