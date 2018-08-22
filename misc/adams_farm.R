# Adam's farm

postcode <- 'GL545UG'

library(CEHcraft)

dir.create('misc/adams_farm')
postcode_map(postcode = postcode,
             name = 'adams_farm',
             outputDir = 'misc',
             radius = 5000,
             verbose = TRUE,
             includeRoads = TRUE)

overview('misc/adams_farm',
         outPath = 'misc/adams_farm')
buildPoster(path = 'misc/adams_farm',
            outDir = 'misc/adams_farm')
