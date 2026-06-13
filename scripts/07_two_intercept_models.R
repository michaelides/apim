#' =============================================================================
#' Two-Intercept Models: MLM and SEM
#' Workshop: Dyadic Data Analysis Using R (EAOHP 2026)
#' =============================================================================
#'
#' The two-intercept model suppresses the global intercept to directly estimate
#' separate intercepts for each group (males and females). This avoids
#' setting an arbitrary reference group.
#'
#' Three nested models are compared:
#'   Model 1: Equal intercepts, equal slopes (most constrained)
#'   Model 2: Different intercepts, equal slopes (recommended baseline)
#'   Model 3: Different intercepts, different slopes (full model)
#'
#' Prerequisites: Run 01_simulate_data.R first to generate data/dyad_data.RData
#' Output: Console output with two-intercept estimates and LRT comparisons

# =============================================================================
# 1. Setup and Data Loading
# =============================================================================

library(lme4)
library(lmerTest)
library(lavaan)
library(dplyr)

load("../data/dyad_data.RData")

cat("Data loaded: ddl (long) and ddw (wide)\n\n")

# =============================================================================
# 2. MLM Two-Intercept Models
# =============================================================================

# --- Model 1: Equal intercepts, equal slopes (most constrained) ---
cat("\n--- Model 1: Equal Intercepts, Equal Slopes ---\n\n")

model1_mlm <- lmer(
  satisfaction ~ wnc + partner_wnc + recovery + partner_recovery +
    has_children + dual_earner +
    (1 | dyad_id),
  data = ddl
)

summary(model1_mlm)



# --- Model 2: Different intercepts, equal slopes (recommended baseline) ---
cat("\n--- Model 2: Different Intercepts, Equal Slopes ---\n\n")

model2_mlm <- lmer(
  satisfaction ~ 0 + gender + wnc + partner_wnc +
    recovery + partner_recovery +
    has_children + dual_earner +
    (1| dyad_id),
  data = ddl
)

summary(model2_mlm)

# --- Model 3: Different intercepts, different slopes (full model) ---
cat("--- Model 3: Different Intercepts, Different Slopes ---\n\n")

model3_mlm <- lmer(
  satisfaction ~ 0 + gender + gender:wnc + gender:partner_wnc +
    gender:recovery + gender:partner_recovery +
    has_children + dual_earner +
    (1| dyad_id),
  data = ddl
)

summary(model3_mlm)


# MLM Likelihood Ratio Tests
# If p > 0.05: fail to reject H0 (intercepts do not differ by gender); if p < 0.05: reject H0

cat("Test A: Model 1 vs Model 2 (Equal vs Different Intercepts)\n")
anova(model1_mlm, model2_mlm)

cat("\nTest B: Model 2 vs Model 3 (Equal vs Different Slopes)\n")
anova(model2_mlm, model3_mlm)


# =============================================================================
# 3. SEM Two-Intercept Model (Wide Format)
# =============================================================================

# This is no difference from what we already tested using the wide specification.
# i.e. a Distinguishable dyad SEM in wide format is already using two intercepts: 
# one for actor and one for partner satisfaction

model_sem_2int <- '
  # Male paths (Person A)
  satisfaction_a ~ a*wnc_a + p*wnc_p + ar*recovery_a +
    pr*recovery_p + c*has_children + d*dual_earner

  # Female paths (Person P) — slopes constrained equal
  satisfaction_p ~ a*wnc_p + p*wnc_a + ar*recovery_p +
    pr*recovery_a + c*has_children + d*dual_earner

  # Separate intercepts (two-intercept model)
  satisfaction_a ~ int_m*1
  satisfaction_p ~ int_f*1

  # Residual variances
  satisfaction_a ~~ var_h*satisfaction_a
  satisfaction_p ~~ var_w*satisfaction_p

  # Predictor variances and covariances
  wnc_a ~~ wnc_p
  recovery_a ~~ recovery_p

  # Residual covariance
  satisfaction_a ~~ res_cov*satisfaction_p
'

fit_sem_2int <- sem(model_sem_2int, data = ddw)

summary(fit_sem_2int, standardized = TRUE, fit.measures = TRUE)


# =============================================================================
# 4. SEM Two-Intercept Model (Long Format)
# =============================================================================

# Does not really exist as the 0 + gender trick does not work in lavaan
# The alternative would be to create gender specific variables in the long format 



# - MLM Two-intercept models directly estimate group means 
# - No arbitrary reference group needed 
# - Two intercept approach is for MLM  
# - Wide format SEM models are essentially two intercept models
# - It is not easy to specify MLM SEM two intercept models with lavaan 
# - Next: Moderated APIM (Script 08)
