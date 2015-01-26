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