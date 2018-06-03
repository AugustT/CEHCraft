# Combining worlds
rm(list = ls())
build_map_csvs <-  function(lcm_raster = raster::raster('W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/landcover_composite_map.tif'), 
                          dtm_raster = raster::raster('W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/uk_elev25.tif'),
                          postcode = 'OX108BB',
                          name = NULL,
                          radius = 5000,
                          outputDir = '.',
                          exagerate_elevation = 2,
                          includeRoads = TRUE,
                          verbose = FALSE,
                          agri_ex = FALSE,
                          seminat_exp = FALSE){
  
  require(CEHcraft)
  
  postcode <- toupper(gsub(' ', '', postcode))
  
  if(agri_ex & seminat_exp) stop('Only one scenario can be applied at a time')
  
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
  
  cat('Adding rivers...')
  uk_rivers <- sf::st_read(quiet = TRUE, 'W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/uk_rivers/uk_rivers.shp')
  uk_canals <- sf::st_read(quiet = TRUE, 'W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/uk_rivers/uk_canals.shp')
  
  
  small_rivers <- crop_linear_layer(postcode = postcode,
                                    radius_m = radius,
                                    layer = uk_rivers[uk_rivers$STRAHLE > 1 & uk_rivers$STRAHLE <= 3,],
                                    buffer = 30,
                                    out_type = 1.008)
  
  big_rivers <- crop_linear_layer(postcode = postcode,
                                  radius_m = radius,
                                  layer = uk_rivers[uk_rivers$STRAHLE > 3,],
                                  buffer = 60,
                                  out_type = 1.008)
  
  canals <- crop_linear_layer(postcode = postcode,
                              radius_m = radius,
                              layer = uk_canals,
                              buffer = 30,
                              out_type = 1.008)
  
  if(sum(sapply(list(small_rivers, big_rivers, canals), FUN = nrow)) > 0){
    
    waterways <- rbind(small_rivers, big_rivers, canals)
    
    uk_waterways <- raster::rasterize(as(waterways,'Spatial'),
                                      lcm_cr,
                                      field = 'out_type')
    
    #smooth dtm
    smooth_elev_cr <- raster::focal(elev_cr, matrix(1,7,7), min, na.rm = TRUE, pad = TRUE)
    elev_cr[!is.na(uk_waterways)] <- smooth_elev_cr[!is.na(uk_waterways)]
    
    uk_waterways[is.na(uk_waterways)] <- lcm_cr[is.na(uk_waterways)]
    
    lcm_cr <- uk_waterways
    rm(list = c('uk_waterways','waterways'))
  }
  
  rm(list = c('canals', 'big_rivers',
              'small_rivers', 'uk_canals', 'uk_rivers' ))
  
  cat('done\n')
  
  rm(list = c('dtm_raster', 'lcm_raster'))
  
  if(includeRoads){
    
    cat('Adding roads')
    uk_roads_123 <- sf::st_read(quiet = TRUE, "W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\uk_osm_roads\\uk_roads_123.shp")
    uk_roads_motorway <- sf::st_read(quiet = TRUE, "W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\uk_osm_roads\\uk_roads_motorway.shp")
    
    motorways <- crop_linear_layer(postcode = postcode,
                                   radius_m = radius,
                                   layer = uk_roads_motorway,
                                   buffer = 60,
                                   out_type = 100)
    
    otherroads <- crop_linear_layer(postcode = postcode,
                                    radius_m = radius,
                                    layer = uk_roads_123,
                                    buffer = 30,
                                    out_type = 101)
    
    uk_roads_crop <- rbind(motorways, otherroads)
    
    ## rasterize and create a new layer with roads and landcover
    uk_roads_crop_r <- raster::rasterize(as(uk_roads_crop,'Spatial'),
                                         lcm_cr,
                                         field = 'out_type')
    
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
  
  if(agri_ex){
    cat('Applying agricultural expansion ...')  
    agricultural_expansion(formatted_maps[[1]])
    cat('done\n')
  } 
  
  if(seminat_exp){
    cat('Applying semi-natural expansion ...')  
    seminatural_expansion(formatted_maps[[1]])
    cat('done\n')
  } 
  
  return(formatted_maps)
}


norm <- build_map_csvs(postcode = 'SG8 7NT')
dtm <- read.csv(norm[[2]], header = FALSE)
norm <- read.csv(norm[[1]], header = FALSE)
  
agri <- build_map_csvs(postcode = 'SG8 7NT', agri_ex = TRUE)
agri <- read.csv(agri[[1]], header = FALSE)

seminat <- build_map_csvs(postcode = 'SG8 7NT', seminat_exp = TRUE)
seminat <- read.csv(seminat[[1]], header = FALSE)

wall_V <- matrix(888, nrow(norm), 1)
wall_H <- matrix(888, 1, (ncol(norm)*3)+2)

combo_lcm <- rbind(as.matrix(cbind(norm, wall_V,
                                   agri, wall_V,
                                   seminat)),
                   as.matrix(wall_H),
                   as.matrix(cbind(seminat, wall_V,
                                   agri, wall_V,
                                   norm)))
raster::plot(raster::raster(combo_lcm))

wall_V <- matrix(60, nrow(dtm), 1)
wall_H <- matrix(60, 1, (ncol(dtm)*3)+2)

combo_dtm <- rbind(as.matrix(cbind(dtm, wall_V,
                                   dtm, wall_V,
                                   dtm)),
                   as.matrix(wall_H),
                   as.matrix(cbind(dtm, wall_V,
                                   dtm, wall_V,
                                   dtm)))

raster::plot(raster::raster(combo_dtm))

lcm_file <- tempfile()
write.table(combo_lcm, file = lcm_file, sep = ',',
            row.names = FALSE, col.names = FALSE)

dtm_file <- tempfile()
write.table(combo_dtm, file = dtm_file, sep = ',',
            row.names = FALSE, col.names = FALSE)

map_path <- CEHcraft::build_map(lcm = lcm_file,
                                dtm = dtm_file,
                                outDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
                                verbose = TRUE,
                                name = 'duxford_combo')
dir.create('misc/overviewer/duxford_combo')
overview('C:/Users/tomaug/AppData/Roaming/.minecraft/saves/duxford_combo',
         outPath = 'misc/overviewer/duxford_combo')
