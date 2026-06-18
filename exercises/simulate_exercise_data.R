#' =============================================================================
#' Simulate Dyad Data for APIM Workshop (Crossover to Work Outcomes)
#' Workshop: Dyadic Data Analysis Using R
#' Author: George Michaelides
#' =============================================================================
#'
#' Generates synthetic dyadic data for the workshop exercises. The data
#' simulate dual-earner couples in which the work-related psychological
#' states of one partner (affect, SDT, job crafting) may crossover to
#' influence the other partner's work outcomes (engagement, performance,
#' creativity).
#'
#' Companion to scripts/01_simulate_data.R, which generates the tutorial
#' dataset (dyad_data.RData). The exercise dataset (exercise_data.RData)
#' produced by this script is independent of the tutorial dataset.
#'
#' Data Structure:
#' - N = 250 dyads (500 individuals)
#' - Person-level predictors: affect, sdt, job_crafting
#' - Person-level outcomes: engagement, performance, creativity
#' - Dyad-level moderators: live_together, years_together,
#'   time_spent_this_morning_together
#' - Distinguishing variable: gender (male vs. female)
#' - Wide format uses _a/_p naming (actor, partner)
#'
#' Per-section focal outcomes (see exercises/exercises.md for details):
#'   engagement  is the focal outcome for sections 2, 4, 6, and 8
#'   creativity  is the focal outcome for sections 3 and 7
#'   performance is the focal outcome for section 5
#'   section 9 lets the student pick
#'
#' True Data-Generating Parameters:
#'
#' Person-level predictor offsets (mean differences by gender):
#'   affect:    males +0.10, females -0.10
#'   sdt:       males -0.10, females +0.10
#'   jc:        no mean difference (driven by affect + sdt)
#'
#' Engagement (engagement ~ affect + sdt + jc + partner_* + moderators + interactions)
#'   intercept:                  alpha_em = 5.00, alpha_ef = 4.85
#'   actor affect:               0.20    partner affect:               0.10
#'   actor sdt:                  0.30    partner sdt:                  0.10
#'   actor jc:                   0.25    partner jc:                   0.05
#'   live_together effect:       0.20    years_together effect:        0.02
#'   time_spent effect:          0.005   partner_jc x live_together:   0.15
#'   actor_sdt x gender_male:    0.10  (distinguishable actor effect)
#'
#' Performance (performance ~ affect + sdt + jc + partner_* + moderators + interactions)
#'   intercept:                  alpha_pm = 5.10, alpha_pf = 5.00
#'   actor affect:               0.15    partner affect:               0.05
#'   actor sdt:                  0.35    partner sdt:                  0.15
#'   actor jc:                   0.30    partner jc:                   0.10
#'   live_together effect:       0.15    years_together effect:        0.03
#'   time_spent effect:          0.003   partner_sdt x years_together: 0.015
#'
#' Creativity (creativity ~ affect + sdt + jc + partner_* + moderators + interactions)
#'   intercept:                  alpha_cm = 4.80, alpha_cf = 4.95
#'   actor affect:               0.25    partner affect:               0.15
#'   actor sdt:                  0.20    partner sdt:                  0.05
#'   actor jc:                   0.20    partner jc:                   0.05
#'   live_together effect:       0.10    years_together effect:        0.01
#'   time_spent effect:          0.004   partner_affect x time_spent:  0.003
#'
#' Within-dyad residual correlations (rho):
#'   affect = 0.30, sdt = 0.30, jc = 0.30
#'   engagement = 0.25, performance = 0.25, creativity = 0.25
#'
#' Key Design Decisions:
#' - Intercepts differ by gender for all three outcomes (males higher on
#'   engagement and performance, females higher on creativity)
#' - Slopes are EQUAL across gender, EXCEPT for actor_sdt on engagement
#'   which is 0.10 stronger for males
#' - One focal crossover x moderator interaction per outcome:
#'     engagement:  partner_jc x live_together
#'     performance: partner_sdt x years_together
#'     creativity:  partner_affect x time_spent_this_morning_together
#' - Years_together and time_spent are NOT centered in the DGP, so
#'   the focal partner effect at moderator = 0 is interpretable, but
#'   students should mean-center for the simple-slopes analysis
#'
#' Prerequisites: None
#' Output: ../data/exercise_data.RData
#' Load in later exercises with: load('../data/exercise_data.RData')

