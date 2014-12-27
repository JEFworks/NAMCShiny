make.lab.dict <- function(path, year) {
    text <- read.table(paste(path,'nam', year, 'lab.txt', sep=''), sep=';', strip.white=T, stringsAsFactors=F)[,1]
    lab <- do.call(rbind, lapply(1:length(text), function(i) {
        s <- strsplit(text[i], '=')[[1]] 
        if(length(s)==2) return(s)
    }))
    lab.dict <- lab[,2]
    names(lab.dict) <- lab[,1]
    return(lab.dict)
}

make.for.dict <- function(path, year) {
    text <- read.table(paste(path, 'nam', year, 'for.txt', sep=''), sep='\n', strip.white=T, stringsAsFactors=F)[,1]
    text <- paste(text, collapse='\n')[[1]]
    text.split <- unlist(strsplit(text, ';'))
    text.has.value <- unlist(lapply(text.split, function(t) grepl('\nVALUE', t)))
    text.value <- text.split[text.has.value]

    text.value.list <- lapply(1:length(text.value), function(i) {
        tv <- strsplit(text.value[i], '\n')[[1]]
        n <- gsub('VALUE ', '', tv[2])
        v <- tv[3:length(tv)]
        return(list(n, v))
    })

    text.value.n <- unlist(lapply(1:length(text.value.list), function(i) text.value.list[[i]][[1]]))
    text.value.v <- lapply(1:length(text.value.list), function(i) text.value.list[[i]][[2]])

    value.dict <- lapply(1:length(text.value.v), function(i) {
        v <- text.value.v[[i]]
        mat <- do.call(rbind, strsplit(v, '='))
        d <- mat[,2]
        names(d) <- gsub("(^ +)|( +$)", "", mat[,1]) ## strip white space
        return(d)
    })
    names(value.dict) <- text.value.n
    return(value.dict)
}

