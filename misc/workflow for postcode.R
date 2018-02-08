postcode <- 'LL240HE'

library(CEHcraft)

postcode_map(postcode = postcode, outputDir = 'worlds/')

overview(savePath = file.path('worlds', gsub(' ', '', postcode)),
         outPath = file.path('worlds', paste('overview', postcode)))
