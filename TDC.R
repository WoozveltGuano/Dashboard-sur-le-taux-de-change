
#Install the necessary packages 
install.packages("stringr")
install.packages("rvest")
install.packages("XML")
install.packages("ggplot2")
install.packages("rsconnect")
##### Taux de Change Dashboard 

#Read the package
library(stringr)
library(rvest)
library(XML)
library(rsconnect)

# The link sources 
Link1<-"https://www.brh.ht/taux-du-jour/"
Link2<-"https://www.brh.ht/taux-affiches-par-les-banques-et-les-agents-de-change-2/"

# Web data
TauxdechangeHTMLdata<- read_html(Link1)
TdcBanqueHTMLdata<- read_html(Link2)

#For Table 1
Tdc_table<- htmlParse(TauxdechangeHTMLdata, encoding = "UTF-8")

web_table<- readHTMLTable(Tdc_table)


#For Table 2 
Tdcbanque_table<- htmlParse(TdcBanqueHTMLdata, encoding = "UTF-8")

web_table2<- readHTMLTable(Tdcbanque_table)


#Conversion des Web data en dataframes  
Table1<- data.frame(web_table)

Table2<- data.frame(web_table2)

x<- data.frame(t(Table2)) 
y<- data.frame(t(Table1)) 


a<- x[c(9,10,11)] #Taux de reference

b<- x[c(1,2,3,4,5,6,7)] #Taux de change des banques

c<- y[c(1,3)]  #Taux de change du marche informel


Taux_de_reference<-a
colnames(Taux_de_reference)<- a[1, ]
Taux_de_reference<- Taux_de_reference[-1, ]
row.names(Taux_de_reference)<- c("Achats","Ventes","Spread")

Taux_de_change_Banque<-b
colnames(Taux_de_change_Banque)<- b[1, ]
Taux_de_change_Banque<-Taux_de_change_Banque[-1, ]
row.names(Taux_de_change_Banque)<-c("Achats","Ventes","Spread")

Taux_de_change_informel<-c
colnames(Taux_de_change_informel)<- c[1, ]
Taux_de_change_informel<-Taux_de_change_informel[-1, ]
row.names(Taux_de_change_informel)<-  c("Achats","Ventes","Spread")


#Affichage des Tableaux 
View(Taux_de_reference)
View(Taux_de_change_Banque)
View(Taux_de_change_informel)

#Creation des graphiques 
range1<- max(Taux_de_reference$`TAUX DE REFERENCE BRH (Achat)`)

plot(Taux_de_reference$`TAUX MAXIMUM`, type = "o", col="blue",axes=FALSE, ann=FALSE)
lines(Taux_de_reference$`TAUX MINIMUM`, type = "o", col="red")    
lines(Taux_de_reference$`TAUX DE REFERENCE BRH (Achat)`, type = "o", col="green")
title(main = "Le Taux de Reference")
axis(1, at=1:3, lab=c("Achats","Ventes","Spread"))
axis(2, las=1, at=5*0:range1)
box()
legend("topright", c("Taux maximum en Bleu","Taux minimum en Rouge","Taux de reference en Vert"))


range1<- max(Taux_de_reference$`TAUX DE REFERENCE BRH (Achat)`)

plot(Taux_de_change_Banque$UNIBANK, type = "o", col="blue",axes=FALSE, ann=FALSE)
lines(Taux_de_change_Banque$SOGEBANK, type = "o", col="red")    
lines(Taux_de_change_Banque$BUH, type = "o", col="green")
lines(Taux_de_change_Banque$CITIBANK, type = "o", col="yellow")
lines(Taux_de_change_Banque$SOGEBEL, type = "o", col="orange")
lines(Taux_de_change_Banque$`CAPITAL BANK`, type = "o", col="purple")
lines(Taux_de_change_Banque$BNC, type = "o", col="black")

title(main = "Le Taux de change des banques")
axis(1, at=1:3, lab=c("Achats","Ventes","Spread"))
axis(2, las=1, at=5*0:range1)
box()
legend("topright", c("Unibank en Bleu",
                     "Sogebank en Rouge",
                     "BUH en Vert",
                     "Citibank en Jaune",
                     "Sogebel en Orange",
                     "Capital Bank en Mauve",
                     "BNC en noir"))

range1<- max(Taux_de_reference$`TAUX DE REFERENCE BRH (Achat)`)

plot(Taux_de_change_informel$`MARCHE BANCAIRE`, type = "o", col="blue",axes=FALSE, ann=FALSE)
lines(Taux_de_change_informel$`MARCHE INFORMEL`, type = "o", col="red")   

title(main = "Le Taux de change du Marche informel")
axis(1, at=1:3, lab=c("Achats","Ventes","Spread"))
axis(2, las=1, at=5*0:range1)
box()
legend("topright", c("Marche Bancaire en Bleu", "Marche Informel en Rouge"))



rsconnect::deployApp("C:/Users/ADMIN/Documents/R/Tableau de bord/Taux de change Dashboard.Rmd")


