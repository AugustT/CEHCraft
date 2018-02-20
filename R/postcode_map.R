#' Create Minecraft world from Postcode
#' 
#' This wraps around other functions to create a minecraft world
#' from a postcode.
#' 
#' @param lcm_raster lcm raster. Defaults to files on W drive
#' @param dtm_raster lcm raster. Defaults to files on W drive
#' @param postcode Character, valid UK postcode to centre map on.
#' @param radius Numeric, radius of the map in meters
#' @param outputDir Character, path to output directory
#' @param exagerate_elevation The factor by which elevation should be exaggerated
#' @param verbose Should python progress be printed. This is a bit buggy.
#'  
#' @export
#' 
#' @return Path to the minecraft map

postcode_map <-  function(lcm_raster = raster::raster('W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/landcover_composite_map.tif'), 
                          dtm_raster = raster::raster('W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/uk_elev25.tif'),
                          postcode = 'OX108BB',
                          radius = 2500,
                          outputDir = '.',
                          exagerate_elevation = 2,
                          verbose = FALSE){
  
  postcode <- toupper(gsub(' ', '', postcode))
  
  cat('\n\n##########################',
      '\nBuilding world for', postcode,
      '\n##########################\n\n')
  
  cat('Cropping dtm...')
  elev_cr <- crop_layer(postcode = postcode,
                        radius_m = radius,
                        layer = dtm_raster)
  cat('done\n')
  
  cat('Cropping lcm...')
  lcm_cr <- crop_layer(postcode = postcode,
                       radius_m = radius,
                       layer = lcm_raster)
  cat('done\n')
  
  rm(list = c('dtm_raster', 'lcm_raster'))

  cat('Formatting maps...')  
  formatted_maps <- format_raster(lcm = lcm_cr, dtm = elev_cr,
                                  name = postcode, exagerate_elevation = exagerate_elevation)
  
  cat('\ndone\n')
  
  cat('Creating Minecraft World\n')  
  map_path <- build_map(lcm = formatted_maps[[1]],
                        dtm = formatted_maps[[2]],
                        outDir = outputDir,
                        verbose = verbose)
  
}