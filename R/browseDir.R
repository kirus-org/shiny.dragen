#' Directory Selection Module UI
#'
#' This module provides a UI for selecting a directory for output processing.
#'
#' @param id A namespace identifier for the module.
#' @param label label of the button. default "Set Output Directory"
#'
#' @usage browseDirUI(id, label)
#' @return A UI definition for the module.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyFiles)
#'
#'   ui <- fluidPage(
#'     mainPanel(
#'       browseDirUI("vcfDir1")
#'     )
#'   )
#'
#'   server <- function(input, output, session) {
#'     browseDirServer("vcfDir1")
#'   }
#'
#'   shinyApp(ui = ui, server = server)
#' }
browseDirUI <- function(id, label= "Set Output Directory") {
  ns <- NS(id)
  tagList(
    shinyDirButton(ns("dir_id"), label = label, title = "Upload"),
    verbatimTextOutput(ns("dir_path"), placeholder = TRUE)
  )
}

#' Directory Selection Module Server
#'
#' This module handles the server-side logic for selecting a directory for output processing.
#'
#' @param id A namespace identifier for the module.
#' @param rv A reactiveValues object for storing the selected directory path.
#'
#' @usage browseDirServer(id, rv)
#'
#' @return None. This function is used for its side effects.
#' It stores the path of the selected directory to the provided reactiveValues object.
#'        
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyFiles)
#'
#'   ui <- fluidPage(
#'     mainPanel(
#'       browseDirUI("vcfDir1")
#'     )
#'   )
#'
#'   server <- function(input, output, session) {
#'     rv <- reactiveValues()
#'     browseDirServer("vcfDir1", rv)
#'   }
#'
#'   shinyApp(ui = ui, server = server)
#' }
browseDirServer <- function(id, rv) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    shinyDirChoose(input, id = 'dir_id', roots = c(home = '~'),
                   filetypes = c('', 'txt', 'bigWig', "tsv", "csv", "bw"))
    
    rv$dir_path <- normalizePath("~")
    
    r_dir <- reactive(input$dir_id)
    
    output$dir_path <- renderText({
      rv$dir_path
    })
    
    observeEvent(ignoreNULL = TRUE,
                 eventExpr = {input$dir_id},
                 handlerExpr = {
                   if (!"path" %in% names(r_dir())) return()
                   home <- normalizePath("~")
                   rv$dir_path <-
                     file.path(home, paste(unlist(r_dir()$path[-1]),
                                           collapse = .Platform$file.sep))
                 })
  })
}
