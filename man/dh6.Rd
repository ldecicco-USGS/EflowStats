% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/dh6.R
\name{dh6}
\alias{dh6}
\title{Function to return the DH6 hydrologic indicator statistic for a given data frame}
\usage{
dh6(qfiletempf)
}
\arguments{
\item{qfiletempf}{data frame containing a "discharge" column containing daily flow values}
}
\value{
dh6 numeric containing DH6 for the given data frame
}
\description{
This function accepts a data frame that contains a column named "discharge" and calculates
DH6; Variability of annual maximum daily flows. Compute the standard deviation for the maximum 1-day
moving averages. DH6 is 100 times the standard deviation divided by the mean (percent-spatial).
}
\examples{
qfiletempf<-sampleData
dh6(qfiletempf)
}

