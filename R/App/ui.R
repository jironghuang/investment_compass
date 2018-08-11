source("R_files/F_graph.R")

ui <- dashboardPage(
  ############Header#######
  dashboardHeader(title = "Investment Compass (Beta version: Data extracted in Batch Mode on 11 Aug 18)"),  
  
  ####################Sidebar#######  
  dashboardSidebar(
    
    width = 300,
    
    sidebarMenu(id = "tab", 
                menuItem("Visualize", tabName = "viz"),
                menuItem("Ticker_symbol_description", tabName = "descr"),
                menuItem("README", tabName = "README")
    ), 
    
    #Return the conditional sidepanel
    uiOutput("dyn_sidebar")
  ),
  
  ####################Body#########
  dashboardBody(
    tabItems(   
      
      tabItem(tabName = "viz",       #linked to the sidebar's tabname
              infoBoxOutput("fallnow"),
              infoBoxOutput("ret1"),
              infoBoxOutput("ret2"),
              infoBoxOutput("ret3"),
              plotOutput("plot1", height = 900) #Height should dynamically change with the number of graphs. 450 for each row
      ),
      
      tabItem(tabName = "descr",       #linked to the sidebar's tabname
              div(style = 'overflow-x: scroll', DT::dataTableOutput("report1"))
      ),
      
      tabItem(tabName = "README",       #linked to the sidebar's tabname
              fluidRow(HTML("<h3>This interactive app predicts the expected returns 1,2 & 3 years later based on the % fall from 52 week high today.</h3> 
                             <h3>The model is built around a simple philosophy - The greater fall in market prices today, the higher the expected future returns.</h3> 
                             <h3>Pls visit the following </a><a href=\"https://www.linkedin.com/pulse/investment-compass-our-volatile-times-jirong-huang\">Article </a>for the full explanation.</h3>
                             <h3>Note: Current Beta version is based on batch data instead of linking directly to Yahoo / Google API</h3>"))
      )      
      
    ) 
  )  
)