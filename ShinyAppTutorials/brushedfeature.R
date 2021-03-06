## Advanced App - Brush Feature

server <- function(input, output, session) {
  library(ggplot2) # for the diamonds dataset, and ggplot feature
  library(DT) # for the dataTableOutput

  output$plot <- renderPlot({
    ggplot(diamonds, aes(price, carat)) + geom_point()
  })
  
  diam <- reactive({
    user_brush <- input$user_brush
    sel <- brushedPoints(diamonds, user_brush)
    return(sel)
  })
  
  output$table <- DT::renderDataTable(DT::datatable(diam()))
}

ui <- fluidPage(
  h1("Using the brush feature to select specific observations"),
  plotOutput("plot", brush = "user_brush"),
  dataTableOutput("table")
  #DT::dataTableOutput("tableDT")
)

shinyApp(ui = ui, server = server)