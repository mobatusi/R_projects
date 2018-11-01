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

ui <- navbarPage("The Mining Stock Scale",
  tabPanel("Adjusting Your Mining Stocks", 
           tags$img(src="logo.png", width ="100px", height = "100px")),
  
  tabPanel("Documentation",
           includeText("documentation.pdf")),
  
  tabPanel("Data Table With the Underlying Data", 
           tags$video(src="WestWave-EEG.mp4", type = "video/mp4", controls = T,
                      width ="900px", height = "800px"))

  
)

server <- function(input, output, session) {
  data = read.csv(file = "course-proj-data.csv", sep = ",", header = TRUE)
  
}

shinyApp(ui, server)