#####
# Make RData files in the data/ directory
#####

#' Use the SAScii library to convert the NAMCS data into an RData matrix
#' @param path: path to folder containing nam*inp.txt and NAMCS*
#' @param year: data year
make.mat <- function(path, year) {
    require(SAScii)
    parse.SAScii(paste(path, "nam", year, "inp.txt", sep=""), beginline = 14 )
    mat <- read.SAScii(paste(path, "NAMCS", year, sep=""), paste(path, "nam", year, "inp.txt", sep=""), beginline = 14) 
    return(mat)
}

#' Make dictionary of label codes to descriptors
#' Label codes comprise the column names in the data matrices
#' @param path: path to folder containing nam*lab.txt
#' @param year: data year
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

#' Make dictionary of value codes to descriptors for each label code
#' Value codes comprise the matrix entries
#' A set of value codes exist for each label code or matrix column
#' @param path: path to folder containing nam*for.txt
#' @param year: data year
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

#' Main runner
main <- function() {
     path <- '../NAMCS/2003/'
     year <- '03'
     lab.dict <- make.lab.dict(path, year)
     for.dict <- make.for.dict(path, year)
     mat <- make.mat(path, year)
     save(mat, lab.dict, for.dict, file='../data/NAMCS2003.RData')

     path <- '../NAMCS/2004/'
     year <- '04'
     lab.dict <- make.lab.dict(path, year)
     for.dict <- make.for.dict(path, year)
     mat <- make.mat(path, year)
     save(mat, lab.dict, for.dict, file='../data/NAMCS2004.RData')

     path <- '../NAMCS/2005/'
     year <- '05'
     lab.dict <- make.lab.dict(path, year)
     for.dict <- make.for.dict(path, year)
     mat <- make.mat(path, year)
     save(mat, lab.dict, for.dict, file='../data/NAMCS2005.RData')

     path <- '../NAMCS/2006/'
     year <- '06'
     lab.dict <- make.lab.dict(path, year)
     for.dict <- make.for.dict(path, year)
     mat <- make.mat(path, year)
     save(mat, lab.dict, for.dict, file='../data/NAMCS2006.RData')

     path <- '../NAMCS/2007/'
     year <- '07'
     lab.dict <- make.lab.dict(path, year)
     for.dict <- make.for.dict(path, year)
     mat <- make.mat(path, year)
     save(mat, lab.dict, for.dict, file='../data/NAMCS2007.RData')

     path <- '../NAMCS/2008/'
     year <- '08'
     lab.dict <- make.lab.dict(path, year)
     for.dict <- make.for.dict(path, year)
     mat <- make.mat(path, year)
     save(mat, lab.dict, for.dict, file='../data/NAMCS2008.RData')

     path <- '../NAMCS/2009/'
     year <- '09'
     lab.dict <- make.lab.dict(path, year)
     for.dict <- make.for.dict(path, year)
     mat <- make.mat(path, year)
     save(mat, lab.dict, for.dict, file='../data/NAMCS2009.RData')

     path <- '../NAMCS/2010/'
     year <- '10'
     lab.dict <- make.lab.dict(path, year)
     for.dict <- make.for.dict(path, year)
     mat <- make.mat(path, year)
     save(mat, lab.dict, for.dict, file='../data/NAMCS2010.RData')
}