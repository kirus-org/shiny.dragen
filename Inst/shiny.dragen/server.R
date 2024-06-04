shinyServer(function(input, output, session) {
  
  # increase limite size of uploaded file  by shiny app to  120MB
  options(shiny.maxRequestSize=120*1024^2) 
  
  ## check if the shiny app is running in local machine or docker container
  is_container <- function() {
    # Check if the app is running inside a Docker container
    if (file.exists("/.dockerenv")) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
  
  # Set WorkSpace Path
  if(is_container()){
    Work_Dir <- "/home/Proliant"
  }else{
    Work_Dir <- "/media/DATA/fastq"
  }

 
 
  
  # Define global reactive values
  rv <- reactiveValues()
  
  source("vcf_server.R", encoding = "UTF-8", local = TRUE)
  source("vcf_ui.R", encoding = "UTF-8", local = TRUE)
  
  ## stop shiny app when browser is closed
  session$onSessionEnded(function() {
    #stopApp()
    print("The shiny.dragen session is closed.")
  })
  
})
