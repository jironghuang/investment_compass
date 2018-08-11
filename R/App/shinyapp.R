#To deploy the app
setwd("/home/jirong/Desktop/github/investment_compass/R/App")
require(rsconnect)
# runApp()

rsconnect::setAccountInfo(name='sef88',
                          token='774B78F3DCDF204010B6DB8A549AFD06',
                          secret='T+53U52YBPufrcz6hI68A3pBCuAWqqCMDR86WLqu')


deployApp(appName = "investment_compass")
