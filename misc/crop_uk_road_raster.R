
## ============================================================================
## 1. Extract and crop around address roads extracted from OpenStreetMa
## downloaded from http://download.geofabrik.de/europe/great-britain.html
## (road base layer was built with build_uk_road_layer.R)
## 2. Integrate withing landcover map
##
## Licence: All OpenStreetMap derived data on the download server is licensed
##          under the Open Database License 1.0. You may use the data for any
##          purpose, but you have to acknowledge OpenStreetMap as the data
##          source. Derived databases have to retain the same license.
##
## Date extracted: 22.02.2018
## ============================================================================


uk_roads_123 <- sf::st_read("W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\uk_osm_roads\\uk_roads_123.shp")
uk_roads_motorway <- sf::st_read("W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\uk_osm_roads\\uk_roads_motorway.shp")
sf::st_crs(uk_roads_123) <- 27700
sf::st_crs(uk_roads_motorway) <- 27700


source('R\\geoaddress_uk.R')
## test with a postcode
postcode='OX109QY'; radius_m=5000

location_pt <- geoaddress_uk(postcode)
a_sf <- sf::st_sfc(sf::st_point(c(location_pt$result$longitude,location_pt$result$latitude)))
sf::st_crs(a_sf) <- 4326
focal_box <- as(sf::st_as_sfc(sf::st_bbox(sf::st_buffer(sf::st_transform(a_sf, 27700), radius_m))), "Spatial")

## crop roads and motorways
uk_roads_123_crop <- uk_roads_123[unlist(sf::st_intersects(sf::st_as_sfc(focal_box),uk_roads_123)),'geometry']
uk_roads_motorway_crop <- uk_roads_motorway[unlist(sf::st_intersects(sf::st_as_sfc(focal_box),uk_roads_motorway)),'geometry']

## add width to roads and motorways
uk_roads_123_crop <- sf::st_buffer(uk_roads_123_crop,15)
uk_roads_motorway_crop <- sf::st_buffer(uk_roads_motorway_crop,25)

## give distinct values to motorways and roads
uk_roads_motorway_crop$road_type <- 100
uk_roads_123_crop$road_type <- 200
uk_roads_crop <- rbind(uk_roads_motorway_crop,uk_roads_123_crop)

## rasterize and create a new layer with roads and landcover
lcm_raster = raster::raster('W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/base_layers/landcover_composite_map.tif')
layer_cr <- raster::crop(lcm_raster, raster::extent(focal_box ))

uk_roads_crop_r <- raster::rasterize(as(uk_roads_crop,'Spatial'),
                                            layer_cr,
                                            field = 'road_type')

lcm_roads <- uk_roads_crop_r
lcm_roads[is.na(lcm_roads)] <- layer_cr[is.na(lcm_roads)]
raster::plot(lcm_roads)
