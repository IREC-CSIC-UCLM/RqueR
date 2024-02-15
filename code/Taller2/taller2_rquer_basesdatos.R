
# =========================================================================
# -----------------------MANEJO BASES DE DATOS----------------------------=
# =========================================================================


# 0. INTRO ----------------------------------------------------------------
#
#   este codigo pretende ser un recordatorio de funciones basicas de manejo
# de bases de datos 
#
#                                                    08/01/2024->XX/XX/XXXX
#
#                   Mario F.T., 


# 1. PREPARACION ----------------------------------------------------------

setwd("D:/taller2") # definimos el working directory


## 1.1. LIBRERIAS ----------------------------------------------------------

library(readxl) # se carga el paquete readxl para usar sus funciones
library(writexl)


## 1.2. DATOS --------------------------------------------------------------

# abrimos la base de datos, con todas las variables como texto:
censosDB<-read_excel("taller2_rquer_DATA.xlsx", col_types = "text")


### 1.2.1. INSPECCIONAR BASE DATOS ------------------------------------------

str(censosDB)  # muestra primeras filas de todas las variables 
head(censosDB) # muestra primeras filas de todas las variables

unique(censosDB$zona)          # ver diferentes niveles factor
length(unique(censosDB$zona))  # cuantos niveles diferentes hay

summary(as.numeric(censosDB$indivs)) # ver estadisticas descriptivas de variable

class(censosDB)             # ver clase del objeto
class(censosDB$Idtransecto) # ver clase del objeto

any(is.na(censosDB$indivs)) # pregunta si hay NA en la variable
any(is.na(censosDB))        # pregunta si hay NA en toda la base de datos


# 2. MODIFICAR BASE DE DATOS ----------------------------------------------

## 2.1. SELECCION DATOS ----------------------------------------------------

### 2.1.1. creando nuevos objetos -------------------------------------------

censosDB2<-censosDB[,c(2,3)]            # base de datos con las columnas 2 y 3
censosDB3<-censosDB[,c("zona","fecha")] # base de datos con las columnas 2 y 3
censosDB4<-censosDB[,c(2:3)]            # base de datos con las columnas 2 y 3

censosDB5<-censosDB[censosDB$zona=="velada",] # base de datos filtrados para la zona "velada"
censosDB6<-subset(censosDB, zona=="velada")   # base de datos filtrados para la zona "velada"

censosDB7<-censosDB[c(censosDB$zona=="velada"&censosDB$Idtransecto=="1"),]          # base de datos filtrados para la zona "velada" y ID 1
censosDB8<-subset(censosDB, c(censosDB$zona=="velada"&censosDB$Idtransecto=="1"))   # base de datos filtrados para la zona "velada" y ID 1

# OPERADORES:
# & es "Y"
# | es "O"
# ! es "no es"


### 2.1.2. filtrando sin crear objeto ---------------------------------------

# para ejecutar funciones sobre la base de datos filtrada:
censosDB[c(censosDB$zona=="velada"&censosDB$Idtransecto=="1"),]          # base de datos filtrados para la zona "velada" y ID 1


## 2.2. CAMBIAR NOMBRE VARIABLES -------------------------------------------

names(censosDB2)<-c("area","date")                 # cambiamos los nombres en ese orden
names(censosDB2)[names(censosDB2)=="zona"]<-"area" # cambiar el nombre de una variable especifica


## 2.3. ELIMINAR -----------------------------------------------------------

censosDB9<-censosDB[,-1]                                    # eliminar primera columna
censosDB9<-censosDB[!names(censosDB) %in% c("Idtransecto")] # eliminar columna por nombre

censosDB9<-censosDB[!censosDB$zona=="marrupe",]             # eliminar todas las filas cuya zona es "marrupe"

censosDB<-censosDB[complete.cases(censosDB),]               # elimina toda fila con algún valor de NA
censosDB<-censosDB[!is.na(censosDB$indivs),]                # elimina las filas que tiene NA en "indivs"


## 2.4. REEMPLAZAR ---------------------------------------------------------

censosDB$zona2<-gsub("marrupe","sotillo",censosDB$zona) # reemplazamos un valor por otro


## 2.5. ANYADIR COLUMNAS O FILAS -------------------------------------------

censosDB$ID2<-NA                  # creamos una columna nueva rellena con NA

censosDB[nrow(censosDB)+1,]<-NA   # anyade una fila en ultima posicion rellena con NA


