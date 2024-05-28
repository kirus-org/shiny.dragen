#' Dropdown UI Function
#'
#' Creates a dropdown button with a customizable content area.
#'
#' @param id The ID of the dropdown module.
#' @param label The label for the dropdown button.
#' @param content The content to be displayed in the dropdown menu.
#'
#' @return A Shiny UI element for the dropdown button.
#' @export
#' @examples
#' if (interactive()) {
#' library(shiny)
#' ui <- fluidPage(
#'   dropdownUI("dropdown1", "FastQ List", DT::dataTableOutput("fastq_list_DT"))
#' )
#' server <- function(input, output, session) {}
#' shinyApp(ui = ui, server = server)
#' }
dropdownUI <- function(id, label, content) {
  #ns <- NS(id)
  tagList(
     tags$head(
       tags$style(HTML(".scrollable-dropdown-menu {max-height: 200px; overflow-y: auto;}"))
     ),
    div(
      class = "dropdown",
      tags$button(
        class = "btn btn-secondary dropdown-toggle",
        `data-toggle` = "dropdown",
        label,
        tags$span(class = "caret")
      ),
      div(
        class = "dropdown-menu scrollable-dropdown-menu",
        content
      ),
      tags$script(
        HTML("
          $('.dropdown-menu').on('shown.bs.dropdown', function () {
            $(this).find('table').DataTable({
            scrollX: true,
            scrollY: $(this).height() - 50,
            paging: false
            });
          });
        ")
      )
    )
  )
}