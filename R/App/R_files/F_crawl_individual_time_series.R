source("R_files/setup.R")

#Load the index list
vf_index_list()

#Use this script to crawl the major indices -->https://finance.yahoo.com/world-indices/
vf_crawl_time_series = function(npIndex){
  
  spTicker = dgIndex_list$ticker[npIndex]
  
  #Include try catch, error
  tryCatch({
  
    start <- as.Date("1950-01-01")
    end <- as.Date("2020-10-01")
    getSymbols(spTicker,from = start, to = end)
    
    #Remove ^
    spTicker = gsub("\\^", "", spTicker)
    
    stock_price = as.data.frame(get(spTicker))  
    
    stock_price$Date = row.names(stock_price)
    
    write.csv(stock_price, paste0("./R/App/Data/output/", spTicker, ".csv"), row.names = F)
    
    return(NULL)
    
  }, error=function(e){})
}

#Compile the function
cmp_vf_crawl_time_series = cmpfun(vf_crawl_time_series)

#Crawl the indices
# finance_data = mclapply(1: nrow(dgIndex_list), cmp_vf_crawl_time_series , mc.cores = detectCores())


