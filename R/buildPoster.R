#' @export
#' @import imager

buildPoster <- function(path, outDir = '.'){
  
  if(!dir.exists(outDir)){
    dir.create(outDir, recursive = TRUE)
  }
  
  images_folder <- file.path(path, 'world-lighting')
  
  fileName <- basename(path)
  
  all <- list.files(images_folder, recursive = TRUE, full.names = FALSE)
  
  for(levels in 5:7){
    
    d <- 2^levels
    
    pasteMat <- function(mat, num){ # paste something to all elements of a matrix
      
      nr <- nrow(mat)
      nmat <- paste0(num, mat)
      return(matrix(nmat, nrow = nr))
      
    }
    
    exGr <- function(a){ #expand our grid
      
      b <- cbind(pasteMat(a,'0'), pasteMat(a,'1'))
      c <- cbind(pasteMat(a,'2'), pasteMat(a,'3'))
      e <- rbind(b,c)
      return(e)
      
    }
    
    level <- levels
    a <- matrix(as.character(0:3), nrow = 2, byrow = TRUE)
    
    while(level != 1){
      level = level - 1
      a <- exGr(a)
    }
    
    a
    
    # We only wan to plot areas with data
    test_exist <- function(i){
      fp <- file.path(
        images_folder,
        paste0(paste(unlist(strsplit(i, split = '*')), collapse = '/'),'.png'))
      file.exists(fp)
    }
    
    TF <- a
    
    for(r in 1:nrow(a)){
      for(col in 1:ncol(a)){
        TF[r,col] <- test_exist(a[r,col]) 
      }
    }
    
    TF <- sapply(as.data.frame(TF), as.logical)
    rTF <- apply(TF, MARGIN = 1, FUN = sum)
    names(rTF) <- 1:length(rTF)
    cTF <- apply(TF, MARGIN = 2, FUN = sum)
    names(cTF) <- 1:length(cTF)
    
    ctake <- as.numeric(names(cTF)[cTF>0])
    rtake <- as.numeric(names(rTF)[rTF>0])
    
    a_area <- a[rtake,ctake]
    
    # crop a little
    if(levels == 5) a_area <- a_area[2:(nrow(a_area) - 1), 3:(ncol(a_area) - 2)]
    if(levels == 6) a_area <- a_area[4:(nrow(a_area) - 2), 6:(ncol(a_area) - 5)]
    if(levels == 7) a_area <- a_area[7:(nrow(a_area) - 4), 11:(ncol(a_area) - 10)]
    
    jpeg(filename = file.path(outDir, paste0(fileName, levels, '.jpeg')),
         width = 384*ncol(a_area),
         height = 384*nrow(a_area))
    
    par(mfcol = c(nrow(a_area), ncol(a_area)))
    par(mar = rep(0,4))
    par(bg = '#1a1a1a')
    
    for(i in a_area){
      
      # print(i)
      
      fp <- file.path(
        images_folder,
        paste0(paste(unlist(strsplit(i, split = '*')), collapse = '/'),'.png'))
      
      if(file.exists(fp)){
        # print(fp)
        im <- load.image(fp)
        plot(im, axes = FALSE, rescale = FALSE)
        
      } else {
    
        plot(1, type = 'n', axes = FALSE, xlab = '', ylab = '')
        
      }
    
    }
    
    dev.off()
    
  }
}