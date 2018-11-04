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
library(shiny) # should always be activated
library(ggplot2) # for the diamonds dataset, and ggplot feature
library(DT) # for the dataTableOutput
library(shinythemes)


ui <- navbarPage(strong("The Mining Stock Scale"),theme = shinytheme("yeti"),
           tabPanel("Adjust your Mining stocks",
             wellPanel(
                    sliderInput(inputId = "w1",
                                label = "Weight on Grade 1",
                                value = 1, min = 0 , max = 20),
                    sliderInput(inputId = "w2",
                                label = "Weight on Grade 2",
                                value = 1, min = 0 , max = 20),
                    sliderInput(inputId = "w3",
                                label = "Weight on Grade 3",
                                value = 1, min = 0 , max = 6)
                    ),
                    plotOutput("plot", brush = "user_brush"),
                    DT::dataTableOutput("table"),
                    downloadButton(outputId = "downlaod", label="Download Table")
             ),
           
           tabPanel("Documentation",
                    h4("Video guide to Shiny App, Iframe",
                             tags$iframe(style="height:700px; width:100%; scrolling=yes", 
                                         src="https://www.youtube.com/embed/vySGuusQI3Y"))),
           
           tabPanel("Data Table With the Underlying Data", 
                    DT::dataTableOutput("tableOrig"))

          
)

data <- read.csv("course-proj-data.csv", sep=";")
attach(data)

server <- function(input, output, session) {


  weighted.data = reactive(
    cbind(data, 
          points = `G1`*input$w1 + `G2`*input$w2 + `G3`*input$w3)
      )
    
  # Plot of calculated score and market capitalization in millions USD
  output$plot <- renderPlot({
      ggplot(weighted.data(), aes(points,MarketCap.in.M) ) + geom_point() + geom_smooth(method='lm')  +
        xlab("Your calculated score") + ylab("Market Capitalization in Million USD")
    })
    
  # Create new reactive data with brushed points
  data.new = reactive({

    user_brush <- input$user_brush
    sel <- brushedPoints(weighted.data(), user_brush)
    return(sel)
    
  })
  
  # Data for the Adjusting your mining stocks tab
  output$table <- DT::renderDataTable(DT::datatable(data.new()))
  
  # Download tab
  output$download <- downloadHandler(
    filename = "selected_miners.csv",
    content = function(file) {
      write.csv(data.new(), file)
    }
  )
  
  # Data for the data table tab
  output$tableOrig <- DT::renderDataTable(DT::datatable(data , options = list(paging=F), rownames = F, 
                                                     filter='top') %>%
      formatCurrency("MarketCap.in.M", "$", digits = 0) %>%
      formatStyle("Symbol", color = "grey")  %>%
      formatStyle("G1", backgroundColor = "lightblue")  %>%
      formatStyle("G2", backgroundColor = "lightblue")  %>%
      formatStyle("G3", backgroundColor = "lightblue")
  )
  
}


shinyApp(ui = ui, server = server)