# ============================================================
# PROYECTO: ANALISIS DE COMUNIDADES VEGETALES NEON
# Autor: Matias Rojas
# ============================================================

# SCRIPT 06: DICCIONARIO Y VALIDACION DE DATOS

# Objetivo:
# Construir un mini diccionario de variables y validar
# los registros de vegetacion mediante reglas de calidad.

# ------------------------------------------------------------
# 1. CARGAR LIBRERIAS
# ------------------------------------------------------------

library(readr)
library(dplyr)
library(tibble)


# ------------------------------------------------------------
# 2. CARGAR DATOS
# ------------------------------------------------------------

source("script/01_importar_datos.R")

dim(datos_plant_cover)

# ------------------------------------------------------------
# 3. CREAR MINI DICCIONARIO DE VARIABLES
# ------------------------------------------------------------

diccionario_neon <- tribble(
  ~variable,      ~tipo,       ~valores_esperados,
  "species",      "Texto",     "Nombre no vacio; NA no permitido",
  "lat",          "Numerica",  "Entre -90 y 90; NA no permitido",
  "canopy_cover", "Numerica",  "Entre 0 y 100%; NA no permitido"
)

# Mostrar diccionario
print(diccionario_neon)

# ------------------------------------------------------------
# 4. CREAR FUNCION DE VALIDACION
# ------------------------------------------------------------

validar_neon <- function(datos) {
  
  # Verificar que las tres columnas existan
  columnas <- c("species", "lat", "canopy_cover")
  
  if (!all(columnas %in% names(datos))) {
    stop("Faltan variables necesarias para validar.")
  }
  
  # Validar identificacion de especies
  especies_ok <- is.character(datos$species) &&
    all(!is.na(datos$species) &
          trimws(datos$species) != "")
  
  # Validar rango geografico de latitud
  latitud_ok <- is.numeric(datos$lat) &&
    all(is.finite(datos$lat) &
          datos$lat >= -90 &
          datos$lat <= 90)
  
  # Validar porcentaje de cobertura vegetal
  cobertura_ok <- is.numeric(datos$canopy_cover) &&
    all(is.finite(datos$canopy_cover) &
          datos$canopy_cover >= 0 &
          datos$canopy_cover <= 100)
  
  # Funcion para mostrar estado
  marca <- function(x) {
    if (isTRUE(x)) "OK" else "FALLA"
  }
  
  # Mostrar resultados
  cat("\nVALIDACION DE DATOS NEON\n")
  cat("-------------------------------\n")
  cat("Especies validas:    ", marca(especies_ok), "\n")
  cat("Latitud valida:     ", marca(latitud_ok), "\n")
  cat("Cobertura valida:   ", marca(cobertura_ok), "\n")
  
}

# ------------------------------------------------------------
# 5. EJECUTAR VALIDACION
# ------------------------------------------------------------

validar_neon(datos_plant_cover)

# ------------------------------------------------------------
# 6. CONTAR REGISTROS QUE NO CUMPLEN LAS REGLAS
# ------------------------------------------------------------

# Especies faltantes o vacias
sum(
  is.na(datos_plant_cover$species) |
    trimws(datos_plant_cover$species) == "",
  na.rm = TRUE
)

# Latitudes faltantes o fuera de rango
sum(
  !is.finite(datos_plant_cover$lat) |
    datos_plant_cover$lat < -90 |
    datos_plant_cover$lat > 90,
  na.rm = TRUE
)

# Coberturas faltantes o fuera de rango
sum(
  !is.finite(datos_plant_cover$canopy_cover) |
    datos_plant_cover$canopy_cover < 0 |
    datos_plant_cover$canopy_cover > 100,
  na.rm = TRUE
)

print(diccionario_neon)

validar_neon(datos_plant_cover)