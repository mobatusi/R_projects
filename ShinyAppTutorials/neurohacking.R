rm(list=ls())
library(ggplot2)
library(ggneuro)
library(RNifti)
library(kirby21.t1)
library(kirby21.fmri)
library(matrixStats)
library(shiny)
library(neurobase)


fname = get_fmri_filenames(visits =1, ids = 113)
# img = readnii(fname)
# img = fast_readnii(fname)
full = readNifti(fname)
img = apply(full, 1:3, mean)

curr_xyz =  ceiling(dim(img)/2)

gray_gradient = scale_fill_gradient(
  low = gray(0),
  high = gray(1),
  na.value = "black")

mat = apply(full, 4, c)


ui <- basicPage(
  plotOutput("plot1", click = "plot_click"),
  plotOutput("plot2"),
  verbatimTextOutput("info")
)

server <- function(input, output, session) {
  
  fd = neurobase::img_colour_df(img)
  # fd
  
  ## CHANGE HERE
  ## Set up buffert, to keep the click.
  click_saved <- reactiveValues(plot_click = NULL)
  
  ## CHANGE HERE
  ## Save the click, once it occurs.
  observeEvent(eventExpr = input$plot_click, handlerExpr = {
    click_saved$plot_click <- input$plot_click
  })
  
  get_data = reactive({
    
    # fd = full_data()
    ## need to figure out current xyz!
    # print(str(input$plot_click))
    print("before click data")
    print(curr_xyz)
    pc = click_saved$plot_click
    plane = pc$panelvar1
    print(is.null(plane))
    
    if (!is.null(plane)) {
      # curr_xyz = ##### SOMETHING
      curr_xyz = switch(
        plane,
        axial = c(pc$x, pc$y, curr_xyz[3]),
        coronal = c(pc$x, curr_xyz[2], pc$y),
        sagittal = c(curr_xyz[1], pc$x, pc$y))
      curr_xyz = floor(curr_xyz)
    }
    out = ggortho_img_df(fd, xyz = curr_xyz)
    curr_xyz <<- curr_xyz
    print("\n\n")
    L = list(plot= out, xyz =curr_xyz)
    L
  })
  
  output$plot1 <- renderPlot({
    # print("before getting data")
    # res = get_data()
    # print("after data")
    # out = ggplot(
    #   data = res,
    #   aes(x = x, y = y, fill = colour)) +
    #   geom_tile() +
    #   facet_wrap(~ plane2, nrow = 2, ncol = 2,
    #              scales = "free")
    # out = out + theme_black_legend +
    #   scale_fill_identity()
    # print("\n\n")
    # out
    out = get_data()
    out = out$plot
    out
  })
  
  output$plot2 <- renderPlot({
    out = get_data()
    xyz = out$xyz
    ind = which(colAlls(t(fd[, paste0("dim", 1:3)]) == xyz))
    tc = mat[ind, ]
    plot(tc, type ="l")
  })
  
  
  
}

shinyApp(ui=ui, server=server)