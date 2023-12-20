############### DIET SOLVER MODULE ###############



# Imports the logic for simplex
source("Logic/simplex.R")

# Default Constraints
minimum = c(2000, 0, 0, 0, 0, 25, 50, 5000, 50, 800, 10)
maximum = c(2250, 300, 65, 2400, 300, 100, 100, 50000, 20000, 1600, 30)
maxserve = 10


# Ui for diet solver
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
          z-index: 1000;
        }

        .scrollable-content {
          width: 80%;
          align: center;
          padding-left: 10px;
          padding-right: 0px;
          font-size: 14px;
          position: relative;
          margin-left: 20%;
          margin-right: 0%;
          overflow-x: auto;
        }
      "))
    ),
    
    # Main whole page
    
    fluidRow(
      
      column(
        3,
        class = "fixed-left-panel",
        
        # Add left panel
        leftPanel(ns)
      ),
      column(
        9,
        # Right Panel
        
        fluidRow(
          style = "width: 100%;
                  margin-left: -4.5%;
                  padding-right: 16%;
                  position: fixed;
                  background-color: #1DBFAA;
                  ",

          align = "center",
          
          # Long solve button
          actionButton(ns("in_solve"), label = "SOLVE", icon("check"), width = "100%", style = "background-color: #1DBFAA;
                       color: white; font-weight: 500px; font-size: 18px; border: #1DBFAA")
        ),
        
        # table of data in right
        
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
  # Left panel (Item selectors)
  
  
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
        
        
        # Search text input 
        column(8,
               style = "margin-right: 0px; 
                  padding-right: 0px",
               textInput(inputId = ns("in_search"),
                         label = NULL,
                         placeholder = "Enter a food name",
                         width = "100%")),
        
        # Reset button
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
        
        # Select all button
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
      
        # Item checkboxes
        uiOutput(ns("out_foodCheckbox")),
      
        # If search not in database
        textOutput(ns("noSuchFoodMessage"))
    ),
  )
}


# Module server for diet solver
server_dietSolver <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      # Loads the database
      database <- read.csv("database.csv")
      
      
      # Initialized empty reactive variabales
      selectedKeys <- reactiveValues(values = NULL)
      
      filteredKeys <- reactiveValues(values = NULL)
      unselectedKeys <- reactiveValues(values = NULL)
      simplexResult <- reactiveValues(value = NULL);
      
      
      # Filters items based on search
      
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
      
      
      # Updates selected key list
      
      observeEvent(input$in_foodCheckbox, {
        input_key <- input$in_foodCheckbox
        
        selectedKeys$values <- union(selectedKeys$values, input_key)
        
        unselectedKeys$values <- setdiff(filteredKeys$values, input_key)
        selectedKeys$values <- setdiff(selectedKeys$values, unselectedKeys$values)
        
       

      }, ignoreNULL = FALSE)
      
      
      # Select All - adds all items
      observeEvent(input$in_selectAll,
                   {
                     selectedKeys$values <- union(selectedKeys$values, database$Foods)
                   })
      
      
      # Clear - removes all items 
      observeEvent(input$clear,
                   {
                     selectedKeys$values <- NULL;
                   })
      
      
      # Outputs reactive table
      output$out_table <- renderTable(
        {
          database[which(database$Foods %in% selectedKeys$values), ]
        }, align = "c"
      )
      
      # Output if search is not in database
      output$noSuchFoodMessage <- renderText({
        if (length(filteredKeys$values) == 0) {
          "No such food."
        } else {
          ""
        }
      })
      
      # Outputs the food check boxes
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
            choices = filteredKeys$values, # Choices are reactive, changes with the search
            individual = FALSE,
            width = "100%",
            direction = "vertical",
            justified = FALSE,
            selected = selectedKeys$values
          )
        }
      })
    
      
      # If none is selected solve button is disabled
      observe({
      if (is.null(selectedKeys$values) || length(selectedKeys$values) == 0) {
        disable("in_solve")
      } 
      else 
      {
        enable("in_solve")
      }
    })
    
      # By default modal shows the final solution
      showModalPage <- reactiveVal(1) 
      
      # If user clicks solve
      observeEvent(input$in_solve, {
        showModalPage(1)
        
        # Solves diet minimization
        
        simplexResult$values <- simplexMinimize(database[which(database$Foods %in% selectedKeys$values), ], minimum, maximum, maxserve)
        
        # Shows the modal
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
    
      # Renders the modal's content
      
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
    
      # Determines which modal page to show
      
      observeEvent(input$togglePage, {
        showModalPage(ifelse(showModalPage() == 1, 2, 1))
      })
      
      #Close modal
      
      observeEvent(input$closeModal, {
        removeModal()
      })
    }
  )
}

# Page 1 of the modal, final solution

modalPanelContentPage1 <- function(simplexResult) {
  
  # If not feasible, prompts user
  
  if (simplexResult$feasible == FALSE) 
  {
    fluidPage(
      h1("No Feasible Solution", style = "text-align: center;"),
      
      h2("Initial Tableau", style = "text-align: center;"),
      h1(""),
      div(
        style = "overflow-x: auto; margin: auto;",
        renderTable(simplexResult$initial$tableau, include.rownames = TRUE, align = "c")
      ),
    )
  } 
  
  # else shows content
  else 
  {
    fluidPage(
      h1("Final Solution", style = "text-align: center;"),
      h1(""),
      h4(sprintf("ITERATION #%s", simplexResult$final$iteration), style = "padding-left: 0; text-align: center"),
      
      # Renders basic solution
      
      div(
        style = "overflow-x: auto; margin: auto; position: center; text-align: center;",
        
        renderTable(simplexResult$final$basicSol, include.rownames = TRUE, align = "c")
      ),
      
      h4("TABLEAU", style = "padding-left: 0; text-align: center;"),
      
      
      # Render table
      
      div(
        style = "overflow-x: auto; margin: auto;",
        renderTable(simplexResult$final$tableau, include.rownames = TRUE, align = "c")
      )
    )
  }
}


# Page 2 of the modal

modalPanelContentPage2 <- function(simplexResult) {
  
  
  # If not feasible, prompts user
  
  if (simplexResult$feasible == FALSE) 
  {
    fluidPage(
      h1("No Feasible Solution", style = "text-align: center;")
    )
  } 
  else
  {
    fluidPage(
      
      # Renders initial tableu
      
      h1("Initial Tableau", style = "text-align: center;"),
      h1(""),
      div(
        style = "overflow-x: auto; margin: auto;",
        renderTable(simplexResult$initial$tableau, include.rownames = TRUE, align = "c")
      ),
      
      
      # Renders per iteration
      
      h1("Iterations", style = "text-align: center;"),
      
      
      # From https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/lapply
      # https://stackoverflow.com/questions/43260089/using-lapply-in-renderui-in-shiny-module
      
      
      lapply(seq(from = 1, to = length(simplexResult$perIterate), by = 3), function(i) {
        iteration <- simplexResult$perIterate[[i]]
        tableau <- simplexResult$perIterate[[i + 1]]
        basicSol <- simplexResult$perIterate[[i + 2]]
   
        
        tagList(
          h4(sprintf("ITERATION #%s", iteration), style = "padding-left: 0; text-align: center"),
          div(
            style = "overflow-x: auto; margin: auto; position: center; text-align: center;",
            renderTable(t(basicSol), include.rownames = TRUE, align = "c")
          ),
          h4("Tableau", style = "padding-left: 0; text-align: center;"),
          div(
            style = "overflow-x: auto; margin: auto;",
            renderTable(tableau, include.rownames = TRUE, align = "c")
          )
        )
      })
    )
  }
}







