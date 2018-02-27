
## ============================================================================
## Extract and merge specific road types from OpenStreetMap that can be
## downloaded from http://download.geofabrik.de/europe/great-britain.html
##
## Licence: All OpenStreetMap derived data on the download server is licensed
##          under the Open Database License 1.0. You may use the data for any
##          purpose, but you have to acknowledge OpenStreetMap as the data
##          source. Derived databases have to retain the same license.
##
## Date extracted: 22.02.2018
## ============================================================================

## unique(wales_roads$fclass)
## wales_roads_ <- uk_roads[wales_roads$fclass %in% c('motorway','primary','secondary','tertiary'),]

wales_roads <- sf::st_read("W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\wales_osm_roads\\gis.osm_roads_free_1.shp")
wales_roads_motorway <- wales_roads[wales_roads$fclass == 'motorway','geometry']
wales_roads_motorway <- sf::st_transform(wales_roads_motorway,27700)
wales_roads_123 <- wales_roads[wales_roads$fclass %in% c('primary','secondary','tertiary'), 'geometry']
wales_roads_123 <- sf::st_transform(wales_roads_123,27700)

scotland_roads <- sf::st_read("W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\scotland_osm_roads\\gis.osm_roads_free_1.shp")
scotland_roads_motorway <- scotland_roads[scotland_roads$fclass == 'motorway','geometry']
scotland_roads_motorway <- sf::st_transform(scotland_roads_motorway,27700)
scotland_roads_123 <- scotland_roads[scotland_roads$fclass %in% c('primary','secondary','tertiary'), 'geometry']
scotland_roads_123 <- sf::st_transform(scotland_roads_123,27700)

england_roads <- sf::st_read("W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\england_osm_roads\\gis.osm_roads_free_1.shp")
england_roads_motorway <- england_roads[england_roads$fclass == 'motorway', 'geometry']
england_roads_motorway <- sf::st_transform(england_roads_motorway,27700)
england_roads_123 <- england_roads[england_roads$fclass %in% c('primary','secondary','tertiary'), 'geometry']
england_roads_123 <- sf::st_transform(england_roads_123,27700)

uk_roads_motorway <- rbind(wales_roads_motorway, scotland_roads_motorway, england_roads_motorway)
uk_roads_123 <- rbind(wales_roads_123, scotland_roads_123, england_roads_123)

sf::st_write(uk_roads_motorway,
            "W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\uk_osm_roads\\uk_roads_motorway.shp",
            delete_dsn = TRUE)
sf::st_write(uk_roads_123,
            "W:\\PYWELL_SHARED\\Pywell Projects\\BRC\\Tom August\\Minecraft\\base_layers\\uk_osm_roads\\uk_roads_123.shp",
            delete_dsn = TRUE)
