#' Browse File
#'
#' A function to browse a file with a specific extension.
#' @param id The input id for the module. 
#' @param extension The file extension to filter by.
#' @param label The label for the file input.
#' @return  A list containing the reactive value of the file path.
#' @examples
#' \dontrun{
#'   library(shiny)
#'
#'   ui <- fluidPage(
#'     browserFileUI("file_input_ui", extension = ".csv")
#'   )
#'
#'   server <- function(input, output, session) {
#'     browserFileServer("file_input_server", extension = ".csv")
#'   }
#'
#'   shinyApp(ui, server)
#' }
#' @export
browserFileUI <- function(id, extension, 
                          label=paste0("Select ", extension ," File")) {
  
  ns <- NS(id)
  tagList(
    fileInput(inputId = ns("file"),
              label = div(style = "font-size:20px",tags$b(label)),
              multiple=FALSE,
              accept = extension),
               tags$style("
              .btn-file {
              vertical-align: middle;border-width: 0px;
              #background-color:#2c3e50; 
              #border-color: #2c3e50;
              vertical-align: middle;
              border-width: 0px;
               
              }
               .progress-bar {
               #background-color: red;
               vertical-align: middle;
               border-width: 0px;
              }")
                         
  )
}

#' Browse File Server
#'
#' This function is the server logic for the browse file module. 
#' It stores the selected file path in a global reactive value.
#'
#' @param id The input id for the module.
#' @param extension The file extension to filter by.
#' @param output output needed for server side
#' @param session session needed for server side
#' 
#' @return A reactive value containing the file path.
#' @examples
#' \dontrun{
#'   library(shiny)
#'
#'   ui <- fluidPage(
#'     browserFileUI("file_input_ui", extension = ".csv")
#'   )
#'
#'   server <- function(input, output, session) {
#'     browserFileServer("file_input_server", extension = ".csv")
#'   }
#'
#'   shinyApp(ui, server)
#' }
#' @export
browserFileServer <- function(id,extension,output, session){
  
  moduleServer(id, function(input, output, session) {
    
    rv <- reactiveValues(file_path = NULL)
    
    # The selected file, if any
    userFile <- reactive({
      # If no file is selected, don't do anything
      validate(need(input$file, message = FALSE))
      input$file
    })
    
    # # Check if the selected file has an allowed extension
    # observeEvent(userFile(), {
    #   file_ext <- tools::file_ext(userFile()$datapath)
    #   validate(need(file_ext %in% extension, 
    #                 message = "Invalid file extension"))
    #   
    # })
    
    # We can run observers in here if we want to
    observe({
      msg <- sprintf("File %s was uploaded.", userFile()$name)
      cat(msg, "\n")
    })
    
  
    observeEvent(input$file, {
      rv$file_path <- userFile()$datapath #input$file$datapath
    })
    
    return(rv)
  })
}
