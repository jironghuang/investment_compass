source("R_files/F_crawl_individual_time_series.R")

#Format the data to be used for charting
df_format_data = function(sp_index_name){

  # stock_price = dp_index_data  
  sp_index_name = gsub("\\^", "", sp_index_name)
  stock_price = paste0("Data/output/",sp_index_name,".csv")
  stock_price = read.csv(stock_price, stringsAsFactors = F)
      
  #create a loop and lag x times
  lag_days = 251
  
  # stk_price = function(lag_days){
  for(i in 1:lag_days) { #lag_days = 260
    
    # as.data.frame(lag(stock_price,i))
    a = assign(paste("lag",i,sep=""),as.data.frame(lag(stock_price[,4],i)))
    names(a) = paste("lag",i)
    
    stock_price = cbind(stock_price,a)
    rm(list = ls()[grepl("lag", ls())]) #remove lags from each iteration, ls refers to list of dataframes
  }
  
  nrows = dim(a)[1]
  
  #Create a % of 52 week high, 52 week low
  #% 52 week high
  max_52weeks = as.data.frame(apply(stock_price[,-c(1,2,3,4,5,7)],1,max, na.rm =T))
  
  lower_52weekhigh = (stock_price[,4] -  max_52weeks)/max_52weeks
  names(lower_52weekhigh)[1] = "col1"
  
  
  #% off 52 week low
  min_52weeks = as.data.frame(apply(stock_price[,-c(1,2,3,4,5,7)],1,min, na.rm = T))
  
  higher_52weeklow = (stock_price[,4] -  min_52weeks)/min_52weeks
  names(higher_52weeklow)[1] = "col1"
  
  #Create a lag of 1,3,5 years ago
  leadprice = as.data.frame(lead(stock_price[,4],251))
  names(leadprice)[1] = "lead1yr"
  leadprice$lead2yr = lead(stock_price[,4],502)
  leadprice$lead3yr = lead(stock_price[,4],753)
  
  #Compute returns
  returns= as.data.frame((leadprice$lead1yr -  stock_price[,4])/stock_price[,4])
  names(returns)[1] = "returns_1yr"
  returns$returns_2yr = (leadprice$lead2yr -  stock_price[,4])/stock_price[,4]
  returns$returns_3yr = (leadprice$lead3yr -  stock_price[,4])/stock_price[,4]
  
  #Look at returns-%52 week high scatterplot
  dat = cbind(stock_price$Date,lower_52weekhigh,higher_52weeklow,returns)
  names(dat) = c("Date","lower_52weekhigh","higher_52weeklow", "returns_1yr","returns_2yr","returns_3yr")
  dat = subset(dat,!is.na(dat$lower_52weekhigh))
  dat = subset(dat,!is.na(dat$higher_52weeklow))
  dat$Date = as.Date(dat$Date)
  
  #Return data frame
  return(dat)

}

#Function for charting graph
gf_charting_graph = function(dp_index_data) {

  # sp_index_name = gsub("\\^", "", sp_index_name)
  # d_index_data = paste0("Data/output/",sp_index_name,".csv")
  # d_index_data = read.csv(d_index_data, stringsAsFactors = F)
  # dat = df_format_data(d_index_data)
  
  dat = dp_index_data
  
  myBreaks <- function(x){
    breaks <- c(min(x),median(x),max(x))
    breaks = quantile(x, c(0, 0.2,0.4,0.6,0.8,1))
    attr(breaks,"labels") <- as.Date(breaks, origin="1970-01-01")
    names(breaks) <- attr(breaks,"labels")
    return(breaks)
  }
  
  # # dat = subset(dat,!is.na(dat$Date))
  dat1 = subset(dat,!is.na(dat$returns_1yr))
  
  yr1_high = ggplot(dat1,aes(lower_52weekhigh,returns_1yr,colour=as.integer(Date))) + geom_point(alpha = 0.6) +
    scale_colour_gradientn(colours = rainbow(5), breaks=myBreaks) + ggtitle("1yr returns vs. Change from 52 week high")+xlab("Change from 52 week high")+ylab("Returns 1 year later")
  #something wrong with non parametric regression 
  yr1_high = yr1_high + geom_smooth(method = "lm", se = TRUE)
  yr1_high = yr1_high +theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))+
    theme(plot.title=element_text(face="bold", size=12)) + labs(color="date")

  dat2 = subset(dat,!is.na(dat$returns_2yr))
  yr2_high = ggplot(dat2,aes(lower_52weekhigh,returns_2yr,colour=as.integer(Date))) + geom_point(alpha = 0.6) +
    scale_colour_gradientn(colours = rainbow(7), breaks=myBreaks) + ggtitle("2yr returns vs. Change from 52 week high")+xlab("Change from 52 week high")+ylab("Returns 2 year later")
  yr2_high = yr2_high+geom_smooth(method = "lm", se = TRUE) 
  yr2_high = yr2_high +theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))+
    theme(plot.title=element_text(face="bold", size=12)) + labs(color="date")

  dat3 = subset(dat,!is.na(dat$returns_3yr))
  yr3_high = ggplot(dat3,aes(lower_52weekhigh,returns_3yr,colour=as.integer(Date))) + geom_point(alpha = 0.6) +
    scale_colour_gradientn(colours = rainbow(7), breaks=myBreaks) + ggtitle("3yr returns vs. Change from 52 week high")+xlab("Change from 52 week high")+ylab("Returns 3 year later")
  yr3_high = yr3_high+geom_smooth(method = "lm", se = TRUE) 
  yr3_high = yr3_high +theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))+
    theme(plot.title=element_text(face="bold", size=12)) + labs(color="date")
  
  #Create holding structure for multiple graphs
  lList_graphs = rep(list(qplot((rnorm(1,0))) + ggtitle("Placeholder")), 3)
  lList_graphs[[1]] = yr1_high
  lList_graphs[[2]] = yr2_high
  lList_graphs[[3]] = yr3_high
  
  nNum_graphs = length(lList_graphs)
  nNum_Col = 2  #Fixing 2 coumns 
  
  return(do.call("grid.arrange", c(lList_graphs, ncol = nNum_Col)))
}

#Create a function to output value of returns 1 year later
n_returns_1yrlater = function(dat){
  dat = subset(dat,!is.na(dat$returns_1yr))
  yr1 = lm(dat$returns_1yr~ dat$lower_52weekhigh)
  yr1 = yr1$coefficients[2]*(dat$lower_52weekhigh[nrow(dat)]) + yr1$coefficients[1]  
  yr1 = round(yr1 * 100, 1)
  return(yr1)
}

n_returns_2yrlater = function(dat){
  dat = subset(dat,!is.na(dat$returns_2yr))
  yr2 = lm(dat$returns_2yr~ dat$lower_52weekhigh)
  yr2 = yr2$coefficients[2]*(dat$lower_52weekhigh[nrow(dat)]) + yr2$coefficients[1]  
  yr2 = round(yr2 * 100, 1)
  return(yr2)
}

n_returns_3yrlater = function(dat){
  dat = subset(dat,!is.na(dat$returns_3yr))
  yr3 = lm(dat$returns_3yr~ dat$lower_52weekhigh)
  yr3 = yr3$coefficients[2]*(dat$lower_52weekhigh[nrow(dat)]) + yr3$coefficients[1]  
  yr3 = round(yr3 * 100, 1)
  return(yr3)
}

n_perc_fallnow = function(dat){
  return(round(dat$lower_52weekhigh[nrow(dat)] * 100, 1))
}







