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
  dIndex_list = read.csv("Data/input/index_list.csv", stringsAsFactors = F)
  assign("dgIndex_list", dIndex_list, envir = globalenv())
}

vf_index_list()