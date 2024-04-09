#########################################
#                                       #
#         TRABAJAR CON CARPETAS         #
#          Y DIRECTORIOS CON R          #
#                                       #
#########################################

# 0. INTRO ----------------------------------------------------------------
#
#   Este codigo pretende mostrar las principales nociones para trabajar y
#   organizar los diferentes espacios de trabajo cuando programamos en R
#
#                                                    26/02/2024->01/04/2024
#
#                   Julio C. D. V & David F. F.,


# 1.0 DIRECTORIO DE TRABAJO -----------------------------------------------

#(get working directory)
getwd() #Con esta función podemos conocer cuál es el actual directorio de trabajo

#(set working directory)
#Si queremos cambiar o  modificar el directorio, debemos usar la siguiente 
#función
setwd("D:/OneDrive - Universidad de Castilla-La Mancha/DOCTORADO UCLM/COLABORACIONES/RqueR") 
setwd("D:/")

#Si se trabaja desde Rstudio, se puede usar el atajo "CTRL + ALT/SHIFT + H" para
#elegir el directorio de trabajo 

#O emplear la siguiente función para elegir a mano la carpeta
home <- choose.dir()
setwd(home)

# 2.0 CREACION DE ELEMENTOS -----------------------------------------------

setwd("D:/")
#Se pueden crear directorios 
dir.create("Taller3")

#Se pueden crear diferentes tipos de archivos
file.create("Taller3/new_text.txt")
file.create("Taller3/new_word.docx")
file.create("Taller3/new_png.png")
file.create("Taller3/new_csv.csv")

#O crear un número de archivos a la vez
N <- 10
dir.create("Taller3/data_sets")
sapply(paste0("Taller3/data_sets/file", 1:N, ".csv"), file.create)


# 3.0 EXISTENCIA DE ARCHIVOS ----------------------------------------------

setwd("D:/Taller3")
#Si queremos conocer si existe un archivo o carpeta
file.exists("R_que_R.png")
file.exists("new_png.png")

#También se puede revisar si una carpeta o directorio existe, 
#y si no existe crearla
folder <- setwd("D:/Taller3/")
if (file.exists(folder)) {         #aplicamos un condicionante para crear una carpeta si no existe, y avisar si ya existe
  cat("The folder already exist")
} else {
  dir.create(folder)
}

folder <- "D:/Other_file/data_edited"
if (file.exists(folder)) {         
  cat("The folder already exist")
} else {
  dir.create(folder)
}

# 4.0 LISTADO DE ARCHIVOS -------------------------------------------------

#Para conocer el listado de archivos dentro de la ruta a especificar (Carpeta)
setwd("D:/")
list.files("Taller3")

#Si se quiere conocer los archivos de un formato específico, también se puede 
#indicar
list.files("Taller3", pattern = ".csv")

#También se puede obtener todos los archivos que estan dentro de la ruta, 
#incluyendo los archivos de las subcarpetas
list.files("Taller3", recursive = TRUE)

#Y se pueden combinar, obteniendo todos los archivos de un formato específico, 
#tanto en la ruta indicada como las subcarpetas de la ruta
list.files("Taller3", pattern = ".csv", recursive = TRUE)

#O se puede buscar los archivos dentro de una carpeta diferente del directorio 
#de trabajo
list.files("D:/Other_file")

#Se puede disponer de los nombres de los archivos y de su ruta completa
list.files("Taller3", full.name = TRUE)

#list.files("D:/OneDrive - Universidad de Castilla-La Mancha/DOCTORADO UCLM",
# full.name = TRUE)
#list.files("D:/OneDrive - Universidad de Castilla-La Mancha/DOCTORADO UCLM",
# pattern = ".pdf", recursive = TRUE)

#También se puede ver un listado de archivos de una carpeta elegida manualmente
list.files(path = choose.dir())

# 5.0 CARGAR ARCHIVOS -----------------------------------------------------

