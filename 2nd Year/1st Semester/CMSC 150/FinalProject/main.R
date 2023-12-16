setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(shiny)
library(shinyjs)
library(shinyWidgets)
library(DT)
library("magrittr")
library("dplyr")

source("modules/module_home.R")
source("modules/module_dietSolver.R")
source("modules/module_regression.R")
source("modules/module_spline.R")

ui <- fluidPage( 
  theme = shinythemes::shinytheme("flatly"), 
  navbarPage(
    id = "navbar",
    title = "CMSC 150 PROJECT",
    selected = "Home",
    position = "fixed-top",
    
    tabPanel("Home", ui_home()),
    tabPanel("Spline", ui_spline("spline")),
    tabPanel("Regression", ui_regression("regression")),
    tabPanel("Diet Solver", ui_dietSolver("dietSolver"))
  ),
  
  useShinyjs(),
  
  
  tags$head(
    tags$style(
      type = "text/css",
      HTML("
      
      body 
      {
        padding-top: 55px;
        margin-left: 0;
        overflow-x: hidden;
      }
      * 
      {
        font-family: 'Montserrat';
      }
      .navbar {
        font-weight: 450;
        font-size: 15px;
      }
      .navbar-brand {
        font-family: 'Montserrat';
        font-weight: 450;
        font-size: 20px;
      }
      .navbar-default .navbar-nav .active > a:after {
        content: '';
        position: absolute;
        left: 50%;
        bottom: 0;
        transform: translateX(-50%);
        width: 10px;
        height: 10px;
        border-radius: 70%;
        background-color: #1DBFAA;
      }
    ")
    )
  )
  
)


server <- function(input, output, session) {
  
  observeEvent(input$navbar_title_click, {
    updateTabsetPanel(session, "navbar", selected = "Home")
  })
  
  addClass(id = "navbar", class = "navbar-right")
  
  server_dietSolver("dietSolver")
  server_spline("spline")
  server_regression("regression")
}

shinyApp(ui = ui, server = server)
