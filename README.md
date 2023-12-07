# Antibiotic Usage in Livestock

## Overview
This interactive tool allows users to explore data on antibiotic usage across various countries over multiple years. This app provides visual insights through interactive tables and graphs. In an era where antibiotic resistance is a growing concern, understanding trends and patterns in antibiotic use in animal agriculture is critical.

## Features
- **Interactive Table**: Explore detailed data on antibiotic usage by country and year.
- **Bar Chart**: Visualize the comparison of antibiotic usage between countries.
- **Trend Line**: Observe the trend of antibiotic usage over the years for selected countries.
- **Summary Statistics**: View summary statistics of antibiotic usage for selected countries.
- **Data Download**: Download the filtered dataset for offline analysis.
- **Search Function**: Search for specific countries to filter the data.
- **Interactive Data Points**: Hover over data points in the bar chart and line chart for detailed information.

## Data Source
The data used in this app is sourced from the open datasets provided by the [Our World in Data](https://github.com/owid/owid-datasets/tree/master/datasets/Antibiotic%20use%20in%20livestock%20-%20European%20Commission%20%26%20Van%20Boeckel%20et%20al.) project, specifically the dataset on antibiotic usage in livestock by the European Commission & Van Boeckel et al.

The data is filtered to exclude countries with only a single year of data to enable analysis of trends over time. I looked at countries with multiple data points across years to allow for a more accurate assessment of changes in antibiotic usage.

## Shiny App Links
- **Assignment B3**: [Shiny App: AntibioticUse](https://jambackward.shinyapps.io/AntibioticUse/)
- **Assignment B4**: [Shiny App: AntibioticUse_B4](https://jambackward.shinyapps.io/AntibioticUse_B4appUpdated/)

## How to Use
- Select one or more countries from the dropdown menu to display the corresponding data.
- Use the search bar to find specific countries quickly.
- Navigate through the tabs to view the data in table format or as bar or line charts.
- Hover over data points in the bar chart and line chart for detailed information.
- Use the 'Summary Statistics' tab to view summary statistics of antibiotic usage.
- Use the 'Download Data' tab to download the currently viewed data as a CSV file.

## Repository Contents
- `AntibioticsUse/`: A folder containing the `app.R` script which is the source code for the Shiny app.
- `Antibiotic Use in Livestock.Rproj`: An R project file for easy setup in RStudio.
- `Antibiotic use in livestock - European Commission & Van Boeckel et al..csv`: The dataset used for the app.
- `README.md`: This file, providing an overview and instructions for the app.

For Assignment B4, the app has been enhanced with a new 'Summary Statistics' tab, allowing users to view summary statistics of antibiotic usage for the selected countries. Users can also search for specific countries using the search bar for a more efficient data selection process. Additionally, the app provides an interactive experience with detailed pop-ups when hovering over data points in the bar chart and line chart.

