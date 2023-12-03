library(shiny)
library(shinyjs)

# Sample data (replace this with your actual data loading logic)
database <- read.csv("C:/Users/Axel/Desktop/university/2nd Year/1st Semester/CMSC 150/FinalProject/database.csv")

ui_dietSolver <- function() {
  fluidPage(
    useShinyjs(),  # Initialize shinyjs
    
    # Main content of the app goes here
    fluidRow(
      checkboxGroupInput("foodChecklist", "Select Foods:", choices = database$Foods),
    ),
    
    # Fixed-bottom strip with buttons and opaque rectangle
    fixedRow(
      div(id = "buttonPanel", style = "position: fixed; bottom: 0; width: 100%; background-color: rgba(255, 255, 255, 0.8); border-top: 1px solid #ccc;",
          column(4, align = "center",
                 actionButton("resetBtn", "Reset")
          ),
          column(4, align = "center",
                 actionButton("selectAllBtn", "Select All")
          ),
          column(4, align = "center",
                 actionButton("submitBtn", "Submit")
          )
      )
    )
  )
}

server_dietSolver <- function(input, output, session) {
  # Server logic goes here
}

shinyApp(ui = ui_dietSolver, server = server_dietSolver)
