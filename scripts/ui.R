library(shiny)


shinyUI(fluidPage(
  titlePanel("Millenium Development Goals: Education"),
  h3('By Patricia Au, Brandon Chong, Jisoo Kim, Satvik Shukla, Jion Yi'),
  sidebarLayout(
    mainPanel(
      plotOutput()
    ),
    sidebarPanel()
  )
))
