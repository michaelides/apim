#' =============================================================================
#' Distinguishable Dyads: Multilevel SEM Moderator Approach
#' Workshop: Dyadic Data Analysis Using R (EAOHP 2026)
#' =============================================================================
#'
#' This script mirrors the multilevel moderator approach from Script 04 but
#' implements it as a two-level SEM in lavaan. Gender moderates actor and
#' partner pathways at the within-dyad level, analogous to:
#'   lmer(satisfaction ~ wnc*gender + partner_wnc*gender + ... + (1|dyad_id))
#'
#' Two-level SEM decomposes variance into within-dyad (individual) and
#' between-dyad (shared) components, while testing gender interactions
#' at the within level.
#'
#' Prerequisites: Run 01_simulate_data.R first to generate data/dyad_data.RData
#' Output: Console output with interaction effects, simple slopes, and LRT

# =============================================================================
# 1. Setup and Data Loading
# =============================================================================

library(lavaan)
library(dplyr)

load("../data/dyad_data.RData")

cat("Data loaded: ddl (long format)\n")
cat("Gender distribution:\n")
print(table(ddl$gender))
cat("\n")

# Create numeric gender indicator for interactions 
# Male = 1, Female = 2
ddl$gender_num <-as.numeric(ddl$gender)

# Create interaction terms manually
ddl$wnc_x_gender <- ddl$wnc * ddl$gender_num
ddl$partner_wnc_x_gender <- ddl$partner_wnc * ddl$gender_num

# =============================================================================
# 2. Baseline: Two-Level SEM Without Gender Moderation
# =============================================================================


# This model decomposes APIM effects into within-dyad and 
# between-dyad components, pooling slopes across gender.
# Following the script 03 model_b convention: has_children and 
# dual_earner have no within-dyad variance (same value for actor
# and partner) so they are specified at the between level only.
# The only difference from model_b in script 03 is that we are now naming 
# the model parameters

model_base <- '
  level: within
    satisfaction ~ a_w*wnc + p_w*partner_wnc + ar_w*recovery +
      pr_w*partner_recovery

  level: between
    satisfaction ~ c_child*has_children + c_dual*dual_earner
'

fit_base <- sem(model_base, data = ddl, cluster = "dyad_id")

summary(fit_base, standardized = TRUE, fit.measures = TRUE)

# =============================================================================
# 3. Full APIM Moderator: Two-Level SEM with Gender Interactions
# =============================================================================


# Gender interactions are specified at the within-dyad level,
# mirroring the lme4 moderator model from Script 04.
# Between-level paths include only the between-dyad covariates 
# has_children, dual_earner), following the script 03 model_b 
# convention. 

model_moderator <- '
  level: within
    satisfaction ~ gender_num + a_w*wnc + p_w*partner_wnc + ar_w*recovery +
      pr_w*partner_recovery +
      g_w*gender_num +
      aw_int*wnc_x_gender + pw_int*partner_wnc_x_gender

  level: between
    satisfaction ~ c_child*has_children + c_dual*dual_earner
'

fit_moderator <- sem(model_moderator, data = ddl, cluster = "dyad_id")

summary(fit_moderator, standardized = TRUE, fit.measures = TRUE)


model_moderator <- '
  level: within
    satisfaction ~ a_w*wnc + p_w*partner_wnc + ar_w*recovery +
      pr_w*partner_recovery +
      g_w*gender_num +
      aw_int*wnc_x_gender + pw_int*partner_wnc_x_gender

  level: between
    satisfaction ~ c_child*has_children + c_dual*dual_earner

  # ── Simple slopes  ──────────────────────────────
  # Substitute the numeric values for your gender_num coding:
  #   dummy coding  → 1 / 2 must match your actual coding of the gender variable

  # Own WNC → satisfaction, by gender
  ss_wnc_M  := a_w + aw_int * 1   # gender_num = 1 - Male 
  ss_wnc_F  := a_w + aw_int * 2   # gender_num = 2 - Female 

  # Partner WNC → satisfaction, by gender
  ss_pwnc_M := p_w + pw_int * 1   # gender_num = 1
  ss_pwnc_F := p_w + pw_int * 2   # gender_num = 2
'

fit_moderator <- sem(model_moderator, data = ddl, cluster = "dyad_id")
summary(fit_moderator, standardized = TRUE, fit.measures = TRUE)


# - Two-level SEM mirrors the lme4 moderator approach (Script 04) 
# - Gender interactions specified at the within-dyad level 
# - Between-dyad effects capture shared dyad-level variation 
# - Models are saturated and therefore Chi-square difference test not possible 
# - Next: Wide-format SEM for distinguishable dyads (Script 06)
