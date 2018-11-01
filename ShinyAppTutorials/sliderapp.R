## Using Reactive and render in one app

server <- function(input, output, session) {
  data <-reactive({
    rnorm(50) *input$myslider
  })
  
  output$plot <- renderPlot({
    plot(data(), col='red', pch=21, bty ="n")
  })
} 
ui <- basicPage(
  h1("using reactive"),
  sliderInput(inputId = "myslider",
              label = "slider1",
              value =1, min=1, max=20),
  plotOutput("plot")
)

shinyApp(ui=ui, server=server)
