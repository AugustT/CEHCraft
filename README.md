# CEHcraft

This code is developed for a public engagement project run by the Centre for Ecology and Hydrology, UK. There will be more information on our website in teh future, when the project is complete

Installing the package is easy and can be done in a couple of lines in R

```r
library(devtools)
install_github(repo = 'augustt/CEHcraft')
```

Use like this

```r
rm(list = ls())

library(CEHcraft)

dir.create('worlds', showWarnings = FALSE)

postcode_map(postcode = 'Ox1 3Pw', 
             outputDir = 'worlds')
```