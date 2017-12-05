library(dplyr)
library(plotly)
source('./scripts/education_completed_data_wrangling.R')

girls.completion <- FormatData(read.csv('./data/Completion_girls.csv', stringsAsFactors = FALSE))
boys.completion <- FormatData(read.csv('./data/Completion_boys.csv', stringsAsFactors = FALSE))
both.completion <- FormatData(read.csv('./data/Completion_both.csv', stringsAsFactors = FALSE))

#Girls and boys average completion rates; for trend line
girls.avg <- girls.completion[c(3:length(girls.completion))] %>% 
  summarize_all(funs(mean(., na.rm=TRUE)))
boys.avg <- girls.completion[c(3:length(girls.completion))] %>% 
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

# fit <- lm(price ~ carat, data = df)
# plot_ly(df1, x = carat, y = price, mode = "markers") %>% 
# add_trace(data = df, x = carat, y = fitted(fit), mode = "lines")
