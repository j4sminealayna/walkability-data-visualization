# Walkability Index Data Visualization

This project analyzes the distribution of walkable neighborhoods across the United States using the EPA National Walkability Index. The goal is to explore how access to walkable environments varies across states and regions and who benefits from those environments.

Using R and data visualization techniques, the project examines three key questions:

- Which states have the highest and lowest population-weighted walkability scores?
- What share of residents live in the most vs least walkable neighborhoods?
- How do walkability scores vary across U.S. Census regions?

The analysis uses data from the EPA Smart Location Database and visualizes patterns using choropleth maps, stacked bar charts, and regional boxplots. 
## Tools Used

- R
- dplyr
- ggplot2
- readr
- maps
- Excel

## Dataset

This project uses the **EPA Smart Location Database**, a nationwide dataset that contains built-environment, demographic, and transportation indicators for every U.S. Census block group.

The database includes variables related to land-use diversity, residential density, street network design, accessibility to destinations, transit access, and employment characteristics.

Dataset source:
https://catalog.data.gov/dataset/smart-location-database8

## Key Insights

- Walkability is unevenly distributed across the U.S., with higher scores concentrated in the Northeast and West Coast.
- Many states contain small pockets of highly walkable areas but large populations in car-dependent neighborhoods.
- Regional analysis shows the Northeast has the highest typical walkability while the South contains many of the lowest-scoring areas.
