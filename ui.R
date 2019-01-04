library(shiny)
library(htmltools)
library(shinycssloaders)
library(shinydashboard)
library(plotly)
options(spinner.size=0.5)
htmlTemplate("index.html",

             button = actionButton(inputId = "teste", "Busca"),
             FileInputjrs = fileInput("file1", "Carregue o arquivo",
                multiple = TRUE,
                accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
             slider = sliderInput(inputId = "TESTE", "teste",min=0 ,max=10, 1, step=0.2),
             textinpt = textInput("teste","teste","Entre com a busca"),
             ##tab1 = withSpinner(DT::dataTableOutput("table1"), type=6,color="#00b300"),
             tab2 = withSpinner(DT::dataTableOutput("table2",width="200%"), type=6,color="#00b300"),
             seletor = selectInput("seletor", "selecione", choices=unique(colnames(mtcars)), width ="40px"),
             pizza = withSpinner(plotlyOutput("reativo", height = "299px"), type=6,color="#00b300"),
             grafico2 = withSpinner(plotlyOutput("g2", width = "199px"), type=6,color="#00b300"),
             seletor2 = selectInput("seletorVa", "Selecione a variável de interesse", choices = unique(colnames(mtcars))),
             confianca_seletor=numericInput("conf","Confianca",value=0.5,step=0.001),
             suporte_seletor=numericInput("sup","Suporte",value=0.0001,step=0.001),
             info = infoBox("Transações", 2, icon = icon("credit-card"))

             )







## FcustomCSS <- function (){

 ## customCSS <- function (theme = NULL) {

 ##   htmlDependency("custom", "1.0", src=c(href = "shared/Apps", file = system.file("www/shared/Apps", package ="shiny")),
 ##                  stylesheet ="style.css")


 ## }

 ## customCSS2 <- function (theme = NULL){
 ##   htmlDependency("ccs", "1.0", src = c(href = "shiny"), stylesheet = "www/style.css")
 ## }
## customCSS2()
