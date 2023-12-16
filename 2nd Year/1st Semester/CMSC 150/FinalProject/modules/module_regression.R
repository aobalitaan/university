
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
      estimate <- reactiveVal(0)
      
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
          estimate(input$regressionEstimate) 
        }
      })
      
      observeEvent(input$regressionClear, {
        reset("regressionFile")
        regressionData(NULL)
        reset("degreeScroller")
        disable("degreeScroller")
      })
      
    }      
  )
}
  
 
