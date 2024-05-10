suppressMessages({
  library(shiny)
  library(shinythemes)
  library(shinydashboard)
  library(knitr)
})

shinyUI(fluidPage(theme = shinytheme("flatly"), title = "shiny.dragen", #superhero, flatly, united
                  ## add the icon logo to browser tab
                  tags$head(
                    HTML("<title>shiny.dragen</title> <link rel='icon' type='image/gif/png' href='logo.png'>")
                  ),
                  
                  tags$head(tags$script(type="text/javascript", src = "octopus.js")),
                  
                  ## Include logo in navbar
                  navbarPage(title=div(img(src="logo.png", height = "50px", collapsable=TRUE, #width = "50px",
                                           style = "position: relative; top: -14px; right: 1px;"),
                                       "shiny.dragen"),
                             
                             
                             tabPanel("Globe",icon = icon('globe'),
                                      # div(class="outer",
                                      #     tags$head(includeCSS("www/styles.css")),
                                      #     
                                      #     uiOutput('ui_frontPage')
                                      # )
                                      ),
                             
                             navbarMenu("", icon = icon("question-circle"),
                                        tabPanel("About",icon = icon("info"),
                                                 withMathJax(includeMarkdown("extdata/help/about.md"))
                                                 #includeHTML("README.html")
                                        ),
                                        tabPanel("Help",  icon = icon("question"),
                                                 withMathJax(includeMarkdown("extdata/help/help.md"))), #uiOutput("help_ui")
                                        tabPanel(tags$a(
                                          "", href = "https://github.com/kirus-org/shiny.dragen/issues", target = "_blank",
                                          list(icon("github"), "Report issue")
                                        )),
                                        tabPanel(tags$a(
                                          "", href = "https://github.com/kirus-org/shiny.dragen", target = "_blank",
                                          list(icon("globe"), "Resources")
                                        ))
                             )
                             
                  )
                  
))