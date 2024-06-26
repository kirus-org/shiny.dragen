% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/browseDir.R
\name{browseDirServer}
\alias{browseDirServer}
\title{Directory Selection Module Server}
\usage{
browseDirServer(id, filetype, workspace)
}
\arguments{
\item{id}{A namespace identifier for the module.}

\item{filetype}{A character sting specifying the files type to use for starting 
directory path in the reactiveValues object. default c('csv', 'tsv', 'txt')}

\item{workspace}{set default work directory}
}
\value{
None. This function is used for its side effects.
It stores the path of the selected directory to the provided reactiveValues object.
}
\description{
This module handles the server-side logic for selecting a directory for output processing.
}
\examples{
if (interactive()) {
 ui <- fluidPage(
   mainPanel(
     browseDirUI("vcfDir1"),
     browseDirUI("vcfDir2")
   )
 )
 
 server <- function(input, output, session) {
   Work_Dir <- normalizePath("~")
   selected_dir1 <- browseDirServer("vcfDir1")
   selected_dir2 <- browseDirServer("vcfDir2")
   
   observe({
     print(paste("Directory 1:", selected_dir1()))
     print(paste("Directory 2:", selected_dir2()))
   })
}
 
 shinyApp(ui = ui, server = server)
}
}
