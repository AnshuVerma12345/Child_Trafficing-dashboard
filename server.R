# Server
server = function(input, output, session) {
    # Sorting the data in descending order
    sorted_data <- reactive({
      data %>% arrange(desc(Value))
    })
  
  #Structure
  output$structure = renderPrint(
    #structure
    data %>% 
      str()
  )
  #Summary
  output$summary = renderPrint(
    #Summary
    data %>% 
      summary()
    
  )
  #Data Table
  output$dataT = renderDataTable({
    datatable(data, options = list(scrollX = TRUE))
  })
  # Stacked Histogram with Density Plot
  output$histplot = renderPlotly({
    # Histogram
    histogram <- data %>% 
      plot_ly() %>% 
      add_histogram(x = ~get(input$var1), histnorm = "probability density") %>% 
      layout(xaxis = list(title = input$var1))
    
    # Density Plot
    density_plot <- data %>% 
      plot_ly() %>% 
      add_lines(x = ~get(input$var1), y = ~..density.., line = list(shape = "spline", smoothing = 0.5),
                name = "Density") 
    
    
    
    # Boxplot
    boxplot <- data %>% 
      plot_ly() %>% 
      add_boxplot(~get(input$var1)) %>% 
      layout(yaxis = list(showticklables = F))
    
    # Stacking plots using subplot
    subplot_list <- list(boxplot, histogram)  # Make sure to use a list
    
    # Create subplot
    subplot <- subplot(subplot_list, nrows = 2, shareX = TRUE) %>% 
      hide_legend() %>% 
      layout("Distribution Chart - Histogram and Boxplot",
             yaxis = list(title = "Frequency"))
    
  })
  output$bar <- renderPlotly({
    data %>% 
      plot_ly() %>% 
      add_bars(x=~`State`, y=~get(input$var1)) %>% 
      layout(title = paste("Statewise crime", input$var1),
             xaxis = list(title = "State"),
             yaxis = list(title = paste(input$var1, "crime rate") ))
  })

}
