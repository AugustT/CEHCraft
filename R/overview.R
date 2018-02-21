#' Create and Overview map of a saved minecraft world
#' 
#' This uses the overviewer programme which is bundled in with the package.
#' This is currently the windows version so will not work on Linux/Mac
#' 
#' @param savePath the path to the folder containing the saved game to be mapped
#' @param outPath the path to a folder where a host of output files will be saved
#' @param launch Logical, should the map be launched once it is complete
#' 
#' @export
#' 
#' @return Path to the overview index.html

overview <- function(savePath, outPath = '.', launch = TRUE){
  
  if(!dir.exists(savePath)) stop('Save game folder does not exist')
  dir.create(outPath, showWarnings = FALSE, recursive = TRUE)
  
  # Build up args in a vector
  args = c(make_quote(normalizePath(savePath)),
           make_quote(normalizePath(outPath)))
  
  # path to overview.exe
  OVpath <- system.file(package = 'CEHcraft', 'overview','overviewer.exe')
  
  output <- system2(command = OVpath,
                    args = args)
  
  if(launch){
    
    browseURL(file.path(outPath, 'index.html'))
    
  }
  
  return(file.path(outPath, 'index.html'))
  
}