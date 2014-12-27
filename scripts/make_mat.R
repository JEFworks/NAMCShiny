library(SAScii)

make.mat <- function(path, year) {
    parse.SAScii(paste(path, "nam", year, "inp.txt", sep=""), beginline = 14 )
    mat <- read.SAScii(paste(path, "NAMCS20", year, sep=""), paste(path, "nam", year, "inp.txt", sep=""), beginline = 14) 
    return(mat)
}
