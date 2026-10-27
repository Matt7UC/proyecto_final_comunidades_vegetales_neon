# ============================================================
# PROYECTO: ANALISIS DE COMUNIDADES VEGETALES NEON
# Autor: Matias Rojas
# ============================================================

# SCRIPT 04: DISTRIBUCION ESPACIAL DE RIQUEZA VEGETAL

# Objetivo:
# Explorar la distribucion geografica de la riqueza
# de especies vegetales entre sitios de monitoreo NEON.

#NOTA: si no se tiene la funcion maps, ejecutar la siguientes lineas
#install.packages("maps")

# ------------------------------------------------------------
# 1. CARGAR LIBRERIAS
# ------------------------------------------------------------

library(readr)
library(dplyr)
library(ggplot2)
library(maps)

# ------------------------------------------------------------
# 2. IMPORTAR DATOS
# ------------------------------------------------------------

source("script/01_importar_datos.R")

# ------------------------------------------------------------
# 3. PREPARAR DATOS ESPACIALES
# ------------------------------------------------------------

datos_espaciales <- datos_plant_cover %>%
  filter(
    !is.na(species),
    trimws(species) != "",
    !is.na(sitename),
    trimws(sitename) != "",
    !is.na(date),
    is.finite(lat),
    is.finite(lon),
    between(lat, -90, 90),
    between(lon, -180, 180)
  ) %>%
  mutate(
    sitio_neon = sub("_.*$", "", sitename)
  )

# Revisar las primeras observaciones
head(datos_espaciales)

# ------------------------------------------------------------
# 4. CALCULAR RIQUEZA POR UNIDAD DE MUESTREO
# ------------------------------------------------------------

riqueza_unidades <- datos_espaciales %>%
  group_by(sitio_neon, sitename, date) %>%
  summarise(
    riqueza = n_distinct(species),
    lat = median(lat),
    lon = median(lon),
    .groups = "drop"
  )

# Mostrar primeros resultados
head(riqueza_unidades)

# ------------------------------------------------------------
# 5. RESUMIR RIQUEZA POR SITIO NEON
# ------------------------------------------------------------

riqueza_neon <- riqueza_unidades %>%
  group_by(sitio_neon) %>%
  summarise(
    riqueza_mediana = median(riqueza),
    n_unidades = n(),
    lat = median(lat),
    lon = median(lon),
    .groups = "drop"
  )

# Ordenar sitios segun riqueza mediana
riqueza_neon <- riqueza_neon %>%
  arrange(desc(riqueza_mediana))

# Visualizar resultados
print(riqueza_neon)

# ------------------------------------------------------------
# 6. CREAR MAPA DE RIQUEZA VEGETAL
# ------------------------------------------------------------

# Obtener mapa base
mapa_base <- ggplot2::map_data("world")

# Construir figura
mapa_riqueza <- ggplot() +
  
  # Dibujar limites geograficos
  geom_polygon(
    data = mapa_base,
    aes(x = long, y = lat, group = group),
    fill = "#F1F3F2",
    color = "grey75",
    linewidth = 0.2
  ) +
  
  # Representar sitios NEON
  geom_point(
    data = riqueza_neon,
    aes(
      x = lon,
      y = lat,
      color = riqueza_mediana,
      size = n_unidades
    ),
    alpha = 0.85
  ) +
  
  # Delimitar area geografica
  coord_quickmap(
    xlim = c(-170, -60),
    ylim = c(15, 75),
    expand = FALSE
  ) +
  
  # Escala de color
  scale_color_viridis_c(
    option = "C",
    name = "Riqueza mediana\n(especies)"
  ) +
  
  # Escala de tamaño
  scale_size_continuous(
    range = c(2, 8),
    name = "Unidades y fechas\nmuestreadas"
  ) +
  
  # Titulos
  labs(
    title = "Distribucion espacial de la riqueza vegetal",
    subtitle = "Riqueza mediana por sitio de monitoreo NEON",
    x = "Longitud",
    y = "Latitud",
    caption = "Fuente: Elaboracion propia a partir de datos NEON"
  ) +
  
  # Estilo
  theme_minimal(base_size = 12) +
  
  theme(
    plot.title = element_text(
      face = "bold",
      size = 16
    ),
    plot.subtitle = element_text(
      size = 11
    ),
    panel.grid.minor = element_blank(),
    legend.position = "right"
  )

# Mostrar mapa
print(mapa_riqueza)

# ------------------------------------------------------------
# 7. EXPORTAR MAPA
# ------------------------------------------------------------

ggsave(
  filename = "figuras/02_mapa_riqueza_neon.png",
  plot = mapa_riqueza,
  width = 13,
  height = 8,
  dpi = 300,
  bg = "white"
)