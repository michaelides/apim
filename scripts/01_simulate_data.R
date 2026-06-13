#' =============================================================================
#' Simulate Dyad Data for APIM Workshop
#' Workshop: Dyadic Data Analysis Using R
#' Author: George Michaelides
#' =============================================================================
#'
#' This script generates synthetic data for BOTH the indistinguishable and
#' distinguishable sections of the workshop. The data simulate dual-earner
#' heterosexual couples where:
#' - Males and females can be distinguished by gender
#' - The slopes are similar across gender, but MEANS differ slightly
#' - This makes indistinguishability an empirical question, not a data property
#'
#' Research Scenario (inspired by Hahn, Binnewies, & Dormann, 2014, JVB):
#' We study dual-earner couples to understand how work-nonwork conflict (WNC)
#' and recovery from work predict each partner's relationship satisfaction.
#' The presence of children in the household may moderate partner crossover
#' effects (Hahn et al., 2014, JVB).
#'
#' Data Structure:
#' - N = 100 dyads (200 individuals)
#' - Person-level predictors: WNC, recovery
#' - Dyad-level covariates: has_children, dual_earner
#' - Person-level outcome: relationship satisfaction
#' - Distinguishing variable: gender (male vs. female)
#' - Wide format uses _a/_p naming (_actor, _partner):
#' actor and partner are arbitrarily labeled members of
#' each dyad. For indistinguishable analysis, the labeling
#' is irrelevant due to equality constraints. For
#' distinguishable analysis, scripts rename these to
#' male/female labels.
#'
#' True Data-Generating Parameters (EQUAL across gender):
#' Actor WNC effect: a_wnc = -0.30
#' Partner WNC effect: p_wnc = -0.15
#' Actor Recovery effect: a_rec = 0.25
#' Partner Recovery effect: p_rec = 0.10
#' Children effect: c_child = -0.10
#' Dual-earner effect: c_dual = 0.20
#' Children x Partner WNC: int_child_pwnc = 0.10
#' Male intercept: alpha_m = 5.00
#' Female intercept: alpha_f = 4.85
#'
#' Key Design Decisions:
#' - Equal slopes across gender (indistinguishability holds for effects)
#' - Different intercepts by gender (males ~0.15 higher satisfaction)
#' - Slightly different WNC means (males ~0.3 SD higher)
#' - Within-dyad correlations: WNC (0.4), Recovery (0.35), Satisfaction residuals (0.3)
#' - Recovery negatively influenced by own WNC
#' - Children moderate partner WNC effect (Hahn et al. finding)
#'
#' Prerequisites: None
#' Output: ../data/dyad_data.RData

# =============================================================================
# 1. Setup
# =============================================================================

rm(list = ls())

set.seed(2026)

N <- 100

a_wnc <- -0.30
p_wnc <- -0.15
a_rec <- 0.25
p_rec <- 0.10
c_child <- -0.10
c_dual <- 0.20
int_child_pwnc <- 0.10
alpha_m <- 5.00
alpha_f <- 4.85
rho_wnc <- 0.40
rho_rec <- 0.35
rho_sat <- 0.30

correlate_errors <- function(rho, x, n = length(x), sd = 1) {
  e_raw <- rnorm(n, 0, sd)
  rho * x + sqrt(1 - rho^2) * e_raw
}


# =============================================================================
# 2. Generate Dyad-Level Covariates
# =============================================================================

has_children <- rbinom(N, 1, 0.4)
dual_earner <- rbinom(N, 1, 0.6)

# Check proportions: expect ~0.4 for children, ~0.6 for dual-earner
prop.table(table(has_children))
prop.table(table(dual_earner))

# =============================================================================
# 3. Generate Person-Level Predictors (WNC)
# =============================================================================
#
# WNC is influenced by has_children and dual_earner.
# Males have slightly higher mean WNC (stress contagion literature).
# Within-dyad correlation (rho_wnc = 0.4) via Cholesky decomposition.
# Use summary() to check means and SDs; use cor() for within-dyad correlation.
# A paired t-test checks whether male and female WNC means differ
# (they should, since males have +0.15 offset).

mu_wnc_m <- 0.5 * has_children - 0.3 * dual_earner + 0.15
mu_wnc_f <- 0.5 * has_children - 0.3 * dual_earner - 0.15

z1_wnc <- rnorm(N, 0, 1)

male_wnc <- mu_wnc_m + z1_wnc
female_wnc <- mu_wnc_f + correlate_errors(rho_wnc, z1_wnc)

summary(male_wnc)
summary(female_wnc)
cor(male_wnc, female_wnc)
t.test(male_wnc, female_wnc, paired = TRUE)

