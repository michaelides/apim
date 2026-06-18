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

The DGP also includes one gender-by-actor effect: `actor_sdt × gender_male`
on `engagement` equals 0.10. All other slopes are equal across gender.

## Per-section outcome

Each section focuses on **one** outcome so the multi-outcome repetition
does not dominate the time budget. Every outcome still appears at least
twice across the set. Section 1 inspects all three. Section 9 lets you
pick.

| Section | Outcome |
|---|---|
| 1. Data simulation & inspection | all three (ICC, t-tests, summaries) |
| 2. Indistinguishable dyads: MLM | `engagement` |
| 3. Indistinguishable dyads: SEM | `creativity` |
| 4. Distinguishable dyads: MLM moderator | `engagement` |
| 5. Distinguishable dyads: SEM (long) | `performance` |
| 6. Distinguishable dyads: SEM wide | `engagement` |
| 7. Two-intercept models | `creativity` |
| 8. Moderated APIM (centrepiece) | `engagement` |
| 9. Integrative exercise | your choice |

## Files

| File | Purpose |
|---|---|
| `exercises/simulate_exercise_data.R` | DGP script (run once to regenerate `data/exercise_data.RData`) |
| `data/exercise_data.RData` | Contains `ddl2` (long) and `ddw2` (wide) |
| `exercises/exercises.md` | This file |
| `exercises/answers_template.R` | Step-by-step instructions and code stubs |
| `exercises/completed_exercises.R` | Fully worked solutions matching this file |

## How to use these exercises

The exercises assume you have the exercise dataset loaded and the workshop's
reference scripts (02–08) available for syntax. Each section below describes
the goal and what to produce. Open `exercises/answers_template.R` for the
step-by-step instructions and code stubs. After producing each output, write
a one-sentence interpretation before moving on — that articulation is the
exercise.

Reference script numbers below refer to `scripts/02_indistinguishable_mlm.R`
through `scripts/08_moderated_apim.R`. Section 5 uses
`scripts/06_distinguishable_sem_longformat.R` and Section 6 uses
`scripts/07_distinguishable_sem_wide.R` — the per-section "Reference" line
in the template makes the mapping explicit.

---

## Section 1 — Data simulation & inspection

**What you are practising:** orienting yourself to a new dyadic dataset
before any modelling.

**Reference:** `exercises/simulate_exercise_data.R` (the DGP) and
`scripts/02_indistinguishable_mlm.R` (for the `icc()` helper).

**What to produce:** Read the header of the simulation script to understand
the data-generating parameters for the three outcomes and the focal
moderated-crossover effects. Run the script to create the data file. In a
fresh R session, load the data and inspect both the long and wide formats.
For each of the three outcomes, fit a null multilevel model and compute the
ICC to assess within-dyad dependence. Summarise the three dyad-level
moderators to understand their distributions. Run paired t-tests on the
three outcomes to identify which show non-zero gender mean differences.

**Reflection prompt:** Which outcome shows the largest gender difference
in mean? Does it match the DGP intercept gap, or is it diluted by the
gender-asymmetric predictors?

---

## Section 2 — Indistinguishable dyads: multilevel modelling

**Outcome:** `engagement`.

**What you are practising:** the basic Actor-Partner Interdependence Model
in long format, treating dyad members as exchangeable.

**Reference:** `scripts/02_indistinguishable_mlm.R`.

**What to produce:** Load the long-format data. Fit the full APIM for
`engagement` with all three actor predictors, all three partner predictors,
the three dyad-level moderators, and a random intercept for dyad. Fit a
reduced model that omits the three partner predictors, and use a
likelihood ratio test to check whether the partner block is jointly needed.
Compute profile-likelihood confidence intervals and write a two-sentence
interpretation of the actor and partner effects.

**Reflection prompt:** Is the partner block jointly significant? Does the
answer match the DGP, which has non-zero partner effects for all three
predictors on `engagement`?

---

## Section 3 — Indistinguishable dyads: SEM

**Outcome:** `creativity`.

**What you are practising:** three structural equation modelling paradigms
for indistinguishable dyads and the formal indistinguishability test.

**Reference:** `scripts/03_indistinguishable_sem.R`.

**What to produce:** Load the wide-format data. For `creativity`, fit
three structural equation models: a cluster-robust model in long format, a
two-level model that decomposes effects into within-dyad and between-dyad
components, and a wide-format model with full equality constraints across
dyad members. Then fit an unconstrained wide-format model and use a
likelihood ratio test to assess whether the equality constraints are
tenable. The DGP has equal slopes on `creativity` across gender, so the
test should fail to reject the indistinguishability null.

**Reflection prompt:** Does the likelihood ratio test confirm
indistinguishability for `creativity`? What does that imply about the
`actor_sdt × gender_male` interaction — is it on `engagement` only, or
could it also appear here?

---

## Section 4 — Distinguishable dyads: MLM moderator

**Outcome:** `engagement`.

**What you are practising:** adding `gender` as a moderator of actor and
partner effects in a multilevel model.

**Reference:** `scripts/04_distinguishable_mlm.R`.

**What to produce:** Load the long-format data. Fit a baseline multilevel
model for `engagement` (no gender interactions) and a full moderator
model that interacts gender with every actor and partner predictor.
Compare the two via a likelihood ratio test. Use simple slopes to extract
the `actor_sdt` effect separately for each gender. The DGP has only one
non-zero gender interaction: `actor_sdt × gender_male` on `engagement`.

