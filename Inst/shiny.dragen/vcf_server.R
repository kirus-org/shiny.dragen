##################### GENERATE FASTQ LIST FILE  #####################

# Call the iconDialogServer function to handle server-side logic
iconDialogServer(id = "info_fastq_dir",
                 title = "FastQ Directory", 
                 message = "Select a directory containing folders corresponding to the samples. 
                 Each folder contains 1 or 2 fastq corresponding to Read 1 and/or Read 2")

## Browse FastQ Directory
selected_fastq_dir <- browseDirServer(id = "fastq_dir_id",filetype = c("gz"), 
                                      workspace = Work_Dir)

## set Fastq-list.tx output folder
selected_fastq_list_dir <- browseDirServer(id = "fast_list_output_id",
                                           filetype = c(".txt", ".csv"),
                                           workspace = dirname(Work_Dir))

## check the structure of fastq Directory
## it must have folder for each sample that starts by A01, A02, B01, B02...
## each sample folder must has 2 .fastq.gz files
  output$check_dir_msg <- renderText({
    
    req(selected_fastq_dir())
    
    # Set the path to the bash script
    #script_path <-"Inst/shiny.dragen/extdata/scripts/check_fastq_directory_structure.sh"
    # Execute the bash script and capture its output
    #script_output <- system(script_path, intern = TRUE)
    
    args_list <- selected_fastq_dir()
    
    check_dir_msg <- system(paste0("./extdata/scripts/check_fastq_directory_structure.sh ", args_list),
                            intern = TRUE)
    
    paste0(check_dir_msg)
  })


## Render SelectInput Samples
output$dynamicSelectInput <- renderUI({
  
  req(selected_fastq_dir())

  if (!dir.exists(selected_fastq_dir())) return()
  
  ##  filter only  directory
  #subdirs <- list.dirs(path = selected_fastq_dir(), full.names = TRUE, recursive = FALSE)
  
  ## filter with files
  subdirs <- list.files(path = selected_fastq_dir(), full.names = TRUE, recursive = FALSE)
  
  folder_names <- basename(subdirs)
  #  extract only the first string before "_"
  display_names <- sapply(folder_names, function(name) strsplit(name, "_")[[1]][1])
  
  #pickerInput(inputId = "gen_ref_id",label = NULL, multiple = TRUE,
  #            options = list(`actions-box` = TRUE),
  #            choices = setNames(subdirs, display_names))
  selectInput("samples_folder_path_id",label = NULL, multiple = TRUE,
              selected = setNames(subdirs, display_names),
              #div(style = "font-size:20px", tags$b("Reference Genomes:")),
              choices = head(setNames(subdirs, display_names), n= 10)
  )
})

## Print Reference Genome path
output$print_sample_folder_path <- renderText({
  req(input$samples_folder_path_id)
  input$samples_folder_path_id
})

# ## ActionButton to generate fastq-list.csv
# output$generate_fastq_list_but <- renderUI({
#   req(selected_fastq_dir(), selected_fastq_list_dir())
#   actionButton(inputId = "gen_fastq_list_but_id", label = tags$b("Generate FastQ List File"),
#                style="position: relative;  transform: translateY(-50%); 
#                        left: 50%; transform: translateX(-50%); margin-top:30px")
# })

## ObserveEvent actionButton to generate Fastq-list.csv

# observeEvent(input$gen_fastq_list_but_id, {
#   # Create a list of command-line arguments
#     args_list <- c("-i", selected_fastq_dir(),
#                     "-o", selected_fastq_list_dir(),
#                      "-f", "fastq-list.csv") 
#     
#   system2("./extdata/scripts/get_fastq_list.sh", args= args_list)
#   
# })

progressBarServer("gen_fastq_list_but_id", 
                  scriptPath = "./extdata/scripts/get_fastq_list.sh", 
                  args_list = c("-i", selected_fastq_dir(),
                                "-o", selected_fastq_list_dir()),
                  startMessage = "Starting fastq-list.csv...", 
                  endMessage = "fastq-list.csv completed",
                  buttonLabel = "Fastq-list.csv",
                  buttonVisibility= reactive({
                    req(selected_fastq_dir(), selected_fastq_list_dir())
                    TRUE
                  })
                  )
######################## VISUALIZE FASTQ LIST FILE #################################

# browse Fastq-list_file.txt
fastq_list_file_id <- browseFileServer(id = "fastq_list_file_id",
                  extension = ".csv")


output$fast_list_example <- renderUI({
  
#req(fastq_list_file_id$file_path)
iconDialogServer(id = "fastq_example",
                 title = "Fastq-list.csv example", 
                 message = HTML('<img src="extdata/img/fastq_list_example.png"/>')
                 )

# Call the iconDialogUI function to create the info icon
iconDialogUI("fastq_example", icon="info-circle")
})

output$fastq_list_view <- renderUI({
  
 # req(fastq_list_file_id$file_path)
  
  iconDialogServer(id = "fastq_view_id",
                   title = "Fastq-list.csv", 
                   message = DT::DTOutput("fastq_list_DT")
  )
  
  # Call the iconDialogUI function to create the info icon
  iconDialogUI("fastq_view_id", icon="eye")
})

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
                   #scrollCollapse = TRUE,
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

#####################    FASTQ2VCF      ##################

output$print_gen_ref_path <- renderText({
  req(input$ref_gen_id)
  input$ref_gen_id
})

## set Fastq-list.tx output folder
selected_vcf_dir <- browseDirServer(id = "vcf_output_id",
                                           filetype = c("gz"),
                                           workspace = dirname(Work_Dir))

## ObserveEvent actionButton to generate VCF
# observeEvent(input$fastq2vcf_but_id, {
#   # Create a list of command-line arguments
#   args_list <- c("-r", input$ref_gen_id,
#                  "-f", fastq_list_file_id$file_path,
#                  "-o", selected_vcf_dir()
#                  ) 
#   
#   system2("./extdata/scripts/fastq2vcf.sh", args= args_list)
#   
# })

progressBarServer("fastq2vcf_but_id", 
                  scriptPath = "./extdata/scripts/fastq2vcf.sh", 
                  args_list <- c("-r", input$ref_gen_id,
                                 "-f", fastq_list_file_id$file_path,
                                 "-o", selected_vcf_dir()
                  ),
                  startMessage = "Starting fastq2vcf...", 
                  endMessage = "VCF completed",
                  buttonLabel = "Generate VCF",
                  buttonVisibility= reactive({
                    req(input$ref_gen_id, fastq_list_file_id$file_path,
                        selected_vcf_dir())
                    TRUE
                  })
)

# ########################
# txt_browser <- browseFileServer("txt_browser", ".txt")
# csv_browser <- browseFileServer("csv_browser", ".csv")
# fastq_browser <- browseFileServer("fastq_browser", ".fastq.gz")
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