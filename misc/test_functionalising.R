# funionalising the python code

## Original (av of 3)
# 10 seconds

## Turn bottom loop into a function (av of 3)
# 10 seconds  

## As above but using list comprehension
# 10 seconds

## Right, so it doesn't really make any difference

# Turn stacked ifs into stacked elif
# 9 seconds (Whoop, minor win!)

## the time without building was 10 seconds meaning that these times dont reflect the 
## time spent building

##testing 2##

# I up the size but building is still a short amount of overall time

rm(list = ls())

library(CEHcraft)
library(rbenchmark)

dir.create('worlds', showWarnings = FALSE)

timed <- benchmark(build = postcode_map(postcode = 'IP294PS',
                               outputDir = 'C:\\Users\\tomaug\\Documents\\minecraft',
                               radius = 5000,
                               verbose = TRUE),
          replications = 5)

cat(paste('\nTime taken:', timed$elapsed/timed$replications, '\n'))

# original
# 173.70 seconds

# original to c:
# 19.12 seconds

# list comprehension + elif to c:
# 19.67 seconds

# list comprehension + elif to c: 10km2
# 195.554 seconds (3.25 minutes)

# original to c: 10km2
# 197.964 

# list comprehension + elif to c: 10km2 - half ground depth 10 -> 5
# 179.168 (2.9 minutes)

# It looks like the constant writing to file is the main speed up, making
# it a local operation seems to have a big impact on time. This might only 
# be the case for 'small' maps where the majority of time is spent in the 
# writing to file versus the building, so it is worth testing on a larger map
