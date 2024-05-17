
output$ui_vcf <- renderUI({

  tagList(
    
    fluidRow(
      column(width = 6, offset = 0, style='padding-left:0px; padding-right:10px; padding-top:0px; padding-bottom:5px',
             div(style = "height:55px;"),
             wellPanel(
               browserFileUI("txt_browser" , extension = ".txt"),
               
               browserFileUI("csv_browser", extension = ".csv"),
               
               browserFileUI("fastq_browser", extension = ".fastq.gz")
               
             )
      ),
      column(width = 6, offset = 0, style='padding-left:5px; padding-right:0px; padding-top:5px; padding-bottom:5px',
             tabBox(
               title = "", id = "tabox_plotID", height = "700px", width = "400px",
               
               tabPanel(tags$b("Lagged Status"), value = "Lagged Status", 
                        wellPanel(
                          actionButton(inputId = "btn_txt_id", label = "print path"),
                          verbatimTextOutput("selected_txt_file")
                        ) 
                        #  plotlyOutput("diff_lag", height = "700px", width = "100%")
               )
               
             )
      )
      
    ),
    fluidRow(width = 12,
             column(width = 6,
                    wellPanel(
                      # File input for output directory
                     browseDirUI("vcfDir_id", label = "Set VCF Output Folder"),
                      
                      actionButton("save_button", label = "Save"),
                      verbatimTextOutput("message")
                    )
             ),
             column(width = 6,
                    wellPanel(
                      textInput(inputId = "file_name", label = "File Name", value = NULL),
                      # Text area for user input
                      textAreaInput("text_input", label = "Enter text:"),
                    )
  
             )
             
    )
  )
})