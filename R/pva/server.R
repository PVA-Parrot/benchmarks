library(shiny)

csvdata <- function(input) {
  upload <- input$fileupload
  read.csv(upload$datapath, header = input$hasHeaders)
}

normalize <- function(data) {
  mins <- sapply(data, min)
  maxs <- sapply(data, max)
  spread <- maxs - mins
  t((t(data) - mins) / spread)
}

calculatepca <- function(input) {
  if (is.null(input$fileupload))
    return(NULL)
  
  data <- csvdata(input)
  
  # remove first column if it has sample names
  if (input$hasRowNames)
    data <- data[c(-1)]
  
  normalized <- normalize(data)
  
  pca <- prcomp(normalized, center = F, scale = F)
  
  # PVA software uses n as a denominator in SD, we need to correct for this
  pca$sdev <- pca$sdev * (1-1/length(normalized))
  
  pca
}


calculateeigen <- function(input) {
  if (is.null(input$fileupload))
    return(NULL)
  
  data <- csvdata(input)
  
  # remove first column if it has sample names
  if (input$hasRowNames)
    data <- data[c(-1)]
  
  normalized <- normalize(data)
  
  eigen(cov(normalized))
  }

shinyServer(function(input, output) {
  
  output$inputTable <- renderDataTable({
    if (is.null(input$fileupload))
      return(NULL)
    csvdata(input)
  })
  
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
    #data.frame(calculateeigen(input)$vectors)
    }
    # ,
    # options = list(searching = F,
    #                ordering = F,
    #                pageLength = 10,
    #                scrollX = T)
    )
  
  outputOptions(output, 'inputTable', suspendWhenHidden = FALSE)
  outputOptions(output, 'eigenvectorsTable', suspendWhenHidden = FALSE)
  outputOptions(output, 'stdevTable', suspendWhenHidden = FALSE)
  outputOptions(output, 'eigenvaluesTable', suspendWhenHidden = FALSE)
})