# =============================================================================
# 1. Setup
# =============================================================================

rm(list = ls())

set.seed(2026)

N <- 250

# Engagement DGP
alpha_em <- 5.00
alpha_ef <- 4.85
a_affect_e <- 0.20
p_affect_e <- 0.10
a_sdt_e    <- 0.30
p_sdt_e    <- 0.10
a_jc_e     <- 0.25
p_jc_e     <- 0.05
c_lt_e     <- 0.20
c_yt_e     <- 0.02
c_tt_e     <- 0.005
int_pjc_lt <- 0.15
int_asdt_gm <- 0.10

# Performance DGP
alpha_pm <- 5.10
alpha_pf <- 5.00
a_affect_p <- 0.15
p_affect_p <- 0.05
a_sdt_p    <- 0.35
p_sdt_p    <- 0.15
a_jc_p     <- 0.30
p_jc_p     <- 0.10
c_lt_p     <- 0.15
c_yt_p     <- 0.03
c_tt_p     <- 0.003
int_psdt_yt <- 0.015

# Creativity DGP
alpha_cm <- 4.80
alpha_cf <- 4.95
a_affect_c <- 0.25
p_affect_c <- 0.15
a_sdt_c    <- 0.20
p_sdt_c    <- 0.05
a_jc_c     <- 0.20
p_jc_c     <- 0.05
c_lt_c     <- 0.10
c_yt_c     <- 0.01
c_tt_c     <- 0.004
int_paff_tt <- 0.003

# Predictor DGP offsets
affect_male_offset   <- 0.10
sdt_male_offset      <- -0.10

# Within-dyad correlations
rho_affect  <- 0.30
rho_sdt     <- 0.30
rho_jc      <- 0.30
rho_engage  <- 0.25
rho_perform <- 0.25
rho_creat   <- 0.25

correlate_errors <- function(rho, x, n = length(x), sd = 1) {
  e_raw <- rnorm(n, 0, sd)
  rho * x + sqrt(1 - rho^2) * e_raw
}


# =============================================================================
# 2. Generate Dyad-Level Moderators
# =============================================================================

live_together <- rbinom(N, 1, 0.85)

years_together <- pmax(0.5, pmin(35, rnorm(N, 10, 5)))

time_spent_this_morning_together <- pmax(0, pmin(150, rnorm(N, 45, 25)))

# Check distributions
prop.table(table(live_together))
summary(years_together)
summary(time_spent_this_morning_together)


# =============================================================================
# 3. Generate Person-Level Predictors (Affect)
# =============================================================================
#
# Males have +0.10 mean affect offset (positive affect literature).
# Within-dyad correlation (rho_affect = 0.30) via Cholesky-style construction.
# Use cor() to verify the empirical within-dyad correlation is close to 0.30.

mu_affect_m <- affect_male_offset
mu_affect_f <- -affect_male_offset

z1_affect <- rnorm(N, 0, 1)

male_affect <- mu_affect_m + z1_affect
female_affect <- mu_affect_f + correlate_errors(rho_affect, z1_affect)

summary(male_affect)
summary(female_affect)
cor(male_affect, female_affect)
t.test(male_affect, female_affect, paired = TRUE)


# =============================================================================
# 4. Generate Person-Level Predictors (SDT)
# =============================================================================
#
# Males have -0.10 mean SDT offset (gender-role theories of autonomy).
# Within-dyad correlation (rho_sdt = 0.30).

mu_sdt_m <- sdt_male_offset
mu_sdt_f <- -sdt_male_offset

z1_sdt <- rnorm(N, 0, 1)

male_sdt <- mu_sdt_m + z1_sdt
female_sdt <- mu_sdt_f + correlate_errors(rho_sdt, z1_sdt)