# =============================================================================
# 4. Generate Person-Level Predictors (Recovery)
# =============================================================================
#
# Recovery is negatively influenced by own WNC (stress impairs recovery)
# and positively influenced by dual_earner status.
# Within-dyad correlation (rho_rec = 0.35) via correlated residuals.
# Use summary() and cor() to verify distributions and correlations.
# WNC-Recovery correlations should be negative (higher WNC → lower recovery).

e_rec_m <- rnorm(N, 0, 0.8)
e_rec_f <- correlate_errors(rho_rec, e_rec_m, sd = 0.8)

male_recovery <- 3 - 0.3 * male_wnc + 0.2 * dual_earner + e_rec_m
female_recovery <- 3 - 0.3 * female_wnc + 0.2 * dual_earner + e_rec_f

summary(male_recovery)
summary(female_recovery)
cor(male_recovery, female_recovery)
cor(male_wnc, male_recovery)
cor(female_wnc, female_recovery)

# =============================================================================
# 5. Generate Person-Level Outcome (Satisfaction) — APIM DGP
# =============================================================================
#
# APIM structure: equal slopes across gender, different intercepts.
# Includes children x partner WNC interaction for the moderation model.
# Correlated residuals within dyads (rho_sat = 0.3).
# Use summary() and cor() to check distributions.
# A paired t-test checks whether male and female satisfaction means differ
# (males should be ~0.15 higher on average).

e_sat_m <- rnorm(N, 0, 0.5)
e_sat_f <- correlate_errors(rho_sat, e_sat_m, sd = 0.5)

male_satisfaction <- alpha_m +
  a_wnc * male_wnc + p_wnc * female_wnc +
  a_rec * male_recovery + p_rec * female_recovery +
  c_child * has_children + c_dual * dual_earner +
  int_child_pwnc * has_children * female_wnc +
  e_sat_m

female_satisfaction <- alpha_f +
  a_wnc * female_wnc + p_wnc * male_wnc +
  a_rec * female_recovery + p_rec * male_recovery +
  c_child * has_children + c_dual * dual_earner +
  int_child_pwnc * has_children * male_wnc +
  e_sat_f

summary(male_satisfaction)
summary(female_satisfaction)
cor(male_satisfaction, female_satisfaction)
t.test(male_satisfaction, female_satisfaction, paired = TRUE)

# =============================================================================
# 6. Assemble Long Format Data (each person = one row)
# =============================================================================

library(dplyr)

# ddl = dyad data long (each person = one row)
ddl <- data.frame(
  dyad_id = rep(1:N, each = 2),
  person_id = rep(1:2, N),
  gender = rep(c("male", "female"), N),
  wnc = c(rbind(male_wnc, female_wnc)),
  recovery = c(rbind(male_recovery, female_recovery)),
  satisfaction = c(rbind(male_satisfaction, female_satisfaction)),
  has_children = rep(has_children, each = 2),
  dual_earner = rep(dual_earner, each = 2)
)

ddl <- ddl %>%
  arrange(dyad_id, person_id) %>%
  group_by(dyad_id) %>%
  mutate(
    partner_wnc = wnc[3 - person_id],
    partner_recovery = recovery[3 - person_id]
  ) %>%
  ungroup()

ddl$gender <- factor(ddl$gender, levels = c("male", "female"))

cat("\nLong format data dimensions:", dim(ddl), "\n")
cat("Variables:", paste(names(ddl), collapse = ", "), "\n")

# =============================================================================
# 7. Assemble Wide Format Data (each dyad = one row)
# =============================================================================

# ddw = dyad data wide (each dyad = one row)
ddw <- data.frame(
  dyad_id = 1:N,
  wnc_a = male_wnc,
  wnc_p = female_wnc,
  recovery_a = male_recovery,
  recovery_p = female_recovery,
  satisfaction_a = male_satisfaction,
  satisfaction_p = female_satisfaction,
  has_children = has_children,
  dual_earner = dual_earner
)
ddw <- tibble(ddw)
cat("Wide format data dimensions:", dim(ddw), "\n")

# =============================================================================
# 8. Save Data
# =============================================================================

save(ddl, ddw, file = "../data/dyad_data.RData")
# Data saved to '../data/dyad_data.RData'
# Load in later scripts with: load('../data/dyad_data.RData')
# This dataset is used by BOTH the indistinguishable and
# distinguishable sections of the workshop.
# NOTE: For the distinguishable dyads section, scripts rename
# _a/_p columns to male_/female_ columns using dplyr::rename().
# This makes the models more interpretable for distinguishable dyads.
