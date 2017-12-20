# Build minecraft worlds for testers
rm(list = ls())

postcodes <- c('IP294PS', 'OX119DD', 'GU98JU', 'OX109QY', 'OX29HE', 'BS66DG')

library(CEHcraft)

dir.create('worlds', showWarnings = FALSE)


for(postcode in postcodes){
  
  postcode_map(postcode = postcode, 
               outputDir = 'worlds',
               radius = 2500,
               verbose = TRUE)

}
