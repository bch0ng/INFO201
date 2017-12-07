library(dplyr)
library(plotly)
library(shiny)


source("education_completed_data_wrangling.R")

girls.completion <- FormatData(read.csv('../data/Completion_girls.csv', stringsAsFactors = FALSE))
boys.completion <- FormatData(read.csv('../data/Completion_boys.csv', stringsAsFactors = FALSE))
both.completion <- FormatData(read.csv('../data/Completion_both.csv', stringsAsFactors = FALSE))

#For ui.R dropdown
dropdown.choices <- both.completion$Country

GetAllCountriesAvg <- function(sex) {
  if (sex == "girls") {
    data <- girls.completion
  } else if (sex == "boys") {
    data <- boys.completion
  } else {
    data <- both.completion
  }
  all.data <- data[c(3:length(data))] %>% 
    summarize_all(funs(mean(., na.rm=TRUE)))
  all.data <- as.data.frame(t(all.data))
  all.data <- data.frame(year = row.names(all.data), all.data, row.names = NULL)
  all.data$year <- gsub('X', '', all.data$year)
  return(all.data)
}

#Filter for country in dataset
GetCountryData <- function(country, sex) {
  data;
  if (sex == "girls") {
    data <- girls.completion
  } else if (sex == "boys") {
    data <- boys.completion
  } else {
    data <- both.completion
  }
  
  country.data <- data %>% filter(Country == country) %>% 
    select(-CountryCode, -Country)
  trans <- as.data.frame(t(country.data))
  country.data <- data.frame(year = row.names(trans), trans, row.names = NULL)
  country.data$year <- gsub('X', '', country.data$year)
  country.data <- filter(country.data, !is.na(V1)) 
  return(country.data)
}


#Scatter("Algeria", "girls")
# Scatter("Australia", "girls")
# GetCountryData("Australia", "girls")
# GetCountryData("Algeria", "girls")

Scatter <- function(country, sex) {
  d <- GetCountryData(country, sex)
  all.data <- GetAllCountriesAvg(sex)
  #Plot graph with only average line
  scatterplot <- plot_ly() %>% 
    layout(title = paste(country, "Average per Year"),
           xaxis = list(title = 'Year', zeroline = TRUE, tickangle = -45),
           yaxis = list(title = 'Average'),
           showlegend = FALSE) %>% 
    #Adds average line
    add_trace(data=all.data, x = ~all.data$year, y = ~all.data$V1, 
              type="scatter", mode = "lines", text = ~paste("Worldwide: ", format(round(V1, 2), nsmall = 2)))
  if (nrow(d) > 0) {
    #Only adds country's value if there are some values (not all null)
    scatterplot <- scatterplot %>% add_trace(data=d, x = ~d$year, 
                                             y = ~d$V1, type="scatter", 
                                             mode="markers",
                                             text = ~paste(country, ": ", V1,
                                                           sep = ""))
  }
  return(scatterplot)
}

