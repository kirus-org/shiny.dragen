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
#'     browseDirServer("vcfDir1", rv, "vcf_folder_path", "filetype")
#'   }
#'
#'   shinyApp(ui = ui, server = server)
#' }
browseDirUI <- function(id, label= "Set Directory") {
  ns <- NS(id)
  tagList(
    splitLayout(cellWidths = c("15%","83%"),
    shinyDirButton(ns("dir_id"), label = label, title = "Upload", 
                   style = "vertical-align: middle;border-width: 0px"),
    verbatimTextOutput(ns("dir_path"), placeholder = TRUE)
    )

  )
}

#' Directory Selection Module Server
#'
#' This module handles the server-side logic for selecting a directory for output processing.
#'
#' @param id A namespace identifier for the module.
#' @param rv A reactiveValues object for storing the selected directory path.
#' @param dir_key A character string specifying the key to use for storing 
#' the directory path in the reactiveValues object. default: /home.
#' @param filetype  A character sting specifying the files type to use for starting 
#' directory path in the reactiveValues object. default c('csv', 'tsv', 'txt')
#'
#'
#' @usage browseDirServer(id, rv, dir_key, filetype)
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
#'     browseDirServer("vcfDir1", rv, "vcf_folder_path", "filetype")
#'   }
#'
#'   shinyApp(ui = ui, server = server)
#' }
browseDirServer <- function(id, rv, dir_key= normalizePath("~"), 
                            filetype = c('','txt', 'csv','tsv')) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    shinyDirChoose(input, id = 'dir_id', hidden= FALSE ,
                   restrictions = system.file(package = "base"),
                   roots = c(`Workspace` = dir_key),
                   filetypes = filetype)
    
    observe({
      rv[[dir_key]] <- dir_key 
    })
    
    r_dir <- reactive(input$dir_id)
    
    output$dir_path <- renderText({
      rv[[dir_key]]
    })
    
    
    observeEvent(ignoreNULL = TRUE,
                 eventExpr = {input$dir_id},
                 handlerExpr = {
                   if (!"path" %in% names(r_dir())) return()
                   init_dir <- dir_key #normalizePath("~")
                   rv[[dir_key]] <-
                     file.path(init_dir, paste(unlist(r_dir()$path[-1]),
                                           collapse = .Platform$file.sep))
                 })
  })
}