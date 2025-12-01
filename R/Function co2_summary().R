#' Summary statistics for CO2 emissions by country
#'
#' @param df The CO2 dataset (output of load_co2_data)
#' @param countries Optional vector of countries to include
#' @param start_year Filter data from this year onward
#' @param end_year Filter data up to this year
#'
#' @return A data frame with mean, median, and sd of CO2 emissions by country
#' @export
co2_summary <- function(df,
                        countries = NULL,
                        start_year = NULL,
                        end_year = NULL) {

  # Defensive
  if (!is.data.frame(df)) stop("df must be a data frame")
  if (!all(c("country", "year", "co2") %in% names(df))) {
    stop("df must contain 'country', 'year', 'co2'")
  }

  if (!is.null(countries)) {
    missing <- setdiff(countries, unique(df$country))
    if (length(missing) > 0) {
      stop("These countries do not exist in dataset: ",
           paste(missing, collapse=", "))
    }
    df <- df[df$country %in% countries, ]
  }

  if (!is.null(start_year)) df <- df[df$year >= start_year, ]
  if (!is.null(end_year))   df <- df[df$year <= end_year, ]

  if (nrow(df) == 0) stop("No data left after filtering")

  stats <- aggregate(
    co2 ~ country,
    df,
    function(x) c(mean = mean(x), median = median(x), sd = sd(x))
  )

  out <- data.frame(
    country = stats$country,
    mean_co2 = stats$co2[, "mean"],
    median_co2 = stats$co2[, "median"],
    sd_co2 = stats$co2[, "sd"]
  )

  return(out)
}
