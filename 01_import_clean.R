# ============================================================
# Mixed Markets Pilot
# Script 01: Import and clean raw data
#
# Purpose:
# Import the three tables from the Excel workbook and clean
# variable names for use in R.
# ============================================================

library(tidyverse)
library(readxl)
library(janitor)

# Path to raw workbook
file_path <- "data/raw/mixed-markets-pilot-database_UPDATED.xlsx"

# Import tables
decisions <- read_excel(
  file_path,
  sheet = "DECISIONS"
) |>
  clean_names()

parties <- read_excel(
  file_path,
  sheet = "PARTIES"
) |>
  clean_names()

ownership <- read_excel(
  file_path,
  sheet = "OWNERSHIP"
) |>
  clean_names()

# Basic checks
cat("\nImport complete.\n")
cat("Decisions:", nrow(decisions), "rows\n")
cat("Parties:", nrow(parties), "rows\n")
cat("Ownership:", nrow(ownership), "rows\n")
