#' sobiEquity
#'
#' sobiEquity is a companion package for the paper "Examining horizontal and vertical
#' equity to a public bicycle share program using a balanced floating catchment area
#' accessibility approach".
#'
#' The package includes the data used in the analysis.
#'
#' Contains information licensed under the Open Government Licence – Canada (https://open.canada.ca/en/open-government-licence-canada).
#'
#' Contains public sector Data made available under the City of Hamilton’s Open Data Licence (https://www.hamilton.ca/city-initiatives/strategies-actions/open-data-licence-terms-and-conditions).
#'
#' @author Elise Desjardins, \email{desjae@@mcmaster.ca}
#' @author Antonio Paez, \email{paezha@@mcmaster.ca}
#' @docType package
#' @name sobiEquity
NULL

#' Hamilton CMA.
#'
#' Boundary of the Hamilton CMA, in Ontario, Canada.
#'
#' @docType data
#' @keywords datasets
#' @keywords transportation
#' @name hamilton_cma
#' @usage data(hamilton_cma)
#' @source Statistics Canada
"hamilton_cma"

#' Hamilton Community Downtown.
#'
#' Boundary of the downtown center of Hamilton, in Ontario, Canada.
#'
#' @docType data
#' @keywords datasets
#' @keywords transportation
#' @name community_downtown
#' @usage data(community_downtown)
#' @source Open Hamilton (https://open.hamilton.ca/)
"community_downtown"

#' Hamilton Dissemination Areas.
#'
#' Boundary of the Hamilton DAs, in Ontario, Canada, with median total household income and
#' population levels within each DA.
#'
#' @docType data
#' @keywords datasets
#' @keywords transportation
#' @name hamilton_da_2016
#' @usage data(hamilton_da_2016)
#' @source Statistics Canada
"hamilton_da_2016"

#' Hamilton Interpolated Population.
#'
#' Interpolated population from Hamilton DAs, in 50-by-50 m cells.
#'
#' @docType data
#' @keywords datasets
#' @keywords transportation
#' @name population_50x50
#' @usage data(population_50x50)
#' @source Statistics Canada
"population_50x50"

#' Hamilton Bike Share Service Area
#'
#' Boundary of the Hamilton Bike Share service area of Hamilton, in Ontario, Canada.
#'
#' @docType data
#' @keywords datasets
#' @keywords transportation
#' @name sobi_service
#' @usage data(sobi_service)
#' @source Open Hamilton (https://open.hamilton.ca/)
"sobi_service"

#' Hamilton Bike Share Stations
#'
#' Location of the Hamilton Bike Share stations of Hamilton, in Ontario, Canada.
#'
#' @docType data
#' @keywords datasets
#' @keywords transportation
#' @name sobi_hubs
#' @usage data(sobi_hubs)
#' @source Open Hamilton (https://open.hamilton.ca/)
"sobi_hubs"

#' Travel Time Matrix
#'
#' Travel time matrix from centroids of population cells to bicycle share
#' stations within 10 km of cells in Hamilton, Ontario, Canada.
#'
#' @docType data
#' @keywords datasets
#' @keywords transportation
#' @name ttm_walk
#' @usage data(ttm_walk)
"ttm_walk"
