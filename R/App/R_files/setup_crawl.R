# #Installation of packages
# check.packages <- function(pkg){
#   new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
#   if (length(new.pkg)) 
#     install.packages(new.pkg, dependencies = TRUE)
#   sapply(pkg, require, character.only = TRUE)
# }
# 
# # Usage example
# packages<-c("shiny", "shinydashboard", "reshape2", "stringr", "RCurl", "parallel", "dplyr", "compiler", "ggplot2", "quantmod", "grid", "gridExtra", "DT")
# check.packages(packages)

require("shiny")
require("shinydashboard")
require("reshape2")
require("parallel")
require("dplyr")
require("compiler")
require("ggplot2")
require("quantmod")
require("grid")
require("gridExtra")
require("DT")

# Load the ticker symbols
vf_index_list = function(){
  dIndex_list = read.csv("./R/App/Data/input/index_list.csv", stringsAsFactors = F)
  assign("dgIndex_list", dIndex_list, envir = globalenv())
}
