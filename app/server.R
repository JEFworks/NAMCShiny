library(shiny)
library(zoo) ## for rollapply

load('../data/RFV.RData')

# Define server logic
shinyServer(function(input, output) {

  output$timePlot <- renderPlot({

    if(length(input$code)>=1) {

        t <- do.call(cbind, lapply(1:length(input$code), function(i) {
            ts <- mat[,4]==input$code[i]
            t <- rollapply(ts, width = input$window.size, by = input$window.jump, FUN = sum, align = "left") 
            return(t)       
        }))
        
        ## make line plot
        name <- paste(code2name[input$code], ' (code: ', input$code, ') ', sep='')
        col <- rainbow(length(input$code))
        #plot(1:length(window), t[,1], type='l', main=name, ylim=c(0,1), col=col[1])
        plot(1:nrow(t), t[,1], type='l', main=name, ylim=c(0,max(t, na.rm=T)), col=col[1], xlab='window', ylab='frequency')
        if(ncol(t)>=2) { for(i in 2:ncol(t)) {
            points(1:nrow(t), t[,i], type='l', col=col[i])
        }}
    } else {
        plot(1, 0, type='l', main='Choose a Primary Reason for Visit', xlab='window', ylab='frequency')
    }
  })
})