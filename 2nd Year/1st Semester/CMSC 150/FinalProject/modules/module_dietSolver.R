library("magrittr")
library("dplyr")

library(shiny)
library(shinyWidgets)

database <- read.csv("C:/Users/Axel/Desktop/university/2nd Year/1st Semester/CMSC 150/FinalProject/database.csv")

ui_dietSolver <- function(id) {
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
          width: 100%;
          align: center;
          padding-left: 0px;
          padding-right: 0px;
          font-size: 14px;
          position: relative;
          margin-left: 18%; /* Adjust the margin to match the width of the left panel */
          margin-right: 0%;
          overflow-x: hidden;
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
      
        class = "scrollable-content",  # Apply the custom class to the scrollable content
        tableOutput(ns("out_selectedFoods"))
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
             background-color: #f8f8f8; 
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
    
        .btn-group > .btn.active {
          background-color: #27ae60;
          color: #ffffff;
        }
        .btn-group > .btn:not(.active):hover {
          background-color: #ecf0f1;
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
               textInput(inputId = ns("searchInput"),
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
                            icon = icon("trash"),
                            width = "100%",
                            offset = 0)),
        column(2,
               style = "margin-right: 0px; 
                        padding-left: 2px;
                        padding-right: 0px
                  ",
               actionButton(ns("selectAll"), 
                            align = "center",
                            label = NULL,
                            icon = icon("check"),
                            width = "100%",
                            offset = 0))
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
      # Reactive values to store selected values
      selected_values <- reactiveValues(values = NULL)
      
      filtered_list <- reactive({
        if (is.null(input$searchInput) || input$searchInput == "") {
          database
        } else {
          database[grepl(input$searchInput, database$Foods, ignore.case = TRUE), ]
        }
      })
      
      observe({
        # Update selected values only if the filtered list changes
        if (!identical(selected_values$values, input$in_foodCheckbox)) {
          # Use isolate to prevent triggering this observer on its own changes
          isolate({
            valid_selected_values <- input$in_foodCheckbox[input$in_foodCheckbox %in% filtered_list()$Foods]
            selected_values$values <- valid_selected_values
          })
        }
      })
      
      output$noSuchFoodMessage <- renderText({
        if (nrow(filtered_list()) == 0) {
          "No such food."
        } else {
          ""
        }
      })
      
      output$out_foodCheckbox <- renderUI({
        if (nrow(filtered_list()) == 0) {
          textOutput("")
        } else {
          checkboxGroupButtons(
            inputId = session$ns("in_foodCheckbox"),
            label = NULL,
            choices = filtered_list()$Foods,
            individual = FALSE,
            width = "100%",
            direction = "vertical",
            justified = FALSE,
            selected = selected_values$values  # Use the reactiveValues
          )
        }
      })
      
      output$out_selectedFoods <- renderTable({
        if (!is.null(selected_values$values)) {
          selected_foods <- database[database$Foods %in% selected_values$values, ]
          selected_foods
        } else {
          NULL
        }
      })
    }
  )
}





