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
browseDirServer(id = "vcfDir_id", rv = rv, dir_key= "vcf_dir_path")
browseDirServer(id = "fastqDir_id", rv = rv, dir_key="fastq_dir_path")

# Observe the Save button click
observeEvent(input$save_button, {
  # Get input values
  text <- input$text_input
  folder <- rv$vcf_dir_path 
  file_name <- input$file_name
  
  print(paste0("folder: ", folder))
  
  # Check if text and folder are provided
  if (text != "" && !is.null(folder) && file_name != "") {
    
    ## OPTION 1 local bash script
    # Prepare bash command
    #bash_command <- paste("echo", shQuote(text), ">",
    #                      shQuote(file.path(folder, file_name)))
    # Execute bash command
    #system(bash_command)
    
    ## OPTION 2 define var option in system env
    # set en environment variable for the bash script
    # Sys.setenv(text = input$text_input)
    # Sys.setenv(output_folder= rv$vcf_dir_path)
    # Sys.setenv(file_name= input$file_name)
    # # Call the Bash script
    # system("./extdata/scripts/save_text.sh")
    
    ## OPTION 3 pass variable through option argument
    # Create a list of command-line arguments
     args_list <- c("-t", shQuote(input$text_input),
                    "-o", rv$vcf_dir_path,
                    "-m", input$file_name)
    # Call the shell script with arguments
    system2("./extdata/scripts/save_text.sh", args = args_list)
    
    
    output$message <- renderPrint({
      paste("File", file_name, "saved in", folder)
    })
  } else {
    output$message <- renderPrint({
      "Please provide text, select a folder, and enter a file name."
    })
  }
})