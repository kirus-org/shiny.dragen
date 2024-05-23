
output$ui_vcf <- renderUI({
  
  tagList(
    h2("Generate Fastq-List.csv File:"),
    tags$hr(),
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
             )
             
      ),
      column(width = 6, offset = 0,
             tabPanel(title = "Tab2",
                      h4(tags$b("Selected Samples:")),
                      wellPanel(
                        #splitLayout(cellWidths = c("20%", "50%"),
                        uiOutput("dynamicSelectInput"),
                        verbatimTextOutput("print_sample_folder_path")
                        #  )
                      ),
                      uiOutput("generate_fastq_list_but")
             )
      )
    ),
    
    h2("Visualize Fastq-List.csv File:"),
    tags$hr(),
    
    fluidRow(width=12,
             column(width = 6, offset = 0,
                    wellPanel(
                      browseFileUI("fastq_list_file_id" , extension = ".csv", 
                                   label= splitLayout(cellWidths = c("90%", "10%"),
                                                      "Select fastq-list.csv:", uiOutput("fast_list_example"))
                      )
                    )
             ),
             column(width = 6, offset = 0,
                    
                    DT::DTOutput("fastq_list_DT") 
             )
    ),
    
    h2("Generate VCF files:"),
    tags$hr(),
    
    fluidRow(
      column(width = 6,
             
             wellPanel(
               selectInput(inputId = "ref_gen_id", label = tags$b("Select Reference Genome:"),
                           choices =list( HG19= "/staging/references/human/hg19/hg19.fa.k_21.f_16.m_149/",
                                          HG38= "/staging/references/human/hg38/hg38.fa.k_21.f_16.m_149/",
                                          MultiGenome= "/staging/references/human/multiGenome/path"),
                           selected = "/staging/references/human/hg38/hg38.fa.k_21.f_16.m_149/"),
               verbatimTextOutput("print_gen_ref_path")
             ),
             
             h4(tags$b("Select VCF Output Folder:")),
             wellPanel(
               browseDirUI(id = "vcf_output_id", label = "Browse")
             ),
             
      ),
      column(width = 6,
             actionButton(inputId = "fastq2vcf_but_id", label = tags$b("Generate VCF"),
                          style="position: relative;  transform: translateY(-50%); 
                       left: 50%; transform: translateX(-50%); margin-top:30px")
             
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