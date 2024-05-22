##################### FASTQ LIST PROCESSION  #####################


## Browse FastQ Directory
browseDirServer(id = "fastq_dir_id", rv = rv, dir_key= WorkDir,
                filetype = c("gz"))


## Render SelectInput Samples
output$dynamicSelectInput <- renderUI({
  
  req(rv[[WorkDir]])
  selected_dir <- rv[[WorkDir]]
  
  if (!dir.exists(selected_dir)) return()
  
  ##  filter only  directory
  #subdirs <- list.dirs(path = selected_dir, full.names = TRUE, recursive = FALSE)
  ## filter with files
  subdirs <- list.files(path = selected_dir, full.names = TRUE, recursive = FALSE)
  
  folder_names <- basename(subdirs)
  #  extract only the first string before "_"
  display_names <- sapply(folder_names, function(name) strsplit(name, "_")[[1]][1])
  
  #pickerInput(inputId = "gen_ref_id",label = NULL, multiple = TRUE,
  #            options = list(`actions-box` = TRUE),
  #            choices = setNames(subdirs, display_names))
  selectInput("gen_ref_id",label = NULL, multiple = TRUE,
              selected = setNames(subdirs, display_names),
              #div(style = "font-size:20px", tags$b("Reference Genomes:")),
              choices = setNames(subdirs, display_names))
})

# Call the iconDialogServer function to handle server-side logic
iconDialogServer("info_module", 
                 title = "FastQ Directory", 
                 message = "Select a directory containing folders corresponding to the samples. 
                 Each folder contains 1 or 2 fastq corresponding to Read 1 and/or Read 2")


# browse Fastq-list_file.txt
fastq_list_file_id <- browserFileServer(id = "fastq_list_file_id",
                  extension = ".csv")


# Render DataTable when file is uploaded
output$fastq_list_DT <- DT::renderDT({
  
  req(fastq_list_file_id$file_path)
  
  # Check if the file is empty
  if (file.info(fastq_list_file_id$file_path)$size == 0) {
    # Return a gentle message if the file is empty
   dat <- data.frame( `Warning!` = "The file is empty. Please provide a file with data.")
  }else{
    dat <- read.csv(fastq_list_file_id$file_path, row.names = NULL)
    
  }
    
  DT::datatable( dat,
    rownames = FALSE,
    escape   = FALSE,
    selection = "single",
    options = list(columnDefs = list(list(className = 'dt-center', targets = "_all")#,
                                     #list(visible=FALSE, targets=c(14)) # hide row_id column
                                     ), 
                   #info = FALSE,
                   pageLength = 5,
                   searching = FALSE,
                   dom = 'tp',
                   autoWidth = TRUE,
                   scrollX = TRUE,
                   scrollY = TRUE,
                   #order = list(1, 'desc'),
                   language = list(emptyTable = 'The selected file seems to be empty!'),
                   initComplete = JS(
                     "function(settings, json) {",
                   "$(this.api().table().header()).css({'background-color': '#f0f4f4', 'color': '#303c54'});",
                     "}")
                   #preDrawCallback = JS('function() { Shiny.unbindAll(this.api().table().node());}'),
                   #drawCallback = JS('function() { Shiny.bindAll(this.api().table().node()); } ')
    ))
})


## Print Reference Genome path
output$Ref_gen_path_id <- renderText({
  input$gen_ref_id
})


# ########################
# txt_browser <- browserFileServer("txt_browser", ".txt")
# csv_browser <- browserFileServer("csv_browser", ".csv")
# fastq_browser <- browserFileServer("fastq_browser", ".fastq.gz")
# 
# global_file_paths <- reactive({
#   list(
#     txt = txt_browser$file_path,
#     csv = csv_browser$file_path,
#     fastq = fastq_browser$file_path
#   )
# })
# 
# # Use global_file_paths in other processes
# observeEvent(input$file,{
#   if (!is.null(global_file_paths())) {
#     for(i in seq(global_file_paths())){
#       cat("Selected file paths:", global_file_paths(), "\n")
#     }
#   }
# })
# 
# # print select txt file
# output$selected_txt_file <- renderPrint( {
#   req(input$btn_txt_id)
#   txt_browser$file_path
# })
# 
# 
# #######################
# 
# ## set vcf output folder
# ## this function stire folderpath in rv$vcf_folder_path
# browseDirServer(id = "vcfDir_id", rv = rv, dir_key= "vcf_dir_path")
# browseDirServer(id = "fastqDir_id", rv = rv, dir_key="fastq_dir_path")
# 
# # Observe the Save button click
# observeEvent(input$save_button, {
#   # Get input values
#   text <- input$text_input
#   folder <- rv$vcf_dir_path
#   file_name <- input$file_name
# 
#   print(paste0("folder: ", folder))
# 
#   # Check if text and folder are provided
#   if (text != "" && !is.null(folder) && file_name != "") {
# 
#     ## OPTION 1 local bash script
#     # Prepare bash command
#     #bash_command <- paste("echo", shQuote(text), ">",
#     #                      shQuote(file.path(folder, file_name)))
#     # Execute bash command
#     #system(bash_command)
# 
#     ## OPTION 2 define var option in system env
#     # set en environment variable for the bash script
#     # Sys.setenv(text = input$text_input)
#     # Sys.setenv(output_folder= rv$vcf_dir_path)
#     # Sys.setenv(file_name= input$file_name)
#     # # Call the Bash script
#     # system("./extdata/scripts/save_text.sh")
# 
#     ## OPTION 3 pass variable through option argument
#     # Create a list of command-line arguments
#      args_list <- c("-t", shQuote(input$text_input),
#                     "-o", rv$vcf_dir_path,
#                     "-m", input$file_name)
#     # Call the shell script with arguments
#     system2("./extdata/scripts/save_text.sh", args = args_list)
# 
# 
#     output$message <- renderPrint({
#       paste("File", file_name, "saved in", folder)
#     })
#   } else {
#     output$message <- renderPrint({
#       "Please provide text, select a folder, and enter a file name."
#     })
#   }
# })