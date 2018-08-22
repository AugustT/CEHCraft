# build poster maps for countryfile live
rm(list = ls())

library(CEHcraft)

dir.create('misc/overviewer/LL414DY_50_50')
overview('C:/Users/tomaug/AppData/Roaming/.minecraft/saves/LL414DY_50_50',
         outPath = 'misc/overviewer/LL414DY_50_50')
buildPoster(path = 'misc/overviewer/LL414DY_50_50',
            outDir = 'misc/overviewer/LL414DY_50_50')

dir.create('misc/overviewer/PH74JS_50_50')
overview('C:/Users/tomaug/AppData/Roaming/.minecraft/saves/PH74JS_50_50',
         outPath = 'misc/overviewer/PH74JS_50_50')
buildPoster(path = 'misc/overviewer/PH74JS_50_50',
            outDir = 'misc/overviewer/PH74JS_50_50')