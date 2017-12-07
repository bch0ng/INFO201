# Sets up libraries and sources
library(dplyr)
library(plotly)
source("scripts/education_completed_data_wrangling.R")

# Girls completion rate data for all countries
girls.completion <- FormatData(read.csv('data/Completion_girls.csv', stringsAsFactors = FALSE))
#Boys completion rate data for all countries
boys.completion <- FormatData(read.csv('data/Completion_boys.csv', stringsAsFactors = FALSE))
#Girls + boys completion rate data for all countries
both.completion <- FormatData(read.csv('data/Completion_both.csv', stringsAsFactors = FALSE))

# For ui.R dropdown
dropdown.choices <- both.completion$Country

#' Takes in a sex and returns the dataset for world (all countries) average by sex.
#' 
#' @param sex    Sex of 'boys', 'girls', or 'both'
#' @return       The dataset for all countries' primary completion average by sex
GetAllCountriesAvg <- function(sex) {
  if (sex == "girls") {
    data <- girls.completion
  } else if (sex == "boys") {
    data <- boys.completion
  } else {
    data <- both.completion
  }
  #Prepares data for graphing
  all.data <- data[c(3:length(data))] %>% 
    summarize_all(funs(mean(., na.rm=TRUE)))
  all.data <- as.data.frame(t(all.data))
  all.data <- data.frame(year = row.names(all.data), all.data, row.names = NULL)
  all.data$year <- gsub('X', '', all.data$year)
  return(all.data)
}

#' Takes in a country and sex and returns a dataset for that country by sex
#' 
#' @param country   Country to get data for
#' @param sex       Sex of 'boys', 'girls', or 'both'
#' @return          The dataset for that country by sex
GetCountryData <- function(country, sex) {
  data; #Data representing the student group (sex) from country
  if (sex == "girls") {
    data <- girls.completion
  } else if (sex == "boys") {
    data <- boys.completion
  } else {
    data <- both.completion
  }
  country.data <- data %>% filter(Country == country) %>% 
    select(-CountryCode, -Country)
  #Prepares data for graphing
  trans <- as.data.frame(t(country.data))
  country.data <- data.frame(year = row.names(trans), trans, row.names = NULL)
  country.data$year <- gsub('X', '', country.data$year)
  country.data <- filter(country.data, !is.na(V1)) 
  return(country.data)
}

#' Takes in a country and sex and returns a scatter plot comparing country 
#' rate against the worldwide average.
#' 
#' @param country   Country to get data for
#' @param sex       Sex of 'boys', 'girls', or 'both'
#' @return          The scatter plot comparing given country's rate against the
#'                      worldwide average.
Scatter <- function(country, sex) {
  country.data <- GetCountryData(country, sex) #Chosen country's data
  all.data <- GetAllCountriesAvg(sex) #Data of all countries
  
  #Plot graph with only average line
  scatter.plot <- plot_ly() %>% 
    layout(title = paste(country, "Completion Rate vs. World Average Rate (1990 - 2014)"),
           xaxis = list(title = 'Year', zeroline = TRUE, tickangle = -45),
           yaxis = list(title = 'Rate'),
           showlegend = FALSE) %>% 
    #Adds average line
    add_trace(data=all.data, x = ~all.data$year, y = ~all.data$V1, 
              type="scatter", mode = "lines", hoverinfo = 'text',
              text = ~paste(year, "Worldwide Average: ", format(round(V1, 2), nsmall = 2)))
  if (nrow(country.data) > 0) {
    #Only adds country's value if there are some values (not all null)
    scatter.plot <- scatter.plot %>% add_trace(data=country.data, x = ~country.data$year, 
                                             y = ~country.data$V1, type="scatter", 
                                             mode="markers",
                                             hoverinfo = 'text',
                                             text = ~paste(year, " ", country, " Rate: ", V1,
                                                           sep = ""))
  }
  return(scatter.plot)
}

