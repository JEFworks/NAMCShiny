# Any code in this file is guaranteed to be called before either
# ui.R or server.R

library(shiny)
library(zoo) # For rollapply().
library(lubridate) # For datetime handling.
library(dplyr) # For collapsing a dataframe by date.
library(ggplot2) # For plotting.
library(scales) # For specifying breaks in the plots.
library(reshape2) # For collapsing dataframes.

# Load a character vector of ReasonForVisit strings indexed by code numbers.
load('data/dict.RData')
# > code2name[1:3]
#         -9                         48000                         31000 
#    "Blank"         "Progress visit, NOS" "General medical examination" 

# Load a dataframe with patient information and ReasonForVisit code numbers.
load('data/mat.RData')
# > mat[1:5, ]
#      VMONTH VYEAR VDAYR AGE SEX ETHNIC RACE  RFV1  RFV2 RFV3
# 2854     12  2002     2  72   2      2    1 67000    -9   -9
# 2855     12  2002     2  42   2      2    1 58100 10501   -9
# 2856     12  2002     2  65   2      2    3 22050    -9   -9
# 2857     12  2002     2  71   2      2    1 15451 18700   -9
# 2858     12  2002     2  77   1      2    1 19251    -9   -9

# Create a Date column 
mat$Date = mdy(with(mat, paste(VMONTH, VDAYR, VYEAR, sep = "-")))

Days = seq(
  from = as.Date(head(mat$Date, 1)),
  to = as.Date(tail(mat$Date, 1)),
  by = "day"
)
Blank = data.frame(Date = Days, Total = NA)
