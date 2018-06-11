### build the test map .csvs ###

### load the habitat type/code info ###
test_lc <- read.csv('misc/test_data_groups.csv', header = TRUE)

test_map_lc <- matrix(rep(test_lc$CODE[1:length(test_lc$CODE)], each = 30), length(test_lc$CODE)*30, 20) # habitat unique habitat types, presented as 3x3 per habitat type 
test_map_elev <- matrix(rep(c(rep(10,10), rep(11,10), rep(12,10)), times = 20), length(test_lc$CODE)*30, 20) # habitat unique habitat types, presented as 3x3 per habitat type 

write.table(test_map_lc, file = 'misc/test_map_lc.csv', sep = ',', row.names = FALSE, col.names = FALSE)
write.table(test_map_elev, file = 'misc/test_map_elev.csv', sep = ',', row.names = FALSE, col.names = FALSE)

# smaller map #
test_map_lc_small <- matrix(rep(test_lc$CODE[1:length(test_lc$CODE)], each = 20), length(test_lc$CODE)*20, 20) # habitat unique habitat types, presented as 3x3 per habitat type 
test_map_elev_small <- matrix(rep(c(rep(10,20)), times = 20), length(test_lc$CODE)*20, 20) # habitat unique habitat types, presented as 3x3 per habitat type 

write.table(test_map_lc_small, file = 'misc/test_map_lc_small.csv', sep = ',', row.names = FALSE, col.names = FALSE)
write.table(test_map_elev_small, file = 'misc/test_map_elev_small.csv', sep = ',', row.names = FALSE, col.names = FALSE)