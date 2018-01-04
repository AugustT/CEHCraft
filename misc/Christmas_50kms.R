## Big Christmas maps

# Lake district, London, Isle of White
rm(list = ls())
library(CEHcraft)

postcodes <- c('LA229QL', 'SW1P1BU', 'PO383NN')

lcm_raster = raster::raster('W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/landcover_composite_map.tif')
dtm_raster = raster::raster('W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/uk_elev25.tif')
radius = 25000
outputDir = '.'
verbose = FALSE
exagerate_elevation = 2

for(postcode in postcodes){

  postcode <- toupper(gsub(' ', '', postcode))
  
  cat('\n\n##########################',
      '\nBuilding world for', postcode,
      '\n##########################\n\n')
  
  cat('Cropping dtm...')
  elev_cr <- crop_layer(postcode = postcode,
                        radius_m = radius,
                        layer = dtm_raster)
  cat('done\n')
  
  raster::plot(elev_cr)
  
  cat('Cropping lcm...')
  lcm_cr <- crop_layer(postcode = postcode,
                       radius_m = radius,
                       layer = lcm_raster)
  cat('done\n')
  raster::plot(lcm_cr)
  
  #rm(list = c('dtm_raster', 'lcm_raster'))
  
  dtm <- elev_cr
  
  # Set the y scaling to be the same as the x and y
  dtm <- round(raster::as.matrix(dtm)/(25/exagerate_elevation))
  
  # set NA values (I have found these in the sea) to the min
  dtm[is.na(dtm)] <- min(dtm, na.rm = TRUE)
  
  # flip lat for minecraft #
  dtm <- dtm[, rev(1:ncol(dtm))]
  
  # Set the minimum height
  dtm <- (dtm -  min(dtm)) + 63
  
  # If the max height is >250 try a couple of things
  if(max(dtm) > 250){ # First make the whole thing lower
    dtm <- (dtm -  min(dtm)) + 5
    if(max(dtm) > 250){ # second, rescale so that it fits
      multiplier <- 250/max(dtm)
      dtm <- round(dtm * multiplier)
    }
  }
  
  cat('\nMinimum height: ', min(dtm))
  cat('\nMaximum height: ', max(dtm))

}

rm(list = c('dtm_raster', 'lcm_raster'))

system.time({postcode_map(postcode = 'LA229QL',
                          outputDir = 'C:/Users/tomaug/OneDrive - NERC/aRt/Minecraft/worlds/50km',
                          radius = 25000,
                          verbose = TRUE)})

system.time({postcode_map(postcode = 'SW1P1BU',
                          outputDir = 'C:/Users/tomaug/OneDrive - NERC/aRt/Minecraft/worlds/50km',
                          radius = 25000,
                          verbose = TRUE,
                          exagerate_elevation = 3)})

system.time({postcode_map(postcode = 'PO383NN',
                          outputDir = 'C:/Users/tomaug/OneDrive - NERC/aRt/Minecraft/worlds/50km',
                          radius = 25000,
                          verbose = TRUE,
                          exagerate_elevation = 3)})