summary(male_sdt)
summary(female_sdt)
cor(male_sdt, female_sdt)
t.test(male_sdt, female_sdt, paired = TRUE)


# =============================================================================
# 5. Generate Person-Level Predictors (Job Crafting)
# =============================================================================
#
# Job crafting is predicted by own affect and own SDT (theoretical antecedent).
# Within-dyad correlation (rho_jc = 0.30) via correlated residuals.

e_jc_m <- rnorm(N, 0, 0.7)
e_jc_f <- correlate_errors(rho_jc, e_jc_m, sd = 0.7)

male_jc <- 0.20 * male_affect + 0.25 * male_sdt + e_jc_m
female_jc <- 0.20 * female_affect + 0.25 * female_sdt + e_jc_f

summary(male_jc)
summary(female_jc)
cor(male_jc, female_jc)
cor(male_affect, male_jc)
cor(female_affect, female_jc)
cor(male_sdt, male_jc)
cor(female_sdt, female_jc)


# =============================================================================
# 6. Generate Outcomes — Engagement (APIM DGP with focal moderation)
# =============================================================================
#
# Focal moderation: partner_jc x live_together.
# Distinguishable feature: actor_sdt is 0.10 stronger for males.
# Correlated residuals within dyads (rho_engage = 0.25).
# Verify the recovered interaction coefficient after fitting a simple model.

e_eng_m <- rnorm(N, 0, 0.5)
e_eng_f <- correlate_errors(rho_engage, e_eng_m, sd = 0.5)

male_engagement <- alpha_em +
  a_affect_e * male_affect + p_affect_e * female_affect +
  a_sdt_e    * male_sdt    + p_sdt_e    * female_sdt +
  a_jc_e     * male_jc     + p_jc_e     * female_jc +
  c_lt_e * live_together + c_yt_e * years_together +
  c_tt_e * time_spent_this_morning_together +
  int_pjc_lt * live_together * female_jc +
  int_asdt_gm * male_sdt +  # male offset on actor_sdt
  e_eng_m

female_engagement <- alpha_ef +
  a_affect_e * female_affect + p_affect_e * male_affect +
  a_sdt_e    * female_sdt    + p_sdt_e    * male_sdt +
  a_jc_e     * female_jc     + p_jc_e     * male_jc +
  c_lt_e * live_together + c_yt_e * years_together +
  c_tt_e * time_spent_this_morning_together +
  int_pjc_lt * live_together * male_jc +
  e_eng_f

summary(male_engagement)
summary(female_engagement)
cor(male_engagement, female_engagement)
t.test(male_engagement, female_engagement, paired = TRUE)


# =============================================================================
# 7. Generate Outcomes — Performance (APIM DGP with focal moderation)
# =============================================================================
#
# Focal moderation: partner_sdt x years_together.
# Slopes equal across gender (no gender interactions on performance).
# Correlated residuals within dyads (rho_perform = 0.25).

e_perf_m <- rnorm(N, 0, 0.5)
e_perf_f <- correlate_errors(rho_perform, e_perf_m, sd = 0.5)

male_performance <- alpha_pm +
  a_affect_p * male_affect + p_affect_p * female_affect +
  a_sdt_p    * male_sdt    + p_sdt_p    * female_sdt +
  a_jc_p     * male_jc     + p_jc_p     * female_jc +
  c_lt_p * live_together + c_yt_p * years_together +
  c_tt_p * time_spent_this_morning_together +
  int_psdt_yt * years_together * female_sdt +
  e_perf_m

female_performance <- alpha_pf +
  a_affect_p * female_affect + p_affect_p * male_affect +
  a_sdt_p    * female_sdt    + p_sdt_p    * male_sdt +
  a_jc_p     * female_jc     + p_jc_p     * male_jc +
  c_lt_p * live_together + c_yt_p * years_together +
  c_tt_p * time_spent_this_morning_together +
  int_psdt_yt * years_together * male_sdt +
  e_perf_f

summary(male_performance)
summary(female_performance)
cor(male_performance, female_performance)
t.test(male_performance, female_performance, paired = TRUE)


