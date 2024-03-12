library(shiny)
library(wordcloud2)
library(datasets)


ui <- shinyUI(fluidPage(
  
  titlePanel("String matching"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      p("This app use ", span("KMP", style = "color:blue"), "to do string search."),
      p("This app will return frequency of matching as well as position of matching for each query strings. Then,word cloud will be generated to visualize the frequency  "),
      br(), 
      strong("Step 1: user upload csv file:  "),  em("column 1: Target strings (muliple strings allowed),column 1: Query strings (muliple strings allowed)  "),
      br(),
      strong("Step 2: choose display options"),  em("Target: display target strings, Result:display matching result tables "),
      br(),
      strong("Step 3: generate word cloud"),  em("colored:  create a colored word cloud")
      
    )
  ),
  tabsetPanel(
    tabPanel("Upload File",
             titlePanel("Uploading Files"),
             sidebarLayout(
               sidebarPanel(
                 fileInput('file1', 'Choose CSV File',
                           accept=c('text/csv', 
                                    'text/comma-separated-values,text/plain', 
                                    '.csv')),
                 
                 # added interface for uploading data from
                 # http://shiny.rstudio.com/gallery/file-upload.html
                 tags$br(),
                 checkboxInput('header', 'Header', TRUE),
                 radioButtons('sep', 'Separator',
                              c(Comma=',',
                                Semicolon=';',
                                Tab='\t'),
                              ','),
                 # Horizontal line ----
                 tags$hr(),
                 
                 # Input: Select number of rows to display ----
                 radioButtons("disp", "Display",
                              choices = c(Target = "target",
                                          Reult = "result"),
                              selected = "target")
             
                 
               ),
               mainPanel(
                 tableOutput('contents')
               )
             )
    ),
    tabPanel("Word cloud",
             pageWithSidebar(
               headerPanel('Word cloud for matching strings'),
               sidebarPanel(
                 
                 # "Empty inputs" - they will be updated after the data is uploaded
                 checkboxInput('checkboxInput', 'Colored', TRUE)
                 
               ),
               mainPanel(
                 wordcloud2Output("wordcloud2")
               )
             )
    )
    
  )
)
)

server <- shinyServer(function(input, output, session) {
  # added "session" because updateSelectInput requires it
  
  
  data <- reactive({ 
    req(input$file1) ## ?req #  require that the input is available
    inFile <- input$file1 

    
    df <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
    
    
    return(df)
  })
  
  output$contents <- renderTable({
 
    df<-as.data.frame(data())
    names(df)<-c("Target", "Query")
    
    Target<-paste(as.character(df[,1]),collapse=";")
    l<-df[,2]
    l<- l[l!=""]

    result<-data.frame(matrix(NA, nrow =   length(l),  ncol = 3))
    names(result)<-c("Query","# of matching","matching locations")
    for (i in 1 :length(l)){
      Query<-as.character(l[i])
      index<-KMP(Query, Target)
      result[i,1]<-paste(Query)
      result[i,3]<-paste(index, collapse=",")
      result[i,2]<-length(index)
    }
    
    
    
    if(input$disp == "target") {
      return(df[,1])
    }
    else {
      return(result)
    }
  })
  
  output$wordcloud2 <- renderWordcloud2({
    df<-as.data.frame(data())
    names(df)<-c("Target", "Query")
    Target<-paste(as.character(df[,1]),collapse=";")
    l<-df[,2]
    l<- l[l!=""]
    
    result<-data.frame(matrix(NA, nrow =   length(l),  ncol = 3))
    names(result)<-c("Query","# of matching","matching locations")
    for (i in 1 :length(l)){
      Query<-as.character(l[i])
      index<-KMP(Query, Target)
      result[i,1]<-paste(Query)
      result[i,3]<-paste(index, collapse=",")
      result[i,2]<-length(index)
    }
    demoFreq<-result[,1:2]
    if(input$colored) {
    wordcloud2(demoFreq, color = "random-light", backgroundColor = "grey") }
    else{
    return(  wordcloud2(demoFreq))}
  })
  
  
  
})

shinyApp(ui, server)