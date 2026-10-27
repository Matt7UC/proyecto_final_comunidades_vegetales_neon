# ============================================================
# PROYECTO: ANALISIS DE COMUNIDADES VEGETALES NEON
# SCRIPT 01: IMPORTACION DE DATOS
# Autor: Matias Rojas
# ============================================================
#En caso de no tener funciones readr y glimpse, descargarlas en las siguientes lineas
#install.packages("dplyr")
#install.packages("readr")

# 1. Cargar librerias
library(readr)
library(dplyr)

# 2. Comprobar directorio de trabajo
getwd()

# 3. Identificar archivos disponibles
list.files()

# 4. Importar datos
datos_plant_cover <- read_csv("data/plant_cover.csv")

# 5. Revisar primeras observaciones
head(datos_neon)

# 6. Revisar dimensiones
dim(datos_neon)

# 7. Identificar variables
names(datos_neon)

# 8. Revisar estructura
glimpse(datos_neon)