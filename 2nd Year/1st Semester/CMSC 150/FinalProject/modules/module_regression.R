source("Logic/regression.R")


ui_regression <- function(id) 
{
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
           
            /* Customize slider ticks */
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
          
          width = 4,  # Set the desired width, you can adjust this value
          
          wellPanel(
            fileInput(ns("regressionFile"), "Upload CSV file"),
            sliderTextInput(
              ns("degreeScroller"), "Degree",
              choices = as.character(0:10),
              grid = TRUE,
              dragRange = TRUE
            ),
            numericInput(ns("regressionEstimate"), "Estimate", value = 0),
            actionButton(ns("regressionClear"), "Clear", width = "100%", style = "margin-bottom: 1px; background-color: #E8083E !important; color: white !important;")
          ),
          
          wellPanel(
            h3("CSV Data"),
            DTOutput(ns("regressionTable"))
            
          )
        ),
        column(
          width = 8,
          # Reactive output for Estimated Value
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


server_regression <- function(id)
{
  moduleServer(
    id,
    function(input, output, session) 
    {
      disable("degreeScroller")
      
      regressionData <- reactiveVal(NULL)
      regResult <- reactiveVal(NULL)
      regEstimate <- reactiveVal(0)
      
      observeEvent(input$regressionFile, {
        regressionData(read.csv(input$regressionFile$datapath, header = FALSE))
        
        if (!is.null(regressionData())) {
          enable("degreeScroller")
          updateSliderTextInput(session, "degreeScroller", choices = as.character(0:(nrow(regressionData()) - 1)))
        }
      })
      
      output$regressionTable <- renderDT({
        datatable(regressionData(), editable = FALSE, colnames = c("X", "Y"))
      })
      
      observeEvent(input$regressionEstimate, {
        if (is.na(input$regressionEstimate) == FALSE)
        {
          regEstimate(input$regressionEstimate) 
        }
      })

      
      observe({
        if ((is.null(regressionData()) == FALSE) && (is.na(regEstimate()) == FALSE))
        {
          regResult(PolynomialRegression(as.numeric(input$degreeScroller), regressionData(), regEstimate()))
        }
      })
      
      observeEvent(input$regressionClear, {
        reset("regressionFile")
        regressionData(NULL)
        reset("degreeScroller")
        reset("regressionEstimate")
        disable("degreeScroller")
      })
      
      
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
      
      # output$regressionGraph <- renderPlot({
      #   x <- seq(0, 10, by = 1)
      #   y <- regResult()$polynomial_function(x)
      #   plot(x, y, type = "l")
      #   
      #   points(regResult()$xVal, regResult()$yVal, col = "red", pch = 16)
      # })
      
      
      
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
  
 
