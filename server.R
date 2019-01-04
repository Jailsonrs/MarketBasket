
  library(shiny)
  library(plotly)
  library(tidyverse)
  ##install.packages("shinycssloaders")
  library(shinycssloaders)
  library(DT)  
  library(highcharter)
  ##install.packages("highcharter")
  library(ggthemes)
  library(ggplot2)
  library(magrittr)
  library("shinydashboard")
  source("src/R/Modelo_produto.R")
  options(shiny.maxRequestSize=500*1024^2)
  ##source("./sa.R")
  tema <- theme(
    panel.background = element_rect(fill="white"),
    panel.grid.minor = element_line(color="red"),
    axis.line = element_line(size=1,linetype=2, arrow=1)

  )

  function(input, output){
    ###OBTENDO CAMINHO DO ARQUIVO APÓS A LEITURA
    arquivo <- reactive({
        infile <- input$file1
        if (is.null(infile)) {
          ##RETORNA NULL SE O ARQ NAO FOI CARREGADO
          return(NULL)}
      else{
        ##CASO CONTRARIO RETORNA O CAMINHO DO ARQUIVO E SALVA NO
        ##OBJETO REATIVO "arquivo"
        return(read_delim(infile$datapath,
                    ";", escape_double = FALSE, trim_ws = TRUE))
      }
    })




    data(mtcars)
    output$reativo <- renderPlotly({
      p <-ggplot(mtcars,aes(mpg, hp))+
        geom_point(col="springgreen4")+
        stat_smooth(method=lm,se=F)+
      labs(title="Diagrama de dispersão\n entre MPG e potência (HP)")+
        tema

      gp <- ggplotly(width=350,height=395) %>%
      config(collaborate=FALSE,
         cloud=FALSE,
         displaylogo=FALSE,
         modeBarButtonsToRemove=c(
        "select2d",
        "sendDataToCloud",
        "pan2d",
        "resetScale2d",
        "hoverClosestCartesian",
        "hoverCompareCartesian",
        "lasso2d",
        "zoomIn2d",
        "zoomOut2d"))
      gp <- layout(gp, margin=list(t = 100),autosize = F)
      gp
  })

  ##RENDERIZANDO TABELA LIDA
  output$table1<- renderDataTable({
    if(is.null(arquivo())){return(data.frame())}
    else{
      arquivo()
    }
      })

      output$table2<- DT::renderDataTable({
          datatable(Alg(arquivo(),input$conf,input$sup),filter="top",extensions = c('Scroller','Buttons','Responsive'), options = list(

                                                                                                 dom = 'Bfrtip',
                                                                                                 buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                                                                                 deferRender = TRUE,
                                                                                                 scrollY = 200,
                                                                                                 scroller = TRUE))
                    




      })

  }
