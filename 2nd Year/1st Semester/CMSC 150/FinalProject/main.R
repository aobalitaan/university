# AXEL O. BALITAAN
# 2022 - 05153
# Project in CMSC 150


############### MAIN ###############





# Sets working directory to current directory of main
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# List of required libraries
required_libraries <- c("shiny", "shinyjs", "shinyWidgets", "DT", "magrittr", "dplyr")

# Install and load libraries if not already installed
for (lib in required_libraries) 
{
  if (!requireNamespace(lib, quietly = TRUE)) 
  {
    install.packages(lib, dependencies = TRUE)
  }
  
  library(lib, character.only = TRUE)
}


# imports modules
source("modules/module_home.R")
source("modules/module_dietSolver.R")
source("modules/module_regression.R")
source("modules/module_spline.R")


# Navigation bar page
ui <- fluidPage( 
  theme = shinythemes::shinytheme("flatly"), 
  navbarPage(
    id = "navbar",
    title = "CMSC 150 PROJECT",
    selected = "Home",
    position = "fixed-top",
    
    
    #Creates tabs for each module
    tabPanel("Home", ui_home("home")),
    tabPanel("Spline", ui_spline("spline")),
    tabPanel("Regression", ui_regression("regression")),
    tabPanel("Diet Solver", ui_dietSolver("dietSolver"))
  ),
  
  useShinyjs(),
  
  # Designs for tabpanel in navbar
  tags$head(
    tags$style(
      type = "text/css",
      HTML("
      
      @font-face {
        font-family: 'Montserrat';
        src: url('Montserrat-Regular.ttf') format('truetype');
        font-weight: normal;
        font-style: normal;
      }
      @font-face {
        font-family: 'Montserrat';
        src: url('Montserrat-Bold.ttf') format('truetype');
        font-weight: bold;
        font-style: normal;
      }
      
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
        background-color: #21283A;
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



# Main Server
server <- function(input, output, session) 
{
  # By default Home is selected, switch tabs
  observeEvent(input$navbar_title_click, {
    updateTabsetPanel(session, "navbar", selected = "Home")
  })
  
  addClass(id = "navbar", class = "navbar-right")
  
  
  
  # Switch to diet solver if explore button was clicked in home module
  observeEvent(input$exploreBtn, {
    updateNavbarPage(session, "navbar", selected = "Diet Solver")
  })
  
  
  # Hosts servers
  server_dietSolver("dietSolver")
  server_spline("spline")
  server_regression("regression")
  server_home("home")
}

shinyApp(ui = ui, server = server)
