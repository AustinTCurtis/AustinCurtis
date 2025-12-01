#' Load the CO2 dataset included in the package
#'
#' @return A cleaned data frame with country, code, year, and CO2 emissions.
#' @export
load_co2_data <- function() {

  # Try loading the dataset; if it fails, stop with a helpful message
  tryCatch({
    data("co2_country", package = "co2Package", envir = environment())
  }, error = function(e) {
    stop("Could not load co2_country dataset. Ensure it exists in data/.")
  })

  df <- co2_country

  # Defensive checks
  required <- c("country", "code", "year", "co2")

  if (!all(required %in% names(df))) {
    stop("Dataset is missing one of the required variables: ",
         paste(required, collapse = ", "))
  }

  if (!is.numeric(df$year)) stop("'year' must be numeric")
  if (!is.numeric(df$co2)) stop("'co2' must be numeric")

  if (nrow(df) < 50) {
    warning("Dataset has fewer than 50 rows — unusual for CO2 data.")
  }

  return(df)
}
