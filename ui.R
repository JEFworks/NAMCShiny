library(shiny)

# Define UI 
shinyUI(navbarPage(
  title = "NAMCShiny",
  
  tabPanel(
    title = "Plot",

    h3("NAMCShiny is an interactive web application for visualizing health trends based on data from the 2003-2010 National Ambulatory Medical Care Survey (NAMCS). Explore trends and patterns in the reasons for medical visits for different patient demographic stratifications."),
    
    plotOutput("mychart"),
  
    # Main
    fluidRow(
      column(
        width = 4,
        
        h4("Reason for Visit"), 
        selectInput('code', NA, name2code, selected = '14400',
                    multiple = TRUE, selectize = TRUE),
        
        h4("Smoothing"),
        wellPanel(
          sliderInput("window.size", "Window Size (days):",
                      min = 7, max = 365, value = 31),
          sliderInput("window.step", "Window Step (days):",
                      min = 7, max = 365, value = 7)
        )
      ),
      
      column(
        width = 4,
        
        h4("Age"),
        wellPanel(
          sliderInput("age", NA, min = 0, max = 100, value = c(0, 100))
        ),
        
        h4("Sex"), 
        wellPanel(  
  #         checkboxGroupInput("sex", NA, list(
  #           "Female" = '1',
  #           "Male" = '2'
  #         ), selected = c('1','2'))
          radioButtons("sex", NA, choices = list(
              "Female and Male" = 3,
              "Female" = 1,
              "Male" = 2
            ),
            selected = 3
          )
  #         , selectInput('facet_row', 'Facet Row', c(None='.', Sex='SEX'))
        )
      ),
      
      column(
        width = 4,
        
        h4("Race"), 
        wellPanel(   
          checkboxGroupInput("race", NA, list(
            "White Only" = '1',
            "Black/African American only" = '2',
            "Asian only" = '3',
            "Native Hawaiian/Oth Pac Isl only" = '4',
            "American Indian/Alaska Native only" = '5',
            "More than one race reported" = '6', 
            "Blank" = '-9'
          ), selected=c('1','2','3','4','5','6','-9'))
        ),
  
        h4("Ethnicity"), 
        wellPanel(
            checkboxGroupInput("ethnic", NA, list(
              "Hispanic or Latino" = '1',
              "Not Hispanic or Latino" = '2', 
              "Blank" = '-9'
            ), selected=c('1','2','-9'))
        )
      )
    ) # End fluidRow
  ),
  
  tabPanel(
    title = "About",

    h3("About NAMCShiny"),
  
    sidebarLayout(
      sidebarPanel(
        p("This ",
          a("Shiny", href="http://shiny.rstudio.com/", target="_blank" ),
          "app was created by:"
        ),
        div(
	  img(src="http://custemized.org/img/team/jean_fan.jpg", height = 100, width=100, style='border-radius:50px'), 
	  br(),
	  a("Jean Fan", href="http://jefworks.com", target="_blank"),
	  style = 'float:left; text-align:center'
	),
        div(
	  img(src="http://custemized.org/img/team/kamil.jpg", height = 100, width=100 , style='border-radius:50px'),
	  br(),
	  a("Kamil Slowikowski", href="http://slowkow.com", target="_blank"),
	  style = 'float:left; text-align:center'
	),
	div(style = 'clear: left;'), br(),
        p("Download the NAMCS data (formatted as ready-to-use .Rdata files) and read the source code at our github project:", 
          a("NAMCShiny",
            href="https://github.com/JEFworks/NAMCShiny",
            target="_blank"
          )
        )
      ), 
      mainPanel(
        p("The National Ambulatory Medical Care Survey (NAMCS), is comprised of annual survey results from samples of patient visits to non-federal employed office-based physicians. The NAMCS data includes information such as patient demographics, reasons for the visit, any medications or therapies prescribed, and more. NAMCS public use data files are currently freely available for years 1973 to 2010 through", 
 	  a("the Center for Disease Control’s website", 
	    href="ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NAMCS/",
	    target="_blank"
	  )
	),
	p("We developed NAMCShiny to allow you to easily explore and visualize trends in the reasons for medical visits for different patient demographic stratifications based on sex, race, ethnicity, and age."),
        p("We encourage you to explore the NAMCS data and find trends in public health. Our vision is that applications like this one have the potential to guide the development of future evidence-based health policies.")
      )
    )
  ),

  tabPanel(
    title = "Contact Us",
    includeMarkdown("docs/contact-us.md")
  ),

  tabPanel(
    title = "Data",
    includeMarkdown("docs/data.md")
  )
))
