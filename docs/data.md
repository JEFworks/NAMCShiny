## Contents

-   Introduction

-   Steps to get started with the NAMCS data

-   Summary statistics describing the NAMCS data

## Introduction

Read this tutorial to get started with the `.RData` files we have prepared for
you.

NAMCS provides data in an outdated `.exe` format [here][1]. We already
converted it to a user-friendly format that you can use immediately.

[1]: ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NAMCS/

## Steps to get started with the NAMCS data

1.  Download and install [RStudio].

2.  Open RStudio and execute these commands to download the data:

    ```{r}
    f1 = "https://github.com/JEFworks/NAMCShiny/raw/master/data/mat.RData"
    f2 = "https://github.com/JEFworks/NAMCShiny/raw/master/data/dict.RData"
    
    download.file(f1, basename(f1), method = "curl", extra = "-L")
    download.file(f2, basename(f2), method = "curl", extra = "-L")
    ```

3.  Next, load the variables stored in the `.RData` files:

    ```{r}
    load("mat.RData")
    load("dict.RData")
    ```

4.  Check that the variables `code2name` and `mat` are loaded:

    ```{r}
    ls()
    # [1] "code2name"      "mat"
    ```

    `code2name` is a character vector of ReasonForVisit strings indexed by
    code numbers:

    ```{r}
    code2name[1:3]
    #       -9                 48000                         31000 
    #  "Blank" "Progress visit, NOS" "General medical examination" 
    ```

    `mat` is a dataframe with patient demographic information and three
    ReasonForVisit code numbers (RFV1, RFV2, RFV3):

    ```{r}
    mat[1:5, ]
    #      VMONTH VYEAR VDAYR AGE SEX ETHNIC RACE  RFV1  RFV2 RFV3
    # 2854     12  2002     2  72   2      2    1 67000    -9   -9
    # 2855     12  2002     2  42   2      2    1 58100 10501   -9
    # 2856     12  2002     2  65   2      2    3 22050    -9   -9
    # 2857     12  2002     2  71   2      2    1 15451 18700   -9
    # 2858     12  2002     2  77   1      2    1 19251    -9   -9
    ```

[RStudio]: http://www.rstudio.com/products/rstudio/download/

## Summary statistics describing the NAMCS data

### Number of patients of each race and ethnicity

```{r}
x = with(mat, table(RACE, ETHNIC))
rownames(x) = RACE_codes[rownames(x)]
colnames(x) = ETHNIC_codes[colnames(x)]
x
#                                     ETHNIC
# RACE                                  Blank Hispanic or Latino Not Hispanic or Latino
#   Blank                               27665               3746                   3015
#   White Only                           6166              18564                 140744
#   Black/African American only          1151                798                  19253
#   Asian only                            214                302                   6099
#   Native Hawaiian/Oth Pac Isl only       33                 58                    549
#   American Indian/Alaska Native only    165                126                   1384
#   More than one race reported            37                110                    481
```

