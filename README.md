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

setwd('W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft')

elev_25 <- raster::raster(file.path('base_layers','uk_elev25.tif'))
lcm <- raster::raster(file.path('base_layers','landcover_composite_map.tif'))

elev_cr <- crop_layer(postcode = 'OX108BB',
                      radius_m = 5000,
                      layer = elev_25)

lcm_cr <- crop_layer(postcode = 'OX108BB',
                     radius_m = 5000,
                     layer = lcm)

dev.new()
par(mfrow = c(1, 2))
raster::plot(elev_cr, main = 'elevation')
raster::plot(lcm_cr, main = 'landcover')
```