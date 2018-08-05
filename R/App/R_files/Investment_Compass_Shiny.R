source("R_files/F_graph.R")

#####################################Rshiny dashboard###########################################
ui <- dashboardPage(

############Header#######
dashboardHeader(title = "Investment Compass"),  
  
####################Sidebar#######  
dashboardSidebar(
  
  width = 300,
  
  sidebarMenu(id = "tab", 
              menuItem("Visualize", tabName = "viz"),
              menuItem("Ticker_symbol_description", tabName = "descr")
  ), 
  
  #Return the conditional sidepanel
  uiOutput("dyn_sidebar")
),

####################Body#########
dashboardBody(
tabItems(   
  
  tabItem(tabName = "viz",       #linked to the sidebar's tabname
          plotOutput("plot1", height = 900) #Height should dynamically change with the number of graphs. 450 for each row
  ),
  
  tabItem(tabName = "descr",       #linked to the sidebar's tabname
          div(style = 'overflow-x: scroll', DT::dataTableOutput("report1"))
  )

      ) 
  )

)

##################################Server##################################
server <- function(input, output) {
  
  output$dyn_sidebar <- renderUI({
    
     if (input$tab == "viz") {
      dyn_ui <- list(selectInput("dropdown1", label = "Select Index", selected = dgIndex_list$ticker[2], choices = c(dgIndex_list$ticker))
      )
    }  
    
    
    if (input$tab == "descr") {
      dyn_ui = list(selectInput("dropdown2", label = "Placeholder", choices = c("Cool", "Awesome"))
      )
    }
    
    return(dyn_ui)
  })
  

#############################Produce stats table for scale variable when clicked#############################
  output$report1 = renderDataTable(DT::datatable(dgIndex_list))
  
  output$plot1 = renderPlot(gf_charting_graph(input$dropdown1))

}#end of server

#############################Shiny app to tie everything up#############################
shinyApp(ui, server)