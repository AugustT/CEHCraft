# test building optimisation
rm(list = ls())

library(CEHcraft)

system.time({postcode_map(postcode = 'SW1P3JR',
                          outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
                          radius = 2500,
                          verbose = TRUE)})

# original time 25 seconds

# Add better obstacle detection 10 seconds this must be a 70%-80% speed up

# Build London
system.time({postcode_map(postcode = 'SW1P1BU',
                          outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
                          radius = 25000,
                          verbose = TRUE)})

overview(savePath = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves/SW1P1BU',
         outPath = 'C:/Users/tomaug/OneDrive - NERC/aRt/Minecraft/overviewer/SW1P1BU',
         launch = TRUE)