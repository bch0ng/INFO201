library(dplyr)
library(plotly)
source('./scripts/education_completed_data_wrangling.R')

girls.completion <- FormatData(read.csv('./data/Completion_girls.csv', stringsAsFactors = FALSE))
boys.completion <- FormatData(read.csv('./data/Completion_boys.csv', stringsAsFactors = FALSE))
both.completion <- FormatData(read.csv('./data/Completion_both.csv', stringsAsFactors = FALSE))

#Calculate average value for both boys and girls separately
#Look @ girls, boys, both
#Calculate average for all countries together by year
#Put into dataframe
girls.completion %>% summarize(avg_by_year = mean(X1990, na.rm = TRUE))
apply(GetCountryData("Algeria", "girls"), 2, mean, na.rm = TRUE)
foo <- data.frame(colMeans(test[c(3:length(girls.completion))], na.rm=TRUE))

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
test <- GetCountryData("Algeria", "girls")

