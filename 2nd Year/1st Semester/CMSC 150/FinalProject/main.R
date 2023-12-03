library(shiny)
library(shinyjs)

source("C:/Users/Axel/Desktop/university/2nd Year/1st Semester/CMSC 150/FinalProject/modules/module_home.R")
source("C:/Users/Axel/Desktop/university/2nd Year/1st Semester/CMSC 150/FinalProject/modules/module_dietSolver.R")
source("C:/Users/Axel/Desktop/university/2nd Year/1st Semester/CMSC 150/FinalProject/modules/module_regression.R")
source("C:/Users/Axel/Desktop/university/2nd Year/1st Semester/CMSC 150/FinalProject/modules/module_spline.R")

ui <- fluidPage( 
  navbarPage(
    id = "navbar",
    title = "CMSC 150 PROJECT",
    selected = "Home",
    position = "fixed-top",
    
    tabPanel("Home", ui_home()),
    tabPanel("Spline", ui_spline()),
    tabPanel("Regression", ui_regression()),
    tabPanel("Diet Problem Solver", ui_dietSolver())
  ),
  
  shinyjs::useShinyjs(),
  
  
  tags$style(
    type = "text/css",
    HTML('
    body 
    {
      padding-top: 50px;
      background-color: #ffffff; /* Light background color */
      color: #000000; /* Text color */
      margin-left: 0; /* Remove left margin */
    }
  ')
  ),
  
  tags$head(tags$style(HTML('* {font-family: "Montserrat", font-size: "20"};')))
)


server <- function(input, output, session) {
  
  observeEvent(input$navbar_title_click, {
    updateTabsetPanel(session, "navbar", selected = "Home")
  })
  
  shinyjs::addClass(id = "navbar", class = "navbar-right")
  
  shiny::moduleServer("home", server_home)
  shiny::moduleServer("tab1", server_spline)
  shiny::moduleServer("tab2", server_regression)
}

shinyApp(ui = ui, server = server)
