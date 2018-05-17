#' Create Minecraft world from Postcode
#' 
#' This wraps around other functions to create a minecraft world
#' from a postcode.
#' 
#' @param lcm_raster lcm raster. Defaults to files on W drive
#' @param dtm_raster lcm raster. Defaults to files on W drive
#' @param postcode Character, valid UK postcode to centre map on.
#' @param name Character, the name to give the save file, if null (default) the postcode is used
#' @param radius Numeric, radius of the map in meters
#' @param outputDir Character, path to output directory
#' @param exagerate_elevation The factor by which elevation should be exaggerated
#' @param includeRoads logical, if TRUE roads are added
#' @param verbose Should python progress be printed. This is a bit buggy.
#' @param agri_ex Logical, should the agricultural expansion scenario be applied?
#'  
#' @export
#' 
#' @return Path to the minecraft map

postcode_map <-  function(lcm_raster = raster::raster('W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/landcover_composite_map.tif'), 
                          dtm_raster = raster::raster('W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/uk_elev25.tif'),
                          postcode = 'OX108BB',
                          name = NULL,
                          radius = 2500,
                          outputDir = '.',
                          exagerate_elevation = 2,
                          includeRoads = TRUE,
                          verbose = FALSE,
                          agri_ex = FALSE){
  
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
  
  if(includeRoads){
    
    cat('Adding roads')
    uk_roads_123 <- sf::st_read(quiet = TRUE, "W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\uk_osm_roads\\uk_roads_123.shp")
    uk_roads_motorway <- sf::st_read(quiet = TRUE, "W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\uk_osm_roads\\uk_roads_motorway.shp")
    
    motorways <- crop_road_layer(postcode = postcode,
                                 radius_m = radius,
                                 roads = uk_roads_motorway,
                                 buffer = 60,
                                 road_type = 100)
    
    otherroads <- crop_road_layer(postcode = postcode,
                                  radius_m = radius,
                                  roads = uk_roads_123,
                                  buffer = 30,
                                  road_type = 101)
    
    uk_roads_crop <- rbind(motorways, otherroads)
    
    ## rasterize and create a new layer with roads and landcover
    uk_roads_crop_r <- raster::rasterize(as(uk_roads_crop,'Spatial'),
                                         lcm_cr,
                                         field = 'road_type')
    
    # Add bridges as '101' class
    uk_roads_crop_r[round(lcm_cr, digits = 3) == 1.008 & !is.na(uk_roads_crop_r)] <- 102
    
    uk_roads_crop_r[is.na(uk_roads_crop_r)] <- lcm_cr[is.na(uk_roads_crop_r)]
    lcm_cr <- uk_roads_crop_r
    
    rm(list = c('uk_roads_crop','uk_roads_crop_r','motorways'))
    cat('done\n')
  }
  
  cat('Formatting lcm and dtm...')  
  formatted_maps <- format_raster(lcm = lcm_cr,
                                  dtm = elev_cr,
                                  name = postcode,
                                  exagerate_elevation = exagerate_elevation)
  
  cat('\ndone\n')
  
  if(agri_ex) agricultural_expansion(formatted_maps[[1]])
  
  cat('Creating Minecraft World\n')  
  map_path <- build_map(lcm = formatted_maps[[1]],
                        dtm = formatted_maps[[2]],
                        outDir = outputDir,
                        verbose = verbose,
                        name = name)
  
}