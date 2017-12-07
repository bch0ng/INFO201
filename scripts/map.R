# Sets up libraries
library(dplyr)
library(highcharter)

#' Takes in a dataframe, sex, and range of values, and returns a world map 
#' of the given dataframe.
#' 
#' @param df            A dataframe
#' @param print.sex     Sex of 'Boys', 'Girls', or 'Boys and Girls'
#' @param data.range    Sequenced values from minimum to maximum of each sex's avg.change
#' @return              A world map visualization of countries, sex, and their avg.change
CreateHCMap <- function(df, print.sex, data.range) {
  map <- hcmap("custom/world-robinson-highres", data = df,
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
                text = '<strong>Note:</strong> Some of the countries, whose data are not available, are whited out on the map.<br />'
    )
  return(map)
}
