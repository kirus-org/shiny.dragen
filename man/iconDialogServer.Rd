% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/iconDialog.R
\name{iconDialogServer}
\alias{iconDialogServer}
\title{Icon Dialogue Module Server}
\usage{
iconDialogServer(id, title, message)
}
\arguments{
\item{id}{The id of the module.}

\item{title}{The title of the modal dialog.}

\item{message}{The message to be displayed in the modal dialog.}
}
\description{
This function handles the server-side logic for the icon module.
}
\examples{
\dontrun{
server <- function(input, output, session) {
  iconDialogServer("info_module", title = "Custom Title", message = "Custom Message")
  # Add other server logic as needed
}
}

}
