# Setting up libraries
library(shiny)
library(dplyr)
library(plotly)
library(tidyr)
source('education_completed_data_wrangling.R')
source('map.R')

# Reading in the data and formatting it to be more accessible
both.sex <- FormatData(read.csv('../data/DisplayByIndicator.csv', stringsAsFactors = FALSE))
# Transposing the data
both.sex.transpose <- TransposeData(both.sex)
avg.change <- CalculateAvgChange(both.sex.transpose)
both.sex$avg.change <- avg.change
both.sex.no.na <- RemoveNA(both.sex)
# Arranged for most positive/negative change to be the top-most value
both.sex.neg.change <- both.sex %>%
                        filter(avg.change < 0) %>% 
                        arrange(avg.change)
both.sex.pos.change <- both.sex %>%
                        filter(avg.change >= 0) %>% 
                        arrange(desc(avg.change))

shinyServer(function(input, output) {
  output$plot <- renderPlotly({
    ggplotly(p)
  })
  
  
})

