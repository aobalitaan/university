source("Logic/quadraticSpline.R")

ui_spline <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    withMathJax(),
    # Header with app title
    headerPanel(
      div(
        h1("Quadratic Spline Generic Solver", style = "color: #1DBFAA;"),
        hr()
      )
    ),
    
    # Main content area
    mainPanel(
      fluidRow(
        column(
          width = 4,  # Set the desired width, you can adjust this value
          wellPanel(
            fileInput(ns("file"), "Upload CSV file"),
            numericInput(ns("estimate"), "Estimate", value = 0),
            actionButton(ns("clear"), "Clear", width = "100%", style = "margin-bottom: 1px; background-color: #E8083E !important; color: white !important;"),
          )
        ),
        column(
          width = 8,
          # Reactive output for Estimated Value
          h3("Estimated Value"),
          verbatimTextOutput(ns("output_yEval")),
          
          # Reactive LaTeX output for Function
          h3("Function"),
          uiOutput(ns("output_y_fx"))
          
        )
      )
    )
  )
}

# Define the server module
server_spline <- function(id) {
  moduleServer(
    id, 
    function(input, output, session) {
      data <- reactiveVal(NULL)
      result <- reactiveVal(NULL)
      
      observeEvent(input$file, {
        data(read.csv(input$file$datapath, header = FALSE))
      })
      
      estimate <- reactiveVal(0)
      
      observeEvent(input$estimate, {
        estimate(input$estimate)
      })
      
      observe({
        if (is.null(data()) == FALSE)
        {
          result(splineProcess(data(), estimate()))
        }
      })
      
      output$output_yEval <- renderText({
        if (is.null(result()$yEval))
        {
          "OUT OF RANGE"
        }
        else
        {
          result()$yEval
        }
      })
      
      output$output_y_fx <- renderUI({
        if (is.null(result()$yEval))
        {
          "OUT OF RANGE"
        }
        else
        {
          result()$fx
        }
      })
      
      
    }
  )
}