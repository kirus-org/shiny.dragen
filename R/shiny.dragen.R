#' Launch shiny.dragen with default browser
#' @description Launch shiny.dragen with default browser
#' @return  shiny webpage
#' @usage shiny.dragen()
#'
#' @examples
#' ShinyApp <-  1
#' \dontrun{
#' shiny.dragen()
#' }
#'
#' @name shiny.dragen
#' @import shiny shinythemes shinydashboard
#' @import  knitr
#' @importFrom utils installed.packages
#' @export

shiny.dragen <- function(){
  if("shiny.dragen" %in% installed.packages()){
    library(shiny.dragen)
    shiny::runApp(system.file("shiny.dragen", package = "shiny.dragen"),
                  launch.browser = TRUE, quiet = TRUE)
  }else{
    stop("Install and load shiny.dragen package before to run it.")
  }
}