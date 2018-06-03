###### Create a custom test map to check all habitat/block type categories ######

# Add custom test rasters in here #
map_path <- CEHcraft::build_map(lcm = 'misc/test_map_lc_small.csv',
                        dtm = 'misc/test_map_elev_small.csv',
                        outDir = 'C:/Users/gawn/AppData/Roaming/.minecraft/saves', 
                        verbose = FALSE, 
                        name = "test_map_small")
