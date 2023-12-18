source("Logic/quadraticSpline.R")

ui_spline <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    tags$head(
      tags$style(
        HTML("
           /* Set a fixed width for verbatim text outputs */
           pre {
              white-space: pre-wrap;
              width: 175%; /* Set your desired fixed width */
           }
      ")
      )
    ),
    headerPanel(
      div(
        h1("Quadratic Spline Generic Solver"),
        hr()
      )
    ),
    
    # Main content area
    mainPanel(
      fluidRow(
        column(
          
          width = 4,  # Set the desired width, you can adjust this value
          wellPanel(
            fileInput(ns("splineFile"), "Upload CSV file"),
            numericInput(ns("splineEstimate"), "Estimate", value = 0),
            actionButton(ns("splineClear"), "Clear", width = "100%", style = "margin-bottom: 1px; background-color: #E8083E !important; color: white !important;"),
          ),
          
          wellPanel(
            h3("CSV Data"),
            DTOutput(ns("splineTable"))
          
          )
        ),
        column(
          width = 8,
          # Reactive output for Estimated Value
          h3("Estimated Value"),
          verbatimTextOutput(ns("output_yEval")),
          
          h3("Interval Function"),
          verbatimTextOutput(ns("output_y_fx")),
          
          # Reactive LaTeX output for Function
          h3("Functions"),
          verbatimTextOutput(ns("output_fx"))
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
      splineResult <- reactiveVal(NULL)
      estimate <- reactiveVal(0)
      
      observeEvent(input$splineFile, {
        data(read.csv(input$splineFile$datapath, header = FALSE))
      })
      
      output$splineTable <- renderDT({
        datatable(data(), editable = FALSE, colnames = c("X", "Y"))
      })
      
      observeEvent(input$splineEstimate, {
        if (is.na(input$splineEstimate) == FALSE)
        {
          estimate(input$splineEstimate) 
        }
      })
      
      observeEvent(input$splineClear, {
        reset("splineFile")
        data(NULL)
        reset("splineEstimate")
        splineResult(NULL)
      })
      
      observe({
        
        if ((is.null(data()) == FALSE) && (is.na(estimate()) == FALSE))
        {
          splineResult(splineProcess(data(), estimate()))
        }
      })
      
      output$output_yEval <- renderText({
        if (is.null(splineResult()$yEval))
        {
          "OUT OF RANGE"
        }
        else
        {
          splineResult()$yEval
        }
      })
      
      output$output_y_fx <- renderText({
        if (is.null(splineResult()$yEval))
        {
          "OUT OF RANGE"
        }
        else
        {
          splineResult()$fx[splineResult()$y_fx]
        }
      })
      
      output$output_fx <- renderText({
        if (is.null(splineResult()$fx))
        {
          "OUT OF RANGE"
        }
        else
        {
          paste(splineResult()$fx, collapse = "\n")
        }
      })
      
      
    }
  )
}