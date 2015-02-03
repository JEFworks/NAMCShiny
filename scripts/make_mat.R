#' Use the SAScii library to convert the NAMCS data into an RData matrix
#' @param path: path to folder containing nam*inp.txt and NAMCS*
#' @param year: data year
make.mat <- function(path, year) {
    require(SAScii)
    parse.SAScii(paste(path, "nam", year, "inp.txt", sep=""), beginline = 14 )
    mat <- read.SAScii(paste(path, "NAMCS", year, sep=""), paste(path, "nam", year, "inp.txt", sep=""), beginline = 14) 
    return(mat)
}

#' Sample runner to generate RData matrix for each year of the NAMCS data
main <- function() {
     path <- '../NAMCS/2003/'
     year <- '03'
     mat <- make.mat(path, year)
}
