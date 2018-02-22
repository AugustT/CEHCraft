###### Create a custom test map to check all habitat/block type categories ######

# Add custom test rasters in here #
map_path <- CEHcraft::build_map(lcm = 'misc/test_map_lc.csv',
                        dtm = 'misc/test_map_elev.csv',
                        outDir = 'C:/Users/gawn/AppData/Roaming/.minecraft/saves', 
                        verbose = TRUE, 
                        name = "test_map")
