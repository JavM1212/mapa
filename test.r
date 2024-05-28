library(sf)

# Lee el shapefile
provincias_sf <- st_read("./shapefile/gadm41_CRI_2.shp")

# Muestra las primeras filas de los datos
head(provincias_sf)

# Muestra los nombres de las columnas
colnames(provincias_sf)
