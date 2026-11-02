# ============================================================
# PROYECTO: ANALISIS DE COMUNIDADES VEGETALES NEON
# Autor: Matias Rojas
# ============================================================

# SCRIPT 05: MODELOS AGRUPADOS CON NEST Y MAP

# Objetivo:
# Explorar la relacion entre riqueza vegetal y latitud
# mediante modelos lineales agrupados por año.


# ------------------------------------------------------------
# 1. CARGAR LIBRERIAS
# ------------------------------------------------------------

library(readr)
library(dplyr)
library(tidyr)
library(purrr)
library(broom)
library(ggplot2)


# ------------------------------------------------------------
# 2. IMPORTAR DATOS
# ------------------------------------------------------------

source("script/01_importar_datos.R")

# ------------------------------------------------------------
# 3. CALCULAR RIQUEZA POR UNIDAD DE MUESTREO
# ------------------------------------------------------------

riqueza_unidades <- datos_plant_cover %>%
  
  # Eliminar registros sin informacion necesaria
  filter(
    !is.na(species),
    trimws(species) != "",
    !is.na(sitename),
    trimws(sitename) != "",
    !is.na(date),
    is.finite(lat),
    between(lat, -90, 90)
  ) %>%
  
  # Crear identificadores de sitio y año
  mutate(
    sitio_neon = sub("_.*$", "", sitename),
    anio = as.integer(format(date, "%Y"))
  ) %>%
  
  # Agrupar por unidad de muestreo y fecha
  group_by(anio, sitio_neon, sitename, date) %>%
  
  # Calcular riqueza
  summarise(
    riqueza = n_distinct(species),
    latitud = median(lat),
    .groups = "drop"
  )

# Mostrar resultados
head(riqueza_unidades)

# ------------------------------------------------------------
# 4. RESUMIR RIQUEZA POR SITIO Y AÑO
# ------------------------------------------------------------

riqueza_sitios <- riqueza_unidades %>%
  
  group_by(anio, sitio_neon) %>%
  
  summarise(
    riqueza_mediana = median(riqueza),
    latitud = median(latitud),
    n_unidades = n_distinct(sitename),
    .groups = "drop"
  ) %>%
  
  # Conservar sitios con al menos 5 unidades distintas
  filter(n_unidades >= 5)

# Visualizar los resultados
head(riqueza_sitios)

# ------------------------------------------------------------
# 5. SELECCIONAR GRUPOS PARA LOS MODELOS
# ------------------------------------------------------------

datos_modelos <- riqueza_sitios %>%
  
  group_by(anio) %>%
  
  filter(
    n() >= 6,
    n_distinct(latitud) >= 3,
    n_distinct(riqueza_mediana) >= 2
  ) %>%
  
  ungroup()

# Revisar cuantos sitios tenemos por año
datos_modelos %>%
  count(anio, name = "n_sitios")

# ------------------------------------------------------------
# 6. AGRUPAR Y ANIDAR DATOS POR AÑO
# ------------------------------------------------------------

datos_anidados <- datos_modelos %>%
  
  group_by(anio) %>%
  
  nest() %>%
  
  ungroup()

# Mostrar estructura
print(datos_anidados)

# ------------------------------------------------------------
# 7. AJUSTAR MODELOS LINEALES POR AÑO
# ------------------------------------------------------------

# Crear funcion para ajustar el modelo
ajustar_modelo <- function(datos) {
  
  lm(
    riqueza_mediana ~ latitud,
    data = datos
  )
  
}

# Aplicar la funcion a cada grupo
modelos_neon <- datos_anidados %>%
  
  mutate(
    modelo = map(data, ajustar_modelo)
  )

# Mostrar modelos generados
print(modelos_neon)

# ------------------------------------------------------------
# 8. EXTRAER COEFICIENTES DE LOS MODELOS
# ------------------------------------------------------------

coeficientes_neon <- modelos_neon %>%
  
  mutate(
    coeficientes = map(modelo, tidy)
  ) %>%
  
  select(anio, coeficientes) %>%
  
  unnest(coeficientes)

# Mostrar los coeficientes
print(coeficientes_neon, n = Inf)

# ------------------------------------------------------------
# 9. EXTRAER ESTADISTICOS DE AJUSTE
# ------------------------------------------------------------

ajustes_neon <- modelos_neon %>%
  
  mutate(
    ajuste = map(modelo, glance)
  ) %>%
  
  select(anio, ajuste) %>%
  
  unnest(ajuste)

# Mostrar resultados
print(ajustes_neon, n = Inf)

# ------------------------------------------------------------
# 10. RESUMEN FINAL DE LOS MODELOS
# ------------------------------------------------------------

# Extraer pendientes
pendientes <- coeficientes_neon %>%
  
  filter(term == "latitud") %>%
  
  transmute(
    anio,
    pendiente = round(estimate, 3),
    p_valor = round(p.value, 4)
  )

# Extraer indicadores generales
indicadores <- ajustes_neon %>%
  
  transmute(
    anio,
    r2 = round(r.squared, 3)
  )

# Unir ambas tablas
resultados_modelos <- pendientes %>%
  
  left_join(indicadores, by = "anio") %>%
  
  arrange(anio)

# Mostrar resultados finales
print(resultados_modelos, n = Inf)

# ------------------------------------------------------------
# 11. VISUALIZAR LOS MODELOS
# ------------------------------------------------------------

grafico_modelos <- ggplot(
  datos_modelos,
  aes(x = latitud, y = riqueza_mediana)
) +
  
  geom_point(
    color = "#357A65",
    size = 2,
    alpha = 0.7
  ) +
  
  geom_smooth(
    method = "lm",
    se = FALSE,
    color = "#1E485C"
  ) +
  
  facet_wrap(~anio) +
  
  labs(
    title = "Relacion entre riqueza vegetal y latitud",
    subtitle = "Modelos lineales independientes por año",
    x = "Latitud (grados decimales)",
    y = "Riqueza mediana de especies",
    caption = "Fuente: Datos NEON. Analisis exploratorio."
  ) +
  
  theme_minimal(base_size = 12)

# Mostrar figura
print(grafico_modelos)

# ------------------------------------------------------------
# 12. EXPORTAR RESULTADOS
# ------------------------------------------------------------

# Crear carpetas si no existen
dir.create("resultados", showWarnings = FALSE)
dir.create("figuras", showWarnings = FALSE)

# Exportar tabla
write_csv(
  resultados_modelos,
  "resultados/modelos_riqueza_latitud.csv"
)

# Exportar figura
ggsave(
  "figuras/05_modelos_riqueza_latitud.png",
  plot = grafico_modelos,
  width = 12,
  height = 7,
  dpi = 300
)

