#poster worlds for cereals
# Testing scenarios
rm(list = ls())

library(CEHcraft)

postcode_map(postcode = 'SG88SQ',
             name = 'SG88SQ_normal_poster',
             outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
             radius = 10000,
             verbose = TRUE,
             includeRoads = TRUE)
dir.create('misc/overviewer/SG88SQ_normal_poster')
overview('C:/Users/tomaug/AppData/Roaming/.minecraft/saves/SG88SQ_normal_poster',
         outPath = 'misc/overviewer/SG88SQ_normal_poster')

postcode_map(postcode = 'SG88SQ',
             name = 'SG88SQ_agri_ex_poster',
             outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
             radius = 10000,
             verbose = TRUE,
             includeRoads = TRUE,
             agri_ex = TRUE)
dir.create('misc/overviewer/SG88SQ_agri_ex_poster')
overview('C:/Users/tomaug/AppData/Roaming/.minecraft/saves/SG88SQ_agri_ex_poster',
         outPath = 'misc/overviewer/SG88SQ_agri_ex_poster')

postcode_map(postcode = 'SG88SQ',
             name = 'SG88SQ_seminat_ex_poster',
             outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
             radius = 10000,
             verbose = TRUE,
             includeRoads = TRUE,
             seminat_exp = TRUE)
dir.create('misc/overviewer/SG88SQ_seminat_ex_poster')
overview('C:/Users/tomaug/AppData/Roaming/.minecraft/saves/SG88SQ_seminat_ex_poster',
         outPath = 'misc/overviewer/SG88SQ_seminat_ex_poster')

buildPoster(path = 'misc/overviewer/SG88SQ_normal_poster',
            outDir = 'misc/overviewer/SG88SQ_normal_poster')
buildPoster(path = 'misc/overviewer/SG88SQ_agri_ex_poster',
            outDir = 'misc/overviewer/SG88SQ_agri_ex_poster')
buildPoster(path = 'misc/overviewer/SG88SQ_seminat_ex_poster',
            outDir = 'misc/overviewer/SG88SQ_seminat_ex_poster')

postcode_map(postcode = 'LA229QL',
             name = 'lake_district',
             outputDir = 'C:/Users/tomaug/AppData/Roaming/.minecraft/saves',
             radius = 25000,
             verbose = TRUE,
             includeRoads = TRUE)
dir.create('misc/overviewer/lake_district')
overview('C:/Users/tomaug/AppData/Roaming/.minecraft/saves/lake_district',
         outPath = 'misc/overviewer/lake_district')
buildPoster(path = 'misc/overviewer/lake_district',
            outDir = 'misc/overviewer/lake_district')