rm(list = ls())

library(CEHcraft)

base_layers_dir <- 'C:/Users/Tom/Documents/minecraft_baselayers'

for(i in 1:12){

  salisbury = 'SP11BN'
  westPerth = 'PH74JS'
  
  includeWaterways <- i >=3
  includeRoads <- i >= 12
  
  if(dir.exists(file.path('misc/TheStory', paste0('TheStory_', i)))){
    unlink(x = file.path('misc/TheStory', paste0('TheStory_', i)), recursive = TRUE)
  }
  
  site <- ifelse(test = i >= 10, yes = salisbury, no = westPerth)
  
  map_out <-  postcode_map(lcm_raster = raster::raster(file.path(base_layers_dir, 'landcover_composite_map.tif')), 
                          dtm_raster = raster::raster(file.path(base_layers_dir, 'uk_elev25.tif')),
                          uk_rivers = file.path(base_layers_dir, 'uk_rivers/uk_rivers.shp'),
                          uk_canals = file.path(base_layers_dir, 'uk_rivers/uk_canals.shp'),
                          uk_roads_123 = file.path(base_layers_dir, 'uk_osm_roads/uk_roads_123.shp'),
                          uk_roads_motorway = file.path(base_layers_dir, 'uk_osm_roads/uk_roads_motorway.shp'),
                          postcode = site,
                          name = paste0('TheStory_', i),
                          includeWaterways = includeWaterways,
                          includeRoads = includeRoads,
                          outputDir = 'misc/TheStory',
                          radius = 5000,
                          py_script = paste0('build_world_', i, '.py'))
  
  overview(savePath = paste0('misc/TheStory/TheStory_', i), 
           outPath = paste0('misc/TheStory/TheStory_', i, '/overview'))

}


for(i in 13:14){
  
  X <- ifelse(i==13,  T, F)

  if(dir.exists(file.path('misc/TheStory', paste0('TheStory_', i)))){
    unlink(x = file.path('misc/TheStory', paste0('TheStory_', i)), recursive = TRUE)
  }
  
  map_out <-  postcode_map(lcm_raster = raster::raster(file.path(base_layers_dir, 'landcover_composite_map.tif')), 
                           dtm_raster = raster::raster(file.path(base_layers_dir, 'uk_elev25.tif')),
                           uk_rivers = file.path(base_layers_dir, 'uk_rivers/uk_rivers.shp'),
                           uk_canals = file.path(base_layers_dir, 'uk_rivers/uk_canals.shp'),
                           uk_roads_123 = file.path(base_layers_dir, 'uk_osm_roads/uk_roads_123.shp'),
                           uk_roads_motorway = file.path(base_layers_dir, 'uk_osm_roads/uk_roads_motorway.shp'),
                           postcode = 'RG96JW',
                           name = paste0('TheStory_', i),
                           includeWaterways = TRUE,
                           includeRoads = TRUE, 
                           agri_ex = X,
                           seminat_exp = !X,
                           outputDir = 'misc/TheStory',
                           radius = 5000)
  
  overview(savePath = paste0('misc/TheStory/TheStory_', i), 
           outPath = paste0('misc/TheStory/TheStory_', i, '/overview'))
  
}

i=15


if(dir.exists(file.path('misc/TheStory', paste0('TheStory_', i)))){
  unlink(x = file.path('misc/TheStory', paste0('TheStory_', i)), recursive = TRUE)
}

map_out <-  postcode_map(lcm_raster = raster::raster(file.path(base_layers_dir, 'landcover_composite_map.tif')), 
                         dtm_raster = raster::raster(file.path(base_layers_dir, 'uk_elev25.tif')),
                         uk_rivers = file.path(base_layers_dir, 'uk_rivers/uk_rivers.shp'),
                         uk_canals = file.path(base_layers_dir, 'uk_rivers/uk_canals.shp'),
                         uk_roads_123 = file.path(base_layers_dir, 'uk_osm_roads/uk_roads_123.shp'),
                         uk_roads_motorway = file.path(base_layers_dir, 'uk_osm_roads/uk_roads_motorway.shp'),
                         postcode = 'RG96JW',
                         name = paste0('TheStory_', i),
                         includeWaterways = TRUE,
                         includeRoads = TRUE, 
                         outputDir = 'misc/TheStory',
                         radius = 5000)

overview(savePath = paste0('misc/TheStory/TheStory_', i), 
         outPath = paste0('misc/TheStory/TheStory_', i, '/overview'))
