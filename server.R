# Setting up libraries
library(shiny)
library(dplyr)
library(plotly)
library(tidyr)

# Reading in the data and formatting it to be more accessible
both.sex <- read.csv('data/DisplayByIndicator.csv', stringsAsFactors = FALSE)
both.sex <- both.sex[c(1:225),c(1:80)]
col.names.temp <- vector()
for (i in colnames(both.sex)) {
  if (!(grepl('Footnotes', i) | grepl('Type', i)))
    col.names.temp <- c(col.names.temp, i)
}
both.sex <- select(both.sex, col.names.temp)
both.sex <- both.sex[,-c(3:5)]




# Transposing the data
# both.sex.transpose <- t(both.sex)
# colnames(both.sex.transpose) <- both.sex.transpose['Country',]
# both.sex.transpose <- both.sex.transpose[-c(1:2),]
# both.sex.transpose <- data.frame(both.sex.transpose)
# both.sex.transpose <- cbind(year = c(1:25), both.sex.transpose)




# Average rate of change in primary completion from 1990-2013
both.sex.wrangled <- both.sex %>% 
                      filter(!is.na(X1990) & !is.na(X2013)) %>% 
                      group_by(Country) %>% 
                      mutate(change = sum(X2013, -X1990, na.rm = TRUE) / 24)

  
  

shinyServer(function(input, output) {
  
  
})
