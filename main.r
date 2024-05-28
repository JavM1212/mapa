# Crear directorio de usuario para paquetes si no existe
dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)
.libPaths(Sys.getenv("R_LIBS_USER"))

# Función para instalar y cargar paquetes
install_if_missing <- function(packages) {
  new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) {
    install.packages(new.packages, lib = Sys.getenv("R_LIBS_USER"))
  }
  sapply(packages, require, character.only = TRUE)
}

packages <- c("ggplot2", "sf", "dplyr", "readxl")
install_if_missing(packages)

# Cargar las librerías
library(ggplot2)
library(sf)
library(dplyr)
library(readxl)

# Cargar los datos desde el archivo Excel
file_path <- "./base_de_datos.xlsx"
data <- read_excel(file_path)

# Mostrar la estructura de los datos
print(head(data))

# Limpiar y preparar los datos (agregar por provincia si es necesario)
data_provincia <- data %>%
  group_by(Provincia) %>%
  summarise(Count = n())

# # Cargar el shapefile de las provincias de Costa Rica
# shapefile_path <- "./shapefile/gadm41_CRI_3.shp"
# provincias_sf <- st_read(shapefile_path)

# # Mostrar los nombres de las columnas para identificar la columna correcta
# print(names(provincias_sf))

# # Asumiendo que la columna en el shapefile que contiene los nombres de las provincias es 'NAME_1'
# # Ajustar 'NAME_1' al nombre correcto de la columna en el shapefile
# map_data <- provincias_sf %>%
#   left_join(data_provincia, by = c("NAME_1" = "Provincia"))

# # Crear el mapa
# ggplot(data = map_data) +
#   geom_sf(aes(fill = Count), color = "black") +
#   scale_fill_viridis_c() +
#   theme_minimal() +
#   labs(title = "Mapa de Costa Rica por Provincia",
#        fill = "Cantidad")

# # Guardar el mapa en un archivo
# ggsave("mapa_costa_rica.png")
