# data-raw/co2_country.R
# This script reads the original CO2 CSV and saves a cleaned dataset into the package as co2_country.

# Path to unzipped CSV:
raw_path <- "C:/Users/austi/OneDrive - University of South Florida/Documents/Curtis/data-raw/annual-co2-emissions-per-country/annual-co2-emissions-per-country.csv"

if (!file.exists(raw_path)) {
  stop("CSV file not found at: ", raw_path,
       ". Update raw_path in data-raw/co2_country.R.")
}

co2_raw <- tryCatch(
  read.csv(raw_path),
  error = function(e) stop("Failed to read CO2 CSV: ", e$message)
)

# Rename columns to standardized names used in package
names(co2_raw)[names(co2_raw) == "Entity"]               <- "country"
names(co2_raw)[names(co2_raw) == "Code"]                 <- "code"
names(co2_raw)[names(co2_raw) == "Year"]                 <- "year"
names(co2_raw)[names(co2_raw) == "Annual.CO..emissions"] <- "co2"

# Basic structure check AFTER renaming
required_cols <- c("country", "year", "co2")
missing_cols <- setdiff(required_cols, names(co2_raw))

if (length(missing_cols) > 0) {
  stop("Expected columns not found after renaming: ",
       paste(missing_cols, collapse = ", "))
}

# keep only the columns you need
keep_cols <- intersect(c("country", "code", "year", "co2"), names(co2_raw))
co2_country <- co2_raw[ , keep_cols]

# filter out bad rows (e.g., NA co2, or year before 1900)
co2_country <- subset(co2_country, !is.na(co2) & year >= 1900)

# Save the cleaned dataset into data/co2_country.rda
usethis::use_data(co2_country, overwrite = TRUE)
