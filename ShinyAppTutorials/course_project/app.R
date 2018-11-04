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
           tabPanel("Adjust your Mining stocks",
             wellPanel(
                    sliderInput(inputId = "G1slider",
                                label = "Weight on Grade 1",
                                value = 1, min = 0 , max = 20),
                    sliderInput(inputId = "G2slider",
                                label = "Weight on Grade 2",
                                value = 1, min = 0 , max = 20),
                    sliderInput(inputId = "G3slider",
                                label = "Weight on Grade 3",
                                value = 1, min = 0 , max = 6)
                    ),
                    plotOutput("plot", brush = "user_brush"),
                    dataTableOutput("table"),
                    downloadButton(outputId = "downlaod", label="Download Table")
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
  library(dplyr)
  library(readr)
  
  #values <- reactiveValues()
  
  data <- read.csv("course-proj-data.csv", sep=";")
  
  datascore <- reactive({ (data['G1']*input$G1slider) + (data['G2']*input$G2slider) + (datascore['G3']*input$G3slider)
  })
  
  #datascore <- reactive(values$data['score'] <- score )

  output$plot <- renderPlot({
    ggplot(data, aes(G2,MarketCap.in.M) ) + stat_summary(fun.data=mean_cl_normal) + 
      geom_smooth(method='lm',formula=y~x) + geom_point()
  })
  
  diam <- reactive({
    
    user_brush <- input$user_brush
    sel <- brushedPoints(data, user_brush)
    return(sel)
    
  })
  
  output$table <- DT::renderDataTable({datatable(diam())
    })
  
  output$tableOrig <- DT::renderDataTable({datatable(data , options = list(paging=F), rownames = F, 
                                      filter='top') %>%
                                        formatCurrency("MarketCap.in.M", "$") %>%
                                        formatStyle("G1", backgroundColor = "lightblue")  %>%
                                        formatStyle("G2", backgroundColor = "lightblue")  %>%
                                        formatStyle("G3", backgroundColor = "lightblue")
                                      })
  
  output$download <- downloadHandler(
    filename = "project_downlaod.csv",
    content = function(file) {
      write.csv(diam(), file)
    }
  )
  
}


shinyApp(ui = ui, server = server)