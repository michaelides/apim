---
title: "Primary References"
subtitle: "Dyadic Data Analysis with the Actor–Partner Interdependence Model (APIM) in R"
author: "EAOHP 2026 Workshop"
date: "2026"
---

# Primary References

The following references accompany the EAOHP 2026 workshop on dyadic data
analysis with the Actor–Partner Interdependence Model (APIM) in R.

**How to use this list.** The first 8 entries are *methods* references on
APIM and the R packages used in the workshop. The last 2 are the
*primary textbook* and the *applied example* whose data structure our
simulated data emulate. Each entry has a one-line note on *when* to read
it.

---

## Foundational APIM papers

- **Kenny, D. A., Kashy, D. A., & Cook, W. L. (2006).**
  *Dyadic data analysis.* Guilford Press.
  The primary APIM textbook — the conceptual and analytic basis for the
  workshop.

- **Cook, W. L., & Kenny, D. A. (2005).** The Actor–Partner
  Interdependence Model: A model of bidirectional effects in
  developmental studies. *International Journal of Behavioral
  Development, 29*(2), 101–108.
  The foundational paper that articulated APIM in psychology.

- **Kenny, D. A., & Ledermann, T. (2010).** Detecting, measuring, and
  testing dyadic patterns in the Actor–Partner Interdependence Model.
  *Journal of Family Psychology, 24*(3), 359–366.
  Introduces the k-pattern tests (actor-only, couple, contrast) used to
  interpret APIM effects.

## Handbook chapters and practical introductions

- **Kashy, D. A., Donnellan, M. B., & Ackerman, R. A. (2017).** Dyadic
  analysis. In A. L. Vangelisti & D. Perlman (Eds.), *The Cambridge
  handbook of personal relationships* (2nd ed., pp. 101–115). Cambridge
  University Press.
  Modern, accessible handbook chapter covering dyadic data analysis
  end-to-end.

- **Ackerman, R. A., Donnellan, M. B., & Kashy, D. A. (2011).** Working
  with dyadic data: An introduction. In L. M. Horowitz & S. N. Strack
  (Eds.), *Handbook of interpersonal psychology: Theory, research,
  assessment, and therapeutic interventions* (pp. 547–558). Wiley.
  Concise, practical introduction with worked examples — a good first
  methods read.

## SEM specification for indistinguishable dyads

- **Olsen, J. A., & Kenny, D. A. (2006).** Structural equation modeling
  with interchangeable dyads. *Psychological Methods, 11*(2), 127–141.
  SEM specification for *indistinguishable* dyads — underpins the
  wide-format `lavaan` syntax we use in script 03.

## Worked SEM tutorial (k-pattern tests)

- **Fitzpatrick, J., Gareau, A., Lafontaine, M.-F., & Gaudreau, P.
  (2016).** How to use the Actor–Partner Interdependence Model to
  estimate different dyadic patterns in Mplus: A step-by-step tutorial.
  *Tutorials in Quantitative Methods for Psychology, 12*(1), 74–86.
  Worked SEM tutorial on the k-pattern tests; closely parallels our
  `lavaan` scripts 05 and 06 (despite the Mplus label, the model
  specification is identical).

## R implementation

- **Rosseel, Y. (2012).** lavaan: An R package for structural equation
  modeling. *Journal of Statistical Software, 48*(2), 1–36.
  The R-side SEM engine used in scripts 03, 05, 06, and 07.

## Extension: intensive longitudinal / diary designs

- **Bolger, N., & Laurenceau, J.-P. (2013).** *Intensive longitudinal
  methods: An introduction to diary and experience sampling research.*
  Guilford Press.
  Methods reference for the diary / ESM extension of APIM (days within
  persons within dyads; see slide 30).

## Applied example (the data structure our scripts emulate)

- **Hahn, V. C., Binnewies, C., & Dormann, C. (2014).** The role of
  partners and children for employees' daily recovery. *Journal of
  Vocational Behavior, 85*(1), 39–48.
  The applied example our scripts emulate — reproduced in
  `scripts/08_moderated_apim.R`.

---

## Local workshop materials

- `scripts/01_simulate_data.R` — Data generation
- `scripts/02_indistinguishable_mlm.R` — Indistinguishable dyads, MLM
- `scripts/03_indistinguishable_sem.R` — Indistinguishable dyads, SEM
  (wide format, `lavaan`)
- `scripts/04_distinguishable_mlm.R` — Distinguishable dyads, MLM
- `scripts/05_distinguishable_sem_moderation.R` — Distinguishable dyads,
  SEM with gender moderation
- `scripts/06_distinguishable_sem_wide.R` — Distinguishable dyads, SEM
  wide format
- `scripts/07_two_intercept_models.R` — Two-intercept (actor–partner)
  models
- `scripts/08_moderated_apim.R` — Moderated APIM, replicating Hahn,
  Binnewies, & Dormann (2014)
- `exercises/` — Student exercises
