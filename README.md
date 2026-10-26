# Patrones espaciales de composición, riqueza y cobertura vegetal: análisis exploratorio con datos NEON
**Autor:** Matías Rojas  
**Institución:** Pontificia Universidad Católica de Chile (UC)  
**Curso:** Visualización y Análisis de Datos Medioambientales.
**Área de estudio:** Ecología vegetal y visualización de datos espaciales.

---

## 1. Introducción

La distribución espacial de las especies vegetales constituye un componente fundamental para comprender la organización y variabilidad de las comunidades vegetales. La composición florística, riqueza de especies y cobertura vegetal representan atributos ecológicos que permiten caracterizar las comunidades y explorar sus diferencias a lo largo de gradientes geográficos y ambientales.

En este contexto, el análisis de datos ecológicos georreferenciados permite identificar patrones de distribución de especies, reconocer diferencias entre localidades y representar espacialmente las características de la vegetación.

El presente proyecto tiene como propósito desarrollar un **análisis exploratorio de datos de comunidades vegetales**, utilizando información obtenida del **National Ecological Observatory Network (NEON)**, una plataforma de monitoreo ecológico de acceso abierto.

Mediante el lenguaje de programación **R** y el entorno **RStudio**, se busca explorar, procesar y visualizar información relacionada con la composición de especies, riqueza vegetal y cobertura, considerando su distribución espacial.

Este trabajo corresponde a una actividad académica del curso de Visualización y Análisis de Datos Medioambientales de la Pontificia Universidad Católica de Chile.

---

## 2. Objetivos

### 2.1. Objetivo general

Caracterizar de manera exploratoria la composición de especies, riqueza y cobertura vegetal, así como su distribución espacial, a partir de registros de vegetación de NEON mediante técnicas de procesamiento y visualización de datos en RStudio.

### 2.2. Objetivos específicos

1. **Explorar y caracterizar la base de datos**, identificando las principales variables ecológicas, espaciales y temporales disponibles.

2. **Describir la composición florística** de los registros analizados, identificando las especies presentes y sus frecuencias de aparición.

3. **Evaluar exploratoriamente la variación de la riqueza y cobertura vegetal** entre los sitios o unidades de muestreo disponibles.

4. **Representar espacialmente la distribución de los registros vegetales**, utilizando las coordenadas geográficas proporcionadas por la base de datos.

5. **Desarrollar visualizaciones gráficas y espaciales reproducibles**, que permitan comunicar e interpretar los principales patrones observados.

---

## 3. Preguntas exploratorias

El análisis se orienta a responder las siguientes preguntas:

- ¿Cuáles son las especies vegetales registradas con mayor frecuencia en la base de datos?

- ¿Cómo varía la riqueza de especies entre los distintos sitios o unidades de muestreo?

- ¿Qué diferencias se observan en los valores de cobertura vegetal entre las especies registradas?

- ¿Existen patrones espaciales identificables en la distribución de las especies vegetales?

- ¿Cómo se distribuyen geográficamente los registros de vegetación disponibles?

Estas preguntas tienen un carácter exploratorio y buscan identificar patrones descriptivos, sin establecer necesariamente relaciones causales.

---

## 4. Diccionario preliminar de datos

La base de datos utilizada contiene registros de vegetación acompañados de información taxonómica, espacial y temporal.

A continuación, se presentan las principales variables consideradas para el análisis.

### 4.1. Variables originales
| Variable       | Tipo     | Qué representa                                     | Ejemplo                    |
| -------------- | -------- | -------------------------------------------------- | -------------------------- |
| `species`      | Texto    | Nombre científico de la especie vegetal registrada | *Galactia elliottii* Nutt. |
| `lat`          | Numérica | Latitud de la parcela                              | `28.058282`                |
| `lon`          | Numérica | Longitud de la parcela                             | `-81.402874`               |
| `sitename`     | Texto    | Identificador del sitio, parcela y subparcela      | `DSNY_DSNY_017_32.4.1`     |
| `date`         | Fecha    | Fecha en que se realizó el muestreo                | `2019-11-04`               |
| `canopy_cover` | Numérica | Porcentaje de cobertura de esa especie             | `5`, `2`, `0.5`, etc.      |
| `uid`          | Texto    | Identificador único de cada registro               | `a3c11564-d4a2...`         |

---

## 5. Fuente de datos

### 5.1. Procedencia

Los datos utilizados en este proyecto fueron obtenidos del **National Ecological Observatory Network (NEON)**.

NEON es una infraestructura de observación ecológica de Estados Unidos que recopila y publica información sobre biodiversidad, vegetación, suelos, clima y otros componentes de los ecosistemas.

La información se encuentra disponible públicamente y puede utilizarse para investigaciones científicas, actividades educativas y ejercicios de análisis de datos.

**Institución:** National Ecological Observatory Network (NEON).

**Portal oficial:** https://www.neonscience.org/

**Repositorio de datos:** https://data.neonscience.org/

---

## 6. Referencias y recursos

**National Ecological Observatory Network (NEON).**

Portal institucional:  
https://www.neonscience.org/

Portal de datos:  
https://data.neonscience.org/

Producto de referencia preliminar:  
https://data.neonscience.org/data-products/DP1.10058.001

Guía oficial de citación:  
https://www.neonscience.org/data/guidelines-policies/citing
