#' Takes in a dataframe, removes unnecessary columns (such as footnotes and types),
#' and then returns it.
#'
#' @param data    A dataframe
#' @return        The formatted dataframe
FormatData <- function(data) {
  data.format <- data[c(1:225),c(1:80)]
  col.names.temp <- vector()
  for (i in colnames(data.format)) {
	if (!(grepl('Footnotes', i) | grepl('Type', i)))
	  col.names.temp <- c(col.names.temp, i)
  }
  data.format <- select(data.format, col.names.temp)
  data.format <- data.format[,-c(3:5)]
  return(data.format)
}

#' Takes in a dataframe, transposes it, and then returns it.
#' 
#' @param data    A dataframe
#' @return        The transposed dataframe
TransposeData <- function(data) {
  data.transpose <- t(data)
  colnames(data.transpose) <- data.transpose['Country',]
  data.transpose <- data.transpose[-c(1:2),]
  data.transpose <- data.frame(data.transpose)
  data.transpose <- cbind(year = c(1990:2014), data.transpose)
  rownames(data.transpose) <- c(1:25)
  for (i in colnames(data.transpose)) {
	data.transpose[[i]] <- as.numeric(as.character(data.transpose[[i]]))
  }
  return(data.transpose)
}

#' Takes in a dataframe and returns the slope of a linear regression
#' for each column.
#' 
#' @param data.transpose    A dataframe
#' @return                  The slope of a linear regression for each column
CalculateAvgChange <- function(data.transpose) {
  avg.change <- vector()
  for (i in colnames(data.transpose)[2:ncol(data.transpose)]) {
	# If country <2 non-NA values then they will have an NA average change
	if (all(is.na(data.transpose[[i]]))) {
	  change <- NA
	} else {
	  change <- coef(lm(data.transpose[[i]] ~ year, data = data.transpose, na.action = 'na.exclude'))[[2]]
	}
	avg.change <- c(avg.change, change)
  }
  # 40 countries have NA for average rate of change
  return(avg.change)
}

#' Takes in a dataframe, removes rows that have NA in the avg.change column,
#' and then returns the filtered dataframe.
#' 
#' @param data    A dataframe
#' @return        The filtered dataframe
RemoveNA <- function(data) {
  data <- data %>% 
    filter(!is.na(avg.change))
  return(data)
}
