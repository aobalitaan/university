############### REGRESSION MODULE ###############



# Imports regression logic
source("Logic/regression.R")


# UI for regression
ui_regression <- function(id) 
{
  ns <- NS(id)
  
  fluidPage(
    tags$head(
      tags$style(
        HTML("
          
           pre {
              white-space: pre-wrap;
              width: 175%;
           }
           
            
           .irs-with-grid .irs-grid-text {
              font-size: 10px;
              line-height: 1.5em;
              white-space: nowrap;
           }
      ")
      )
    ),
    headerPanel(
      div(
        h1("Polynomial Regression Solver"),
        hr()
      )
    ),
    
    mainPanel(
      fluidRow(
        column(
          
          width = 4,
          
          
          # Input panel
          
          wellPanel(
            
            # CSV file input
            
            fileInput(ns("regressionFile"), "Upload CSV file"),
            sliderTextInput(
              ns("degreeScroller"), "Degree",
              choices = as.character(1:10),
              grid = TRUE,
              dragRange = TRUE
            ),
            
            # Estimate Input
            
            numericInput(ns("regressionEstimate"), "Estimate", value = 0),
            actionButton(ns("regressionClear"), "Clear", width = "100%", style = "margin-bottom: 1px; background-color: #E8083E !important; color: white !important;")
          ),
          
          # Shows the content of the csv
          wellPanel(
            h3("CSV Data"),
            DTOutput(ns("regressionTable"))
            
          )
        ),
        
        # Right (Results) side
        column(
          width = 8,
    
          h3("Estimated Value"),
          verbatimTextOutput(ns("output_regression_Y")),
          
          h3("Function"),
          verbatimTextOutput(ns("output_regression_Fx")),
          
          h3("Graph"),
          plotOutput(ns("regressionGraph"))
        )
      )
    )
  )
}


# Server for regression

server_regression <- function(id)
{
  moduleServer(
    id,
    function(input, output, session) 
    {
      
      # By default degree scroller is disabled (no file yet)
      
      disable("degreeScroller")
      
      regressionData <- reactiveVal(NULL)
      regResult <- reactiveVal(NULL)
      regEstimate <- reactiveVal(0)
      
      
      # If user inputted a file
      
      observeEvent(input$regressionFile, {
        regressionData(read.csv(input$regressionFile$datapath, header = FALSE))
        
        # Enables and sets up the degree scroller
        if (!is.null(regressionData())) {
          enable("degreeScroller")
          updateSliderTextInput(session, "degreeScroller", choices = as.character(1:(nrow(regressionData()) - 1)))
        }
      })
      
      # Renders the csv file table
      
      output$regressionTable <- renderDT({
        datatable(regressionData(), editable = FALSE, colnames = c("X", "Y"))
      })
      
      # Gets the value to be estimated
      
      observeEvent(input$regressionEstimate, {
        if (is.na(input$regressionEstimate) == FALSE)
        {
          regEstimate(input$regressionEstimate) 
        }
      })

      # If a file is loaded, generate results
      
      observe({
        if ((is.null(regressionData()) == FALSE) && (is.na(regEstimate()) == FALSE))
        {
          regResult(PolynomialRegression(as.numeric(input$degreeScroller), regressionData(), regEstimate()))
        }
      })
      
      # Clear button, clears/resets all input
      
      observeEvent(input$regressionClear, {
        reset("regressionFile")
        regressionData(NULL)
        reset("degreeScroller")
        reset("regressionEstimate")
        disable("degreeScroller")
      })
      
      
      # Results Rendering
      
      output$output_regression_Y <- renderText({
        if (is.null(regResult()$y_estimate))
        {
          "DATA NOT VALID"
        }
        else
        {
          paste(regResult()$y_estimate, collapse = "\n")
        }
      })
      
      output$output_regression_Fx <- renderText({
        if (is.null(regResult()$polynomial_string))
        {
          "DATA NOT VALID"
        }
        else
        {
          paste(regResult()$polynomial_string, collapse = "\n")
        }
      })
      

      # Renders the regression graph      
      
      output$regressionGraph <- renderPlot({
        
        
        req(regResult())  # Ensure regResult is not NULL
        
        if (as.numeric(input$degreeScroller) == 0) 
        {
          plot(0, 0, type = "n", xlim = c(min(regResult()$xVal), max(regResult()$xVal)), ylim = c(0, regResult()$y_estimate), col = "red", pch = 16, 
               xlab = "X", ylab = "Y", main = "Polynomial Regression")
          abline(a = regResult()$polynomial_function(0), b = 0, col = "blue")
        }
        else
        {
          x <- seq(min(regResult()$xVal), max(regResult()$xVal), length.out = 100)
          y <- regResult()$polynomial_function(x)
          
          plot(x = regResult()$xVal, y = regResult()$yVal, col = "red", pch = 16, 
               xlab = "X", ylab = "Y", main = "Polynomial Regression")
          
          lines(x, y, type = "l", col = "blue")
        }
      })
    }      
  )
}
  
 
