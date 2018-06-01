# Testing roads
rm(list = ls())

library(CEHcraft)

postcode_map(postcode = 'OX108BB',
             name = 'OX108BB_normal_rivers',
             outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
             radius = 1000,
             verbose = TRUE,
             includeRoads = TRUE,
             agri_ex = FALSE)

dir.create('misc/overviewer/OX108BB_normal_rivers')
overview('C:/Users/tomaug/AppData/Roaming/.minecraft/saves/OX108BB_normal_rivers',
         outPath = 'misc/overviewer/OX108BB_normal_rivers')