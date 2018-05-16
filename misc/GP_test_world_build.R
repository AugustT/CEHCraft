# test trees

rm(list = ls())

library(CEHcraft)

# 23 seconds 
system.time({postcode_map(postcode = 'YO18QP',
                          outputDir = 'C:/Users/gawn/AppData/Roaming/.minecraft/saves',
                          radius = 2500,
                          verbose = TRUE)})