# =============================================================================
# 8. Generate Outcomes — Creativity (APIM DGP with focal moderation)
# =============================================================================
#
# Focal moderation: partner_affect x time_spent_this_morning_together.
# Slopes equal across gender (no gender interactions on creativity).
# Correlated residuals within dyads (rho_creat = 0.25).

e_crea_m <- rnorm(N, 0, 0.5)
e_crea_f <- correlate_errors(rho_creat, e_crea_m, sd = 0.5)

male_creativity <- alpha_cm +
  a_affect_c * male_affect + p_affect_c * female_affect +
  a_sdt_c    * male_sdt    + p_sdt_c    * female_sdt +
  a_jc_c     * male_jc     + p_jc_c     * female_jc +
  c_lt_c * live_together + c_yt_c * years_together +
  c_tt_c * time_spent_this_morning_together +
  int_paff_tt * time_spent_this_morning_together * female_affect +
  e_crea_m

female_creativity <- alpha_cf +
  a_affect_c * female_affect + p_affect_c * male_affect +
  a_sdt_c    * female_sdt    + p_sdt_c    * male_sdt +
  a_jc_c     * female_jc     + p_jc_c     * male_jc +
  c_lt_c * live_together + c_yt_c * years_together +
  c_tt_c * time_spent_this_morning_together +
  int_paff_tt * time_spent_this_morning_together * male_affect +
  e_crea_f

summary(male_creativity)
summary(female_creativity)
cor(male_creativity, female_creativity)
t.test(male_creativity, female_creativity, paired = TRUE)


# =============================================================================
# 9. Assemble Long Format Data (each person = one row)
# =============================================================================

library(dplyr)

# ddl2 = dyad data long v2 (each person = one row)
ddl2 <- data.frame(
  dyad_id = rep(1:N, each = 2),
  person_id = rep(1:2, N),
  gender = rep(c("male", "female"), N),
  affect = c(rbind(male_affect, female_affect)),
  sdt = c(rbind(male_sdt, female_sdt)),
  job_crafting = c(rbind(male_jc, female_jc)),
  engagement = c(rbind(male_engagement, female_engagement)),
  performance = c(rbind(male_performance, female_performance)),
  creativity = c(rbind(male_creativity, female_creativity)),
  live_together = rep(live_together, each = 2),
  years_together = rep(years_together, each = 2),
  time_spent_this_morning_together = rep(time_spent_this_morning_together, each = 2)
)

ddl2 <- ddl2 %>%
  arrange(dyad_id, person_id) %>%
  group_by(dyad_id) %>%
  mutate(
    partner_affect = affect[3 - person_id],
    partner_sdt = sdt[3 - person_id],
    partner_job_crafting = job_crafting[3 - person_id]
  ) %>%
  ungroup()

ddl2$gender <- factor(ddl2$gender, levels = c("male", "female"))

cat("\nLong format data dimensions:", dim(ddl2), "\n")
cat("Variables:", paste(names(ddl2), collapse = ", "), "\n")


# =============================================================================
# 10. Assemble Wide Format Data (each dyad = one row)
# =============================================================================

# ddw2 = dyad data wide v2 (each dyad = one row)
ddw2 <- data.frame(
  dyad_id = 1:N,
  affect_a = male_affect,
  affect_p = female_affect,
  sdt_a = male_sdt,
  sdt_p = female_sdt,
  job_crafting_a = male_jc,
  job_crafting_p = female_jc,
  engagement_a = male_engagement,
  engagement_p = female_engagement,
  performance_a = male_performance,
  performance_p = female_performance,
  creativity_a = male_creativity,
  creativity_p = female_creativity,
  live_together = live_together,
  years_together = years_together,
  time_spent_this_morning_together = time_spent_this_morning_together
)
ddw2 <- tibble::as_tibble(ddw2)
cat("Wide format data dimensions:", dim(ddw2), "\n")


# =============================================================================
# 11. Save Data
# =============================================================================

save(ddl2, ddw2, file = "../data/exercise_data.RData")
# Data saved to '../data/exercise_data.RData'
# Load in later scripts with: load('../data/exercise_data.RData')
