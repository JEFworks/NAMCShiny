library(shiny)
library(zoo) # For rollapply().
library(lubridate) # For datetime handling.
library(dplyr) # For collapsing a dataframe by date.
library(ggplot2) # For plotting.
library(scales) # For specifying breaks in the plots.
library(reshape2) # For collapsing dataframes.

# Load a character vector of ReasonForVisit strings indexed by code numbers.
# > code2name[1:3]
#         -9                         48000                         31000 
#    "Blank"         "Progress visit, NOS" "General medical examination" 
load('data/dict.RData')

# Load a dataframe with patient information and ReasonForVisit code numbers.
# > mat[1:5, ]
#      VMONTH VYEAR VDAYR AGE SEX ETHNIC RACE  RFV1  RFV2 RFV3
# 2854     12  2002     2  72   2      2    1 67000    -9   -9
# 2855     12  2002     2  42   2      2    1 58100 10501   -9
# 2856     12  2002     2  65   2      2    3 22050    -9   -9
# 2857     12  2002     2  71   2      2    1 15451 18700   -9
# 2858     12  2002     2  77   1      2    1 19251    -9   -9
load('data/mat.RData')

mat$Date = mdy(with(mat, paste(VMONTH, VDAYR, VYEAR, sep = "-")))

Days = seq(
  from = as.Date(head(mat$Date, 1)),
  to = as.Date(tail(mat$Date, 1)),
  by = "day"
)
Blank = data.frame(Date = Days, Total = NA)

#' Define server logic.
#' @param input A list of items set by the input controls on the page.
#' @param output A list of items displayed in the output DOM.
#' @param session A session for a particular user of the application.
shinyServer(function(input, output, session) {
  # Define the DOM element called "mychart".
  output$mychart <- renderPlot({
    # Select a subset of patients.
    idx_Demographics = mat$ETHNIC %in% input$ethnic &
      mat$RACE %in% input$race &
      mat$AGE >= input$age[1] &
      mat$AGE <= input$age[2]
    
    # If "Male" or "Female" is selected, then filter. Don't filter for "Both".
    if (input$sex %in% c(1, 2)) {
      idx_Demographics = idx_Demographics & mat$SEX %in% input$sex  
    }

    # Data to plot
    d <- do.call(cbind, lapply(1:length(input$code), function(i) {
      # Collapse the data by day.
      Collapsed = summarise(
        group_by(mat[idx_Demographics, ], Date),
        Total = sum(RFV1 == input$code[i]) +
                sum(RFV2 == input$code[i]) +
                sum(RFV3 == input$code[i])
      )

      # Fill the 2003-2010 dataframe with values.
      Blank$Total = NA
      idx_Date = as.character(Blank$Date) %in% as.character(Collapsed$Date) 
      Blank$Total[idx_Date] = Collapsed$Total

      # Apply a sliding window.
      zs <- zoo(Blank$Total, Blank$Date)
      
      # Replace NA with 0.
      zs[is.na(zs)] = 0

      rollapply(
        zs,
        FUN = function(x) sum(x, na.rm = TRUE),
        width = as.integer(input$window.size),
        by = as.integer(input$window.step),
        align = "left"
      )
    }))
    d <- as.data.frame(d)
    colnames(d) <- code2name[as.character(input$code)]
    #rownames(d) <- make.unique(t.lab)
    d$Date <- as.Date(rownames(d))
    
#     if (input$facet_row == '.') {
      m <- melt(d, id.vars = c("Date"))
#     } else {
#       m <- melt(d, id.vars = c("Date", input$facet_row))  
#     }

    p <- ggplot() +
      geom_line(data = m,
                aes(x = Date, y = value, group = variable, color = variable)) +
      theme_linedraw(base_size = 16) +
      scale_x_date(breaks = date_breaks("years"),
                   minor_breaks = "1 month",
                   labels = date_format("%Y")) +
      labs(x = "", y = "Count", color = "Reason")
    
#     facets <- paste(input$facet_row, '~', '.')
#     if (facets != '. ~ .') {
#       p <- p + facet_grid(facets)
#     }

    print(p)
  })
})