#' Get location from a postcode
#' 
#' function to geolocalize a postcode or find a centroid of a location
#' 
#' @param address The postcode to search for
#' @param format The format postcodes are given in  ('list' or 'data.frame')
#'
#' @return A dataframe of location information
#' 
#' @export
#' 
#' @import rjson
#' @import plyr

geoaddress_uk <-
function(address, format = ifelse(length(address)==1,'list','dataframe'))
{
    address <- toupper(gsub(" ","",unique(address)))
    
    if (1 == length(address))
    {
        # a single IP address
        require(rjson)
        require(plyr)
        url <- paste(c("https://api.postcodes.io/postcodes/", address), collapse='')
        ret <- try(fromJSON(readLines(url, warn=FALSE)),silent=TRUE)
        
        if (format == 'dataframe')
            ret <- try(data.frame(t(unlist(ret$result))),silent=TRUE)
        if(class(ret)=="try-error") ret <- data.frame(postcode=address)
        
        return(ret)
        
    } else {
        
        ret <- data.frame()
        add.error <- c()
        for (i in 1:length(address))
        {
            r <- geoaddress_uk(address[i], format="dataframe")
            ret <- plyr::rbind.fill(ret, r)
        }
        ret$postcode <- toupper(gsub(" ","",unique(ret$postcode)))
        return(ret)
    }
}
