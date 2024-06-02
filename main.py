
import geopandas as gpd
import pandas as pd
import matplotlib.pyplot as plt

# Rutas de los archivos
shapefile_path = "./shapefile/gadm41_CRI_1.shp"
data_path = "./base_de_datos.xlsx"

# Cargar el shapefile usando GeoPandas
gdf = gpd.read_file(shapefile_path)

# Asegurarse de que los nombres de las provincias estén en mayúsculas y sin espacios
gdf['NAME_1'] = gdf['NAME_1'].str.strip().str.upper()

# Mostrar las primeras filas del GeoDataFrame para identificar las columnas
print(gdf.head())

# Cargar el archivo de datos usando Pandas
data_df = pd.read_excel(data_path, sheet_name='Base de datos')

# Asegurarse de que los nombres de las provincias en el archivo de datos coincidan
data_df['Provincia'] = data_df['Provincia'].str.strip().str.upper()

# Mostrar las primeras filas del DataFrame para identificar las columnas
print(data_df.head())

# Calcular la distribución de sexo por provincia
sex_distribution = data_df.groupby(['Provincia', 'Sexo'])['Población '].sum().unstack().fillna(0)

# Asegurarse de que los nombres de las provincias en el shapefile coincidan con los del DataFrame
sex_distribution.index = sex_distribution.index.str.upper()

# Unir los DataFrames usando las columnas correctas
merged_df = gdf.merge(sex_distribution, left_on='NAME_1', right_index=True)

# Crear el mapa
fig, ax = plt.subplots(1, 1, figsize=(15, 15))
gdf.plot(ax=ax, color='white', edgecolor='black')

# Plot each province with its sex distribution
for idx, row in merged_df.iterrows():
    ax.annotate(text=f"F: {int(row['Femenino'])}\nM: {int(row['Masculino'])}", 
                xy=(row.geometry.centroid.x, row.geometry.centroid.y),
                ha='center', fontsize=8, bbox=dict(facecolor='white', alpha=0.5, boxstyle='round,pad=0.5'))

# Ajustar los límites del eje para hacer zoom
ax.set_xlim([-86, -82])  # Ajusta estos valores según la región de interés
ax.set_ylim([8, 11.5])  # Ajusta estos valores según la región de interés

plt.title('Mapa de Costa Rica por Provincia con Distribución de Sexo')
plt.show()
