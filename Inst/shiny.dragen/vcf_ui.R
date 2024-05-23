
output$ui_vcf <- renderUI({
  
  tagList(
    # tabsetPanel(id = "tabset_id",
    #             tabPanel(title = "Tab1"),
    #             tabPanel(title = "Tab2")
    # ),
    
    fluidRow(
      column(width = 6, offset=0,
             
             h4(tags$b("Set FastQ Directory:"), 
             div(style = "display:inline-block;",  
                 # Call the iconDialogUI function to create the info icon
                 iconDialogUI("info_fastq_dir", icon="info-circle"))
             ),
             wellPanel(#style = "background:grey",
             browseDirUI(id = "fastq_dir_id", label = "Browse"),
             textOutput("check_dir_msg")
             ),
             
             h4(tags$b("Save fastq-list.csv to:")),
             wellPanel(
             browseDirUI("fast_list_output_id" , label = "Browse")
             ),
                uiOutput("generate_fastq_list_but")
      ),
      column(width = 6, offset = 0,
             tabPanel(title = "Tab2",
                      h4(tags$b("Selected Samples:")),
                      wellPanel(
                        #splitLayout(cellWidths = c("20%", "50%"),
                        uiOutput("dynamicSelectInput"),
                        verbatimTextOutput("Ref_gen_path_id")
                        #  )
                      )
             )
      )
    ),
    
    tags$hr(),
    
    fluidRow(width=12,
             column(width = 6, offset = 0,
                    wellPanel(
                      browseFileUI("fastq_list_file_id" , extension = ".csv", 
                                    label= div(style= "display:inline-block;clear:right;",
                                        uiOutput("fast_list_example"),"Select fastq-list.csv:")
                                    )
                    )
                    ),
             column(width = 6, offset = 0,
     
                    DT::DTOutput("fastq_list_DT")  
                    
            
    )
    )
    # fluidRow(
    #   column(width = 6, offset = 0, 
    #          style='padding-left:0px; padding-right:10px; padding-top:0px; padding-bottom:5px',
    #          div(style = "height:55px;"),
    #          wellPanel(
    #            browseFileUI("txt_browser" , extension = ".txt"),
    # 
    #            browseFileUI("csv_browser", extension = ".csv"),
    # 
    #            browseFileUI("fastq_browser", extension = ".fastq.gz")
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