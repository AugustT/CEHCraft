rm(list = ls())

library(CEHcraft)

base_layers_dir <- 'C:/Users/Tom/Documents/minecraft_baselayers'

for(i in 1){
  
  map_out <-  postcode_map(lcm_raster = raster::raster(file.path(base_layers_dir, 'landcover_composite_map.tif')), 
                          dtm_raster = raster::raster(file.path(base_layers_dir, 'uk_elev25.tif')),
                          uk_rivers = file.path(base_layers_dir, 'uk_rivers/uk_rivers.shp'),
                          uk_canals = file.path(base_layers_dir, 'uk_rivers/uk_canals.shp'),
                          uk_roads_123 = file.path(base_layers_dir, 'uk_osm_roads/uk_roads_123.shp'),
                          uk_roads_motorway = file.path(base_layers_dir, 'uk_osm_roads/uk_roads_motorway.shp'),
                          postcode = 'PH74JZ',
                          name = paste0('TheStory_', i),
                          outputDir = 'misc/TheStory',
                          radius = 5000,
                          py_script = paste0('build_world_', i, '.py'))
  
  overview(savePath = paste0('misc/TheStory/TheStory_', i), outPath = tempdir())

}
