############### SPLINE MODULE ###############




# Imports spline logic
source("Logic/quadraticSpline.R")

# Ui for spline

ui_spline <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    tags$head(
      tags$style(
        HTML("
           
           pre {
              white-space: pre-wrap;
              width: 175%; 
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
          
          width = 4,
          
          # Well panel for inputs
          
          wellPanel(
            fileInput(ns("splineFile"), "Upload CSV file"),
            numericInput(ns("splineEstimate"), "Estimate", value = 0),
            actionButton(ns("splineClear"), "Clear", width = "100%", style = "margin-bottom: 1px; background-color: #E8083E !important; color: white !important;"),
          ),
          
          # Well panel for CSV contents
          
          wellPanel(
            h3("CSV Data"),
            DTOutput(ns("splineTable"))
          
          )
        ),
        
        
        # Output section (right panel)
        
        column(
          width = 8,
          h3("Estimated Value"),
          verbatimTextOutput(ns("output_yEval")),
          
          h3("Interval Function"),
          verbatimTextOutput(ns("output_y_fx")),
          
          h3("Functions"),
          verbatimTextOutput(ns("output_fx"))
          )
        )
    )
  )
}

# server for spline

server_spline <- function(id) {
  moduleServer(
    id, 
    function(input, output, session) {
      data <- reactiveVal(NULL)
      splineResult <- reactiveVal(NULL)
      estimate <- reactiveVal(0)
      
      
      # File input
      observeEvent(input$splineFile, {
        data(read.csv(input$splineFile$datapath, header = FALSE))
      })
      
      # Rendering of csv data
      output$splineTable <- renderDT({
        datatable(data(), editable = FALSE, colnames = c("X", "Y"))
      })
      
      
      # Getting to be estimated x value
      
      observeEvent(input$splineEstimate, {
        if (is.na(input$splineEstimate) == FALSE)
        {
          estimate(input$splineEstimate) 
        }
      })
      
      
      # Clearing input
      observeEvent(input$splineClear, {
        reset("splineFile")
        data(NULL)
        reset("splineEstimate")
        splineResult(NULL)
      })
      
      
      # Solving for quadratic spline
      observe({
        
        if ((is.null(data()) == FALSE) && (is.na(estimate()) == FALSE))
        {
          splineResult(splineProcess(data(), estimate()))
        }
      })
      
      
      # Renders results
      
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