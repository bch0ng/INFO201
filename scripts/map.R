# Set up libraries
library(shiny)
library(dplyr)
library(plotly)
library(tidyr)

# read the data of average change in education rates 
df <- read.csv('./../data/abcd.csv', stringsAsFactors = FALSE)

# light grey boundaries
l <- list(color = toRGB('grey'), width = 0.5)

# specify map format
g <- list(
  showframe = F,
  showcoastlines = F,
  projection = list(type = 'Mercator')
)

# render map
p <- plot_geo(df) %>%
  add_trace(
    z = ~avg.change, color = ~avg.change, colors = 'Purples',
    text = ~country.name, locations = ~country.three.letter.code, marker = list(line = l)) %>%
  colorbar(title = 'Average change in \n primary education rate\n 1990 - 2014', limits = c(-3, 5)) %>%
  layout(
    title = 'Average Change of Education Rate Around the World from 1990 to 2014',
    geo = g
  )

p
