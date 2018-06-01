# scenario helper functions
# takes a raster and a set of values. it creates clumps for each value and combines them into 
# a new raster. values are id * 1000 plus clump id i.e if id is 123, you would have clumps 
# numbered 123001, 123002, 123003..
# raster - the raster to clump
# ids - the ids within this to clump
#' @export
clumpIDs <- function(raster, ids){
  temp2 <- raster
  temp2[] <- 0
  for (i in ids){
    temp <- raster
    temp[raster == i] <- 1
    temp[raster != i] <- 0
    clumps <- clump(temp)
    temp2[clumps != 0] <- clumps[clumps != 0] + (i*1000)
  }
  return(temp2)
}

# taking two outputs from clumpIDs this finds IDs in 'from' to be converted to 'to'
# to meet the required expansion factor 'expansion_of_to'
#' @export
getClumpsToconvert <- function(from, to, expansion_of_to = NULL, target_area = NULL){
  if(is.null(expansion_of_to) & is.null(target_area)) stop('target_area and expansion_of_to cannot both be NULL')
  to_area <- sum(freq(to)[2:nrow(freq(to)),2])
  
  if(is.null(target_area)){
    target_area <- expansion_of_to * to_area
    if(target_area < 20){ # will be 0 if none already exists... in which case still covert some
    
        target_area <- expansion_of_to * sum(freq(from)[2:nrow(freq(from)),2])
      
      }
  }
  
  freq_from <- freq(from)
  tot <- 0
  n <- 1 
  if(nrow(freq_from)>2){
    while(tot < target_area & n != nrow(freq_from)-1){
      convert_from <- freq_from[sample(2:nrow(freq_from), size = n, replace = FALSE),,drop=FALSE]
      tot = sum(convert_from[,2])
      n = n + 1
    }
    if(tot < target_area){
      warning(paste('target area of', target_area,
                    'not reached. Only', tot,
                    'available for conversion'))
    }
    cIDs <- convert_from[,1]
    attr(x = cIDs, which = 'needed') <- max(target_area - tot, 0)
    return(cIDs)
  } else {
    warning('Nothing available to convert')
    cIDs <- NA
    attr(x = cIDs, which = 'needed') <- target_area
    return(cIDs)
  }
}

# takes clumps, each clump id gives its original type and its clump id, see clumpIDs.
# it takes a id to expand and ids not to change as well as an expansion factor and
# returns the clump ids of those that need to change
#' @export
convert_within_clumps <- function(clumps, id_to_expand, proportion_needed, ids_to_not_change = NULL){
  freq_a <- freq(clumps)[2:nrow(freq(clumps)),]
  tot_ara <- sum(freq_a[,2])
  current_area <- sum(freq_a[freq_a[,1]>=(id_to_expand*1000) & freq_a[,1]<((id_to_expand+1)*1000),2])
  target_area <- tot_ara*proportion_needed 
  freq_tochange <- freq_a[freq_a[,1] < (id_to_expand * 1000) | freq_a[,1] >= ((id_to_expand + 1) * 1000),]
  if(!is.null(ids_to_not_change)){
    for(i in ids_to_not_change){
      freq_tochange <- freq_tochange[freq_tochange[,1]<(i*1000) | freq_tochange[,1]>=((i+1)*1000),,drop=FALSE]
    }
  }
  tot <- 0 
  n <- 1 
  tc <- NULL
  while(tot < target_area & n != nrow(freq_tochange)){
    to_convert <- freq_tochange[sample(1:nrow(freq_tochange), size = n, replace = FALSE),,drop=FALSE]
    tc <- to_convert[,1]
    tot = sum(to_convert[,2])
    n = n + 1
  }
  if(tot < target_area){warning('target conversion not reached')}
  return(tc)
}
