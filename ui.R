library(shiny)
library(dplyr)
library(plotly)
library(tidyr)
source('scripts/education_completed_data_wrangling.R')
source('scripts/map.R')
source('scripts/completion_scatter.R')

shinyUI(navbarPage('Millenium Development Goals: Education',
                   id = 'navbar',
                   fluid = TRUE,
                   theme = 'styles.css',
                   tabPanel('About',
                            id = 'intro',
                            h1(id = 'appTitle', 'Introduction'),
                            h3(id = 'names', 'By Patricia Au, Brandon Chong, Jisoo Kim, Satvik Shukla, Jion Yi'),
                            mainPanel(
                              h4('Project Description'),
                              p('The aim of this project is to visualize global education trends and its various factors. 
                                By looking at our finished project, our audience will be able to answer the following questions:'),
                              strong('(1) How have education rates changed over the years in the countries we are looking at?'), 
                              br(),
                              strong('(2) What are the education rates of countries by males, females, and both in 2013?'),
                              br(),
                              p('Our target audience includes the United Nations, its member states, non-governmental orgnanizations,
                                and its private investors.Our project will be available to the public, which allows individuals interested 
                                in this topic to learn more about global education trends. We hope that our visualizations will drive the 
                                United Nation to create and implement policies in global education. In addition, our project will allow states 
                                with inadequate resources to analyze and learn about the global trends as well as those within their own country.'),
                              br(),
                              h4('Sources'),
                              a('Millenium Development Goals: Education', href = 'http://databank.worldbank.org/data/reports.aspx?source=millennium-development-goals'),
                              br(),
                              a('Millenium Development Goals Indicators', href = 'http://mdgs.un.org/unsd/mdg/Data.aspx'),
                              br(),
                              a('World Bank: Education Statistics - All Indicators', href = 'http://databank.worldbank.org/data/reports.aspx?source=Education%20Statistics')
                            )
                   ),
                   
                   tabPanel('Country Averages Map',
                            mainPanel(
                              id = 'map',

                              tags$div(id = 'loader'),
                              h3('Loading...'),
                              
                              highchartOutput('map')
                              # tableOutput("scatter.table"),
                            ),
                            sidebarPanel(
                              class = 'sidebar',
                              radioButtons('map.sex', 'Sex',
                                           choices = list("Both" = 'both.sex', "Male" = 'boys', "Female" = 'girls'), 
                                           selected = 'both.sex')
                            )
                   ),
                   tabPanel('Country Comparisons',
                            sidebarLayout(
                              mainPanel(
                                h3('Comparing Country Completion Rates Against World Average'),
                                plotlyOutput('scatter.table')
                              ),
                              sidebarPanel(
                                class = 'sidebar',
                                radioButtons("scatter.sex", 'Sex',
                                             choices = list("Female" = "girls", "Male" = "boys",
                                                            "Both" = "both"),selected = "girls"),
                                selectInput("scatter.country", 'Country', 
                                            choices = dropdown.choices)
                              )
                            )
                   ),
                   
                   tabPanel('Table',
                            sidebarLayout(
                              mainPanel(
                                h3(id = 'tableHeader', 'Primary School Completion'),
                                tableOutput('table')
                              ),
                              sidebarPanel(
                                class = 'sidebar',
                                h5('This table displays the percentage completion of primary school per country
                                   in 2013.'),
                                # Table Widgets
                                radioButtons('sex', 'Sex',
                                             choices = list("Both" = 1, "Male" = 2, "Female" = 3), 
                                             selected = 1),
                                radioButtons('arrange.by', 'Arrange By',
                                             choices = list("Descending" = 1, "Ascending" = 2), 
                                             selected = 1),
                                sliderInput("table.max", 'Primary Completed Rate', min = 30, 
                                            max = 115, value = c(30,115))
                              )
                            )
                   )
))