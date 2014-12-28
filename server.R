library(shiny)
library(zoo) # For rollapply
library(sqldf) # For sql querying

load('data/dict.RData') # For code2name
load('data/mat.RData') # For mat

# Define server logic
shinyServer(function(input, output, session) {

    output$mychart <- renderLineChart({

        # Time
        #t <- rollapply(mat[,1:3], width = input$window.size, by = input$window.jump, FUN = mean, align = "left")
        #t.lab <- paste(t[,3], t[,2], t[,1], sep='/')

        # Form query
        query <- paste('SELECT RFV1 FROM mat WHERE SEX in (' ,
          paste(input$sex, collapse=','),
          ') AND ETHNIC in (',
          paste(input$ethnic, collapse=','),
          ') AND RACE in (',
          paste(input$race, collapse=','),
          ') AND AGE between', input$age.min, 'and', input$age.max,
          collapse='')
        print(query)
        # Query matrix for subset
        q <- sqldf(query)

        # Data to plot
        d <- as.data.frame(do.call(cbind, lapply(1:length(input$code), function(i) {
            dt <- rollapply(q==input$code[i], width = input$window.size, by = input$window.jump, FUN = sum, align = "left") 
        })))
        colnames(d) <- code2name[input$code]
        #rownames(d) <- make.unique(t.lab)
        
        return(d)
    })
})