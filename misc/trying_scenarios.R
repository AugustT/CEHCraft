str(formatted_maps)
library(raster)

lcm_tab <- read.csv(formatted_maps[[1]], header = FALSE)

lcm <- raster(as.matrix(lcm_tab))

unique(lcm)

# get clumps of fields
lcm

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

arable <- clumpIDs(lcm, c(29:38))
improved_grassland <- clumpIDs(lcm, c(13, 132))
seminatural_grassland <- clumpIDs(lcm, c(12,14:16,133,131))
heathland <- clumpIDs(lcm, c(17))

## CREATE MORE ARABLE
# What is the total area of arable
arable_area <- sum(freq(arable)[2:nrow(freq(arable)),2])

# expand by 20%
target_area <- 0.2*arable_area
freq_IG <- freq(improved_grassland)

tot <- 0
n <- 1 
IDS <- NULL
if(nrow(freq_IG)>2){
  while(tot < target_area & n != nrow(freq_IG)-1){
    to_convert_IG <- freq_IG[sample(2:nrow(freq_IG), size = n, replace = FALSE),,drop=FALSE]
    tot = sum(to_convert_IG[,2])
    n = n + 1
    print(n)
  }
}
  
if(tot < target_area){warning('target amount of improved grassland not found')}

# add these conversions to LCM as random
for(i in to_convert_IG[,1]){
  lcm[improved_grassland %in% i] <- sample(c(29:38), size = 1)
}

# now recreate arable
arable <- clumpIDs(lcm, c(29:38))

# now change these crop types
freq_ara <- freq(arable)

# total area
tot_ara <- sum(freq_ara[2:nrow(freq_ara),2])

# WW area
ww_ara <- sum(freq_ara[freq_ara[,1]>=38000 & freq_ara[,1]<39000,2])

current_WW <- ww_ara/tot_ara

target_area <- (tot_ara*0.55) - ww_ara 
tot <- 0 
n <- 1 
freq_ara_nonWW <- freq_ara[freq_ara[,1]<38000 | freq_ara[,1]>=39000,]

while(tot < target_area & n != nrow(freq_ara_nonWW)-1){
  to_convert_WW <- freq_ara_nonWW[sample(2:nrow(freq_ara_nonWW), size = n, replace = FALSE),,drop=FALSE]
  tot = sum(to_convert_WW[,2])
  n = n + 1
  print(n)
}

# add to the lcm
lcm[arable %in% to_convert_WW[,1]] <- 38

# oilseed rape

freq_ara_nonOR <- freq_ara_nonWW[freq_ara_nonWW[,1]<32000 | freq_ara_nonWW[,1]>=33000,]
freq_ara_nonOR <- freq_ara_nonOR[!freq_ara_nonOR[,1] %in% to_convert_WW[,1],]
freq_ara_OR <- freq_ara[freq_ara[,1] >= 32000 & freq_ara[,1] < 33000,]

# target for oilseed rape
current_OR <- sum(freq_ara_OR[,2])

target_area <- (tot_ara*0.3) - current_OR 
tot <- 0 
n <- 1

while(tot < target_area & n != nrow(freq_ara_nonOR)-1){
  to_convert_OR <- freq_ara_nonOR[sample(2:nrow(freq_ara_nonOR), size = n, replace = FALSE),,drop=FALSE]
  tot = sum(to_convert_OR[,2])
  n = n + 1
  print(n)
}

# add to the lcm
lcm[arable %in% to_convert_OR[,1]] <- 32

## CREATE MORE IMPROVED GRASSLAND
######WORK FROM HERE
# expand by 10%
freq_IG <- freq(improved_grassland)
IG_expansion <- 0.1 * sum(freq_IG[freq_IG[,1] != 0, 2])

# remove new arable from improved grassland
improved_grassland[improved_grassland %in% to_convert_IG[,1]] <- 0

freq_SNG <- freq(seminatural_grassland)

tot <- 0
n <- 1 
IDS <- NULL
to_convert_SNG <- NULL 

if(nrow(freq_SNG) > 2){
  while(tot < IG_expansion & n != nrow(freq_SNG)-1){
    to_convert_SNG <- freq_SNG[sample(2:nrow(freq_SNG), size = n, replace = FALSE),,drop=FALSE]
    tot = sum(to_convert_SNG[,2])
    n = n + 1
    print(n)
  }
}

if(tot < IG_expansion){warning('target amount of semi_natural grassland not found')}

# add these conversions to improved_grassland
improved_grassland[seminatural_grassland %in% to_convert_SNG[,1]] <- seminatural_grassland[seminatural_grassland %in% to_convert_SNG[,1]]


# Convert these so 55% winter wheat and 33% oilseed rape

plot(arable)
freq(arable)


