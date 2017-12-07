# Sets up libraries and sources
library(shiny)
library(dplyr)
library(plotly)
library(tidyr)
source('scripts/education_completed_data_wrangling.R')
source('scripts/map.R')
source('scripts/completion_scatter.R')

shinyUI(navbarPage('Millenium Development Goals: Education',
                   fluid = TRUE,
                   theme = 'styles.css',
                   # Introduction to our Project
                   tabPanel('Project Introduction',
                            id = 'intro',
                            HTML(
                              '<h1>Introduction</h1>'
                            ),
                            mainPanel(
                              HTML(
                                 '<h4>Project Description</h4>
                                  <p>
                                    The aim of this project is to visualize global education trends and its various factors. 
                                    By looking at our finished project, our audience will be able to answer the following questions:
                                  </p>

                                  <strong>
                                    <ol>
                                      <li>How have primary school completion rates changed over the past 20 years globally?</li>
                                      <li>What are the primary school completion rates of countries by male, female, and both up to 2014?</li>
                                    </ol>
                                  </strong>

                                  <p>
                                    Our main target audience includes the United Nations, its member states, non-governmental orgnanizations,
                                    and its private investors.Our project will be available to the public, which allows individuals interested 
                                    in this topic to learn more about global education trends. We hope that our presentation will assist the 
                                    United Nations in helping critical countries educational support plans so that we may achieve our Millenium
                                    Development Goal of universal primary education. In addition, our project will allow countries
                                    with inadequate resources to analyze and learn about the global trends as well as their own country\'s trends.
                                  </p>
                                  <br />
                                  <h4>Sources</h4>
                                  <ul>
                                    <li><a href="http://databank.worldbank.org/data/reports.aspx?source=millennium-development-goals">
                                      Millenium Development Goals: Education
                                    </a></li>
                                    <li><a href="http://mdgs.un.org/unsd/mdg/Data.aspx">
                                      Millenium Development Goals Indicators
                                    </a></li>
                                    <li><a href="http://databank.worldbank.org/data/reports.aspx?source=Education%20Statistics">
                                      World Bank: Education Statistics - All Indicators
                                    </a></li>
                                  </ul>'
                              )
                            )
                   ),
                   # World Map
                   tabPanel('Country Averages Map',
                            mainPanel(
                              id = 'map',
                              tags$div(class = 'loader'),
                              h3('Loading...'),
                              highchartOutput('map')
                            ),
                            sidebarPanel(
                              class = 'sidebar',
                              radioButtons('map.sex', 'Sex',
                                           choices = list("Both" = 'both.sex',
                                                          "Male" = 'boys', 
                                                          "Female" = 'girls'), 
                                           selected = 'both.sex')
                            ),
                            sidebarPanel(
                              class = 'sidebar description',
                              h4('Description'),
                              p('This interactive map displays the average change in primary school
                                completion from 1990 to 2014. By viewing this graph, we can identify
                                critical countries and regions where educational assistance may be
                                the most effective.')
                            )
                   ),
                   # Scatter plot graph
                   tabPanel('Country Comparisons Graph',
                              mainPanel(
                                # Description of scatter plot
                                h3(id = 'tableHeader', 'Comparing Country Completion Rates Against the World Average Rate'),
                                HTML('<p><strong>Note:</strong> Not all countries reported their completion rates.</p>'),
                                tags$div(class = 'loader'),
                                plotlyOutput('scatter.plot')
                              ),
                              sidebarPanel(
                                class = 'sidebar',
                                h4('Description'),
                                p('This scatter plot shows the relation between the students\' gender and
                                    primary completion rate for each country, while also comparing it to the
                                    world average.')
                              ),
                              sidebarPanel(
                                class = 'sidebar',
                                radioButtons("scatter.sex", 'Sex',
                                             choices = list("Female" = "girls", "Male" = "boys",
                                                            "Both" = "both"),selected = "girls"),
                                selectInput("scatter.country", 'Country', 
                                            choices = dropdown.choices)
                              )
                   ),
                   # Table of the latest data
                   tabPanel('2013 Primary Completion Data',
                            mainPanel(
                              h3(class = 'header', 'Primary School Completion'),
                              tableOutput('table')
                            ),
                            sidebarPanel(
                              class = 'sidebar',
                              h4('Description'),
                              p('This table displays the latest primary school completion
                                percentage. By viewing this table, we can identify
                                critical countries and regions where completion is below 50%
                                that would benefit the most from additional educational support,
                                so that we will be able to reach our Millenium Development Goal of
                                universal primary education.')
                            ),
                            sidebarPanel(
                              class = 'sidebar',
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
                          ),
                   tags$footer(
                     HTML('<p class="subheader">INFO201 AF 5<br />
                            Patricia Au | Brandon Chong | Jisoo Kim | Satvik Shukla | Jion Yi</p>')
                   )
))