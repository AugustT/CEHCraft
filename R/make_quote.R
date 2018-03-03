# get quotes correct
make_quote <- function(x){
  xn <- gsub('\\\\', '\\\\\\\\', as.character(x))
  xf <- gsub("'", '', gsub('"', '', xn))
  return(paste0('"', xf, '"'))
}