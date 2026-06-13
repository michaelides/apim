# Workshop Exercises — Crossover to Work Outcomes

Companion exercises for the exercise dyadic dataset (`data/exercise_data.RData`).
This dataset is **independent** from the original Hahn-et-al-style dataset
used by scripts 02–08. The exercise scenario studies how work-related
psychological states of one partner (affect, self-determination, job
crafting) crossover to influence the other partner's work outcomes
(engagement, performance, creativity), and how three dyad-level moderators
(live_together, years_together, time_spent_this_morning_together) shape
those pathways.

## Dataset summary

| Element | Specification |
|---|---|
| N couples | 250 (500 individuals) |
| Predictors (person-level) | `affect`, `sdt`, `job_crafting` |
| Outcomes (person-level) | `engagement`, `performance`, `creativity` |
| Crossover moderators (dyad-level) | `live_together` (binary), `years_together` (continuous), `time_spent_this_morning_together` (continuous) |
| Distinguishing variable | `gender` (male / female) |
| Within-dyad predictor correlations | ~0.30 (affect, sdt, jc) |
| Within-dyad outcome correlations | ~0.25 (engagement, performance, creativity) |
| Partner predictors in long format | `partner_affect`, `partner_sdt`, `partner_job_crafting` |
| Wide format | `_a` / `_p` suffixes (actor / partner) |

## Focal moderated-crossover effects (one per outcome)

| Outcome | Focal partner predictor | Focal moderator | DGP interaction |
|---|---|---|---|
| engagement | `partner_job_crafting` | `live_together` | partner_jc × live_together = 0.15 |
| performance | `partner_sdt` | `years_together` | partner_sdt × years_together = 0.015 |
| creativity | `partner_affect` | `time_spent_this_morning_together` | partner_affect × time_spent = 0.003 |

## Files

| File | Purpose |
|---|---|
| `exercises/simulate_exercise_data.R` | DGP script (run once to regenerate `data/exercise_data.RData`) |
| `data/exercise_data.RData` | Contains `ddl2` (long) and `ddw2` (wide) |
| `exercises/exercises.md` | This file |
| `exercises/answers_template.R` | Step-by-step instructions and code stubs |

## How to use these exercises

The exercises assume you have the exercise dataset loaded and the workshop's
reference scripts (02–08) available for syntax. Each section below describes
the goal and what to produce. Open `exercises/answers_template.R` for the
step-by-step instructions and code stubs. After producing each output, write
a one-sentence interpretation before moving on — that articulation is the
exercise.

---

## Section 1 — Data simulation & inspection

**What you are practising:** orienting yourself to a new dyadic dataset
before any modelling.

**What to produce:** Read the header of the simulation script to understand
the data-generating parameters for the three outcomes and the focal
moderated-crossover effects. Run the script to create the data file. In a
fresh R session, load the data and inspect both the long and wide formats.
For each of the three outcomes, fit a null multilevel model and compute the
ICC to assess within-dyad dependence. Summarise the three dyad-level
moderators to understand their distributions. Compute within-dyad
correlations for the three predictors to verify the simulated coupling. Run
paired t-tests on the predictors and outcomes to identify which show
non-zero gender mean differences.

**Reflection prompt:** Which of the three outcomes shows the largest gender
difference in mean, and which shows the smallest? Does the difference match
the DGP intercept gap, or is it diluted by the gender-asymmetric
predictors?

---

## Section 2 — Indistinguishable dyads: multilevel modelling

**What you are practising:** the basic Actor-Partner Interdependence Model
in long format, treating dyad members as exchangeable.

**What to produce:** Load the long-format data. For each of the three
outcomes, fit the full Actor-Partner Interdependence Model with all three
actor predictors, all three partner predictors, the three dyad-level
moderators, and a random intercept for dyad. Also fit a reduced model that
omits the three partner predictors, and compare the two to test whether the
partner block is jointly needed. Repeat the process for all three
outcomes. For each outcome, compute profile-likelihood confidence intervals
and write a two-sentence interpretation of the actor and partner effects.

**Reflection prompt:** For which outcome is the partner block
(partner_affect, partner_sdt, partner_job_crafting) jointly most
important? Does this match the data-generating process?

---

## Section 3 — Indistinguishable dyads: SEM

**What you are practising:** three structural equation modelling paradigms
for indistinguishable dyads and the formal indistinguishability test.

**What to produce:** Load the wide-format data. For each of the three
outcomes, fit three structural equation models: a cluster-robust model in
long format, a two-level model that decomposes effects into within-dyad
and between-dyad components, and a wide-format model with full equality
constraints across dyad members. Then fit an unconstrained wide-format
model and use a likelihood ratio test to assess whether the equality
constraints are tenable. Repeat for all three outcomes.

**Reflection prompt:** For each outcome, do the likelihood ratio test
results agree with the data-generating process (which has equal slopes
across gender, with the single exception of `actor_sdt × gender_male` on
engagement)? Which outcome's test result is the weakest signal in favour
of indistinguishability, and why?

---

## Section 4 — Distinguishable dyads: MLM moderator

