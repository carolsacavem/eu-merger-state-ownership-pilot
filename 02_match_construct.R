# ============================================================
# Mixed Markets Pilot
# Script 02: Match and construct analysis dataset
#
# Purpose:
# Link merger decisions to parties and ownership observations,
# construct alternative State-ownership measures, and create
# one analysis-ready observation per merger case.
#
# This is a methodological pilot and is not suitable for
# substantive statistical inference.
# ============================================================

library(tidyverse)

# Check that Script 01 has been run
stopifnot(
  exists("decisions"),
  exists("parties"),
  exists("ownership")
)

# ------------------------------------------------------------
# 1. Attach decision information to each merger party
# ------------------------------------------------------------

case_parties <- parties |>
  left_join(
    decisions |>
      select(
        case_id,
        case_name,
        ownership_reference_year,
        phase,
        remedies,
        review_duration_days
      ),
    by = "case_id"
  )

# ------------------------------------------------------------
# 2. Prepare ownership table for matching
# ------------------------------------------------------------

ownership_lookup <- ownership |>
  select(
    -standardised_company_name
  )

# Match using company identifier AND relevant year
case_parties <- case_parties |>
  left_join(
    ownership_lookup,
    by = c(
      "party_id",
      "ownership_reference_year" = "year"
    )
  )

# ------------------------------------------------------------
# 3. Construct alternative ownership measures
# ------------------------------------------------------------

case_parties <- case_parties |>
  mutate(
    
    any_state_ownership = case_when(
      total_state_ownership_share_pct > 0 ~ 1,
      total_state_ownership_share_pct == 0 ~ 0,
      TRUE ~ NA_real_
    ),
    
    majority_state_ownership = case_when(
      total_state_ownership_share_pct >= 50 ~ 1,
      total_state_ownership_share_pct < 50 ~ 0,
      TRUE ~ NA_real_
    ),
    
    full_state_ownership = case_when(
      total_state_ownership_share_pct == 100 ~ 1,
      total_state_ownership_share_pct < 100 ~ 0,
      TRUE ~ NA_real_
    ),
    
    actual_state_control = case_when(
      state_control == "yes" ~ 1,
      state_control == "no" ~ 0,
      state_control == "not_applicable" ~ 0,
      TRUE ~ NA_real_
    )
  )

# ------------------------------------------------------------
# 4. Aggregate from party level to merger-case level
# ------------------------------------------------------------

case_ownership <- case_parties |>
  group_by(case_id) |>
  summarise(
    
    any_state_party = case_when(
      any(any_state_ownership == 1, na.rm = TRUE) ~ 1,
      all(any_state_ownership == 0, na.rm = TRUE) &
        !any(is.na(any_state_ownership)) ~ 0,
      TRUE ~ NA_real_
    ),
    
    any_majority_state_party = case_when(
      any(majority_state_ownership == 1, na.rm = TRUE) ~ 1,
      all(majority_state_ownership == 0, na.rm = TRUE) &
        !any(is.na(majority_state_ownership)) ~ 0,
      TRUE ~ NA_real_
    ),
    
    any_state_controlled_party = case_when(
      any(actual_state_control == 1, na.rm = TRUE) ~ 1,
      all(actual_state_control == 0, na.rm = TRUE) &
        !any(is.na(actual_state_control)) ~ 0,
      TRUE ~ NA_real_
    ),
    
    .groups = "drop"
  )

# ------------------------------------------------------------
# 5. Create case-level real pilot dataset
# ------------------------------------------------------------

analysis_real <- decisions |>
  left_join(
    case_ownership,
    by = "case_id"
  ) |>
  mutate(
    
    phase_ii_binary = case_when(
      phase == "II" ~ 1,
      phase == "I" ~ 0,
      TRUE ~ NA_real_
    ),
    
    remedies_binary = case_when(
      remedies == "yes" ~ 1,
      remedies == "no" ~ 0,
      TRUE ~ NA_real_
    )
  )

# ------------------------------------------------------------
# 6. Save processed dataset
# ------------------------------------------------------------

dir.create(
  "data/processed",
  showWarnings = FALSE,
  recursive = TRUE
)

write_csv(
  analysis_real,
  "data/processed/merger_analysis_real.csv"
)

# ------------------------------------------------------------
# 7. Basic checks
# ------------------------------------------------------------

cat("\nReal pilot dataset created.\n")
cat("Merger cases:", nrow(analysis_real), "\n")

cat("\nPhase II outcome:\n")
print(
  analysis_real |>
    count(phase_ii_binary)
)

cat("\nRemedies outcome:\n")
print(
  analysis_real |>
    count(remedies_binary)
)

cat("\nState-ownership coding:\n")
print(
  case_ownership |>
    count(any_state_party)
)
