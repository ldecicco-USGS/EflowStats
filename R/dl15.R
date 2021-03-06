#' Function to return the DL15 hydrologic indicator statistic for a given data frame
#' 
#' This function accepts a data frame that contains a column named "discharge" and calculates 
#' DL15; Low exceedence flows. Compute the 90-percent exceedence value for the entire flow record. DL15 is the 
#' exceedence value divided by the median for the entire record (dimensionless-spatial).
#' 
#' @param qfiletempf data frame containing a "discharge" column containing daily flow values
#' @return dl15 numeric containing DL15 for the given data frame
#' @export
#' @examples
#' qfiletempf<-sampleData
#' dl15(qfiletempf)
dl15 <- function(qfiletempf) {
  isolateq <- qfiletempf$discharge
  sortq <- sort(isolateq)
  hfcrit <- quantile(sortq,.1,type=6)
  medianq <- median(qfiletempf$discharge)
  dl15 <- round(hfcrit/medianq,digits=2)
  return(dl15)
}