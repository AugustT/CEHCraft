#' Perform agricultural expansion scenario
#' 
#' @param lcm_path A character string giving the path to the lcm csv
#' @param arable_expansion 0.2
#' @param improved_grassland_expansion 0.1
#' @param prop_winter_wheat 0.55
#' @param prop_oilseed_rape 0.3
#' @return NULL
#' 
#' @export
#' 
#' @import raster

agricultural_expansion <- function(lcm_path,
                                   arable_expansion = 0.2,
                                   improved_grassland_expansion = 0.1,
                                   prop_winter_wheat = 0.55,
                                   prop_oilseed_rape = 0.3){
  
  lcm_tab <- read.csv(lcm_path, header = FALSE)
  
  lcm <- raster(as.matrix(lcm_tab))
  
  # get clumps of fields
  arable <- clumpIDs(lcm, c(29:38))
  org_ara_area <- as.numeric(freq(arable != 0)[freq(arable != 0)[,1]==1,2])
  
  improved_grassland <- clumpIDs(lcm, c(13, 132))
  org_IG_area <- as.numeric(freq(improved_grassland != 0)[freq(improved_grassland != 0)[,1]==1,2])
  
  seminatural_grassland <- clumpIDs(lcm, c(12,14:16,133,131))
  org_SNG_area <- as.numeric(freq(seminatural_grassland != 0)[freq(seminatural_grassland != 0)[,1]==1,2])
  
  heathland <- clumpIDs(lcm, c(17))
  org_H_area <- as.numeric(freq(heathland != 0)[freq(heathland != 0)[,1]==1,2])
  
  ## CREATE MORE ARABLE
  # expand by 20%
  to_convert_IG <- getClumpsToconvert(improved_grassland, arable, arable_expansion)
  
  ## Add conversion of semi-natural grassland if not enough ##
  if(attr(to_convert_IG, 'needed') != 0){
    to_convert_IG <- c(getClumpsToconvert(seminatural_grassland, arable, 
                                          target_area = attr(to_convert_IG, 'needed')),
                       to_convert_IG)
  }
  
  # add these conversions to LCM as random
  for(i in to_convert_IG){
    lcm[improved_grassland %in% i] <- sample(c(29:38), size = 1)
  }
  
  # now recreate arable and improved_grassland
  arable <- clumpIDs(lcm, c(29:38))
  improved_grassland <- clumpIDs(lcm, c(13, 132))
  
  # now change these crop types
  convert_to_WW <- convert_within_clumps(arable, 38, prop_winter_wheat, 32)
  
  # add to the lcm
  lcm[arable %in% convert_to_WW] <- 38
  for(i in convert_to_WW) arable[arable == i] <- 38000 + (i/1000)
  
  # oilseed rape
  covert_to_OR <- convert_within_clumps(arable, 32, prop_oilseed_rape, 38)
  
  # add to the lcm
  lcm[arable %in% covert_to_OR] <- 32
  for(i in covert_to_OR) arable[arable == i] <- 32000 + (i/1000)
  
  ## CREATE MORE IMPROVED GRASSLAND
  # expand by 10%
  target_area <- org_IG_area * improved_grassland_expansion
  to_convert_SNG <- getClumpsToconvert(seminatural_grassland, improved_grassland, 
                                       target_area = target_area)
  
  ## ADD heathland conversion if needed ##
  if(attr(to_convert_SNG, 'needed') != 0){
    to_convert_SNG <- c(getClumpsToconvert(heathland, improved_grassland, 
                                           target_area = attr(to_convert_SNG, 'needed')),
                        to_convert_SNG)
  }
  
  # add these conversions to LCM as random
  for(i in to_convert_SNG){
    lcm[improved_grassland %in% i] <- sample(c(13, 132), size = 1)
  }
  
  write.table(round(raster::as.matrix(lcm), digits = 3), file = lcm_path, sep = ',',
              row.names = FALSE, col.names = FALSE)
}