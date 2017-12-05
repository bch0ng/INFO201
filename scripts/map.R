# Set up libraries
library(shiny)
library(dplyr)
library(plotly)
library(tidyr)
library(xlsx)
 
df <- read.csv('./../data/abcd.csv', stringsAsFactors = FALSE)
View(df)

# light grey boundaries
l <- list(color = toRGB('grey'), width = 0.5)

# specify map format
g <- list(
  showframe = F,
  showcoastlines = F,
  projection = list(type = 'Mercator')
)

min(df$avg.change)
max(df$avg.change)
median(df$avg.change)

p <- plot_geo(df) %>%
  add_trace(
    z = ~avg.change, color = ~avg.change, colors = 'Blues',
    text = ~country.name, locations = ~country.three.letter.code, marker = list(line = l)
  ) %>%
  colorbar(title = 'Average change in primary educaiton rate 1990 - 2014', limits = c(-3, 5)) %>%
  layout(
    title = 'Average Change of Education Rate Around the World from 1990 to 2014',
    geo = g
  )

p

# mapbox api token: pk.eyJ1IjoiamVleWF3biIsImEiOiJjamFyYXUyYnIxOXJ4MzNwZnF1dGM4ejE4In0.4RjG8TJVaGmjhAG2We6MBA

# Sys.setenv("plotly_username"="jeeyawn")
# Sys.setenv("plotly_api_key"="pk.eyJ1IjoiamVleWF3biIsImEiOiJjamFyYXUyYnIxOXJ4MzNwZnF1dGM4ejE4In0.4RjG8TJVaGmjhAG2We6MBA")