**Reflection prompt:** Does the simple-slope plot for `actor_sdt` by
gender show a clear male-female difference, in line with the DGP, or do
other gender interactions appear spuriously significant?

---

## Section 5 — Distinguishable dyads: SEM (two-level with moderation)

**Outcome:** `performance`.

**What you are practising:** mirroring the multilevel moderator approach
in SEM with calculated simple slopes.

**Reference:** `scripts/06_distinguishable_sem_longformat.R`.

**What to produce:** Load the long-format data. Construct a numeric gender
indicator and create manual interaction columns for every actor and
partner predictor. Specify a two-level SEM for `performance` with the
gender interactions at the within-dyad level and the three moderators at
the between-dyad level. Add calculated simple-slope parameters (one per
gender per pathway) using the lavaan `:=` operator. Fit the model and
compare the within-dyad SEM gender coefficients with the multilevel
estimates from a simple re-fit on `performance`. The DGP has no gender
interactions on `performance`, so the gender block should be small.

**Reflection prompt:** Do the SEM gender coefficients agree with a quick
MLM re-fit on `performance`? Where do they differ, and is the difference
substantively meaningful?

---

## Section 6 — Distinguishable dyads: SEM wide format

**Outcome:** `engagement`.

**What you are practising:** the unconstrained / slopes-equal /
fully-constrained model sequence and the three nested likelihood ratio
tests.

**Reference:** `scripts/07_distinguishable_sem_wide.R`.

**What to produce:** Load the wide-format data. For `engagement`, fit
three wide-format SEMs: one with all paths free to vary across dyad
members, one that constrains slopes to be equal but leaves intercepts
free, and one that constrains everything (slopes, intercepts, residual
variances). Run the three nested likelihood ratio tests per outcome:
slope equality, intercept equality, and overall indistinguishability.
Report each p-value. The DGP has equal slopes on `engagement` (the only
gender interaction is `actor_sdt × gender_male`, which the wide-format
unconstrained vs slopes-equal test may flag) and a non-zero intercept
gap.

**Reflection prompt:** Which of the three LRTs is most decisive? Does
the slope-equality test pick up the `actor_sdt × gender_male` DGP effect
in the wide-format SEM?

---

## Section 7 — Two-intercept models

**Outcome:** `creativity`.

**What you are practising:** the parameterisation trick that directly
estimates separate intercepts per group, and its SEM analogue.

**Reference:** `scripts/05_two_intercept_models.R`.

**What to produce:** Load the long-format data. For `creativity`, fit
three nested multilevel models: one with equal intercepts and equal
slopes, one with separate intercepts for each gender but equal slopes,
and one with separate intercepts and separate slopes. Use the
parameterisation that suppresses the global intercept and replaces it
with separate group intercepts (`0 + gender` in `lmer`). Compare adjacent
models with likelihood ratio tests. Then fit the SEM analogue in wide
format (two intercepts, equal slopes) and confirm the intercept estimates
match the multilevel model. The DGP has a negative male-vs-female
intercept gap on `creativity` (males 4.80, females 4.95), so the
two-intercept approach should reveal a clear mean reversal.

**Reflection prompt:** The two-intercept approach is recommended when the
researcher wants to report the absolute mean of each group. Does the
`creativity` model show a substantively interesting mean reversal between
males and females?

---

## Section 8 — Moderated APIM (the centrepiece)

**Outcome:** `engagement`.

**What you are practising:** testing whether the partner crossover effect
is moderated by a dyad-level variable, using both multilevel modelling
and SEM.

**Reference:** `scripts/08_moderated_apim.R`.

**What to produce:** Load both the long- and wide-format data. For
`engagement`, fit a baseline multilevel model and a moderated multilevel
model that includes the focal `partner_job_crafting × live_together`
interaction (DGP value 0.15). Use simple slopes to extract the
`partner_job_crafting` effect at the two levels of `live_together`, and
plot the interaction. Run the likelihood ratio test comparing base to
moderated. Then build the wide-format SEM with a manually created
product indicator and computed simple-slope parameters, and compare the
simple-slope estimates with those from the multilevel model.

**Reflection prompt:** Do the multilevel and SEM simple-slope estimates
agree? Where do they differ, and is the difference larger for the binary
moderator (`live_together`) than you would expect for a continuous
moderator?

---

## Section 9 — Integrative exercise

**Outcome:** your choice (one of the three).

**What you are practising:** combining everything you have learned to
answer a single, fully-specified research question.

**What to produce:** Pick one outcome (e.g. `engagement`, since it has the
richest DGP). Build a kitchen-sink multilevel model that includes all
three actor predictors, all three partner predictors, all three
dyad-level moderators, the focal crossover-by-moderator interaction for
your chosen outcome, and a random intercept. Build the corresponding
wide-format SEM with a manually created product indicator and computed
simple-slope parameters at three levels of the moderator (low, mean,
high; for the binary `live_together`, use 0 and 1). Report the actor and
partner effect estimates with standard errors, the focal interaction
coefficient from both approaches, the three simple slopes, and the SEM
fit indices. Write a 4–6 sentence interpretation paragraph covering the
substantive size and direction of the partner crossover effect, whether
the moderator meaningfully changes that effect, a plain-language
interpretation, and one limitation or follow-up question.

**Reflection prompt:** If you had to present this in a 5-minute
conference talk, which figure and which one-sentence result would you
lead with?
