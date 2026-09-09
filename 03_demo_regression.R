# ============================================================
# Mixed Markets Pilot
# Script 03: Simulated regression demonstration
#
# IMPORTANT:
# All observations generated in this script are synthetic.
#
# The purpose is solely to demonstrate the regression workflow
# envisaged for the proposed research. The results are NOT
# empirical findings concerning European Commission enforcement.
# ============================================================

library(tidyverse)

# Make simulation reproducible
set.seed(123)

# ------------------------------------------------------------
# 1. Generate synthetic merger dataset
# ------------------------------------------------------------

demo_data <- tibble(
  
  case_number = 1:200,
  
  state_owned = rbinom(
    200,
    size = 1,
    prob = 0.30
  ),
  
  transaction_size = rnorm(
    200,
    mean = 1000,
    sd = 400
  ),
  
  sector = sample(
    c(
      "Energy",
      "Transport",
      "Technology",
      "Consumer",
      "Other"
    ),
    200,
    replace = TRUE
  )
)

# Generate synthetic Phase II outcome
demo_data <- demo_data |>
  mutate(
    
    probability_phase_ii = plogis(
      -2 +
        0.6 * state_owned +
        0.0004 * transaction_size
    ),
    
    phase_ii = rbinom(
      n(),
      size = 1,
      prob = probability_phase_ii
    )
  )

# ------------------------------------------------------------
# 2. Model 1: State ownership only
# ------------------------------------------------------------

model_1 <- glm(
  phase_ii ~ state_owned,
  data = demo_data,
  family = binomial
)

# ------------------------------------------------------------
# 3. Model 2: Add transaction size and sector controls
# ------------------------------------------------------------

model_2 <- glm(
  phase_ii ~
    state_owned +
    transaction_size +
    sector,
  data = demo_data,
  family = binomial
)

# ------------------------------------------------------------
# 4. Display results
# ------------------------------------------------------------

cat("\nMODEL 1: STATE OWNERSHIP ONLY\n")
print(summary(model_1))

cat("\nMODEL 2: WITH TRANSACTION SIZE AND SECTOR CONTROLS\n")
print(summary(model_2))

cat(
  "\nIMPORTANT: These results are generated from synthetic data",
  "and have no substantive empirical interpretation.\n"
)
