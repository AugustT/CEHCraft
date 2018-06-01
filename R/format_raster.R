#' Convert rasters for mapping
#' 
#' This function does a number of tasks to make the maps ready
#' for building into a minecraft world. This includes translating
#' the lcm types.
#' 
#' @param lcm Raster of the Land Cover Map
#' @param dtm Raster digital terrain model
#' @param name Character, the name of the map, ususally the location
#' @param outDir Character, the location the save the results, usually a temporary location
#' @param exagerate_elevation How much should elevation be exaggerated by?
#' @param snow_height the height above which snow will appear. Defaults to 700m above sea level
#' 
#' @import raster
#' 
#' @export
#' 
#' @return A list of length 2. first element is the path to the dtm, second is the lcm

format_raster <- function(lcm,
                          dtm,
                          name = 'MyWorld',
                          outDir = tempdir(),
                          exagerate_elevation = 2,
                          snow_height = 700){
  
  # Use the DTM so set regions where there should be snow
  lcm[dtm > snow_height] <- 78
  
  for(i in seq(20, 200, 20)){
    temp <- lcm[dtm > (snow_height - i) & dtm > ((snow_height - i) + 20)]
    prob <- 1 - (i / 200)
    temp[runif(length(temp)) < prob] <- 78
    lcm[dtm > (snow_height - i) & dtm > ((snow_height - i) + 20)] <- temp
  }
  
  lcm[dtm > (snow_height - 100)]
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
  
  # rotate to get north in the right place
  dtm <- apply(t(dtm),2,rev)
  
  cat('\nMinimum height: ', min(dtm))
  cat('\nMaximum height: ', max(dtm))
  
  # Write it out
  dtm_path <- file.path(outDir, paste0('dtm-', name, '.csv'))
  write.table(dtm, file = dtm_path,
              sep = ',',
              row.names = FALSE,
              col.names = FALSE)
  
  ## LCM ##
  lcm_class$EUNIS2_CODE <- as.numeric(as.factor(lcm_class$EUNIS2))

  # add crop types #
  lcm_class[lcm_class$LCLU_Name == "be (Beetroot)", "EUNIS2_CODE"] <- 29
  lcm_class[lcm_class$LCLU_Name == "fb (Field bean)", "EUNIS2_CODE"] <- 30
  lcm_class[lcm_class$LCLU_Name == "ma (Maize)", "EUNIS2_CODE"] <- 31
  lcm_class[lcm_class$LCLU_Name == "or Oilseed rape)", "EUNIS2_CODE"] <- 32
  lcm_class[lcm_class$LCLU_Name == "ot (Other)", "EUNIS2_CODE"] <- 33
  lcm_class[lcm_class$LCLU_Name == "po (Potatoes)", "EUNIS2_CODE"] <- 34
  lcm_class[lcm_class$LCLU_Name == "sb (Spring barley)", "EUNIS2_CODE"] <- 35
  lcm_class[lcm_class$LCLU_Name == "sw (Spring wheat)", "EUNIS2_CODE"] <- 36
  lcm_class[lcm_class$LCLU_Name == "wb (Winter barley)", "EUNIS2_CODE"] <- 37
  lcm_class[lcm_class$LCLU_Name == "ww (Winter wheat)", "EUNIS2_CODE"] <- 38
  lcm_class[lcm_class$LCLU_Name == "Bog", "EUNIS2_CODE"] <- 9
  lcm_class[lcm_class$LCLU_Name == "Freshwater", "EUNIS2_CODE"] <- 4
  lcm_class[lcm_class$LCLU_Name == "Inland rock", "EUNIS2_CODE"] <- 23
  lcm_class[lcm_class$LCLU_Name == "Non woodland-Agriculture land", "EUNIS2_CODE"] <- 24
  lcm_class[lcm_class$LCLU_Name == "Woodland-Uncertain", "EUNIS2_CODE"] <- 19
  lcm_class[lcm_class$LCLU_Name == "Woodland-Cloud \\ shadow", "EUNIS2_CODE"] <- 19
  lcm_class[lcm_class$LCLU_Name == "Woodland-Assumed woodland", "EUNIS2_CODE"] <- 19
  lcm_class[lcm_class$LCLU_Name == "Saline lagoons", "EUNIS2_CODE"] <- 999
  lcm_class[lcm_class$LCLU_Name == "Suburban", "EUNIS2_CODE"] <- 251
  lcm_class[lcm_class$LCLU_Name == "Non woodland-Urban", "EUNIS2_CODE"] <- 251
  lcm_class[lcm_class$LCLU_Name == "Neutral grassland", "EUNIS2_CODE"] <- 131
  lcm_class[lcm_class$LCLU_Name == "gr (Improved grassland)", "EUNIS2_CODE"] <- 132
  lcm_class[lcm_class$LCLU_Name == "Lowland meadows", "EUNIS2_CODE"] <- 133
  
  
  lcm <- round(raster::as.matrix(lcm), digits = 3)
  
  # flip lat for minecraft #
  lcm <- lcm[, rev(1:ncol(lcm))]
  
  # rotate to get north in the right place
  lcm <- apply(t(lcm),2,rev)
  
  # Add snow to this bit
  for(i in unique(as.vector(lcm))){
    if(i %in% lcm_class$LCLU){
      lcm[lcm == i] <- lcm_class$EUNIS2_CODE[lcm_class$LCLU == i]
    } else if(i == 250){ #sea
      lcm[lcm == i] <- 4 # sea = water
    } else if(i == 78){ #snow
      # do nothing
    } else if(i %in% 100:102){ #roads
      # do nothing
    } else {
      lcm[lcm == i] <- 13 # unknown = grass
    }
  }
  
  lcm_path <- file.path(outDir, paste0('lcm-', name, '.csv'))
  
  write.table(lcm, file = lcm_path, sep = ',',
              row.names = FALSE, col.names = FALSE)
  
  return(list(lcm_path = lcm_path, dtm_path = dtm_path,
              lcm_ras = lcm, dtm_ras = dtm))
  
}