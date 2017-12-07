# Sets up libraries and sources
library(shiny)
library(dplyr)
library(plotly)
library(tidyr)
source('scripts/education_completed_data_wrangling.R')
source('scripts/map.R')
source('scripts/completion_scatter.R')

# Reading in the data and formatting it to be more accessible
both.sex <- FormatData(read.csv('data/DisplayByIndicator.csv', stringsAsFactors = FALSE))
boys <- FormatData(read.csv('data/Completion_boys.csv', stringsAsFactors = FALSE))
girls <- FormatData(read.csv('data/Completion_girls.csv', stringsAsFactors = FALSE))

# Transposes the data and Calculates the average change of each country from given years
both.sex$avg.change <- CalculateAvgChange(TransposeData(both.sex))
girls$avg.change <- CalculateAvgChange(TransposeData(girls))
boys$avg.change <- CalculateAvgChange(TransposeData(boys))

# Removes the countries who have NA value for average change
RemoveNA(both.sex)
RemoveNA(boys)
RemoveNA(girls)

shinyServer(function(input, output) {
  # Interactive map showing average change in primary school completion per 
  # country over given years
  output$map <- renderHighchart2({
    print.sex <- ''
    data.range <- vector()
    if (input$map.sex == 'both.sex') {
      print.sex <- 'Boys and Girls'
      data.range <- c(seq(-3, 5, by = 1), 30)
    } else if (input$map.sex == 'boys') {
      print.sex <- paste0(toupper(substr(input$map.sex, 1, 1)), 
                          substr(input$map.sex, 2, nchar(input$map.sex)))
      data.range <- c(seq(-9, 6, by = 1), 25)
    } else {
      print.sex <- paste0(toupper(substr(input$map.sex, 1, 1)), 
                          substr(input$map.sex, 2, nchar(input$map.sex)))
      data.range <- c(seq(-3, 8, by = 1), 30)
    }
    return(CreateHCMap(get(input$map.sex), print.sex, data.range))
  })
  
  # Scatter plot for each country's primary completion rate over given year
  output$scatter.plot <- renderPlotly({
    sex <- input$scatter.sex
    country <- input$scatter.country
    return(Scatter(country, sex))
  })
  
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
    else if(input$arrange.by == 3) {
      data.arrange <- data.arrange %>% arrange(Country)
    }
    colnames(data.arrange)[2] <- 'Primary School Completion Rate in 2013'
    return(data.arrange)
  })
})