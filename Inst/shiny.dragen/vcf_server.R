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