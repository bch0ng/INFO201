library(dplyr)
library(plotly)
library(shiny)

source("./scripts/education_completed_data_wrangling.R")

girls.completion <- FormatData(read.csv('./data/Completion_girls.csv', stringsAsFactors = FALSE))
boys.completion <- FormatData(read.csv('./data/Completion_boys.csv', stringsAsFactors = FALSE))
both.completion <- FormatData(read.csv('./data/Completion_both.csv', stringsAsFactors = FALSE))

#Girls and boys average completion rates; for trend line
# girls.avg <- girls.completion[c(3:length(girls.completion))] %>% 
#   summarize_all(funs(mean(., na.rm=TRUE)))
# girls.avg = as.data.frame(t(girls.avg))
# girls.avg <- data.frame(year = row.names(girls.avg), girls.avg, row.names = NULL)
# boys.avg <- boys.completion[c(3:length(boys.completion))] %>% 
#   summarize_all(funs(mean(., na.rm=TRUE)))
# both.avg <- both.completion[c(3:length(both.completion))] %>% 
#   summarize_all(funs(mean(., na.rm=TRUE)))

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
  return(country.data)
}

all.data <- GetAllCountriesAvg("girls")
dropdown.choices <- both.completion$Country

Scatter <- function(country, sex) {
  d <- GetCountryData(country, sex)
  all.data <- GetAllCountriesAvg(sex)
  scatterplot <- plot_ly() %>% 
    add_trace(data=d, x = ~d$year, y = ~d$V1, type="scatter", mode="markers") %>% 
    layout(title = paste(country, "Average per Year"),
           xaxis = list(title = 'Year', zeroline = TRUE),
           yaxis = list(title = 'Average'),
           showlegend = FALSE) %>% 
    add_trace(data=all.data, x = ~all.data$year, y = ~all.data$V1, type="scatter", mode = "lines")
  return(scatterplot)
}

typeof(Scatter("Algeria", "girls"))
