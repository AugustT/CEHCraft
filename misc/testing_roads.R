# Testing roads
rm(list = ls())

library(CEHcraft)

postcode_map(postcode = 'OX108BB',
             outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
             radius = 5000,
             verbose = TRUE,
             includeRoads = TRUE)