**What you are practising:** adding `gender` as a moderator of actor and
partner effects in a multilevel model.

**What to produce:** Load the long-format data. For each outcome, fit a
baseline multilevel model (no gender interactions) and a full moderator
model that interacts gender with every actor and partner predictor. Compare
the two via a likelihood ratio test. For each outcome, use a simple-slopes
tool to extract the actor effects (and partner effects, where relevant)
separately for each gender, and report the profile-likelihood confidence
intervals. Repeat for all three outcomes.

**Reflection prompt:** The data-generating process specifies that only
`actor_sdt × gender_male` on engagement is non-zero. Do the simple-slope
plots and likelihood ratio tests pick this up cleanly, or do other
interactions appear spuriously significant?

---

## Section 5 — Distinguishable dyads: SEM (two-level with moderation)

**What you are practising:** mirroring the multilevel moderator approach
in SEM with calculated simple slopes.

**What to produce:** Load the long-format data. Construct a numeric gender
indicator and create manual interaction columns for every actor and partner
predictor. For each outcome, specify a two-level SEM with the gender
interactions at the within-dyad level and the three moderators at the
between-dyad level. Add calculated simple-slope parameters (one per gender
per pathway). Fit the model and compare the within-dyad SEM gender
coefficients with the multilevel estimates from the previous section.
Repeat for all three outcomes.

**Reflection prompt:** The within-dyad SEM gender coefficients should
mirror the multilevel estimates from the previous section. Where do they
differ, and why?

---

## Section 6 — Distinguishable dyads: SEM wide format

**What you are practising:** the unconstrained / slopes-equal /
fully-constrained model sequence and the three nested likelihood ratio
tests.

**What to produce:** Load the wide-format data. For each outcome, fit three
wide-format SEMs: one with all paths free to vary across dyad members, one
that constrains slopes to be equal but leaves intercepts free, and one
that constrains everything (slopes, intercepts, residual variances). Run
the three nested likelihood ratio tests per outcome: slope equality,
intercept equality, and overall indistinguishability. Build a fit-indices
table that compares the three models for each outcome.

**Reflection prompt:** For which outcome is the slope-equality test most
likely to be non-significant — and is that consistent with the single
`actor_sdt × gender_male` interaction in the data-generating process?

---

## Section 7 — Two-intercept models

**What you are practising:** the parameterisation trick that directly
estimates separate intercepts per group, and its SEM analogue.

**What to produce:** Load the long-format data. For each outcome, fit three
nested multilevel models: one with equal intercepts and equal slopes, one
with separate intercepts for each gender but equal slopes, and one with
separate intercepts and separate slopes. Use the parameterisation that
suppresses the global intercept and replaces it with separate group
intercepts. Compare adjacent models with likelihood ratio tests. Repeat for
all three outcomes. Also fit the SEM analogue in wide format (two
intercepts, equal slopes) and confirm the intercept estimates match the
multilevel model.

**Reflection prompt:** The two-intercept approach is recommended when the
researcher wants to report the absolute mean of each group (not the
contrast with a reference). Which of the three outcomes has the most
substantively different male vs. female mean, and is that consistent with
what you saw in Section 1?

---

## Section 8 — Moderated APIM (the centrepiece)

**What you are practising:** testing whether the partner crossover effect
on each outcome is moderated by a dyad-level variable, using both
multilevel modelling and SEM.

**What to produce:** Load both the long- and wide-format data. For each
outcome, fit a baseline multilevel model and a moderated multilevel model
that includes the focal partner-by-moderator interaction for that outcome.
Use a simple-slopes tool to extract and visualise the partner predictor's
effect at low and high levels of the focal moderator. Run the likelihood
ratio test comparing base to moderated. Then for each outcome, build the
corresponding wide-format SEM with a manually created product indicator
and computed simple-slope parameters, and compare the simple-slope
estimates with those from the multilevel model. Repeat for all three
outcomes.

**Reflection prompt:** Compare the multilevel and SEM simple-slope
estimates for each outcome. Where do they differ, and is the difference
larger when the moderator is binary (live_together) or continuous
(years_together, time_spent_this_morning_together)? Why might that be?

---

## Section 9 — Integrative exercise

**What you are practising:** combining everything you have learned to
answer a single, fully-specified research question.

**What to produce:** Pick one of the three outcomes. Build a kitchen-sink
multilevel model that includes all three actor predictors, all three
partner predictors, all three dyad-level moderators, the focal
crossover-by-moderator interaction for your chosen outcome, and a random
intercept. Build the corresponding wide-format SEM with a manually created
product indicator and computed simple-slope parameters at three levels of
the moderator (low, mean, high). Report the actor and partner effect
estimates with standard errors, the focal interaction coefficient from both
approaches, the three simple slopes, and the SEM fit indices. Write a
4–6 sentence interpretation paragraph covering the substantive size and
direction of the partner crossover effect, whether the moderator
meaningfully changes that effect, a plain-language interpretation, and one
limitation or follow-up question.

**Reflection prompt:** If you had to present this in a 5-minute
conference talk, which figure and which one-sentence result would you lead
with?
