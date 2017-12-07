library(shiny)


shinyUI(navbarPage('Millenium Development Goals: Education',
                   fluid = TRUE,
                   theme = 'styles.css',
                   tabPanel('About',
                     h3('By Patricia Au, Brandon Chong, Jisoo Kim, Satvik Shukla, Jion Yi'),
                     sidebarPanel(),
                     mainPanel(
                      textOutput('about')
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
                   ),
                   tabPanel('Country Averages',
                            sidebarLayout(
                              mainPanel(
                                h3(id = 'mapHeader', 'Average Change in Primary School Completion, 1990-2014'),
                                # tableOutput("scatter.table"),
                                plotlyOutput('map')
                              ),
                              sidebarPanel(
                                id = 'mapSidePanel'
                              )
                            )
                   )
))