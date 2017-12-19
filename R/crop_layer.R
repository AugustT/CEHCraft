#' Crop a raster layer given a postcode
#' 
#' Function to crop a raster layer, using the bounding box of a specified radius
#' (in meters) around a point (centroid of a postcode).
#' 
#' @param postcode A character string giving a valid UK postcode
#' @param radius Numeric in meters giving the radius of the bounding box
#' @param layer A raster layer to be cropped
#' 
#' @return A raster layer
#' 
#' @export
#' 
#' @import sf
#' @import raster

crop_layer <-
function(postcode='OX108BB',radius_m=5000,layer=NULL){
    
    location_pt <- geoaddress_uk(postcode)
    a_sf <- sf::st_sfc(sf::st_point(c(location_pt$result$longitude,location_pt$result$latitude)))
    sf::st_crs(a_sf) <- 4326
    focal_box <- as(sf::st_as_sfc(sf::st_bbox(sf::st_buffer(sf::st_transform(a_sf, 27700), radius_m))), "Spatial")
    
    layer_cr <- raster::crop(layer, raster::extent(focal_box ))
    
    return(layer_cr)
}
