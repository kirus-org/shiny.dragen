#' Icon Dialogue Module UI
#'
#' This module creates an info icon that displays a message when hovered over or clicked.
#'
#' @param id The id of the module.
#' @param icon  Set Icon model
#' @usage
#' iconDialogUI(id, icon)
#'
#' @examples
#' \dontrun{
#' ui <- fluidPage(
#'   iconDialogUI("info_module", icon),
#'   # Add other UI elements as needed
#' )
#'
#' server <- function(input, output, session) {
#'   iconDialogServer("info_module", title = "Custom Title", message = "Custom Message")
#'   # Add other server logic as needed
#' }
#' 
#' shinyApp(ui = ui, server = server)
#' }
#'
#' @export
iconDialogUI <- function(id, icon="info-circle") {
  ns <- NS(id)
  tagList(
    div(
      style = "display:inline-block;",
      icon(icon, id = ns("info_icon"), style = "cursor: pointer; font-size: 18px;")
    ),
    tags$script(HTML(sprintf("
      $(document).ready(function() {
        var icon = $('#%s');
        icon.on('click', function() {
          Shiny.setInputValue('%s', 'click');
        });
        icon.hover(
          function() {
            Shiny.setInputValue('%s', 'hover_in');
          },
          function() {
            Shiny.setInputValue('%s', 'hover_out');
          }
        );
      });
    ", ns("info_icon"), ns("info_event"), ns("info_event"), ns("info_event"))))
  )
}

#' Icon Dialogue Module Server
#' 
#' This function handles the server-side logic for the icon module.
#'
#' @param id The id of the module.
#' @param title The title of the modal dialog.
#' @param message The message to be displayed in the modal dialog.
#' 
#' @usage iconDialogServer(id, title, message)
#' @examples
#' \dontrun{
#' server <- function(input, output, session) {
#'   iconDialogServer("info_module", title = "Custom Title", message = "Custom Message")
#'   # Add other server logic as needed
#' }
#' }
#'
#' @export
iconDialogServer <- function(id, title = "This is a Title", message = "This is an information message.") {

  moduleServer(id, function(input, output, session) {
    observeEvent(input$info_event, {
      event <- input$info_event
      if (event == "click" || event == "hover_in") {
        showModal(modalDialog(
          title = title,
          message,
          easyClose = TRUE,
          footer = NULL
        ))
      }
    })
  })
}
