# Testing roads
rm(list = ls())

library(CEHcraft)

postcode_map(postcode = 'OX108BB',
             name = 'OX108BB_normal',
             outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
             radius = 2500,
             verbose = TRUE,
             includeRoads = TRUE,
             agri_ex = FALSE)

postcode_map(postcode = 'OX108BB',
             name = 'OX108BB_agr_ex',
             outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
             radius = 2500,
             verbose = TRUE,
             includeRoads = TRUE,
             agri_ex = TRUE)

dir.create('misc/overviewer/OX108BB_normal')
overview('C:/Users/tomaug/AppData/Roaming/.minecraft/saves/OX108BB_normal',
         outPath = 'misc/overviewer/OX108BB_normal')
dir.create('misc/overviewer/OX108BB_agr_ex')
overview('C:/Users/tomaug/AppData/Roaming/.minecraft/saves/OX108BB_agr_ex',
         outPath = 'misc/overviewer/OX108BB_agr_ex')