
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
                    wellPanel()
                    #plotlyOutput("forcast_log_active", height = "350px")
             ),
             column(width = 6,
                    wellPanel()
                    #plotlyOutput("forcast_log_death", height = "350px")  
             )
             
    )
  )
})