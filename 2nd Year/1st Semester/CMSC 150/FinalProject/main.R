library(shiny)
library(shinyWidgets)

source("C:/Users/Axel/Desktop/university/2nd Year/1st Semester/CMSC 150/FinalProject/simplex.R")
database = read.csv("C:/Users/Axel/Desktop/university/2nd Year/1st Semester/CMSC 150/FinalProject/database.csv")
userinput = matrix();

ui <- fluidPage(
  pickerInput(
    inputId = "choices",
    label = "Checkbox (multiple page, 10 per page)",
    choices = database[[1]],
    options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
    multiple = TRUE
  ),
  tableOutput("table")
)
server <- function(input, output, session) {
  output$table <- renderTable({
    database[database[[1]] %in% input$choices, ]
  })
}

shinyApp(ui = ui, server = server)