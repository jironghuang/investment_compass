source("R_files/F_graph.R")

function(input, output) {
  
  dataInput <- reactive({
    df_format_data(input$dropdown1) 
    
  })
  
  
  output$dyn_sidebar <- renderUI({
    
    if (input$tab == "viz") {
      dyn_ui <- list(selectInput("dropdown1", label = "Select Index", selected = dgIndex_list$ticker[2], choices = c(dgIndex_list$ticker))
      )
    }  
    
    
    if (input$tab == "descr") {
      dyn_ui = list(selectInput("dropdown2", label = "Placeholder", choices = c("Cool", "Awesome"))
      )
    }
    
    if (input$tab == "README") {
      dyn_ui = list(selectInput("dropdown3", label = "Placeholder", choices = c("Cool", "Awesome"))
      )
    }    
    
    return(dyn_ui)
  })
  
  
  #############################Produce stats table for scale variable when clicked#############################
  output$report1 = renderDataTable(DT::datatable(dgIndex_list, options = list(pageLength = 35)))
  
  # output$plot1 = renderPlot(gf_charting_graph(input$dropdown1))  
  
  output$plot1 = renderPlot(gf_charting_graph(dataInput()))  

  output$fallnow <- renderInfoBox({
    infoBox(
      "% fall from 52 week high now", n_perc_fallnow(dataInput()), color = "red"
    )
  })  
    
  output$ret1 <- renderInfoBox({
    infoBox(
      "Returns_1_year_later (%)", n_returns_1yrlater(dataInput()), color = "purple"
    )
  })

  output$ret2 <- renderInfoBox({
    infoBox(
      "Returns_2_years_later (%)", n_returns_2yrlater(dataInput()), color = "yellow"
    )
  })  

  output$ret3 <- renderInfoBox({
    infoBox(
      "Returns_3_years_later (%)", n_returns_3yrlater(dataInput()), color = "green"
    )
  })
  
}  