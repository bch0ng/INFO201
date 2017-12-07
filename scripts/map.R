# Set up libraries
library(shiny)
library(dplyr)
library(plotly)
library(tidyr)
library(highcharter)

# read the data of average change in education rates 
df <- read.csv('data/abcd.csv', stringsAsFactors = FALSE)

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

CreateHCMap <- function(data, print.sex, data.range) {
  map <- hcmap("custom/world-robinson-lowres", data = data,
               name = "Avg Rate Change in %", value = "avg.change", joinBy = c("name", "Country"),
               borderColor = "transparent") %>%
    hc_colorAxis(dataClasses = color_classes(data.range)) %>% 
    hc_legend(layout = "vertical", align = "right",
              floating = FALSE, valueDecimals = 1, valueSuffix = "%") %>%
    hc_mapNavigation(enabled = TRUE, 
                     enableMouseWheelZoom = TRUE, 
                     mouseWheelSensitivity = 1.05,
                     enableDoubleClickZoomTo = TRUE) %>% 
    hc_title(text = paste0('Average Change in Primary Education Rate for ', print.sex, ' 1990-2014')) %>% 
    hc_subtitle(align = 'center',
                useHTML = TRUE,
                text = '<strong>Note<sub>1</sub>:</strong> Some of the countries, whose data are not available, are greyed out on the map.<br />
                <strong>Note<sub>2</sub>:</strong> Click on the legend to show/hide corresponding countries.<br />
                <strong>Note<sub>3</sub>:</strong> Please be patient when loading different gender data.'
    )
  return(map)
}
