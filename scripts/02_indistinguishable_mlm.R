#' =============================================================================
#' Indistinguishable Dyads: Multilevel Modeling Approach
#' Workshop: Dyadic Data Analysis Using R (EAOHP 2026)
#' =============================================================================
#'
#' This script estimates the basic APIM for indistinguishable dyads using
#' multilevel modeling (lme4). Data are in long format (one row per person,
#' two rows per dyad). Slopes are pooled symmetrically across dyad members.
#'
#' Prerequisites: Run 01_simulate_data.R first to generate data/dyad_data.RData
#' Output: Console output with ICC, model summaries, and effect estimates

# =============================================================================
# 1. Setup and Data Loading
# =============================================================================
library(lme4)
library(lmerTest)
library(dplyr)

rm(list = ls())
load("../data/dyad_data.RData")

cat("Long format dimensions:", nrow(ddl), "rows,", ncol(ddl), "columns\n\n")
str(ddl)
head(ddl)

# =============================================================================
# 2. Step 1: Intercept-Only (Null) Model — Compute ICC
# =============================================================================

icc <- function(model, grp_id = "dyad_id") {
  var_components <- as.data.frame(lme4::VarCorr(model))
  var_between  <- var_components$vcov[var_components$grp == grp_id]
  var_residual <- var_components$vcov[var_components$grp == "Residual"]
  
  if (length(var_between) == 0) {
    stop(paste("Grouping factor '", grp_id, "' not found in the model components.", sep = ""))
  }
  
  icc_val <- var_between / (var_between + var_residual)
  
  cat("\n--- Intra-class Correlation (ICC) ---\n")
  cat("Between-group variance (", grp_id, "): ", round(var_between, 4), "\n", sep = "")
  cat("Residual variance:", round(var_residual, 4), "\n")
  cat("ICC:", round(icc_val, 4), "\n")
  cat("Interpretation:", round(icc_val * 100, 1), "% of variance\n")
  cat("is shared within groups (non-independence).\n\n")
  cat("Note: An ICC > 0 justifies multilevel modeling.\n")
  
  return(invisible(icc_val))
}

null_model <- lmer(satisfaction ~ 1 + (1 | dyad_id), data = ddl)
summary(null_model)
icc(null_model)

# =============================================================================
# 3. Step 2: Full Multilevel APIM Model
# =============================================================================


apim_mlm <- lmer(
  satisfaction ~ wnc + partner_wnc + recovery + partner_recovery +
    has_children + dual_earner + (1 | dyad_id),
  data = ddl
)

summary(apim_mlm)


# =============================================================================
# 4. Model Comparison: With vs Without Partner Effects
# =============================================================================


actor_only <- lmer(
  satisfaction ~ wnc + recovery + has_children + dual_earner + (1 | dyad_id),
  data = ddl
)

cat("Likelihood Ratio Test:\n")
anova_result <- anova(actor_only, apim_mlm)
print(anova_result)

# If p > 0.05: fail to reject H0 (partner effects not needed); if p < 0.05: reject H0

# =============================================================================
# 6. Confidence Intervals
# =============================================================================

# Wald is a faster alternative but profile is better
# ci <- confint(apim_mlm, method = "Wald") 
ci <- confint(apim_mlm, method = "profile")
print(round(ci, 4))

# =============================================================================
# - ICC confirms non-independence within dyads 
# - Actor effects: own WNC and recovery predict own satisfaction 
# - Partner effects: partner's WNC and recovery predict own satisfaction 
# - In indistinguishable models, slopes are pooled across gender
# - Next: Compare with SEM approach (Script 03) 
