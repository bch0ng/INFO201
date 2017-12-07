# Set up libraries
library(dplyr)
library(highcharter)

# Creates a world map of given dataset
CreateHCMap <- function(df, print.sex, data.range) {
  map <- hcmap("custom/world-robinson-lowres", data = df,
               name = "Avg Rate Change in %", value = "avg.change", joinBy = c("name", "Country"),
               borderColor = "transparent") %>%
    hc_colorAxis(dataClasses = color_classes(data.range)) %>% 
    hc_legend(layout = "vertical", 
              align = "right", 
              navigation = TRUE, 
              title = list(text = HTML('Average Rate Change<br />
                                       (Click on options<br />
                                        below to show/hide)')),
              floating = FALSE, 
              valueDecimals = 1, 
              valueSuffix = "%") %>%
    hc_mapNavigation(enabled = TRUE, 
                     enableMouseWheelZoom = TRUE, 
                     mouseWheelSensitivity = 1.05,
                     enableDoubleClickZoomTo = TRUE) %>% 
    hc_title(text = paste0('Average Change in Primary Education Rate for ', print.sex, ' 1990-2014'),
              style = list(color = '#466551', fontSize = '16pt')) %>% 
    hc_subtitle(align = 'center',
                useHTML = TRUE,
                style = list(color = '#466551'),
                text = '<strong>Note<sub>1</sub>:</strong> Some of the countries, whose data are not available, are greyed out on the map.<br />
                <strong>Note<sub>2</sub>:</strong> Please be patient when loading different gender data.'
    )
  return(map)
}
