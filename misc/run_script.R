rm(list = ls())

library(CEHcraft)

dir.create('worlds', showWarnings = FALSE)

system.time({postcode_map(postcode = 'IP294PS',
                          outputDir = 'worlds',
                          radius = 500,
                          verbose = FALSE)})
# 17.97 seconds 0.018 seconds per 1000 pixels

system.time({postcode_map(postcode = 'IP294PS',
                            outputDir = 'worlds',
                            radius = 2500,
                            verbose = FALSE)})
# 107.58 seconds 0.00428 seconds per 1000 pixels

system.time({postcode_map(postcode = 'IP294PS',
                          outputDir = 'worlds',
                          radius = 5000,
                          verbose = FALSE)})
# 901 seconds 0.00901 seconds / 1000 pixels

# top of winemere small
system.time({postcode_map(postcode = 'LA229LB',
                          outputDir = 'worlds/5km',
                          radius = 2500,
                          verbose = FALSE)})

# top of windemere big
system.time({postcode_map(postcode = 'LA229LB',
                          outputDir = 'worlds/10km',
                          radius = 5000,
                          verbose = FALSE)})

# entire lake district (MASSIVE)
system.time({postcode_map(postcode = 'LA229QL',
                          outputDir = 'W:/PYWELL_SHARED/Pywell Projects/BRC/Tom August/Minecraft/CEHCraft/worlds/50km',
                          radius = 25000,
                          verbose = TRUE)})
# 4250 seconds 0.0017 seconds / 1000 pixels # ALL HEIGHTS WERE NA