#Podemos leer todos los archivos de un formato específico que esten dentro de un
#mismo directorio
setwd("D:/Other_file")
all_data_frames <- lapply(list.files(pattern = ".csv"), read.csv)

# Unir todos los archivos en uno solo
single_data_frame <- Reduce(rbind, all_data_frames)


# 6.0 INFORMACIÓN DE ARCHIVOS ---------------------------------------------

#Cabe la posibilidad de sacar una instantanea (snapshot) del directorio de interés
snapshot <- fileSnapshot()
#Si lo guardamos, nos devolverá una lista con diferente información interesante
snapshot
#La información más interesante es la que se guarda en la sección "info"
snapshot$info
#"size" indica el tamaño del archivo
#"isdir" indica si el archivo es un directorio (TRUE FALSE)
#"mode" indica los permisos del archivo
#"mtime" indica la fecha de la ultima modificacion
#"ctime" indica la fecha de creación
#"atime" indica la fecha del último acceso
#"exe" indica el tipo de ejecutable (o "no" si no es ejecutable)

#También se puede sacar información para un único archivo
file.info("data1.csv")
file.mtime("data1.csv")

#Para sacar el nombre base del archivo hacemos uso de la siguiente función
basename("data1.csv")
basename("D:/Taller3/data_sets/file1.csv")

#Y lo mismo para sacar el nombre del directorio
dirname("data1.csv")
dirname("D:/Taller3/data_sets/file1.csv")
dirname(folder)

#Para obtener la extension del archivo
library(tools)
file_ext("D:/Taller3/new_png.png")


# 7.0 ABRIR/EJECUTAR ARCHIVOS ---------------------------------------------

setwd("D:/Taller3")
#Con esta función nos permite abrir el archivo en nuestro ordenador
shell.exec("new_word.docx")

file.show("new_text.txt")

#También podemos abrir una ventana para seleccionar la ruta del archivo
Route <- file.choose()
Route
#Esta función te devuelve el nombre completo del archivo seleccionado
file.show(Route)


# 8.0 MOVER ARCHIVOS ------------------------------------------------------

#Podemos mover un archivo de una ubicación a otra creando una copia manteniendo
#el nombre (por no asignar nombre en la carpeta donde se copia)
file.copy("D:/Taller3/new_text.txt",
          "D:/Other_file")

#O podemos copiar y cambiar el nombre del archivo en la nueva copia
file.copy("D:/Taller3/new_text.txt",
          "D:/Other_file/new_textv2.txt")


# 9.0 ELIMINAR ARCHIVOS --------------------------------------------------

#Para eliminar archivos, podemos usar dos rutas diferentes
unlink("D:/Other_file/new_textv2.txt")
file.remove("D:/Other_file/new_text.txt")

#Si queremos eleiminar un directorio entero, añadimos "recursive = TRUE"
unlink("D:/Taller3", recursive = TRUE)
file.remove("D:/Taller3")

# 10.0 GUARDAR DATOS ------------------------------------------------------

#Separamos el listado de datos en tres bases de datos separadas
data.1 <- all_data_frames[[1]]
data.2 <- all_data_frames[[2]]
data.3 <- all_data_frames[[3]]

#marcamos el directorio
home <- setwd("D:/Other_file/data_edited")

#Ahora iniciamos un bucle para guardar cada base de datos
for (i in 1:length(all_data_frames)) {
  all_data_frames.i <- all_data_frames[[i]] #esta función la empleamos para seleccionar el objeto de la lista
  folder <- paste("data_folder",i, sep="_") #marcamos el nombre que queremos asignar a cada carpeta
  if (file.exists(folder)) {         #aplicamos un condicionante para crear una carpeta si no existe, y avisar si ya existe
    cat("The folder already exist")
  } else {
    dir.create(folder)
  }
  route_rst<-paste(folder, "/data_",i,"_ed.csv", sep="")  #marcamos la ruta donde queremos enviar los documentos
  write.csv(all_data_frames.i, route_rst)  #guardamos los documentos
}




# FIN ---------------------------------------------------------------------

