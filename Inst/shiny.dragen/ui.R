suppressMessages({
  library(shiny)
  library(shinythemes)
  library(shinydashboard)
  library(knitr)
})

shinyUI(fluidPage(theme = shinytheme("flatly"), title = "shiny.dragen", #superhero, flatly
                  ## add the icon logo to browser tab
                  tags$head(
                    HTML("<title>shiny.dragen</title> <link rel='icon' type='image/gif/png' href='logo.png'>")
                  ),
                  
                  
                  
                  
))