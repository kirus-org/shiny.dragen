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
#'if (interactive()) {
#'  ui <- fluidPage(
#'    mainPanel(
#'      browseDirUI("vcfDir1"),
#'      browseDirUI("vcfDir2")
#'    )
#'  )
#'  
#'  server <- function(input, output, session) {
#'  Work_Dir <- normalizePath("~")
#'    selected_dir1 <- browseDirServer("vcfDir1")
#'    selected_dir2 <- browseDirServer("vcfDir2")
#'    
#'    observe({
#'      print(paste("Directory 1:", selected_dir1()))
#'      print(paste("Directory 2:", selected_dir2()))
#'    })
#' }
#'  
#'  shinyApp(ui = ui, server = server)
#'}
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
#' @param filetype  A character sting specifying the files type to use for starting 
#' directory path in the reactiveValues object. default c('csv', 'tsv', 'txt')
#' @param workspace set default work directory
#'
#' @usage browseDirServer(id, filetype, workspace)
#'
#' @return None. This function is used for its side effects.
#' It stores the path of the selected directory to the provided reactiveValues object.
#'        
#' @export
#'
#' @examples
#'if (interactive()) {
#'  ui <- fluidPage(
#'    mainPanel(
#'      browseDirUI("vcfDir1"),
#'      browseDirUI("vcfDir2")
#'    )
#'  )
#'  
#'  server <- function(input, output, session) {
#'    Work_Dir <- normalizePath("~")
#'    selected_dir1 <- browseDirServer("vcfDir1")
#'    selected_dir2 <- browseDirServer("vcfDir2")
#'    
#'    observe({
#'      print(paste("Directory 1:", selected_dir1()))
#'      print(paste("Directory 2:", selected_dir2()))
#'    })
#' }
#'  
#'  shinyApp(ui = ui, server = server)
#'}
browseDirServer <- function(id, filetype= c('', 'txt', 'csv', 'tsv'), 
                            workspace= normalizePath("~")) {
  
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    shinyDirChoose(input, id = 'dir_id', 
                   roots = c(`Workspace` = workspace),
                   filetypes = filetype)
    
    selected_dir <- reactiveVal(NULL)
    
    observeEvent(input$dir_id, {
      if (!is.null(input$dir_id) && "path" %in% names(input$dir_id)) {
        dir_path <- normalizePath(file.path(workspace, paste(unlist(input$dir_id$path[-1]), 
                                                             collapse = .Platform$file.sep)))
        selected_dir(dir_path)
      }
    })
    
    output$dir_path <- renderText({
      selected_dir()
    })
    
    return(selected_dir)
  })
}