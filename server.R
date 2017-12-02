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
both.sex.transpose <- t(both.sex)
colnames(both.sex.transpose) <- both.sex.transpose['Country',]
both.sex.transpose <- both.sex.transpose[-c(1:2),]
both.sex.transpose <- data.frame(both.sex.transpose)
both.sex.transpose <- cbind(year = c(1:25), both.sex.transpose)
rownames(both.sex.transpose) <- c(1:25)
for (i in colnames(both.sex.transpose)) {
  both.sex.transpose[[i]] <- as.numeric(as.character(both.sex.transpose[[i]]))
}

# Average rate of change in primary completion from 1990-2013
avg.change <- vector()
for (i in colnames(both.sex.transpose)[2:ncol(both.sex.transpose)]) {
  # If country <2 non-NA values then they will have an NA average change
  if (all(is.na(both.sex.transpose[[i]]))) {
    change <- NA
  } else {
    change <- coef(lm(both.sex.transpose[[i]] ~ year, data = both.sex.transpose, na.action = 'na.exclude'))[[2]]
  }
  avg.change <- c(avg.change, change)
}
# 40 countries have NA for average rate of change
both.sex$avg.change <- avg.change

# Arranged for most positive/negative change to be the top-most value
both.sex.neg.change <- both.sex %>%
                        filter(avg.change < 0) %>% 
                        arrange(avg.change)
both.sex.pos.change <- both.sex %>%
                        filter(avg.change >= 0) %>% 
                        arrange(desc(avg.change))


shinyServer(function(input, output) {
  
  
})

