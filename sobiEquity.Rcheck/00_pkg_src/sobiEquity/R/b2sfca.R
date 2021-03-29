#' Compute balanced floating catchment area accessibility
#'
#' @param ttm A travel time matrix with a column of origin IDs, a column of destination IDs, travel times, type of destinations, population at the origin, and supply at the destination.
#' @param threshold A threshold for the binary impedance function
#' @return The level of service \code{los} and accessibility \code{accessibility}.
#' @export
#' @examples
#' #add(1, 1)
#' #add(10, 1)

b2sfca <- function(ttm = ttm, threshold = threshold){
  # calculate the impedance
  ttm <- ttm %>%
    dplyr::mutate(impedance_binary = ifelse(travel_time <= threshold, 1, 0))

  # Calculate the sum of the impedance by population for the balancing factors. In the binary case, this should be the same as the number of SoBi hubs that each interpolated population unit can reach
  sum_b1 <- ttm %>%
    dplyr::group_by(UID) %>%
    dplyr::summarize(sum_b1 = sum(impedance_binary),
              .groups = "drop")

  # Calculate the sum of the impedance by SoBi hubs for the balancing factors. In the binary case, this should be the same as the number of interpolated population cells that each SoBi hub serves
  sum_b2 <- ttm %>%
    dplyr::group_by(hub) %>%
    dplyr::summarize(sum_b2 = sum(impedance_binary))

  # Join the sum of the impedance to the table to calculate the balanced impedance values:
  ttm <- ttm %>%
    dplyr::left_join(sum_b1, by = "UID") %>%
    dplyr::left_join(sum_b2, by = "hub")

  # **Important:** notice that some values of `sum_b1` are zeros! This means that some population units cannot reach a SoBi hub in at most 24 min. Since the balancing impedance is calculated by diving the impedance by `sum_b1`, this will lead to NaNs (divisions by zero). To avoid issues we will remove any population units that reach zero hubs:
  ttm <- ttm %>%
    dplyr::filter(sum_b1 > 0,
                  sum_b2 > 0)

  # Calculate balanced impedance values:
  ttm <- ttm %>%
    dplyr::mutate(balanced_impedance_1 = impedance_binary/sum_b1,
                  balanced_impedance_2 = impedance_binary/sum_b2)

  # The level of service of each hub is the number of bicycle racks at the hub, divided by the population that they serve:
  los <- ttm %>%
    dplyr::group_by(hub) %>%
    dplyr::summarize(los = dplyr::first(racks) / sum((population * balanced_impedance_1)),
              .groups = "drop")

  # Join the level of service to the table:
  ttm <- ttm %>%
    dplyr::left_join(los, by = "hub")

  # To calculate accessibility, the level of service of each hub needs to be distributed proportionally to the population units.
  accessibility <- ttm %>%
    dplyr::group_by(UID) %>%
    dplyr::summarize(accessibility = sum(los * balanced_impedance_2),
              .groups = "drop")

  output = list(los = los,
                accessibility = accessibility)
  return(output)
}
