suppressMessages({
  library(shiny)
  library(shinythemes)
  library(shinydashboard)
  library(shinyFiles)
  #library(shinyWidgets)
  library(knitr)
})

shinyUI(fluidPage(theme = shinytheme("flatly"), title = "shiny.dragen", #superhero, flatly, united
                  ## add the icon logo to browser tab
                  tags$head(
                    HTML("<title>shiny.dragen</title> <link rel='icon' type='image/gif/png' href='dragen_f29405.png'>")
                  ),
                  
                  tags$head(tags$script(type="text/javascript", src = "octopus.js")),
                  
                  ## Include logo in navbar
                  navbarPage(title=div(img(src="dragen_f29405.png", height = "50px", collapsable=TRUE, #width = "50px",
                                           style = "position: relative; top: -14px; right: 1px;"),
                                       tags$b("dragen"), style="color:#FFB266"),
                             
                             #tabPanel("dragen", icon = icon('dragon')),
                             
                            # tabPanel("fastq", icon= icon('dna')),
                             
                             tabPanel("VCF",icon = icon('table'),
                                      # div(class="outer",
                                      #     tags$head(includeCSS("www/styles.css")),
                                      #     
                                           uiOutput('ui_vcf')
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