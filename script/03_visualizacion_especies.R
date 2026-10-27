# ============================================================
# PROYECTO: ANALISIS DE COMUNIDADES VEGETALES NEON
# Autor: Matias Rojas
# Curso: Visualizacion y Analisis de Datos Medioambientales
# ============================================================

# SCRIPT 03: VISUALIZACION DE ESPECIES VEGETALES

# Objetivo:
# Representar la frecuencia relativa de presencia de
# las especies vegetales registradas en NEON.

# ------------------------------------------------------------
# 1. CARGAR LIBRERIAS
# ------------------------------------------------------------
##NOTA: en caso de no tener descargado las librerias, aplicar las siguientes lineas
#install.packages("dplyr")
#install.packages("readr")
#install.packages("ggplot2")

library(readr)
library(dplyr)
library(ggplot2)

# ------------------------------------------------------------
# 2. IMPORTAR DATOS
# ------------------------------------------------------------

source("script/01_importar_datos.R")

# ------------------------------------------------------------
# 3. IDENTIFICAR UNIDADES DE MUESTREO
# ------------------------------------------------------------

# Contar unidades de muestreo diferentes

n_unidades <- datos_plant_cover %>%
  filter(
    !is.na(sitename),
    sitename != "",
    !is.na(date)
  ) %>%
  distinct(sitename, date) %>%
  nrow()

# Mostrar resultado

print(n_unidades)

# ------------------------------------------------------------
# 4. CALCULAR FRECUENCIA RELATIVA DE ESPECIES
# ------------------------------------------------------------

frecuencia_relativa <- datos_plant_cover %>%
  
  # Excluir registros sin especie, sitio o fecha
  filter(
    !is.na(species),
    species != "",
    !is.na(sitename),
    sitename != "",
    !is.na(date)
  ) %>%
  
  # Evitar contar una especie varias veces en una misma unidad
  distinct(sitename, date, species) %>%
  
  # Contar las unidades donde aparece cada especie
  count(species, name = "n_presencias") %>%
  
  # Calcular porcentaje de unidades con presencia
  mutate(
    porcentaje = (n_presencias / n_unidades) * 100
  ) %>%
  
  # Ordenar desde la especie mas frecuente
  arrange(desc(porcentaje))

# Visualizar resultados

head(frecuencia_relativa, 15)

# ------------------------------------------------------------
# 5. SELECCIONAR LAS 15 ESPECIES MAS FRECUENTES
# ------------------------------------------------------------

top15_especies <- frecuencia_relativa %>%
  slice_max(
    order_by = porcentaje,
    n = 15,
    with_ties = FALSE
  )

# Revisar resultados
print(top15_especies)

# ------------------------------------------------------------
# 6. CREAR GRAFICO DE FRECUENCIA RELATIVA
# ------------------------------------------------------------

grafico_especies <- ggplot(
  top15_especies,
  aes(
    x = reorder(species, porcentaje),
    y = porcentaje
  )
) +
  
  # Crear barras
  geom_col(fill = "#3B8067", width = 0.7) +
  
  # Incorporar etiquetas de porcentaje
  geom_text(
    aes(label = paste0(round(porcentaje, 1), "%")),
    hjust = -0.15,
    size = 3.5
  ) +
  
  # Transformar barras verticales en horizontales
  coord_flip() +
  
  # Añadir espacio para las etiquetas
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.20))
  ) +
  
  # Titulos y nombres de ejes
  labs(
    title = "Especies vegetales mas frecuentes en NEON",
    subtitle = "Porcentaje de unidades de muestreo con presencia",
    x = "Especie vegetal",
    y = "Frecuencia relativa de presencia (%)",
    caption = "Fuente: National Ecological Observatory Network (NEON)"
  ) +
  
  # Aplicar estilo visual
  theme_minimal(base_size = 12) +
  
  theme(
    plot.title = element_text(face = "bold", size = 15),
    axis.text.y = element_text(size = 9),
    panel.grid.major.y = element_blank()
  )

# Mostrar grafico
print(grafico_especies)

# ------------------------------------------------------------
# 7. EXPORTAR FIGURA
# ------------------------------------------------------------

ggsave(
  filename = "figuras/01_frecuencia_relativa_especies.png",
  plot = grafico_especies,
  width = 12,
  height = 8,
  dpi = 300,
  bg = "white"
)