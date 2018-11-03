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
           wellPanel(
                    sliderInput(inputId = "G1slider",
                                label = "Weight on Grade 1",
                                value = 1, min = 0 , max = 20),
                    sliderInput(inputId = "G2slider",
                                label = "Weight on Grade 2",
                                value = 1, min = 0 , max = 20),
                    sliderInput(inputId = "G3slider",
                                label = "Weight on Grade 3",
                                value = 1, min = 0 , max = 6),
                    plotOutput("plot",brush = "user_brush"),
                    dataTableOutput("table")
                    ),
           
           tabPanel("Documentation",
                    tabPanel("Video guide to Shiny App, Iframe",
                             tags$iframe(style="height:600px; width:100%; scrolling=yes", 
                                         src="https://youtu.be/Gyrfsrd4zK0"))),
           
           tabPanel("Data Table With the Underlying Data", 
                    DT::dataTableOutput("tableOrig"))

          
)

server <- function(input, output, session) {
  library(ggplot2) # for the diamonds dataset, and ggplot feature
  library(DT) # for the dataTableOutput
  library(shiny) # should always be activated
  data <- read.csv("course-proj-data.csv", sep=";")
  
  score <- reactive({(data['G1']*input$G1slider) + (data['G2']*input$G2slider) + (data['G3']*input$G3slider)
    })
  
  output$plot <- renderPlot({
    ggplot(data, aes(G1, G2)) + geom_point()
    })

  diam <- reactive({
    
    user_brush <- input$user_brush
    sel <- brushedPoints(data, user_brush)
    return(sel)
    
  })
  
  output$table <- DT::renderDataTable({datatable(diam())
    })
  
  output$tableOrig <- DT::renderDataTable({datatable(data, options = list(paging=F), rownames = F, 
                                      filter='top') %>%
                                        formatCurrency("MarketCap.in.M", "$") %>%
                                        formatStyle("G1", backgroundColor = "lightblue")  %>%
                                        formatStyle("G2", backgroundColor = "lightblue")  %>%
                                        formatStyle("G3", backgroundColor = "lightblue")
                                      })
  
}


shinyApp(ui, server)