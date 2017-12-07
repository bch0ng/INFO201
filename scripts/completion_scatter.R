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
girls.avg = as.data.frame(t(girls.avg))
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
  #returns data as two columns
  country.data <- data %>% filter(Country == country) %>% 
    select(-CountryCode, -Country)
  trans <- as.data.frame(t(country.data))
  country.data <- data.frame(year = row.names(trans), trans, row.names = NULL)
  return(country.data)
}
d <- GetCountryData("Algeria", "girls")


Scatter <- function(country, sex) {
  d <- GetCountryData(country, sex)
  scatterplot <- plot_ly(d, x = ~d$year, y = ~d$V1, type="scatter") %>% 
    layout(title = paste(country, "Average per Year"),
           xaxis = list(title = 'Year',
                        zeroline = TRUE
           ),
           yaxis = list(title = 'Average'
           )) %>%
   
  return(scatterplot)
}

d <- Scatter("Algeria", "girls")


# fit <- lm(price ~ carat, data = df)
# plot_ly(df1, x = carat, y = price, mode = "markers") %>% 
# add_trace(data = df, x = carat, y = fitted(fit), mode = "lines")
