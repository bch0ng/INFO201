# Setting up libraries
library(shiny)
library(dplyr)
library(plotly)
library(tidyr)
source('education_completed_data_wrangling.R')

# Reading in the data and formatting it to be more accessible
both.sex <- FormatData(read.csv('../data/DisplayByIndicator.csv', stringsAsFactors = FALSE))
boys <- FormatData(read.csv('../data/Completion_boys.csv', stringsAsFactors = FALSE))
girls <- FormatData(read.csv('../data/Completion_girls.csv', stringsAsFactors = FALSE))
# Transposing the data
both.sex.transpose <- TransposeData(both.sex)
avg.change <- CalculateAvgChange(both.sex.transpose)
both.sex$avg.change <- avg.change
both.sex.no.na <- RemoveNA(both.sex)
# Arranged for most positive/negative change to be the top-most value
# both.sex.neg.change <- both.sex %>%
#                         filter(avg.change < 0) %>% 
#                         arrange(avg.change)
# both.sex.pos.change <- both.sex %>%
#                         filter(avg.change >= 0) %>% 
#                         arrange(desc(avg.change))

# Primary completion in 2013

shinyServer(function(input, output) {
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
  
})

