#' Function to return all flow statistics for an outside daily discharge data set
#' 
#' This function accepts a data frame of outside discharge data (datetime in format 'YYYY-MM-DD')
#' and list of desired statistic groups and returns a data frame containing requested statistics
#' 
#' @param daily_data data frame containing datetime and discharge
#' @param drain_area value of drainage area for station
#' @param site_id string containing site identifier
#' @param stats string containing desired groups of statistics 
#' @return statsout data frame containing requested statistics for each station
#' @export
#' @examples
#' qfiletempf<-dailyData
#' drain_area<-54
#' site_id <- "Test site"
#' stats="magnifSeven,magStat,flowStat,durStat,timStat,rateStat"
#' ObservedStatsOther(qfiletempf,drain_area,site_id,stats)
ObservedStatsOther <- function(daily_data,drain_area,site_id,stats) {
  Flownum <- (length(grep("magStat", stats)) * 94) + (length(grep("flowStat", stats)) * 14) + (length(grep("durStat", stats)) * 44) + (length(grep("timStat", stats)) * 10) + (length(grep("rateStat", stats)) * 9) + (length(grep("otherStat", stats)) * 9)
  Magnifnum <- (length(grep("magnifSeven", stats)) * 7)
  colnames(daily_data) <- c("date","discharge")
  x_obs <- daily_data 
  x_obs$date <- as.Date(x_obs$date,"%Y-%m-%d")
  x_obs$month_val <- substr(x_obs$date,6,7)
  x_obs$year_val <- substr(x_obs$date,1,4)
  x_obs$day_val <- substr(x_obs$date,9,10)
  x_obs$jul_val <- strptime(x_obs$date,"%Y-%m-%d")$yday+1
  x_obs$wy_val <- ifelse(as.numeric(x_obs$month_val)>=10,as.character(as.numeric(x_obs$year_val)+1),x_obs$year_val) 
  temp <- aggregate(discharge ~ wy_val,data=x_obs,length)
  temp <- temp[which(temp$discharge>=365),]
  
  obs_data<-x_obs[x_obs$wy_val %in% temp$wy_val,]
  countbyyr<-aggregate(obs_data$discharge, list(obs_data$wy_val), length)
  colnames(countbyyr)<-c("wy","num_samples")
  sub_countbyyr<-countbyyr[countbyyr$num_samples>=365,]
  if (nrow(sub_countbyyr)==0) {
    comment<-"No complete water years for site"
  } else {
    obs_data<-merge(obs_data,sub_countbyyr,by.x="wy_val",by.y="wy")
    obs_data<-obs_data[order(obs_data$date),]
    peakData <- aggregate(obs_data$discharge,by=list(obs_data$wy_val),max)
    colnames(peakData) <- c("wy_val","discharge")
    peakData <- obs_data[paste(obs_data$wy_val,obs_data$discharge) %in% paste(peakData$wy_val,peakData$discharge),]
    peakData$logval <- log10(peakData$discharge)
  min_date <- min(obs_data[which(obs_data$month_val=="10"&obs_data$day_val=="01"),]$date)
  max_date <- max(obs_data[which(obs_data$month_val=="09"&obs_data$day_val=="30"),]$date)
  obs_data <- obs_data[which(obs_data$date>=min_date&obs_data$date<=max_date),]
  
  namesMagnif <- c("lam1Obs", "tau2Obs", "tau3Obs", "tau4Obs", "ar1Obs", "amplitudeObs", "phaseObs")
  namesMagStat <- c("ma1_mean_disc", "ma2_median_disc", "ma3_mean_annual_var", "ma4", "ma5_skew", "ma6", "ma7", "ma8", "ma9", "ma10", "ma11", "ma12_jan_mean", 
                    "ma13_feb_mean", "ma14_mar_mean", "ma15_apr_mean", "ma16_may_mean", "ma17_june_mean", "ma18_july_mean", "ma19_aug_mean", "ma20_sep_mean", "ma21_oct_mean", 
                    "ma22_nov_mean", "ma23_dec_mean", "ma24_jan_var", "ma25_feb_var", "ma26_mar_var", "ma27_apr_var", "ma28_may_var", "ma29_jun_var", "ma30_july_var", "ma31_aug_var", 
                    "ma32_sep_var", "ma33_oct_var", "ma34_nov_var", "ma35_dec_var", "ma36", "ma37_var_across_months", "ma38", "ma39_monthly_std_dev", "ma40_monthly_skewness", 
                    "ma41", "ma42", "ma43", "ma44", "ma45", "ml1", "ml2", "ml3", "ml4", "ml5", "ml6", "ml7", "ml8", "ml9", "ml10", "ml11", "ml12", "ml13_min_monthly_var", "ml14_min_annual_flow", 
                    "ml15", "ml16", "ml17", "ml18", "ml19", "ml20", "ml21", "ml22", "mh1", "mh2", "mh3", "mh4", "mh5", "mh6", "mh7", "mh8", "mh9", "mh10", "mh11", "mh12", "mh13", 
                    "mh14_med_annual_max", "mh15", "mh16_high_flow_index", "mh17", "mh18", "mh19", "mh20", "mh21", "mh22", "mh23", "mh24", "mh25", "mh26_high_peak_flow", "mh27")
  namesFlowStat <- c("fl1_low_flood_pulse", "fl2_low_pulse_var", "fl3", "fh1_high_pulse_count", "fh2_high_pulse_var", "fh3_high_pulse_count_three", "fh4_high_pulse_count_seven", 
                     "fh5", "fh6", "fh7", "fh8", "fh9", "fh10","fh11")
  namesDurStat <- c("dl1_min_daily_flow", "dl2_min_3_day_avg", "dl3", "dl4_min_30_day_avg", "dl5_min_90_day_avg", "dl6_min_flow_var", "dl7", "dl8", "dl9_min_30_day_var", 
                    "dl10_min_90_day_var", "dl11", "dl12", "dl13", "dl14", "dl15", "dl16", "dl17", "dl18_zero_flow_days", "dl19", "dl20", "dh1", "dh2", "dh3", "dh4", "dh5_max_90_day_avg", 
                    "dh6", "dh7", "dh8", "dh9", "dh10_max_90_day_var", "dh11", "dh12", "dh13", "dh14", "dh15", "dh16", "dh17", "dh18", "dh19", "dh20", "dh21","dh22","dh23","dh24")
  namesTimStat <- c("ta1", "ta2", "ta3","tl1_min_flow_julian_day", "tl2_min_julian_var", "tl3","tl4","th1_max_flow_julian_day", "th2_max_julian_var","th3")
  namesRateStat <- c("ra1_rise_rate", "ra2_rise_rate_var", "ra3_fall_rate", "ra4_fall_rate_var", "ra5", "ra6", "ra7", "ra8", "ra9")
  namesOtherStat <- c("med_flowObs", "cv_flowObs", "cv_dailyObs", "flow_10Obs", "flow_25Obs", "flow_50Obs", "flow_75Obs", 
                      "flow_90Obs", "flow_15Obs")
  
  namesFull <- c("site_no", "min_date", "max_date")
  
  yv<-as.character(min(obs_data$date))
  ymaxv<-as.character(max(obs_data$date))
  cat(paste("dates calculated for site","\n",sep=" "))
  obs_data <- obs_data[,c('wy_val','date','discharge','month_val','year_val','day_val','jul_val')]
  obs_count <- nrow(obs_data)
  cat(paste("dfs created for site",obs_count,"\n",sep=" "))
    if (Flownum>0) {
      ObsFlowStats <- FlowStatsAll(obs_data,drain_area,stats=stats,peakData=peakData)
      cat(paste("Flow stats calculated for site",site_id,"\n",sep=" "))
    }
    if (Magnifnum>0) {
      magnifSevenObs <- magnifSeven(obs_data)
      cat(paste("Mag7 stats calculated for site",site_id,"\n",sep=" "))
    }
  comment <- ""
  statsout<-data.frame(t(c(site_id,yv,ymaxv,magnifSevenObs,ObsFlowStats,comment)),stringsAsFactors=FALSE)
  
  if (Magnifnum>0) {
    namesFull <- c(namesFull,namesMagnif)
  }
  if (length(grep("otherStat",stats))>0) {
    namesFull <- c(namesFull,namesOtherStat)
  }
  if (length(grep("magStat",stats))>0) {
    namesFull <- c(namesFull,namesMagStat)
  }
  if (length(grep("flowStat",stats))>0) {
    namesFull <- c(namesFull,namesFlowStat)
  }
  if (length(grep("durStat",stats))>0) {
    namesFull <- c(namesFull,namesDurStat)
  }
  if (length(grep("timStat",stats))>0) {
    namesFull <- c(namesFull,namesTimStat)
  }
  if (length(grep("rateStat",stats))>0) {
    namesFull <- c(namesFull,namesRateStat)
  }}
  namesFull <- c(namesFull,'comment')
  
  colnames(statsout)<-namesFull
  cat("statsout created and named \n")
  return(statsout)
}