############### HOME MODULE ###############


# UI for Home

ui_home <- function(id) {
  ns <- NS(id)
  fluidPage(
    
    
    # Welcome Section
    
    div(
      style = "background-image: url('bg_landing.png'); 
            background-size: cover; 
            text-align: left;   /* Align text and buttons to the left */
            width: 108%;         /* Full width */
            padding-top: 25%;
            padding-left: 5%;
            padding-right: 55%;  /* Add right padding */
            margin-left: -45px;
            height: 100vh;",
      h1("Welcome!", style = "color: white; font-size: 50px; font-weight: bold;"),
      p("Explore the practical application of computing concepts in the real world with our CMSC 150 Project. Delve into the tangible utilization of computing principles, showcasing their relevance in various scenarios. Discover three powerful tools: the Quadratic Spline Solver, Polynomial Regression Solver, and Diet Problem Solver (Simplex).",
        style = "color: white; font-size: 16px; font-weight: normal;"
      ),
      br(),
      actionButton("exploreBtn", "Explore Now", style = "background-color: #1DBFAA; color: white; font-weight: 500;")
    ),
    
    # About Section
    
    column(
      width = 6,
      h3("About the Website"),
      p("Meticulously crafted using RShiny, our website represents the culmination of the CMSC 150 Project. Immerse yourself in the interactive interface and witness how computing concepts seamlessly come to life in the form of practical tools."
      ),
      br(),
      actionButton(ns("learnMoreBtn"), "Learn More", class = "btn btn-secondary")
    ),
    
    # Developer Section
    
    column(
      width = 6,
      style = "padding-bottom: 2%",
      h3("About the Developer"),
      p("Axel O. Balitaan is a 19-year-old Computer Science student inspired to pursue the field after immersing himself in the world of technology through a K-drama called Start-Up. Beyond coding, Axel finds joy in dancing and jamming to music."
      ),
      br(),
      actionButton(ns("contactBtn"), "Contact Axel", class = "btn btn-info")
    ),
  )
}




# Server for home

server_home <- function (id)
{
  moduleServer(
    id,
    function(input, output, session)
    {
      
      # Clicking the learn more button
      
      observeEvent(input$learnMoreBtn, {
        showModal(
          modalDialog(
            id = "learnMoreModal",
            title = "User Manual",
            size = "l",
            withTags(
             tags$iframe(src = "UserManual.pdf", style = "width: 100%; height: 600px;", type = "application/pdf")
            ),
            
            easyClose = TRUE
          )
        )
      })
      
      # Clicking the contact button
      
      observeEvent(input$contactBtn, {
        showModal(
          modalDialog(
            id = "contactModal",
            title = "Contact Information",
            size = "s",
            HTML('<div>
              <p style="font-size: 18px;">Connect with Axel:</p>
              <ul>
                <li><a href="https://www.facebook.com/BalitaanAxel/" target="_blank"><img src="facebook_icon.png" alt="Facebook" style="width:24px;height:24px;margin-right:8px;"> Facebook</a></li>
                <li><a href="mailto:aobalitaan@up.edu.ph"><img src="gmail_icon.png" alt="Email" style="width:24px;height:24px;margin-right:8px;"> Email</a></li>
                <li><a href="https://github.com/aobalitaan" target="_blank"><img src="github_icon.png" alt="GitHub" style="width:24px;height:24px;margin-right:8px;"> GitHub</a></li>
                <li><a href="https://www.linkedin.com/in/axel-balitaan-b910b0241/" target="_blank"><img src="linkedin_icon.png" alt="LinkedIn" style="width:24px;height:24px;margin-right:8px;"> LinkedIn</a></li>
              </ul>
            </div>'),
            
            easyClose = TRUE
          )
        )
      })
    }
  )
}


