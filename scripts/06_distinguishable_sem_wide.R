#' =============================================================================
#' Distinguishable Dyads: SEM Wide Format
#' Workshop: Dyadic Data Analysis Using R (EAOHP 2026)
#' =============================================================================
#'
#' This script estimates the APIM for distinguishable dyads using SEM (lavaan)
#' in wide format. Separate paths are estimated for males and females.
#' Nested model comparisons test whether slopes can be constrained to equality.
#'
#' Prerequisites: Run 01_simulate_data.R first to generate data/dyad_data.RData
#' Output: Console output with unconstrained/constrained estimates and LRT

# =============================================================================
# 1. Setup and Data Loading
# =============================================================================

library(lavaan)
library(dplyr)

load("../data/dyad_data.RData")

cat("Data loaded: ddw (wide format)\n")
cat("Dimensions:", nrow(ddw), "dyads,", ncol(ddw), "variables\n\n")

# Actor = Male ; Partner = Female

# =============================================================================
# 2. Model 1: Unconstrained (All Paths Free to Vary by Gender)
# =============================================================================


model_unconstrained <- '
  # Actor/Male paths 
  satisfaction_a ~ a_h*wnc_a + p_h*wnc_p + ar_h*recovery_a +
    pr_h*recovery_p + c_h*has_children + d_h*dual_earner

  # Partner/Female paths 
  satisfaction_p ~ a_w*wnc_p + p_w*wnc_a + ar_w*recovery_p +
    pr_w*recovery_a + c_w*has_children + d_w*dual_earner

  # Intercepts
  satisfaction_a ~ int_a*1
  satisfaction_p ~ int_p*1

  # Residual variances
  satisfaction_a ~~ var_h*satisfaction_a
  satisfaction_p ~~ var_w*satisfaction_p

  # Predictor variances and covariances
  wnc_a ~~ wnc_p
  recovery_a ~~ recovery_p

  # Residual covariance
  satisfaction_a ~~ res_cov*satisfaction_p
'

fit_unconstrained <- sem(model_unconstrained, data = ddw)

summary(fit_unconstrained, standardized = TRUE, fit.measures = TRUE)

# =============================================================================
# 3. Model 2: Slopes Constrained Equal (Intercepts Free)
# =============================================================================


model_slopes_equal <- '
  # Actor/Male paths 
  satisfaction_a ~ a*wnc_a + p*wnc_p + ar*recovery_a +
    pr*recovery_p + c*has_children + d*dual_earner

  # Partner/Female paths 
  # same labels = constrained equal
  satisfaction_p ~ a*wnc_p + p*wnc_a + ar*recovery_p +
    pr*recovery_a + c*has_children + d*dual_earner

  # Intercepts FREE to vary
  satisfaction_a ~ int_a*1
  satisfaction_p ~ int_p*1

  # Residual variances
  satisfaction_a ~~ var_h*satisfaction_a
  satisfaction_p ~~ var_w*satisfaction_p

  # Predictor variances and covariances
  wnc_a ~~ wnc_p
  recovery_a ~~ recovery_p

  # Residual covariance
  satisfaction_a ~~ res_cov*satisfaction_p
'

fit_slopes_equal <- sem(model_slopes_equal, data = ddw)

cat("--- Slopes Equal Model ---\n")
summary(fit_slopes_equal, standardized = TRUE, fit.measures = TRUE)

# =============================================================================
# 4. Model 3: Fully Constrained (Slopes + Intercepts Equal)
# =============================================================================


model_full_equal <- '
  # Actor/Male paths 
  satisfaction_a ~ a*wnc_a + p*wnc_p + ar*recovery_a +
    pr*recovery_p + c*has_children + d*dual_earner

  # Partner/Female paths  (same labels)
  satisfaction_p ~ a*wnc_p + p*wnc_a + ar*recovery_p +
    pr*recovery_a + c*has_children + d*dual_earner

  # Intercepts EQUAL
  satisfaction_a ~ alpha*1
  satisfaction_p ~ alpha*1

  # Residual variances EQUAL
  satisfaction_a ~~ var_res*satisfaction_a
  satisfaction_p ~~ var_res*satisfaction_p

  # Predictor variances and covariances
  wnc_a ~~ wnc_p
  recovery_a ~~ recovery_p

  # Residual covariance
  satisfaction_a ~~ res_cov*satisfaction_p
'

fit_full_equal <- sem(model_full_equal, data = ddw)

cat("--- Fully Constrained Model ---\n")
summary(fit_full_equal, standardized = TRUE, fit.measures = TRUE)

# =============================================================================
# 5. Chi-Square Difference Tests
# =============================================================================

# If p > 0.05: fail to reject H0 (slopes do not differ by gender); if p < 0.05: reject H0


cat("Test 1: Unconstrained vs Slopes Equal\n")
cat("(Do slopes differ by gender?)\n\n")
lrt1 <- lavTestLRT(fit_unconstrained, fit_slopes_equal)
print(lrt1)

cat("\nTest 2: Slopes Equal vs Fully Constrained\n")
cat("(Do intercepts differ by gender?)\n\n")
lrt2 <- lavTestLRT(fit_slopes_equal, fit_full_equal)
print(lrt2)

cat("\nTest 3: Unconstrained vs Fully Constrained\n")
cat("(Overall indistinguishability test)\n\n")
lrt3 <- lavTestLRT(fit_unconstrained, fit_full_equal)
print(lrt3)


#Fit Indices Comparison


fits <- c("chisq", "df", "pvalue", "cfi", "tli", "rmsea", "srmr")

fit_indices <- data.frame(unconstrained = fitMeasures(fit_unconstrained, fits),
                          slopes_equal = fitMeasures(fit_slopes_equal, fits),
                          full_equal = fitMeasures(fit_full_equal, fits)
)
round(fit_indices, 4)


# - Unconstrained: All paths free to vary by gender 
# - Slopes Equal: Slopes constrained, intercepts free 
# - Fully Constrained: All parameters equal (indistinguishable) 
# - Chi-square difference tests evaluate each constraint 
# - In our DGP: slopes are equal, intercepts differ slightly 
# - Next: Two-intercept models (Script 07)
