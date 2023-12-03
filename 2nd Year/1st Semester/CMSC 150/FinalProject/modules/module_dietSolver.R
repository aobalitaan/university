
# Sample data (replace this with your actual data loading logic)
database <- read.csv("C:/Users/Axel/Desktop/university/2nd Year/1st Semester/CMSC 150/FinalProject/database.csv")

ui_dietSolver <- function() {
  fluidPage(
    useShinyjs(),  # Initialize shinyjs
    
    fluidRow(
      # Left panel
      div
      (
        id = "leftPanel",
        style = "position: fixed; 
           top: 20; 
           left: 0;
           bottom: 0;
           width: 20%; 
           height: 100%; 
           background-color: #f8f8f8; 
           border-right: 1px solid #ccc;
           overflow-y: auto;
           padding-top: 70px;
           padding-left: 20px;
          font-size: 15px
        ",

        textInput("searchInput", "Search Foods:"),
        checkboxGroupInput("foodChecklist", "", choices = database$Foods)
      )
    ),
      
    
    # Fixed-bottom strip with buttons and opaque rectangle
    fixedRow(
      div(id = "buttonPanel", 
          style = "position: fixed; 
                  top: 0; 
                  width: 100%; 
                  height: 50px;
                  background-color: #ffffff; 
                  border-top: 1px solid #ccc;",
          
          column(3, align = "center",
                 actionButton("resetBtn", "Reset")
          ),
          column(3, align = "center",
                 actionButton("selectAllBtn", "Select All")
          ),
          column(3, align = "center",
                 actionButton("submitBtn", "Submit")
          )
      )
    ),
    
  )
}

server_dietSolver <- function(input, output, session) 
{
}

