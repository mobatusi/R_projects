# Approx. 50 observations = mining stocks
# MarketCap = market capitalization in million
# Symbol = abbreviation for comp. name (randomized)
# G1 = number of most valuable plots
# G2 = number of intermediate plots
# G3 = number of least valuable plots

# Preferences of invesors might differ

# Mining Stock Evaluation:
## The invetors specifies the importance of each grade (weight)
## Each grade is multiplied by its weight
## Figures are added together to get a score
## Evaluation is based on the scores

# Download data (.csv)
## store it in the app folder
## semicolon (;) separator


###

library(shiny)
library(ggplot2)
library(DT)
library(shinythemes)
ui <- navbarPage(strong("The Mining Stock Scale"),theme = shinytheme("yeti"),
           tabPanel("Adjusting Your Mining Stocks",
                    sliderInput(inputId = "G1slider",
                                label = "G1",
                                value = 1, min = 0 , max = 9),
                    sliderInput(inputId = "G2slider",
                                label = "G2",
                                value = 1, min = 0 , max = 8),
                    sliderInput(inputId = "G3slider",
                                label = "G3",
                                value = 1, min = 0 , max = 10),
                    plotOutput("plot"),
                    DT::dataTableOutput("table")
                    ),
           
           tabPanel("Documentation"),
           
           tabPanel("Data Table With the Underlying Data", 
                    DT::dataTableOutput("table"))

          
)

server <- function(input, output, session) {
  data <- reactive({read.csv("course-proj-data.csv", sep=";")})
  
  data2 <- reactive({rnorm(50)*input$G1slider})
  
  output$plot <- renderPlot({plot(data2(), col = "red", pch = 21, bty = "n")})
  
  
  output$table <- DT::renderDataTable(datatable( data, options = list(paging=F), rownames = F, 
                                      filter='top') %>%
                                        formatCurrency("MarketCap.in.M", "$") %>%
                                        formatStyle("G1", backgroundColor = "lightblue")  %>%
                                        formatStyle("G2", backgroundColor = "lightblue")  %>%
                                        formatStyle("G3", backgroundColor = "lightblue")
                                      )
  
}


shinyApp(ui, server)