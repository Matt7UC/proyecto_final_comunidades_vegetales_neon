# ============================================================
# PROYECTO: ANALISIS DE COMUNIDADES VEGETALES NEON
# Autor: Matias Rojas
# Curso: Visualizacion y Analisis de Datos Medioambientales
# ============================================================

# SCRIPT 02: ANALISIS EXPLORATORIO DE DATOS

# Objetivo:
# Caracterizar preliminarmente los registros de vegetacion
# de NEON mediante estadisticas descriptivas de especies,
# sitios de muestreo y cobertura vegetal.

# ------------------------------------------------------------
# 1. CARGAR LIBRERIAS
# ------------------------------------------------------------

library(readr)
library(dplyr)


# ------------------------------------------------------------
# 2. CARGAR DATOS
# ------------------------------------------------------------

source("script/01_importar_datos.R")

# ------------------------------------------------------------
# 3. CARACTERIZACION GENERAL DE LA BASE DE DATOS
# ------------------------------------------------------------

# Numero total de registros
nrow(datos_plant_cover)

# Numero total de variables
ncol(datos_plant_cover)

# ------------------------------------------------------------
# 4. REVISION DE DATOS FALTANTES
# ------------------------------------------------------------

# Contar valores faltantes por variable
colSums(is.na(datos_plant_cover))

# Calcular y mostrar el porcentaje de valores faltantes por variable
round(colMeans(is.na(datos_plant_cover)) * 100, 2)

# ------------------------------------------------------------
# 5. COMPOSICION FLORISTICA
# ------------------------------------------------------------

# Numero de especies diferentes
n_distinct(datos_plant_cover$species, na.rm = TRUE)

# Mostrar las primeras 20 especies únicas registradas
head(unique(datos_plant_cover$species), 20)

# ------------------------------------------------------------
# 6. FRECUENCIA DE ESPECIES
# ------------------------------------------------------------

# Calcular frecuencia de registros por especie

frecuencia_especies <- datos_plant_cover %>%
  filter(!is.na(species), trimws(species) != "") %>%
  count(species, sort = TRUE, name = "n_registros")

# Mostrar las primeras 15 especies
head(frecuencia_especies, 15)

# ------------------------------------------------------------
# 7. RIQUEZA DE ESPECIES
# ------------------------------------------------------------

# Calcular riqueza por unidad de muestreo y fecha

riqueza_sitios <- datos_plant_cover %>%
  filter(
    !is.na(sitename),
    !is.na(date),
    !is.na(species),
    trimws(sitename) != "",
    trimws(species) != ""
  ) %>%
  group_by(sitename, date) %>%
  summarise(
    riqueza = n_distinct(species),
    .groups = "drop"
  )

# Visualizar resultados
head(riqueza_sitios)

# Ordenar unidades según riqueza de especies

riqueza_ordenada <- riqueza_sitios %>%
  arrange(desc(riqueza))

# Mostrar las primeras 10 unidades
head(riqueza_ordenada, 10)

# ------------------------------------------------------------
# 8. COBERTURA VEGETAL
# ------------------------------------------------------------

# Resumen estadistico de cobertura vegetal

summary(datos_plant_cover$canopy_cover)

# ------------------------------------------------------------
# 9. EXPORTAR RESULTADOS
# ------------------------------------------------------------

# Crear carpeta de resultados

dir.create("resultados", showWarnings = FALSE)

# Exportar frecuencia de especies

write_csv(
  frecuencia_especies,
  "resultados/frecuencia_especies.csv"
)

# Exportar riqueza de especies

write_csv(
  riqueza_sitios,
  "resultados/riqueza_sitios.csv"
)