library(shiny)
library(shinyjs)

ui <- fluidPage(
  withMathJax(),  # Enable MathJax rendering
  tabPanel(
    title = "Diagnostics", 
    h4(textOutput("diagTitle")),
    uiOutput("formula")
  )
)

server <- function(input, output, session){
  output$formula <- renderUI({
    my_calculated_value <- 5 + "x"^2  # Replace this with your dynamic calculation
    withMathJax(paste0("$$", my_calculated_value, "$$"))
  })
}

shinyApp(ui, server)
