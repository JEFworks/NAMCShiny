library(shiny)

load('../data/RFV.RData')

# Define UI 
shinyUI(fluidPage(
    
  # Application title
  titlePanel("NAMCShiny"),

  h4("An interactive web application to explore the primary reason for medical visits based on the 2003-2010 National Ambulatory Medical Care Survey results"), 
  br(),

  # Descriptions
  sidebarLayout(
    sidebarPanel(
      p("To download the data and code used in this",
        a("Shiny app", href="http://shiny.rstudio.com/", target="_blank"),
        "as well as additional NAMCS data processed for R, please see:", 
        br(),
        a("NAMCShiny on github", href="#", target="_blank")
      )
    ),
    mainPanel(
      p("The National Ambulatory Medical Care Survey (NAMCS) is a national survey designed to meet the need for objective, reliable information about the provision and use of ambulatory medical care services in the United States. Results are based on a sample of visits to non-federal employed office-based physicians who are primarily engaged in direct patient care."),
      p("We encourage further exploration of NAMCS data to identify potential trends in public health and guide the development of future health policies.")
    ),
  ),

  # Break
  hr(),

  # Main
  fluidRow(

    column(8,
      ## Main plot
      h4("Plot for 2003 to 2010 Period"), 
      plotOutput("timePlot"),

      ## Window sliders
      h4("Smoothing"), 
      wellPanel(   
          fluidRow(
            column(6,  
              sliderInput("window.size",
                  "Window Size:",
                  min = 1,
                  max = 10000,
                  value = 5000)
            ),
            column(6,  
               sliderInput("window.jump",
                  "Window Jump:",
                  min = 1,
                  max = 5000,
                  value = 500)
            )
          )
        )
    ),

    column(4,
      ## Reason for visit
      h4("Primary Reason for Visit"), 
      wellPanel(
          checkboxGroupInput("code", NA, name2code, selected='14400')
      )
    )
  )
))