% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/dh23.R
\name{dh23}
\alias{dh23}
\title{Function to return the DH23 hydrologic indicator statistic for a given data frame}
\usage{
dh23(qfiletempf, thresh)
}
\arguments{
\item{qfiletempf}{data frame containing a "discharge" column containing daily flow values}

\item{thresh}{numeric containing 1.67-year flood threshold calculated by getPeakThresh}
}
\value{
dh23 list containing DH23 for the given data frame
}
\description{
This function accepts a data frame that contains a column named "discharge" and a threshold value obtained
using the peakdata and peakthresh functions and calculates
DH23; Flood duration. Compute the flood threshold as the flow equivalent for a flood recurrence of 1.67 years.
Determine the number of days each year that the flow remains above the flood threshold. DH23 is the mean (or
median-Use Preference option) of the number of flood days for years in which floods occur (days-temporal).
}
\examples{
qfiletempf<-sampleData
dh23(qfiletempf, 1158)
}

