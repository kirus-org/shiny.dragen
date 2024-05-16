shinyServer(function(input, output, session) {
  
  # increase limite size file to  120MB
  options(shiny.maxRequestSize=120*1024^2) 
  
  source("vcf_server.R", encoding = "UTF-8", local = TRUE)
  source("vcf_ui.R", encoding = "UTF-8", local = TRUE)
  
  ## stop shiny app when browser is closed
  session$onSessionEnded(function() {
    stopApp()
    print("The shiny.dragen session is closed.")
  })
  
})
