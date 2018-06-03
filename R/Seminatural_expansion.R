
#' Perform semi-natural habitat expansion scenario
#' 
#' @param lcm_path A character string giving the path to the lcm csv
#' @param seminatural_expansion 0.2
#' @param improved_grassland_expansion 0.1
#' @param woodland_expansion 0.05
#' @param prop_winter_wheat 0.20
#' @param prop_oilseed_rape 0.10
#' @param prop_barley 0.20
#' @param prop_field_bean 0.05
#' @param prop_potato 0.05
#' @param prop_sugar_beet 0.05
#' @param prop_maize 0.05
#' @return NULL
#' 
#' @export
#' 
#' @import raster

seminatural_expansion <- function(lcm_path,
                                  seminatural_expansion = 0.2,       
                                  improved_grassland_expansion = 0.1,
                                  woodland_expansion = 0.05,        
                                  prop_winter_wheat = 0.20,
                                  prop_oilseed_rape = 0.10,
                                  prop_barley = 0.20,
                                  prop_field_bean = 0.05,
                                  prop_potato = 0.05,
                                  prop_sugar_beet = 0.05,
                                  prop_maize = 0.05){
  
  lcm_tab <- read.csv(lcm_path, header = FALSE)
  
  lcm <- raster(as.matrix(lcm_tab))
  
  # get clumps of fields
  arable <- clumpIDs(lcm, c(29:38))
  org_ara_area <- as.numeric(freq(arable != 0)[freq(arable != 0)[,1]==1,2])
  
  improved_grassland <- clumpIDs(lcm, c(13, 132))
  org_IG_area <- as.numeric(freq(improved_grassland != 0)[freq(improved_grassland != 0)[,1]==1,2])
  
  seminatural_grassland <- clumpIDs(lcm, c(12,14:16,133,131))
  org_SNG_area <- as.numeric(freq(seminatural_grassland != 0)[freq(seminatural_grassland != 0)[,1]==1,2])
  
  woodland <- clumpIDs(lcm, c(19))
  org_W_area <- as.numeric(freq(woodland != 0)[freq(woodland != 0)[,1]==1,2])
  
  ## CREATE MORE Semi-natural
  # expand by 20%
  to_convert_IG <- getClumpsToconvert(improved_grassland, seminatural_grassland, seminatural_expansion)
  
  # add these conversions to LCM as random
  for(i in to_convert_IG){
    lcm[improved_grassland %in% i] <- sample(c(12,14:16,133,131), size = 1)
  }
  
  ## Add conversion of arable if not enough ##
  if(attr(to_convert_IG, 'needed') != 0){
    to_convert_IG <- getClumpsToconvert(arable, seminatural_grassland, 
                                        target_area = attr(to_convert_IG, 'needed'))
    for(i in to_convert_IG){
      lcm[arable %in% i] <- sample(c(12,14:16,133,131), size = 1)
    }                 
  }
  
  # now recreate classes
  arable <- clumpIDs(lcm, c(29:38))
  improved_grassland <- clumpIDs(lcm, c(13, 132))
  seminatural_grassland <- clumpIDs(lcm, c(12,14:16,133,131))
  
  ## CREATE MORE BROADLEAFED WOODLAND
  # expand by 5%
  to_convert_W <- getClumpsToconvert(improved_grassland, woodland, 
                                       woodland_expansion)
  
  # add these conversions to LCM as random
  for(i in to_convert_W){
    lcm[improved_grassland %in% i] <- 19
  }
  
  if(attr(to_convert_W, 'needed') != 0){
    to_convert_W <- getClumpsToconvert(arable, woodland, 
                                      target_area = attr(to_convert_IG, 'needed'))
    for(i in to_convert_W){
      lcm[arable %in% i] <- 19
    }                 
  }
  
  arable <- clumpIDs(lcm, c(29:38))
  improved_grassland <- clumpIDs(lcm, c(13, 132))
  woodland <- clumpIDs(lcm, c(19))
  
  ## CREATE MORE IMPROVED GRASSLAND
  # expand by 10%
  target_area <- org_IG_area * improved_grassland_expansion
  to_convert_SNG <- getClumpsToconvert(arable, improved_grassland, 
                                       target_area = target_area)
  
  # add these conversions to LCM as random
  for(i in to_convert_SNG){
    lcm[arable %in% i] <- sample(c(13, 132), size = 1)
  }
  

  # CHANGE CROP TYPES
  cps <- data.frame(props = rev(c(prop_winter_wheat, prop_oilseed_rape,
                                  prop_barley, prop_field_bean,
                                  prop_potato, prop_sugar_beet,
                                  prop_maize)),
                    ids = c(31, 33, 34, 30, 35, 32, 38))

  # now change these crop types
  ignore <- NULL
  for (i in 1:nrow(cps)){
    to_convert <-  convert_within_clumps(arable, cps$ids[i], cps$props[i],
                                         ids_to_not_change = ignore)
    lcm[arable %in% to_convert] <- cps$ids[i]
    for(j in to_convert) arable[arable == j] <- cps$ids[i]*1000 + (j/1000)
    ignore <- c(ignore, cps$ids[i])
  }

  write.table(round(raster::as.matrix(lcm), digits = 3), file = lcm_path, sep = ',',
              row.names = FALSE, col.names = FALSE)
}