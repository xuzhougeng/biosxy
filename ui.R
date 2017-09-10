

# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

header <- dashboardHeader(
  title = "生信媛",
  titleWidth = 300
)

## 申请系统
# fileds <- c("author","beginDate","endDate","keywords") 
orderSystem <- tabItem(tabName="orderSystem",
                       fluidRow(
                         box(width = 4, title = "找一找",
                             selectInput(inputId = "author", label = "作者", choice=author_list),
                             dateInput(inputId = "beginDate", label= c("起始日期"), value= '2016-12-24',
                                       min='2016-12-24'),
                             dateInput(inputId = "endDate", label= c("终止日期")),
                             textInput(inputId = "keywords", label = c("关键字"), placeholder="RNA-Seq"),
                             column(width=4, offset = 4, actionButton(inputId = "sure", label = "查找"))
                         ),
                         box(width = 8, title = "结果", status = "info", height = 700, 
                             DT::dataTableOutput("dataViews"))))


body <- dashboardBody(
    orderSystem
    )
    
ui <- dashboardPage(
  header =  header,
  sidebar = dashboardSidebar(disable = TRUE),
  body = body,
  title = "生信媛"
  
)
