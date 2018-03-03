# test trees

rm(list = ls())

library(CEHcraft)

# 23 seconds 

system.time({postcode_map(postcode = 'LA229LB',
                          outputDir = 'C:/Users/Tom August/AppData/Roaming/.minecraft/saves',
                          radius = 2500,
                          verbose = TRUE)})

overview(savePath = 'C:/Users/Tom August/AppData/Roaming/.minecraft/saves/LA229LB', 
         outPath = tempdir(),
         launch = TRUE)