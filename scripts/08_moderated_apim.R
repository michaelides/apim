#' =============================================================================
#' Moderated APIM: Replicating Hahn, Binnewies, & Dormann (2014)
#' Workshop: Dyadic Data Analysis Using R (EAOHP 2026)
#' =============================================================================
#'
#' This script replicates the theoretical model of Hahn, Binnewies, & Dormann
#' (2014, JVB) examining whether dyad-level moderators (has_children) alter
#' standard APIM pathways, specifically the partner crossover effect.
#'
#' Both MLM and SEM frameworks are demonstrated.
#'
#' Prerequisites: Run 01_simulate_data.R first to generate data/dyad_data.RData
#' Output: Console output with moderation effects, simple slopes, and plots

# =============================================================================
# 1. Setup and Data Loading
# =============================================================================

library(lme4)
library(lmerTest)
library(lavaan)
library(dplyr)
library(interactions)

load("../data/dyad_data.RData")

cat("Data loaded: ddl (long) and ddw (wide)\n")
cat("Children distribution:\n")
print(table(ddl$has_children))
cat("Proportion with children:", mean(ddl$has_children), "\n\n")

# =============================================================================
# 2. MLM: Moderated APIM
# =============================================================================


cat("Research Question: Does the presence of children moderate the\n")
cat("partner crossover effect (Partner WNC -> Own Satisfaction)?\n\n")

cat("Theoretical Mechanism: Partner crossover represents stress\n")
cat("transmission. Joint domestic demands (child-rearing) may alter\n")
cat("these crossover pathways.\n\n")

# --- Base model (no moderation) ---
model_base <- lmer(
  satisfaction ~ wnc + partner_wnc + recovery + partner_recovery +
    has_children + dual_earner + (1 | dyad_id),
  data = ddl
)

# --- Moderated model ---
model_mod <- lmer(
  satisfaction ~ wnc + partner_wnc + recovery + partner_recovery +
    has_children + dual_earner +
    partner_wnc:has_children + wnc:has_children +
    (1 | dyad_id),
  data = ddl
)

cat("--- Base Model (No Moderation) ---\n")
summary(model_base)

cat("\n--- Moderated Model ---\n")
summary(model_mod)


lrt <- anova(model_base, model_mod)
print(lrt)
# If p > 0.05: fail to reject H0 (interaction terms not needed); if p < 0.05: reject H0

# =============================================================================
# 3. Simple Slopes with interactions Package
# =============================================================================


cat("\n--- Actor WNC x Children ---\n")
sim_awnc <- sim_slopes(model_mod, pred = wnc,
                       modx = has_children, johnson_neyman = FALSE)

interact_plot(model_mod, pred = wnc,
    modx = has_children, plot.points = TRUE)

print(sim_awnc)


cat("--- Partner WNC x Children ---\n")
sim_pwnc <- sim_slopes(model_mod, pred = partner_wnc,
                        modx = has_children, johnson_neyman = FALSE)
print(sim_pwnc)
interact_plot(model_mod, pred = partner_wnc,
              modx = has_children, plot.points = TRUE)




# =============================================================================
# 4. SEM: Moderated APIM (Wide Format)
# =============================================================================


ddw$wnc_a_children <- ddw$wnc_a * ddw$has_children
ddw$wnc_p_children <- ddw$wnc_p * ddw$has_children

model_sem_mod <- '
  # Actor (male)
  satisfaction_a ~ a*wnc_a + p*wnc_p + ar*recovery_a + pr*recovery_p +
    c*has_children + d*dual_earner +
    a_int*wnc_a_children + p_int*wnc_p_children

  # Partner (female)
  satisfaction_p ~ a*wnc_p + p*wnc_a + ar*recovery_p + pr*recovery_a +
    c*has_children + d*dual_earner +
    a_int*wnc_p_children + p_int*wnc_a_children

  # Intercepts
  satisfaction_a ~ int*1
  satisfaction_p ~ int*1

  # Residual variances
  satisfaction_a ~~ var*satisfaction_a
  satisfaction_p ~~ var*satisfaction_p

  # Predictor variances and covariances
  wnc_a ~~ wnc_p
  recovery_a ~~ recovery_p

  # Residual covariance
  satisfaction_a ~~ res_cov*satisfaction_p
  
  # --------------------------------------------------------
  # SIMPLE SLOPES (Calculated Parameters)
  # --------------------------------------------------------
  
  # 1. Actor Effects (wnc on own satisfaction)
  actor_slope_no_child   := a + a_int * 0
  actor_slope_has_child  := a + a_int * 1

  # 2. Partner Effects (wnc on partner satisfaction)
  partner_slope_no_child  := p + p_int * 0
  partner_slope_has_child := p + p_int * 1
  
'

fit_sem_mod <- sem(model_sem_mod, data = ddw)
summary(fit_sem_mod, standardized = TRUE, fit.measures = TRUE)

# Compare MLM and SEM Moderation Estimates 
# Which approach do you prefer? Why?



# - Hahn et al. (2014): Children buffer the partner crossover effect 
# - Both MLM and SEM can accommodate dyad-level moderators 
# - MLM: Direct interaction terms in lmer 
# - SEM: Manual product indicators in lavaan 
# - Simple slopes analysis reveals conditional effects 
# - In our DGP: partner_wnc x children = 0.10 (buffering) 
# - This completes the workshop script series!
