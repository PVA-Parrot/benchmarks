library(shiny)

calculatepca <- function(input) {
  upload <- input$fileupload
  if (is.null(upload))
    return(NULL)
  
  data <- read.csv(upload$datapath, header = input$hasHeaders)
  
  # remove first column if it has sample names
  if (input$hasRowNames)
    data <- data[c(-1)]
  
  # TODO: normalize data
  
  prcomp(data)
}

shinyServer(function(input, output) {
  output$stdevTable <- renderTable({
    sdev <- calculatepca(input)$sdev
    if (is.null(sdev))
      return(NULL)
    t(unlist(sdev))
  })
  
  output$eigenvaluesTable <- renderTable({
    sdev <- calculatepca(input)$sdev
    if (is.null(sdev))
      return(NULL)
    t(unlist(sdev ^ 2))
  })
  
  output$eigenvectorsTable <- renderDataTable({
    calculatepca(input)$rotation
  },
  options = list(searching = F,
                 ordering = F,
                 pageLength = 10,
                 scrollX = T))
  
  outputOptions(output, 'eigenvectorsTable', suspendWhenHidden = FALSE)
  outputOptions(output, 'stdevTable', suspendWhenHidden = FALSE)
  outputOptions(output, 'eigenvaluesTable', suspendWhenHidden = FALSE)
})
