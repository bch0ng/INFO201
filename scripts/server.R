# Setting up libraries
library(shiny)
library(dplyr)
library(plotly)
library(tidyr)
source('education_completed_data_wrangling.R')
source('map.R')
source('completion_scatter.R')

# require(devtools)
# install_github('rCharts', 'ramnathv')

# Reading in the data and formatting it to be more accessible
both.sex <- FormatData(read.csv('../data/DisplayByIndicator.csv', stringsAsFactors = FALSE))
boys <- FormatData(read.csv('../data/Completion_boys.csv', stringsAsFactors = FALSE))
girls <- FormatData(read.csv('../data/Completion_girls.csv', stringsAsFactors = FALSE))

boys$avg.change <- CalculateAvgChange(TransposeData(boys))
boys <- boys %>% 
          filter(!is.na(avg.change))
girls$avg.change <- CalculateAvgChange(TransposeData(girls))
girls <- girls %>% 
          filter(!is.na(avg.change))
# Transposing the data
both.sex.transpose <- TransposeData(both.sex)
avg.change <- CalculateAvgChange(both.sex.transpose)
both.sex$avg.change <- avg.change
both.sex <- both.sex %>% 
              filter(!is.na(avg.change))
#both.sex.no.na <- RemoveNA(both.sex)
# Arranged for most positive/negative change to be the top-most value
# both.sex.neg.change <- both.sex %>%
#                         filter(avg.change < 0) %>% 
#                         arrange(avg.change)
# both.sex.pos.change <- both.sex %>%
#                         filter(avg.change >= 0) %>% 
#                         arrange(desc(avg.change))

# Primary completion in 2013
shinyServer(function(input, output, session) {
  # Table for primary completion rate in 2013
  output$table <- renderTable({
    data <- both.sex
    if (input$sex == 2)
      data <- boys
    else if (input$sex == 3)
      data <- girls
    data.arrange <- data %>% 
      select(Country, X2013) %>% 
      filter(X2013 > input$table.max[1] & X2013 < input$table.max[2]) %>% 
      na.exclude() %>% 
      arrange(X2013)
    if (input$arrange.by == 1)
      data.arrange <- data.arrange %>% 
      arrange(desc(X2013))
    colnames(data.arrange)[2] <- 'Primary School Completion Rate in 2013'
    return(data.arrange)
  })
  
  # render map
  # output$map <- renderPlotly({
  #   ggplotly(p)
  # })
  
  output$map <- renderHighchart2({
    print.sex <- ''
    data.range <- vector()
    if (input$map.sex == 'both.sex') {
      print.sex <- 'Boys and Girls'
      data.range <- c(seq(-3, 5, by = 1), 30)
    } else if (input$map.sex == 'boys') {
      print.sex <- paste0(toupper(substr(input$map.sex, 1, 1)), substr(input$map.sex, 2, nchar(input$map.sex)))
      data.range <- c(seq(-9, 6, by = 1), 25)
    } else {
      print.sex <- paste0(toupper(substr(input$map.sex, 1, 1)), substr(input$map.sex, 2, nchar(input$map.sex)))
      data.range <- c(seq(-3, 8, by = 1), 30)
    }
    map <- hcmap("custom/world-robinson-lowres", data = get(input$map.sex),
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
  })
  # render table
  output$scatter.table <- renderPlotly({
    sex <- input$scatter.sex
    country <- input$scatter.country
    return(Scatter(country, sex))
  })
})