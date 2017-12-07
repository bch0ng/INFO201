library(dplyr)
library(plotly)
setwd("~/Desktop/INFO201/INFO201")
source("./scripts/education_completed_data_wrangling.R")

girls.completion <- FormatData(read.csv('./data/Completion_girls.csv', stringsAsFactors = FALSE))
boys.completion <- FormatData(read.csv('./data/Completion_boys.csv', stringsAsFactors = FALSE))
both.completion <- FormatData(read.csv('./data/Completion_both.csv', stringsAsFactors = FALSE))

#Girls and boys average completion rates; for trend line
girls.avg <- girls.completion[c(3:length(girls.completion))] %>% 
  summarize_all(funs(mean(., na.rm=TRUE)))
boys.avg <- boys.completion[c(3:length(boys.completion))] %>% 
  summarize_all(funs(mean(., na.rm=TRUE)))
both.avg <- both.completion[c(3:length(both.completion))] %>% 
  summarize_all(funs(mean(., na.rm=TRUE)))

#Function: filter for country in dataset
GetCountryData <- function(country, sex) {
  data;
  if (sex == "girls") {
    data <- girls.completion
  } else if (sex == "boys") {
    data <- boys.completion
  } else {
    data <- both.completion
  }
  return(data %>% filter(Country == country))
}

trans <- as.data.frame(t(GetCountryData("Afghanistan", "girls")))
into.column <- data.frame(year = row.names(trans), trans, row.names = NULL)

CountryData <- function(country, sex) {
  trans <- as.data.frame(t(GetCountryData(country, sex)))
  into.column <- data.frame(year = row.names(trans), trans, row.names = NULL)
  return(into.column)
}

Scatter <- function(country, sex) {
  choice <- CountryData(country, sex)
  choice <- choice[c(3:27),]
  scatterplot <- plot_ly(choice, type="scatter", x = ~choice$year, y = ~choice$V1) %>% 
    layout(title = paste(country, "Average per Year"),
           xaxis = list(title = 'Year',
                        zeroline = TRUE
           ),
           yaxis = list(title = 'Average'
           ))
}


# fit <- lm(price ~ carat, data = df)
# plot_ly(df1, x = carat, y = price, mode = "markers") %>% 
# add_trace(data = df, x = carat, y = fitted(fit), mode = "lines")
