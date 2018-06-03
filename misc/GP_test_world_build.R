# test trees

rm(list = ls())

library(CEHcraft)

# 23 seconds # CB224RT
system.time({postcode_map(postcode = 'OX108BB',
                          outputDir = 'C:/Users/gawn/AppData/Roaming/.minecraft/saves',
                          radius = 2500,
                          includeRoads = TRUE,
                          verbose = FALSE)})

