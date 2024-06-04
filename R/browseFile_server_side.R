#' Directory Selection Module UI
#'
#' This module provides a UI for selecting a directory for output processing.
#'
#' @param id A namespace identifier for the module.
#' @param label label of the button. default "Set Output Directory"
#'
#' @usage browseFileUI_server_side(id, label)
#' @return A UI definition for the module.
#' @export
#'
#' @examples
#'if (interactive()) {
#'  ui <- fluidPage(
#'    mainPanel(
#'      browseFileUI_server_side("vcfDir1"),
#'      browseFileUI_server_side("vcfDir2")
#'    )
#'  )
#'  
#'  server <- function(input, output, session) {
#'  Work_Dir <- normalizePath("~")
#'    selected_file1 <- browseFileServer_server_side("vcfDir1")
#'    selected_file2 <- browseFileServer_server_side("vcfDir2")
#'    
#'    observe({
#'      print(paste("Directory 1:", selected_file1()))
#'      print(paste("Directory 2:", selected_file2()))
#'    })
#' }
#'  
#'  shinyApp(ui = ui, server = server)
#'}
browseFileUI_server_side <- function(id, label= "Select File") {
  ns <- NS(id)
  tagList(
    splitLayout(cellWidths = c("15%","83%"),
    shinyFilesButton(ns("file_id"), label = label, title = "Upload", multiple = FALSE,
                   style = "vertical-align: middle;border-width: 0px"),
    verbatimTextOutput(ns("file_path"), placeholder = TRUE)
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
#' @usage browseFileServer_server_side(id, filetype, workspace)
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
#'      browseFileUI_server_side("vcfDir1"),
#'      browseFileUI_server_side("vcfDir2")
#'    )
#'  )
#'  
#'  server <- function(input, output, session) {
#'    Work_Dir <- normalizePath("~")
#'    selected_file1 <- browseFileServer_server_side("vcfDir1")
#'    selected_file2 <- browseFileServer_server_side("vcfDir2")
#'    
#'    observe({
#'      print(paste("Directory 1:", selected_file1()))
#'      print(paste("Directory 2:", selected_file2()))
#'    })
#' }
#'  
#'  shinyApp(ui = ui, server = server)
#'}
browseFileServer_server_side <- function(id, filetype = c('csv', 'tsv', 'txt'), 
                              workspace = normalizePath("~")) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    shinyFileChoose(input, id = 'file_id', 
                    roots = c(`Workspace` = workspace),
                    filetypes = filetype)
    
    selected_file <- reactiveVal(NULL)
    
    observeEvent(input$file_id, {
      if (!is.null(input$file_id)) {
        # Getting the parsed path from input$file_id
        file_path <- parseFilePaths(roots = c(`Workspace` = workspace), input$file_id)
        
        # Extract the first selected file path (if multiple files are allowed, handle accordingly)
        if (nrow(file_path) > 0) {
          selected_file(as.character(file_path$datapath[1]))
        }
      }
    })
    
    output$file_path <- renderText({
      selected_file()
    })
    
    return(selected_file)
  })
}