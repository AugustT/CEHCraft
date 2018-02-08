# test trees

rm(list = ls())

library(CEHcraft)

system.time({postcode_map(postcode = 'LA229LB',
                          outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
                          radius = 2500,
                          verbose = FALSE)})