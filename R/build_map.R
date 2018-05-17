#' Convert formatted rasters to minecraft worlds
#' 
#' This function uses a python script to convert the files produced by 
#' format_raster into minecraft maps. The name of the world is taken
#' from the input files
#' 
#' @param lcm Character, path to formatted lcm
#' @param dtm Character, path to formatted dtm
#' @param name Character, the name of the map, ususally the location. The name of the world is taken
#' from the input files by default.
#' @param outDir Character, the location the save the results, usually a temporary location
#' @param verbose Should python progress be printed. This is a bit buggy.
#'  
#' @export
#' 
#' @return Path to the minecraft map

build_map <- function(lcm, dtm, name = NULL,
                      outDir = '.', verbose = FALSE){
  
  if(is.null(name)) name = gsub('^dtm-','',gsub('.csv$','',basename(dtm)))
  python_script <- make_quote(normalizePath(file.path(find.package('CEHcraft'), 'python', 'build_world.py')))
  
  # Build up args in a vector
  suppressWarnings({worlddir <- make_quote(normalizePath(file.path(outDir, name)))})
  out_filename <- name
  dtm_filename <- make_quote(normalizePath(dtm))
  lcm_filename <- make_quote(normalizePath(lcm))
  tf <- tempfile(fileext = '.txt')
  tt1 <- make_quote(normalizePath(file.path(find.package('CEHcraft'), 'python', 'treetop1.csv')))
  tt2 <- make_quote(normalizePath(file.path(find.package('CEHcraft'), 'python', 'treetop2.csv')))
  # cat(tf, '\n')
  
  args = c(worlddir, out_filename, dtm_filename, lcm_filename, tf, tt1, tt2)
  
  # Add path to script as first arg
  allArgs <- c(python_script, args)
  
  command <- "python"
  
  # cat(paste(command, allArgs), collapse = ' ')
  
  wait <- ifelse(verbose, yes = FALSE, no = TRUE)
  
  if(!verbose) cat('\nFollow progress by viewing the log file: ', tf)
  
  output <- system2(command,
                    args = allArgs, 
                    wait = wait)
  if(verbose){
    e <- FALSE
    n_lines <- 1
    Sys.sleep(3)
    while(!e){
      
      if(file.exists(tf)){
        
        suppressWarnings({log <- readLines(tf)})
        if(n_lines <= length(log)){
          
          cat('\n')
          cat(paste(log[n_lines:length(log)], collapse = '\n'))
          if(any(grepl('^Saved [[:digit:]]+ chunks.$', log))) e <- TRUE
          n_lines <- length(log) + 1
          
        }
        
        if(any(grepl('error', tolower(log)))) e <- TRUE
        if(any(grepl('^Could not load', tolower(log)))) e <- TRUE
        
        n_lines <- length(log) + 1
        
      }
      
      Sys.sleep(0.5)
      
    }
  }
  
  return(file.path(outDir, out_filename))

}