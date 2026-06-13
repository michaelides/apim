#' =============================================================================
#' Indistinguishable Dyads: Structural Equation Modeling Approach
#' Workshop: Dyadic Data Analysis Using R (EAOHP 2026)
#' =============================================================================
#'
#' This script estimates the APIM for indistinguishable dyads using SEM (lavaan).
#' Three analytical paradigms are demonstrated:
#'   Model A: Cluster-robust SE (long format, quick alternative)
#'   Model B: Two-level SEM (within/between decomposition)
#'   Model C: Wide-format APIM with full equality constraints (primary)
#'
#' The indistinguishability test compares constrained vs unconstrained models.
#'
#' Prerequisites: Run 01_simulate_data.R first to generate data/dyad_data.RData
#' Output: Console output with fit indices, parameter estimates, and LRT

# =============================================================================
# 1. Setup and Data Loading
# =============================================================================

library(lavaan)
library(dplyr)

load("../data/dyad_data.RData")

cat("Wide format dimensions:", nrow(ddw), "rows,", ncol(ddw), "columns\n\n")
str(ddl)
head(ddl)

# =============================================================================
# 2. Model A: Cluster-Robust Standard Errors (Long Format)
# =============================================================================


model_a <- '
  satisfaction ~ wnc + partner_wnc + recovery + partner_recovery +
    has_children + dual_earner
'

fit_a <- sem(model_a, data = ddl, cluster = "dyad_id")

summary(fit_a, standardized = TRUE, fit.measures = TRUE)
 
# Compare the results from summary(apim_mlm)


# =============================================================================
# 3. Model B: Two-Level SEM 
# =============================================================================

# Note: Within-level effects capture individual variation.
# Between-level effects capture dyad-level shared variation.
# has_children and dual_earner do not have any within dyad variance (it is the same value for actor and partner)
# thus they are added to the between part of the model 

model_b <- '
  level: within
    satisfaction ~ wnc + partner_wnc + recovery + partner_recovery 
  level: between 
    satisfaction ~ has_children + dual_earner 
'

fit_b <- sem(model_b, data = ddl, cluster = "dyad_id")

summary(fit_b, standardized = TRUE, fit.measures = TRUE)

# Compare the results from summary(apim_mlm) and also with the SEM model A approach

# =============================================================================
# 4. Model C: Wide-Format APIM with Equality Constraints (Primary)
# =============================================================================


model_c_constrained <- '
  # Regression paths with equality constraints
  satisfaction_a ~ a_wnc*wnc_a + p_wnc*wnc_p + a_rec*recovery_a +
    p_rec*recovery_p + c_child*has_children + c_dual*dual_earner

  satisfaction_p ~ a_wnc*wnc_p + p_wnc*wnc_a + a_rec*recovery_p +
    p_rec*recovery_a + c_child*has_children + c_dual*dual_earner

  # Intercept equality
  satisfaction_a ~ alpha*1
  satisfaction_p ~ alpha*1

  # Residual variance equality
  satisfaction_a ~~ var_res*satisfaction_a
  satisfaction_p ~~ var_res*satisfaction_p

  # Predictor variances and covariances
  wnc_a ~~ wnc_p
  recovery_a ~~ recovery_p

  # Residual covariance
  satisfaction_a ~~ res_cov*satisfaction_p
'

fit_c_constrained <- sem(model_c_constrained, data = ddw)

cat("--- Model C (Constrained) Summary ---\n")
summary(fit_c_constrained, standardized = TRUE, fit.measures = TRUE)

# =============================================================================
# 5. Unconstrained Model (for Indistinguishability Test)
# =============================================================================

# An unconstrained model allows each parameter to be estimated separate for actors and partners
# .... this is essentially what distinguishable dyad models are for 
model_c_unconstrained <- '
  # Regression paths WITHOUT equality constraints
  # Person A
  satisfaction_a ~ a_h*wnc_a + p_h*wnc_p + ar_h*recovery_a +
    pr_h*recovery_p + c_h*has_children + d_h*dual_earner

  # Person P
  satisfaction_p ~ a_w*wnc_p + p_w*wnc_a + ar_w*recovery_p +
    pr_w*recovery_a + c_w*has_children + d_w*dual_earner

  # Free intercepts
  satisfaction_a ~ int_a*1
  satisfaction_p ~ int_p*1

  # Free residual variances
  satisfaction_a ~~ var_a*satisfaction_a
  satisfaction_p ~~ var_p*satisfaction_p

  # Predictor variances and covariances
  wnc_a ~~ wnc_p
  recovery_a ~~ recovery_p

  # Residual covariance
  satisfaction_a ~~ res_cov*satisfaction_p
'

fit_c_unconstrained <- sem(model_c_unconstrained, data = ddw)

summary(fit_c_unconstrained, standardized = TRUE, fit.measures = TRUE)

# Indistinguishability Test: Chi-Square Difference (LRT)
lrt <- lavTestLRT(fit_c_unconstrained, fit_c_constrained)
print(lrt)
# If p > 0.05: fail to reject H0 (members are indistinguishable); if p < 0.05: reject H0


# =============================================================================

# - Model A: Quick cluster-robust approach (long format)
# - Model B: Two-level decomposition (within/between)
# - Model C: Wide-format with full equality constraints (primary)
# - LRT tests whether indistinguishability holds empirically
# - With balanced data, MLM and SEM yield identical point estimates
# - SEM advantages: fit indices, FIML for missing data, latent variables
# - Next: Distinguishable dyads (Script 04)
