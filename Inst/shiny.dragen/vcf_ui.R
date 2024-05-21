
output$ui_vcf <- renderUI({

  tagList(
    
    fluidRow(
      column(width = 6, offset=0,
             h4(tags$b("Set FastQ Directory:"), 
                div(style = "display:inline-block;",  
                    # Call the iconDialogUI function to create the info icon
                    iconDialogUI("info_module", icon="info-circle"))
                ),
             wellPanel(
             browseDirUI(id = "fastq_dir_id", label = "Browse")
             ),
             # tabPanel(title = "Tab Panal", value = "Tab Value",icon = icon('table'),
             #          wellPanel(
             #            browserFileUI(id = "fq_smp_id", extension = "fastq.gz", label = "Select Sample")
             #          )
             # )
             
             ),
      
      column(width = 6, offset = 0,
             h4(tags$b("Selected Samples:")),
             wellPanel(
               #splitLayout(cellWidths = c("20%", "50%"),
                           uiOutput("dynamicSelectInput"),
                           verbatimTextOutput("Ref_gen_path_id")
             #  )
             )


             )
      
    ),
    fluidRow(width=12,
      column(width = 6, offset = 0,
             wellPanel(
               browserFileUI("fastq_list_file_id" , extension = ".csv")
             )),
      column(width = 6, offset = 0,
             
             DT::DTOutput("fastq_list_DT")  

      )
    )
   # fluidRow(
   #   column(width = 6, offset = 0, 
   #          style='padding-left:0px; padding-right:10px; padding-top:0px; padding-bottom:5px',
   #          div(style = "height:55px;"),
   #          wellPanel(
   #            browserFileUI("txt_browser" , extension = ".txt"),
   # 
   #            browserFileUI("csv_browser", extension = ".csv"),
   # 
   #            browserFileUI("fastq_browser", extension = ".fastq.gz")
   # 
   #          )
   #   ),
   #   column(width = 6, offset = 0, 
   #          style='padding-left:5px; padding-right:0px; padding-top:5px; padding-bottom:5px',
   #          tabBox(
   #            title = "", id = "tabox_plotID", height = "700px", width = "400px",
   # 
   #            tabPanel(tags$b("Lagged Status"), value = "Lagged Status",
   #                     wellPanel(
   #                       actionButton(inputId = "btn_txt_id", label = "print path"),
   #                       verbatimTextOutput("selected_txt_file")
   #                     )
   #                     #  plotlyOutput("diff_lag", height = "700px", width = "100%")
   #            )
   # 
   #          )
   #   )
   # 
   # ),
   # fluidRow(width = 12,
   #          column(width = 6,
   #                 wellPanel(
   #                   # File input for output directory
   #                  browseDirUI("vcfDir_id", label = "Set VCF Output Folder"),
   # 
   #                   actionButton("save_button", label = "Save"),
   #                   verbatimTextOutput("message"),
   #                  browseDirUI("fastqDir_id", label = "Set FastQ Output Folder"),
   #                 )
   #          ),
   #          column(width = 6,
   #                 wellPanel(
   #                   textInput(inputId = "file_name", label = "File Name", value = NULL),
   #                   # Text area for user input
   #                   textAreaInput("text_input", label = "Enter text:"),
   #                 )
   # 
   #          )
   # 
   #  )
  )
})