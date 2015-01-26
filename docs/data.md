# Data

Read this tutorial to get started with the `.RData` files we have prepared for
you.

NAMCS provides data in an outdated `.exe` format [here][1]. We already
converted it to a user-friendly format that you can use immediately.

[1]: ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NAMCS/

## Steps

1. Download and install [RStudio].

2. Open RStudio and execute these commands to download the data:

    ```{r}
    f1 = "https://github.com/JEFworks/NAMCShiny/raw/master/data/mat.RData"
    download.file(f1, basename(f1), method = "curl", extra = "-L")

    f2 = "https://github.com/JEFworks/NAMCShiny/raw/master/data/dict.RData"
    download.file(f2, basename(f2), method = "curl", extra = "-L")
    ```

3. Next, load the variables `code2name` and `mat` that are stored in the
   `.RData` files.

    ```{r}
    # Load a character vector of ReasonForVisit strings indexed by code numbers.
    # > code2name[1:3]
    #         -9                         48000                         31000 
    #    "Blank"         "Progress visit, NOS" "General medical examination" 
    load('data/dict.RData')

    # Load a dataframe with patient information and ReasonForVisit code numbers.
    # > mat[1:5, ]
    #      VMONTH VYEAR VDAYR AGE SEX ETHNIC RACE  RFV1  RFV2 RFV3
    # 2854     12  2002     2  72   2      2    1 67000    -9   -9
    # 2855     12  2002     2  42   2      2    1 58100 10501   -9
    # 2856     12  2002     2  65   2      2    3 22050    -9   -9
    # 2857     12  2002     2  71   2      2    1 15451 18700   -9
    # 2858     12  2002     2  77   1      2    1 19251    -9   -9
    load('data/mat.RData')
    ```

4. Go to town!

[RStudio]: http://www.rstudio.com/products/rstudio/download/
