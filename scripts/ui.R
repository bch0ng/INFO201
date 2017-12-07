library(shiny)
library(plotly)


shinyUI(navbarPage('Millenium Development Goals: Education',
                   fluid = TRUE,
                   theme = 'styles.css',
                   tabPanel('About',
                            h1(id = 'appTitle', 'Millenium Development Goals: Education'),
                            h3(id = 'names', 'By Patricia Au, Brandon Chong, Jisoo Kim, Satvik Shukla, Jion Yi'),
                            mainPanel(
                              h4('Project Description'),
                              p('The aim of this project is to visualize global education trends and its various factors. 
                                By looking at our finished project, our audience will be able to answer the following questions:'),
                              strong('(1) How have education rates changed over the years in the countries we are looking at?'), 
                              br(),
                              strong('(2) What are the education rates of countries by males, females, and both in 2014?'),
                              br(),
                              p('Our target audience includes the United Nations, its member states, non-governmental orgnanizations,
                                and its private investors.Our project will be available to the public, which allows individuals interested 
                                in this topic to learn more about global education trends. We hope that our visualizations will drive the 
                                United Nation to create and implement policies in global education. In addition, our project will allow states 
                                with inadequate resources to analyze and learn about the global trends as well as those within their own country.'),
                              br(),
                              h4('Technical Description'),
                              p('The format of our final product will be a Shiny application that changes dynamically with user input. 
                                In addition to the comma-separated values (CSV) data needed to conduct our research and create visualizations, 
                                the user will be able to adjust values to filter certain parts of the data (ie. viewing by country, viewing by 
                                factor, etc.)To view more specific trends, 
                                our data will be filtered and grouped by data rows. In addition, we will join our datasets 
                                to compare current and past data in country trends. External libraries, such as Dplyr and Shiny, will enable us 
                                to create a dynamic web page with interactive graphics.')
                              ),
                              h4('Sources'),
                              a('Millenium Development Goals: Education', href = 'http://databank.worldbank.org/data/reports.aspx?source=millennium-development-goals'),
                              br(),
                              a('Millenium Development Goals Indicators', href = 'http://mdgs.un.org/unsd/mdg/Data.aspx'),
                              br(),
                              a('World Bank: Education Statistics - All Indicators', href = 'http://databank.worldbank.org/data/reports.aspx?source=Education%20Statistics')
                   ),
                   
                   tabPanel('Country Averages',
                            mainPanel(
                              id = 'map',
                              br(),
                              br(),
                              plotlyOutput('map', width = 'auto'),
                              
                              strong('Note:'),
                              p('Some of the countries, whose data are not available, are omitted in the map.')
                              # tableOutput("scatter.table"),
                            )
                   ),
                   
                   tabPanel('Table',
                            sidebarLayout(
                              mainPanel(
                                h3(id = 'tableHeader', 'Primary School Completion'),
                                tableOutput('table')
                              ),
                              sidebarPanel(
                                id = 'tableSidebar',
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