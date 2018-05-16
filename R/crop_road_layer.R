#' Crop a road layer given a postcode
#' 
#' Function to crop a road layer, using the bounding box of a specified radius
#' (in meters) around a point (centroid of a postcode).
#' 
#' @param postcode A character string giving a valid UK postcode
#' @param radius Numeric in meters giving the radius of the bounding box
#' @param layer A road layer to be cropped
#' @param buffer Buffer in meters to add to the roads
#' @param road_type A numeric code to give cells containing this road type (100 = motorway, 200 = other roads)
#' 
#' @return A raster layer
#' 
#' @export
#' 
#' @import sf
#' @import raster

crop_road_layer <-
  function(postcode='OX108BB',radius_m=5000,roads=NULL,buffer=15,road_type=100){
    
    # # flip lat for minecraft #
    # roads <- roads[, rev(1:ncol(roads))]
    # 
    # # rotate to get north in the right place
    # roads <- t(apply(roads, 2, rev))
    
    suppressWarnings(sf::st_crs(roads) <- 27700)
   
    location_pt <- geoaddress_uk(postcode)
    a_sf <- sf::st_sfc(sf::st_point(c(location_pt$result$longitude,location_pt$result$latitude)))
    sf::st_crs(a_sf) <- 4326
    focal_box <- as(sf::st_as_sfc(sf::st_bbox(sf::st_buffer(sf::st_transform(a_sf, 27700), radius_m))), "Spatial")
    
    ## crop roads
    roads_crop <- roads[unlist(sf::st_intersects(sf::st_as_sfc(focal_box),roads)),'geometry']

    ## add width to roads and motorways
    roads_buffered <- sf::st_buffer(roads_crop, buffer)

    ## give distinct values to motorways and roads
    if(length(roads_buffered$geometry) > 0) roads_buffered$road_type <- road_type
    
    return(roads_buffered)
  }
