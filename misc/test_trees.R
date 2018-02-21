# test trees

rm(list = ls())

library(CEHcraft)

# 23 seconds 

system.time({postcode_map(postcode = 'LA229QL',
                          outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
                          radius = 25000,
                          verbose = TRUE)})

overview(savePath = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves/LA229QL',
         outPath = 'C:/Users/tomaug/OneDrive - NERC/aRt/Minecraft/overviewer/LA229QL_2',
         launch = TRUE)
