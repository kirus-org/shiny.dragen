
#' Progress Bar Module UI
#'
#' Creates the UI for the progress bar module with customizable button styling and visibility.
#'
#' @param id A unique identifier for the module.
#' @param buttonLabel A label for the action button.
#' 
#'
#' @return A `tagList` containing the action button and the progress bar UI elements.
#' @export
#' @examples
#' if (interactive()) {
#' # In your UI definition
#' progressBarUI("progress1", buttonLabel = "Run Script 1",
#' buttonStyle = "position: relative; transform: translateY(-50%);
#' left: 50%; transform: translateX(-50%); margin-top:30px")
#' progressBarUI("progress2", buttonLabel = "Run Script 2")
#' }
progressBarUI <- function(id, buttonLabel = "Start Script") {
  ns <- NS(id)
  tagList(
    uiOutput(ns("actionButtonUI")),
    textOutput(ns("status")),
    uiOutput(ns("progressBar"))
  )
}

#' Progress Bar Module Server
#'
#' Handles the server logic for the progress bar module.
#'
#' @param id A unique identifier for the module.
#' @param scriptPath Path to the Bash script to be executed.
#' @param args_list A list of arguments to pass to the script.
#' @param startMessage Message displayed when the script starts.
#' @param endMessage Message displayed when the script completes.
#' @param buttonLabel A label for the action button.
#' @param buttonVisibility A reactive expression to control the visibility of the button.
#' @param buttonStyle Custom CSS styling for the action button.
#' 
#' @usage progressBarServer(id, scriptPath, args_list, startMessage, endMessage,
#' buttonLabel, buttonVisibility, buttonStyle)
#' 
#' @return None. This function is used for its side effects.
#' @export
#' @examples
#' if (interactive()) {
#' # In your server definition
#' progressBarServer("progress1", scriptPath = "script1.sh",
#' args_list = c("-i", "input_dir", "-o", "output_dir"), 
#' startMessage = "Starting script 1...", endMessage = "Script 1 completed",
#' buttonLabel= "start script 1", buttonVisibility = reactive({ TRUE }))
#' 
#' progressBarServer("progress2", scriptPath = "script2.sh",
#' args_list = c("-i", "input_dir", "-o", "output_dir"),
#' startMessage = "Starting script 2...", endMessage = "Script 2 completed",
#' buttonLabel= "start scrip2t", buttonVisibility = reactive({ FALSE }),
#' buttonStyle = FALSE)
#'}
progressBarServer <- function(id, scriptPath, args_list, 
                              startMessage = "Script started...", 
                              endMessage = "Script completed",
                              buttonLabel= "Start Script",
                              buttonVisibility,
                              buttonStyle = "position: relative; 
                                          transform: translateY(-50%); left: 50%;
                                          transform: translateX(-50%); margin-top:30px") {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    task_process <- reactiveVal(NULL)
    progress_value <- reactiveVal(0)
    
    output$progressBar <- renderUI({
      if(buttonVisibility()) {
      tags$div(
        class = "progress",
        tags$div(
          class = "progress-bar",
          role = "progressbar",
          style = paste0("width: ", progress_value(), "%;"),
          `aria-valuenow` = progress_value(),
          `aria-valuemin` = "0",
          `aria-valuemax` = "100",
          paste0(progress_value(), "%")
        )
      )
      }
    })
    
    output$actionButtonUI <- renderUI({
      if(buttonVisibility()) {
        actionButton(ns("start"), buttonLabel, style = buttonStyle)
      }
    })
    # output$actionButtonUI <- renderUI({
    #   visibility <- buttonVisibility()
    #   print(paste("Button visibility:", visibility))
    #   if (visibility) {
    #     actionButton(ns("start"), buttonLabel, style = buttonStyle)
    #   }
    # })
    
    observeEvent(input$start, {
      output$status <- renderText(startMessage)
      progress_value(0)
      
      # Start the Bash script in a separate process
      task_process(process$new(
        scriptPath,
        args = args_list,
        stdout = "|",
        stderr = "|"
      ))
      
      # Check progress periodically
      observe({
        invalidateLater(1000, session)
        proc <- task_process()
        if (!is.null(proc) && proc$is_alive()) {
          proc_output <- proc$read_output_lines()
          if (length(proc_output) > 0) {
            last_progress <- tail(proc_output, 1)
            if (grepl("^\\d+\\.?\\d*$", last_progress)) {  # Check if last_progress is a numeric value
              last_progress <- as.numeric(last_progress)
              progress_value(last_progress)
              if (last_progress == 100) {
                output$status <- renderText(endMessage)
              } else {
                output$status <- renderText(paste("Progress:", last_progress, "%"))
              }
            }
          }
        } else {
          output$status <- renderText(endMessage)
          progress_value(100)
        }
      })
      
      
      
      
    })
  })
}