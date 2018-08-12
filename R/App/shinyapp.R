#To deploy the app
setwd("/home/jirong/Desktop/github/investment_compass/R/App")
require(rsconnect)
# runApp()

rsconnect::setAccountInfo(name = 'sef88',
                          token = Sys.getenv("shiny_token"),
                          secret = Sys.getenv("shiny_secret"))


deployApp(appName = "investment_compass")
