txt_browser <- browserFileServer("txt_browser", ".txt")
csv_browser <- browserFileServer("csv_browser", ".csv")
fastq_browser <- browserFileServer("fastq_browser", ".fastq.gz")

global_file_paths <- reactive({
  list(
    txt = txt_browser$file_path,
    csv = csv_browser$file_path,
    fastq = fastq_browser$file_path
  )
})

# Use global_file_paths in other processes
observeEvent(input$file,{
  if (!is.null(global_file_paths())) {
    for(i in seq(global_file_paths())){
      cat("Selected file paths:", global_file_paths(), "\n")
    }
  }
})

# print select txt file
output$selected_txt_file <- renderPrint( {
  req(input$btn_txt_id)
  txt_browser$file_path
})



## set vcf output folder
## this function stire folderpath in rv$vcf_folder_path
browseDirServer(id = "vcfDir_id", rv = rv)


# Observe the Save button click
observeEvent(input$save_button, {
  # Get input values
  text <- input$text_input
  folder <- rv$dir_path 
  file_name <- input$file_name
  
  print(paste0("folder: ", folder))
  
  # Check if text and folder are provided
  if (text != "" && !is.null(folder) && file_name != "") {
    # Prepare bash command
    bash_command <- paste("echo", shQuote(text), ">",
                          shQuote(file.path(folder, file_name)))
    
    # Execute bash command
    system(bash_command)
    
    output$message <- renderPrint({
      paste("File", file_name, "saved in", folder)
    })
  } else {
    output$message <- renderPrint({
      "Please provide text, select a folder, and enter a file name."
    })
  }
})