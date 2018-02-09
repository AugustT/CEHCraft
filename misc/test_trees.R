# test trees

rm(list = ls())

library(CEHcraft)

# 23 seconds 

system.time({postcode_map(postcode = 'LA229LB',
                          outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
                          radius = 2500,
                          verbose = TRUE)})

overview(savePath = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves/LA229LB', 
         outPath = tempdir(),
         launch = TRUE)