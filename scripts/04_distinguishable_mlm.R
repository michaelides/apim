#' =============================================================================
#' Distinguishable Dyads: Multilevel Moderator Approach
#' Workshop: Dyadic Data Analysis Using R (EAOHP 2026)
#' =============================================================================
#'
#' This script estimates the APIM for distinguishable dyads using the
#' moderator approach in multilevel modeling (lme4). Gender moderates
#' actor and partner pathways.
#'
#' Version B (Full APIM Moderator): Properly decomposes actor and partner
#' pathways with gender interactions.
#'
#' Prerequisites: Run 01_simulate_data.R first to generate data/dyad_data.RData
#' Output: Console output with interaction effects and simple slopes

# =============================================================================
# 1. Setup and Data Loading
# =============================================================================

library(lme4)
library(lmerTest)
library(dplyr)

load("data/dyad_data.RData")

cat("Data loaded: ddl (long format)\n")
cat("Gender distribution:\n")
print(table(ddl$gender))

# =============================================================================
# 2. Baseline: Indistinguishable Model (No Gender Effects)
# =============================================================================


model_base <- lmer(
  satisfaction ~ wnc + partner_wnc + recovery + partner_recovery +
    has_children + dual_earner + (1 | dyad_id),
  data = ddl
)

summary(model_base)

# =============================================================================
# 3. Full APIM Moderator Model (Version B — Decomposed)
# =============================================================================


cat("WARNING: Version A (simple moderator) conflates actor and partner\n")
cat("pathways. Always use Version B for proper decomposition.\n\n")

model_moderator <- lmer(
  satisfaction ~ wnc * gender + partner_wnc * gender +
    recovery + partner_recovery + has_children + dual_earner +
    (1 | dyad_id),
  data = ddl
)

summary(model_moderator)


cat("--- WNC Actor Effects ---\n")
sim_slopes(model_moderator, pred = wnc,
           modx = gender, johnson_neyman = FALSE)
cat("\n--- WNC Partner Effects ---\n")
sim_slopes(model_moderator, pred = partner_wnc,
           modx = gender, johnson_neyman = FALSE)



# =============================================================================
# 4. Likelihood Ratio Test: Moderator vs Constrained
# =============================================================================


cat("Comparing: Full moderator model vs Constrained (no interactions)\n\n")

lrt <- anova(model_base, model_moderator)
print(lrt)
# If p > 0.05: fail to reject H0 (gender does not moderate slopes); if p < 0.05: reject H0


ci <- confint(model_moderator, method = "profile") # or use Wald for faster estimation
print(round(ci, 4))


# - Version B properly decomposes actor and partner pathways 
# - Male is the reference group; female effects = reference + interaction 
# - LRT tests whether gender moderates any APIM pathway 
# - In our simulated data, slopes are equal (DGP has no gender moderation) 
# - Next: SEM approach for distinguishable dyads (Script 05)
