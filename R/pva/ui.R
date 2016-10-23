library(shiny)

shinyUI(fluidPage(
  titlePanel("Polytopic Vector Analysis"),
  
  verticalLayout(
    wellPanel(
      fileInput(
        "fileupload",
        "Upload CSV file",
        accept = c("text/csv",
                   "text/comma-separated-values,text/plain",
                   ".csv")
      ),
      checkboxInput("hasHeaders", "First row are table headers", value = TRUE),
      checkboxInput("hasRowNames", "First row are sample names", value = TRUE)
    ),
    
    conditionalPanel(
      condition = "output.inputTable",
      tags$h2("Raw Input Data"),
      dataTableOutput("inputTable")
    ),
    
    conditionalPanel(
      condition = "output.stdevTable",
      tags$h2("Standard Deviations"),
      tableOutput("stdevTable")
    ),
    
    conditionalPanel(
      condition = "output.eigenvaluesTable",
      tags$h2("Eigenvalues"),
      tableOutput("eigenvaluesTable")
    ),
    
    conditionalPanel(
      condition = "output.eigenvectorsTable",
      tags$h2("Eigenvectors"),
      dataTableOutput("eigenvectorsTable")
    )
  )
))
