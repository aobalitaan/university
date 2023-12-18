source("Logic/simplex.R")
minimum = c(2000, 0, 0, 0, 0, 25, 50, 5000, 50, 800, 10)
maximum = c(2250, 300, 65, 2400, 300, 100, 100, 50000, 20000, 1600, 30)
maxserve = 10


ui_dietSolver <- function(id) 
{
  ns <- NS(id)
  fluidPage(
    
    # Add custom CSS styles
    tags$head(
      tags$style(HTML("
        .fixed-left-panel {
          position: fixed;
          width: 18%;
          height: 100%;
          overflow-y: auto;
          z-index: 1000; /* Set a higher z-index to keep it on top */
        }

        .scrollable-content {
          width: 80%;
          align: center;
          padding-left: 10px;
          padding-right: 0px;
          font-size: 14px;
          position: relative;
          margin-left: 20%; /* Adjust the margin to match the width of the left panel */
          margin-right: 0%;
          overflow-x: auto;
        }
      "))
    ),
    
    fluidRow(
      column(
        3,
        class = "fixed-left-panel",  # Apply the custom class to the left panel
        leftPanel(ns)
      ),
      column(
        9,
        
        
        
        fluidRow(
          style = "width: 100%;
                  margin-left: -4.5%;
                  padding-right: 16%;
                  position: fixed;
                  background-color: #1DBFAA;
                  ",

          align = "center",
          
          actionButton(ns("in_solve"), label = "SOLVE", icon("check"), width = "100%", style = "background-color: #1DBFAA;
                       color: white; font-weight: 500px; font-size: 18px; border: #1DBFAA")
        ),
        
        class = "scrollable-content",
        fluidRow(
          align = "center",
          style = "margin-top: 50px;
                  width: 100%;
                  padding-left = 0;",
          tableOutput(ns("out_table"))
        )
        
      )
    )
  )
}

leftPanel <- function(ns) 
{
  fluidRow(
    style = "
              position: fixed; 
             top: 20; 
             left: 0;
             bottom: 0;
             width: 20%; 
             height: 100%; 
             background-color: #ffffff; 
             border-right: 1px solid #ccc;
             overflow-y: auto;
             overflow-x: hidden;
             padding-left: 20px;
             padding-right: 5px;
             padding-top: 65px;
             font-size: 15px",
    
    align = "center",
    
    div(
      tags$style(HTML("
        .btn-group > .btn:not(.active) {
          border-bottom: 2px solid #A5B6B8 !important;
          margin-bottom: 1px;
        }
        .btn-group > .btn.active {
          background-color: #27ae60;
          color: #ffffff;
        }
        .btn-group > .btn:not(.active):hover {
          background-color: #ecf0f1;
          color: #000000 !important;
        }
        .btn-group > .btn.active:hover {
          background-color: #c0392b;
          color: #ffffff;
        }
        ")
      ),
      
      
      fluidRow(
        style = "padding-right: 15px",
        
        column(8,
               style = "margin-right: 0px; 
                  padding-right: 0px",
               textInput(inputId = ns("in_search"),
                         label = NULL,
                         placeholder = "Enter a food name",
                         width = "100%")),
        
        column(2,
               style = "margin-right: 0px; 
                  padding-left: 2px;
                  padding-right: 0px",
               actionButton(ns("clear"),
                            align = "center",
                            label = NULL,
                            icon = icon("refresh"),
                            width = "100%",
                            offset = 0,
                            style = "background-color: #E8083E !important; color: white !important;")),  # Set red background color
        
        column(2,
               style = "margin-right: 0px; 
                  padding-left: 2px;
                  padding-right: 0px",
               actionButton(ns("in_selectAll"), 
                            align = "center",
                            label = NULL,
                            icon = icon("bolt"),
                            width = "100%",
                            offset = 0,
                            style = "background-color: #FB8D1A !important; color: white !important;"))  # Set yellow background color
      ),
        uiOutput(ns("out_foodCheckbox")),
        textOutput(ns("noSuchFoodMessage"))
    ),
    
    uiOutput(ns("foodTable"))
  )
}

server_dietSolver <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      database <- read.csv("database.csv")
      
      selectedKeys <- reactiveValues(values = NULL)
      
      filteredKeys <- reactiveValues(values = NULL)
      unselectedKeys <- reactiveValues(values = NULL)
      simplexResult <- reactiveValues(value = NULL);
      
      observeEvent(input$in_search, {
        input_search <- gsub("\\\\", " ", input$in_search)
        
        if (is.null(input_search) || input_search == "") 
        {
          filteredKeys$values <- database$Foods
        } 
        else 
        {
          filteredKeys$values <- database[grepl(input_search, database$Foods, ignore.case = TRUE), ]$Foods
        }
      })
      
      
      observeEvent(input$in_foodCheckbox, {
        input_key <- input$in_foodCheckbox
        
        selectedKeys$values <- union(selectedKeys$values, input_key)
        
        unselectedKeys$values <- setdiff(filteredKeys$values, input_key)
        selectedKeys$values <- setdiff(selectedKeys$values, unselectedKeys$values)
        
       

      }, ignoreNULL = FALSE)
      
      observeEvent(input$in_selectAll,
                   {
                     selectedKeys$values <- union(selectedKeys$values, database$Foods)
                   })
      
      observeEvent(input$clear,
                   {
                     selectedKeys$values <- NULL;
                   })
      output$out_table <- renderTable(
        {
          database[which(database$Foods %in% selectedKeys$values), ]
        }, align = "c"
      )
      
      output$noSuchFoodMessage <- renderText({
        if (length(filteredKeys$values) == 0) {
          "No such food."
        } else {
          ""
        }
      })
      
      output$out_foodCheckbox <- renderUI({
        if (length(filteredKeys$values) == 0) 
        {
          textOutput("")
        } 
        else 
        {
          checkboxGroupButtons(
            inputId = session$ns("in_foodCheckbox"),
            label = NULL,
            choices = filteredKeys$values,
            individual = FALSE,
            width = "100%",
            direction = "vertical",
            justified = FALSE,
            selected = selectedKeys$values
          )
        }
      })
    
      observe({
      if (is.null(selectedKeys$values) || length(selectedKeys$values) == 0) {
        disable("in_solve")
      } 
      else 
      {
        enable("in_solve")
      }
    })
    
      showModalPage <- reactiveVal(1) 
      
    
      observeEvent(input$in_solve, {
        showModalPage(1)
        simplexResult$values <- simplexMinimize(database[which(database$Foods %in% selectedKeys$values), ], minimum, maximum, maxserve)
        showModal(
          modalDialog(
            title = "Solver Result",
            size = "l",
            
            uiOutput(session$ns("modalContent")),
            
            footer = tagList(
              if (simplexResult$values$feasible == TRUE)
              {
                actionButton(session$ns("togglePage"), "More/Back", style = "background-color: #FB8D1A; color: white")
              },
              
              actionButton(session$ns("closeModal"), "Close", style = "background-color: #E8083E; color: white")
            ),
            easyClose = TRUE,
            style = "width: 150%; max-width: 100%; margin: 0;"
          )
        )
      })
    
      output$modalContent <- renderUI({
        if (showModalPage() == 1) 
        {
          modalPanelContentPage1(simplexResult$values)
        } 
        else 
        {
          modalPanelContentPage2(simplexResult$values)
        }
      })
    
      observeEvent(input$togglePage, {
        showModalPage(ifelse(showModalPage() == 1, 2, 1))
      })
      
      observeEvent(input$closeModal, {
        removeModal()
      })
    }
  )
}

modalPanelContentPage1 <- function(simplexResult) {
  if (simplexResult$feasible == FALSE) {
    fluidPage(
      h1("No Feasible Solution", style = "text-align: center;")
    )
  } 
  else {
    fluidPage(
      h1("Final Solution", style = "text-align: center;"),
      h1(""),
      h4(sprintf("ITERATION #%s", simplexResult$final$iteration), style = "padding-left: 0; text-align: center"),
      
      div(
        style = "overflow-x: auto; margin: auto; position: center; text-align: center;",
        
        renderTable(t(simplexResult$final$basicSol), include.rownames = TRUE, align = "c")
      ),
      
      h4("TABLEU", style = "padding-left: 0; text-align: center;"),
      
      div(
        style = "overflow-x: auto; margin: auto;",
        renderTable(simplexResult$final$tableu, include.rownames = TRUE, align = "c")
      )
    )
  }
}

modalPanelContentPage2 <- function(simplexResult) {
  if (simplexResult$feasible == FALSE) {
    fluidPage(
      h1("No Feasible Solution", style = "text-align: center;")
    )
  } 
  else
  {
    fluidPage(
      h1("Initial Tableu", style = "text-align: center;"),
      h1(""),
      div(
        style = "overflow-x: auto; margin: auto;",
        renderTable(simplexResult$initial$tableu, include.rownames = TRUE, align = "c")
      ),
      h1("Iterations", style = "text-align: center;"),
      
      # Use lapply to create a tagList directly
      lapply(seq(from = 1, to = length(simplexResult$perIterate), by = 3), function(i) {
        iteration <- simplexResult$perIterate[[i]]
        tableu <- simplexResult$perIterate[[i + 1]]
        basicSol <- simplexResult$perIterate[[i + 2]]
        t
        
        tagList(
          h4(sprintf("ITERATION #%s", iteration), style = "padding-left: 0; text-align: center"),
          div(
            style = "overflow-x: auto; margin: auto; position: center; text-align: center;",
            renderTable(t(basicSol), include.rownames = TRUE, align = "c")
          ),
          h4("TABLEU", style = "padding-left: 0; text-align: center;"),
          div(
            style = "overflow-x: auto; margin: auto;",
            renderTable(tableu, include.rownames = TRUE, align = "c")
          )
        )
      })
    )
  }
}







