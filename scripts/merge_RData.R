#####
# Merge 2003 to 2010 Reason for Visits for NAMCShiny application
#####

#####
# Load
#####

load('../data/NAMCS2010.RData')
mat.2010 <- mat
lab.dict.2010 <- lab.dict
for.dict.2010 <- for.dict

load('../data/NAMCS2009.RData')
mat.2009 <- mat
lab.dict.2009 <- lab.dict
for.dict.2009 <- for.dict

load('../data/NAMCS2008.RData')
mat.2008 <- mat
lab.dict.2008 <- lab.dict
for.dict.2008 <- for.dict

load('../data/NAMCS2007.RData')
mat.2007 <- mat
lab.dict.2007 <- lab.dict
for.dict.2007 <- for.dict

load('../data/NAMCS2006.RData')
mat.2006 <- mat
lab.dict.2006 <- lab.dict
for.dict.2006 <- for.dict

load('../data/NAMCS2005.RData')
mat.2005 <- mat
lab.dict.2005 <- lab.dict
for.dict.2005 <- for.dict

load('../data/NAMCS2004.RData')
mat.2004 <- mat
lab.dict.2004 <- lab.dict
for.dict.2004 <- for.dict

load('../data/NAMCS2003.RData')
mat.2003 <- mat
lab.dict.2003 <- lab.dict
for.dict.2003 <- for.dict

######
# Combine all data
######

require(plyr)
mat <- rbind.fill(
    mat.2003,
    mat.2004,
    mat.2005,
    mat.2006,
    mat.2007,
    mat.2008,
    mat.2009,
    mat.2010
)

# Order by date
mat.ordered <- mat[order(mat[,'VYEAR'],mat[,'VMONTH'],mat[,'VDAYR'], decreasing=F),]
mat <- mat.ordered

# Fix to make reason for visit codes more consistent
mat[mat$RFV1 == 90000,'RFV1'] = -9 
mat[mat$RFV2 == 90000,'RFV2'] = -9
mat[mat$RFV3 == 90000,'RFV3'] = -9
# Substitute unimputed race for consistency
mat[is.na(mat$RACE),'RACE'] = mat$RACEUN[is.na(mat$RACE)] 
# Substitute unimputed ethnicity for consistency
mat[is.na(mat$ETHNIC),'ETHNIC'] = mat$ETHUN[is.na(mat$ETHNIC)] 

# Save filtered and unfiltered versions
mat.all <- as.data.frame(mat)
save(mat.all, file='../data/merged.RData')
mat <- as.data.frame(mat.all[, c('VMONTH', 'VYEAR', 'VDAYR', 'AGE', 'SEX', 'ETHNIC', 'RACE', 'RFV1', 'RFV2', 'RFV3')])
save(mat, file='../data/merged_filtered.RData')

######
# Dictionaries
######

# Sort by frequency
codes.freq <- sort(table(unlist(mat[,c('RFV1', 'RFV2', 'RFV3')])), decreasing=T)
codes.order <- names(codes.freq)
# Combine codes from 2010 and 2003; should be conserved
code2name <- for.dict.2010['RFVF'][[1]][codes.order]
na <- codes.order[is.na(code2name)]
code2name[na] <- for.dict.2003['RFVF'][[1]][na]
code2name <- code2name[codes.order]
name2code <- names(code2name); names(name2code) <- code2name

# Save dictionaries
save(code2name, name2code, file='../data/merged_dict.RData')
