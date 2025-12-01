# Plot CO2 emissions over time

#' @param df The CO2 dataset
#' @param countries Vector of countries to plot

#' @return A ggplot line plot
#' @export
plot_co2_trend <- function(df, countries) {

  if (!is.data.frame(df)) stop("df must be a data frame")
  if (!all(c("country", "year", "co2") %in% names(df))) {
    stop("df must contain country, year, co2")
  }

  if (missing(countries)) {
    stop("You must provide a vector of countries")
  }

  missing <- setdiff(countries, unique(df$country))
  if (length(missing) > 0) {
    stop("Countries not found: ", paste(missing, collapse = ", "))
  }

  df <- df[df$country %in% countries, ]

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("ggplot2 is required; install it with install.packages('ggplot2')")
  }

  p <- ggplot2::ggplot(df, ggplot2::aes(year, co2, color = country)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = "CO2 Emissions Over Time",
      x = "Year",
      y = "Annual CO2 Emissions"
    )

  return(p)
}
