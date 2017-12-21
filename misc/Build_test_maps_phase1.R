# Build minecraft worlds for testers
rm(list = ls())

postcodes <- c('IP294PS', 'OX119DD', 'GU98JU', 'OX109QY', 'OX29HE', 'BS66DG', 'LA229LB', 'DY82DA')

library(CEHcraft)

dir.create('worlds', showWarnings = FALSE)


for(postcode in postcodes){
  
  postcode_map(postcode = postcode, 
               outputDir = 'worlds/5km',
               radius = 2500,
               verbose = TRUE)

}


for(postcode in postcodes){
  
  postcode_map(postcode = postcode, 
               outputDir = 'worlds/10km',
               radius = 5000,
               verbose = TRUE)
  
}