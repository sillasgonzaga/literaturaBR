#' load_all_books
#'
#' Retorna um dataframe com todos os livros contidos no pacote literaturaBR.
#'
#'
#'
#' @return Dataframe
#' @examples
#' # load_all_books()
load_all_books <- function(){
  d <- data(package = "literaturaBR")
  all_datasets <- d$results[, "Item"]
  # call datasets into R
 e <- new.env()
 data(list = all_datasets, package = "literaturaBR", envir = e)
 # combine books into a single dataframe
 x  <- mget(all_datasets, envir = e)
 df <- do.call("rbind", x)
 rm(e)
 return(df)
}
