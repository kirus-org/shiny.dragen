shinyServer(function(input, output, session) {
  
  
  ## stop shiny app when browser is closed
  session$onSessionEnded(function() {
    stopApp()
    print("The shiny.dragen session is closed.")
  })
  
  
})