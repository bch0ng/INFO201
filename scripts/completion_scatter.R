library(dplyr)
library(plotly)
source('./scripts/education_completed_data_wrangling.R')

girls.completion <- FormatData(read.csv('./data/Completion_girls.csv', stringsAsFactors = FALSE))
boys.completion <- FormatData(read.csv('./data/Completion_boys.csv', stringsAsFactors = FALSE))
both.completion <- FormatData(read.csv('./data/Completion_both.csv', stringsAsFactors = FALSE))

#Calculate average value for both boys and girls separately

#Function: calculate average boys and girls for chosen country


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

#View(GetCountryData("Algeria", "both"))
#View(GetCountryData("Algeria", "girls"))

# fit <- lm(price ~ carat, data = df)
# plot_ly(df1, x = carat, y = price, mode = "markers") %>% 
# add_trace(data = df, x = carat, y = fitted(fit), mode = "lines")