## 2.6. ORDENAR ------------------------------------------------------------

sort(as.numeric(censosDB$indivs))   # ordena de menor a mayor los valores

censosDB2<-censosDB[order(as.numeric(censosDB$indivs)),] # crear otra base de datos ordenada por los valores de los individuos


## 2.7. BUSCAR -------------------------------------------------------------

which(censosDB$zona == "velada")  # filas que cumplen la condicion

## 2.8. CAMBIAR CLASE DE VARIABLE ------------------------------------------

censosDB$individs_num<-as.numeric(censosDB$indivs) # cambiar a clase numerico en otra variable
censosDB$indivs<-as.numeric(censosDB$indivs) # cambiar a clase numerico reemplazando variable

censosDB$fecha_date<-as.Date(as.numeric(censosDB$fecha), origin="1900-01-01")  # convertir a formato fecha

# 3. CREAR BASE DE DATOS ------------------------------------------------

diccDB<-data.frame(
  zona=   c("marrupe","velada" ,"guisando"),
  habitat=c("encinar","encinar","pinar")
)


## 3.1. COMBINAR BASES DE DATOS --------------------------------------------

diccDB2<-cbind(diccDB,c("ganadero","agricola","forestal")) # crea una base de datos uniendo una columna nueva a otra base de datos
diccDB<-rbind(diccDB,1)                                    # anyade una fila con el valor 1
censosDB2<-merge(censosDB,diccDB)                          # fusiona ambas bases de datos automaticamente si hay una variable comun


# 4. BUSCARV --------------------------------------------------------------

library(lookup)
censosDB$habitat<-lookup(censosDB$zona, diccDB$zona, diccDB$habitat) # anyade la variable habitat utilizando zona como link y consultando a diccDB


# 5. TABLA DINAMICA -------------------------------------------------------

aggregate(as.numeric(indivs)~zona, censosDB, FUN=sum)                                    # suma de individuos por zona
aggregate(as.numeric(indivs)~zona+Idtransecto, censosDB, FUN=mean)                       # promedio de individuos por zona y transecto
Idtransecto_zona_DB<-aggregate(Idtransecto~zona, censosDB, FUN=length)                   # crea  base de datos de la cuenta de transectos por zona


# 6. CONCATENAR -----------------------------------------------------------

provincias<-c("zamora","leon")
paste("SPAIN",provincias,sep="")   # concatenar texto y lista sin separador
paste("SPAIN",provincias,sep="_")  # concatenar texto y lista con separador

censosDB$zona_ID<-paste(censosDB$zona,censosDB$Idtransecto,sep="_")  # crear variable concatenando


# 7. FUNCION "SI" ---------------------------------------------------------

numero<--7
ifelse(numero>0, "numero es positivo", "numero es negativo")  # condicional sobre valor del objeto "numero"

censosDB$presencia<-ifelse(as.numeric(censosDB$indivs)>0, "SI","NO")  # condicional sobre el valor de la variable "indivs" para cada fila


# 8. EXTRAER --------------------------------------------------------------

censosDB$fecha<-as.Date(as.numeric(censosDB$fecha), origin="1900-01-01")
censosDB$year<-substr(as.character(censosDB$fecha),1,4)                   # extrae el anyo de la fecha como texto


# 9. COMPARACIONES --------------------------------------------------------

censosDB$indivs2<-censosDB$indivs   # variable dummy para este ejercicio
censosDB$indivs2[3:7]<-"98"         # variable dummy para este ejercicio

censosDB$isindivsequalindivs2<-censosDB$indivs==censosDB$indivs2  # crea una variable que es TRUE si indivs es igual a indivs2


# 10. GUARDAR BASES DE DATOS ----------------------------------------------

library(writexl)

write_xlsx(censosDB, "censosDB.xlsx")   # guarda como XLSX en el working directory


library(openxlsx)

diccDB<-data.frame(zona=c("marrupe","velada" ,"guisando"),habitat=c("encinar","encinar","pinar"))  # base de datos dumy para el ejercicio

wb <- createWorkbook()            # crea un objeto workbook y le anyade pestanyas
addWorksheet(wb, "datos_brutos")
addWorksheet(wb, "diccionario")

writeData(wb, "datos_brutos", censosDB)  # incluimos los datos en las pestanyas
writeData(wb, "diccionario", diccDB)

saveWorkbook(wb, "censosDB.xlsx", overwrite=TRUE) # guarda finalmente el archivo en el working directory


