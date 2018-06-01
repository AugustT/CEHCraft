#' Crop a linear layer given a postcode
#' 
#' Function to linear layer, using the bounding box of a specified radius
#' (in meters) around a point (centroid of a postcode).
#' 
#' @param postcode A character string giving a valid UK postcode
#' @param radius Numeric in meters giving the radius of the bounding box
#' @param layer A layer to be cropped (ie road or river)
#' @param buffer Buffer in meters to add to the lines
#' @param out_type A numeric code to give cells containing this line type (e.g. 100 = motorway, 200 = other roads)
#' 
#' @return A raster layer
#' 
#' @export
#' 
#' @import sf
#' @import raster

crop_linear_layer <-
  function(postcode='OX108BB',radius_m=5000,layer=NULL,buffer=15,out_type=100){
    
    # # flip lat for minecraft #
    # layer <- layer[, rev(1:ncol(layer))]
    # 
    # # rotate to get north in the right place
    # layer <- t(apply(layer, 2, rev))
    
    suppressWarnings(sf::st_crs(layer) <- 27700)
   
    location_pt <- geoaddress_uk(postcode)
    a_sf <- sf::st_sfc(sf::st_point(c(location_pt$result$longitude,location_pt$result$latitude)))
    sf::st_crs(a_sf) <- 4326
    focal_box <- as(sf::st_as_sfc(sf::st_bbox(sf::st_buffer(sf::st_transform(a_sf, 27700), radius_m))), "Spatial")
    
    ## crop linear
    linear_crop <- layer[unlist(sf::st_intersects(sf::st_as_sfc(focal_box),layer)),'geometry']

    ## add width to linear feature
    linear_buffered <- sf::st_buffer(linear_crop, buffer)

    ## give distinct values to motorways and linear
    if(length(linear_buffered$geometry) > 0) linear_buffered$out_type <- out_type
    
    return(linear_buffered)
  }
