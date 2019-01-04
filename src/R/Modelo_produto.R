
  library("arules")
  library("arulesViz")
  library(data.table)
  library(tidyverse)
  source("transacoes.R")

Alg<- function(file,conf,sup){
  ##X2016_1 <- read_delim("../Nclaudino/Recomendacao/2016 - 1.csv",
    ##                  ";", escape_double = FALSE, trim_ws = TRUE)
  compras <- file
  #write.csv(compras,file="compras.csv",quote=FALSE,row.names = FALSE)
  #View(compras)
  #View(table(compras$COD_PRODUTO))
  #####################################################################################################################################################|
  #Retira as transa??es n?o desejadas
  compras<-compras%>%filter(!(str_detect(COD_PRODUTO,"S")))%>%
    filter(!(str_detect(COD_PRODUTO,"G")))%>%
    filter(!(str_detect(COD_PRODUTO,"00000")))%>%
    filter(!(str_detect(CLASSIFICACAO,"CHIP")))%>%
    filter(!(str_detect(CLASSIFICACAO,"ALMOXARIFADO")))%>%
    filter(!(str_detect(CLASSIFICACAO,"SERVICOS")))

orders <- compras[,c("ORCAMENTO","COD_PRODUTO")]
order_trans <- transa(
  orders,
  format="single",
  cols=c("ORCAMENTO","COD_PRODUTO"),
  rm.duplicates=T
  )

regras<-apriori(order_trans,parameter = list(supp=sup,maxlen=50,maxtime=0,conf=conf))

  #View(inspect(regras))
  regras_show<-as(regras,"data.frame")
  regras_show$rules=regras_show$rules%>%str_replace_all("[{]","")%>%str_replace_all("[}]","")
  aux<-str_split(regras_show$rules," => ",simplify = TRUE)
  aux<-as.data.frame(aux)
  names(aux)<-c("lhs","rhs")
  regras_show2<-cbind(aux,regras_show)
  #Coloca os nomes dos produtos no rhs e a categoria
  Produtos_categoria <- read_delim("Produtos-categoria.txt",
                                   ";", escape_double = FALSE, trim_ws = TRUE)
  regras_merge<-merge(regras_show2,Produtos_categoria,by.x="rhs",by.y="COD_PRODUTO")
  regras_ordenadas<-regras_merge%>%filter(lhs!="")%>%
    arrange(lhs,lift)%>%group_by(lhs,CLASSIFICACAO)%>%
    top_n(1,wt=lift)%>%group_by(lhs)%>%top_n(25,wt=lift)
  regras_ordenadas<-regras_ordenadas%>%mutate(lift=lift+1000)

  joins<-anti_join(regras_merge,regras_ordenadas,by=c("lhs","rhs"))
  regras_ordenadas2<-rbind(as.data.frame(regras_ordenadas),joins)



  modelo_produto <- regras_ordenadas2%>%filter(lhs!="")%>%mutate(id=1)%>%group_by(lhs)%>%top_n(25,wt=lift)%>%select(id,lhs,rhs,lift)
  names(modelo_produto) <- c("ID_FORNECEDOR","PRODUTO","COD_PRODUTO_RECOMENDADO","LIFT")

    modelo_produto2<-data.table(Produto=factor(modelo_produto$PRODUTO),
                                `Produto recomendado`=factor(modelo_produto$COD_PRODUTO_RECOMENDADO))
   

  return(modelo_produto2)
}
