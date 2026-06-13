#' =============================================================================
#' Workshop Exercises — Answer Template
#' Workshop: Dyadic Data Analysis Using R (EAOHP 2026)
#' =============================================================================
#'
#' Purpose:
#'   This file is a guided answer template. It contains ZERO executable code
#'   and ZERO R code snippets. Every instruction is a plain-prose comment
#'   telling you what analysis to perform, what to look for, and what to
#'   record. Function names appear in prose where helpful, but no syntax is
#'   shown.
#'
#' How to use:
#'   1. Read the matching section in exercises/exercises.md to understand
#'      the goal.
#'   2. For each numbered step below, look at the referenced script in
#'      scripts/ (numbered 02 through 08) for the exact syntax pattern.
#'   3. Adapt the syntax to the exercise dataset using these substitutions:
#'         Use ddl2 in place of ddl; use ddw2 in place of ddw.
#'         Use affect in place of wnc, and also add sdt and job_crafting.
#'         Use sdt in place of recovery, and also add job_crafting.
#'         Use engagement, performance, or creativity in place of
#'         satisfaction.
#'         Use live_together in place of has_children, and also add
#'         years_together and time_spent_this_morning_together.
#'   4. Add a 1-sentence interpretation as a comment after each analysis
#'      so you articulate what you see. That articulation is the exercise.
#'
#' Outputs:
#'   When filled in, the script should run top-to-bottom and produce console
#'   output (model summaries, likelihood ratio tests, simple slopes) for all
#'   9 sections.
#'
#' Prerequisites:
#'   Run exercises/simulate_exercise_data.R first to create
#'   data/exercise_data.RData. Required packages: lme4, lmerTest, lavaan, dplyr,
#'   tibble, interactions.
#' =============================================================================


# =============================================================================
# Setup and Data Loading
# =============================================================================
#
# 1. Clear the workspace and set the working directory to the workshop root.
#
# 2. Load the required libraries. You will need lme4 and lmerTest for
#    multilevel modelling, lavaan for structural equation modelling, dplyr
#    and tibble for data manipulation, and interactions for simple-slopes
#    analysis.
#
# 3. Load the exercise dataset with the load function. The data file is
#    data/exercise_data.RData. Loading it creates two data frames in
#    your workspace: ddl2 (the long format, 500 rows by 15 columns) and
#    ddw2 (the wide format, 250 rows by 16 columns).
#
# 4. Print the structure of both data frames and confirm the dimensions
#    match the values above.
#
# 5. Optionally, copy the icc helper function from
#    scripts/02_indistinguishable_mlm.R into this file so you can reuse it
#    below to extract the intra-class correlation from a fitted multilevel
#    model.


# =============================================================================
# Section 1 — Data simulation & inspection
# =============================================================================
# Reference: exercises/simulate_exercise_data.R (the simulation script, with
#            no analysis code) and scripts/02_indistinguishable_mlm.R (for
#            the icc helper).
# Goal: orient yourself to the exercise dataset before any modelling.
#
# 0. Open exercises/simulate_exercise_data.R and read the header comment
#    block (approximately lines 1 through 60). Note the data-generating
#    parameters for the three outcomes and the focal moderated-crossover
#    effects.
#
# 1. Run exercises/simulate_exercise_data.R to create or re-create the
#    data/exercise_data.RData file.
#
# 2. For each of the three outcomes (engagement, performance, creativity),
#    fit a null multilevel model with a random intercept for dyad and
#    compute the intra-class correlation. The ICC tells you the proportion
#    of outcome variance that is shared within dyads. Use the lmer
#    function from lme4 for the model fit, and the icc helper (copied
#    above) for the extraction. Expect all three ICCs to be greater than
#    0.40.
#
# 3. Summarise the three dyad-level moderators. For live_together, build a
#    frequency table and convert it to proportions; expect about 85 percent
#    of dyads to have value 1. For years_together, expect a mean near 10
#    and a range from 1 to 35. For time_spent_this_morning_together, expect
#    a mean near 45 minutes and a range from 0 to 150.
#
# 4. For each of the three predictors (affect, sdt, job_crafting), compute
#    the within-dyad correlation. The cleanest approach is to merge the
#    long-format data on dyad_id so you have separate male and female
#    columns for each predictor, then use the cor function. Expect each
#    correlation to be near 0.30.
#
# 5. For each of the three outcomes and each of the three predictors, run
#    a paired t-test of the variable against gender using the t.test
#    function with paired set to TRUE. Identify which variables show
#    statistically significant gender mean differences. Expect clear
#    differences on sdt and creativity.
#
# Reflection: which outcome has the largest gender mean difference, and
# does it match the data-generating process intercept gap? (The DGP
# specifies alpha_m minus alpha_f equals plus 0.15 for engagement, plus
# 0.10 for performance, and minus 0.15 for creativity.)


# =============================================================================
# Section 2 — Indistinguishable dyads: multilevel modelling
# =============================================================================
# Reference: scripts/02_indistinguishable_mlm.R
# Goal: fit the basic Actor-Partner Interdependence Model in long format,
#       treating dyad members as exchangeable.
#
# 1. Fit the full APIM for engagement. The model should include all three
#    actor predictors (affect, sdt, job_crafting), all three partner
#    predictors (partner_affect, partner_sdt, partner_job_crafting), all
#    three dyad-level moderators (live_together, years_together,
#    time_spent_this_morning_together), and a random intercept for dyad.
#    Use the lmer function from lme4, and save the fitted object with a
#    descriptive name such as apim_eng. See the apim_mlm model in
#    scripts/02_indistinguishable_mlm.R for the syntax pattern.
#
# 2. Fit a reduced version of the same model that omits the three partner
#    predictors. Use the anova function from lme4 to compare the full and
#    reduced models with a likelihood ratio test. The test tells you
#    whether the partner block is jointly needed.
#
# 3. Repeat steps 1 and 2 for the performance and creativity outcomes.
#    Save the fitted objects as apim_perf, apim_creat, and their
#    corresponding actor-only versions.
#
# 4. For each outcome, compute profile-likelihood confidence intervals
#    using the confint function from lme4 with the profile method. Write
#    a two-sentence interpretation of the actor and partner effects.
#
# Reflection: for which outcome is the partner block (the three partner
# predictors taken together) most useful, and does that match the
# data-generating process? (The DGP has non-zero partner effects for all
# three outcomes.)


# =============================================================================
# Section 3 — Indistinguishable dyads: SEM
# =============================================================================
# Reference: scripts/03_indistinguishable_sem.R
# Goal: fit three structural equation modelling paradigms for
#       indistinguishable dyads, then perform the formal
#       indistinguishability test.
#
# 1. Model A is a cluster-robust standard errors model fit on the
#    long-format data. Specify the regression of an outcome on all six
#    predictors plus the three moderators, then use the sem function from
#    lavaan with the cluster argument set to dyad_id. Repeat for each of
#    the three outcomes.
#
# 2. Model B is a two-level SEM. Place the six within-dyad predictors
#    (the three actor and three partner predictors) at the within level,
#    and the three moderators at the between level. The moderators have
#    no within-dyad variance because they take the same value for both
#    dyad members. Use the sem function with the cluster argument. Repeat
#    for each outcome.
#
# 3. Model C is a wide-format APIM with equality constraints. Use a single
#    parameter label per path (so the actor and partner paths for the
#    same predictor share a label), set equal intercepts across the two
#    dyad members, and set equal residual variances. Fit one Model C per
#    outcome using the sem function on ddw2. Confirm that the actor and
#    partner paths are labelled identically.
#
# 4. Fit an unconstrained wide-format model for each outcome (separate
#    parameter labels for the actor and partner paths). Then use the
#    lavTestLRT function from lavaan to compare the unconstrained and
#    constrained models. Interpret the p-value: a non-significant
#    p-value means indistinguishability is tenable for that outcome.
#
# Reflection: for which outcome is the likelihood ratio test p-value
# smallest, and is that consistent with the single actor-sdt by
# gender-male interaction in the data-generating process?


# =============================================================================
# Section 4 — Distinguishable dyads: MLM moderator
# =============================================================================
# Reference: scripts/04_distinguishable_mlm.R
# Goal: add gender as a moderator of actor and partner effects in a
#       multilevel model.
#
# 1. For each outcome, fit a baseline multilevel model with no gender
#    interactions. The structure is the same as the full APIM from
#    Section 2. Use the lmer function from lme4. Save the fitted
#    objects as model_base_eng, model_base_perf, model_base_creat.
#
# 2. For each outcome, fit the full moderator model. The cleanest syntax
#    is to wrap the six predictors in parentheses and multiply by gender,
#    so that every actor and partner predictor interacts with gender.
#    Keep the three moderators (which have no within-dyad variance) as
#    main effects only. Use the lmer function. Save the fitted objects
#    as mod_eng, mod_perf, mod_creat.
#
# 3. For each outcome, use the anova function from lme4 to compare the
#    baseline model and the full moderator model with a likelihood ratio
#    test. The test tells you whether gender moderates any of the
#    actor or partner pathways.
#
# 4. For each outcome, use the sim_slopes function from the interactions
#    package to extract the simple slopes of the actor effects separately
#    for each gender (set the johnson_neyman argument to FALSE). Repeat
#    for any partner effect whose gender interaction is significant.
#
# 5. For each outcome, compute profile-likelihood confidence intervals
#    using the confint function from lme4 with the profile method.
#
# Reflection: the data-generating process has only one gender
# interaction (actor-sdt by gender-male on engagement). Do the simple
# slopes and likelihood ratio tests pick this up cleanly, or do other
# interactions appear spuriously significant?


# =============================================================================
# Section 5 — Distinguishable dyads: SEM (two-level with moderation)
# =============================================================================
# Reference: scripts/05_distinguishable_sem_moderation.R
# Goal: mirror the multilevel moderator approach in SEM with calculated
#       simple slopes.
#
# 1. Create a numeric gender indicator in ddl2 by applying the as.numeric
#    function to the gender factor. The result takes value 1 for males
#    and value 2 for females. Then create manual interaction columns in
#    ddl2 by multiplying each of the six predictors (the three actor and
#    three partner predictors) by the numeric gender indicator. See
#    scripts/05_distinguishable_sem_moderation.R for the column-naming
#    convention.
#
# 2. For each outcome, specify a two-level SEM using the sem function
#    from lavaan. Place the gender interactions and the gender main
#    effect at the within level, and the three moderators at the between
#    level. Use named labels on the path coefficients so you can refer
#    to them in the next step.
#
# 3. Add calculated simple-slope parameters using the lavaan defined
#    operator (the colon-equals symbol that lavaan uses to declare
#    user-defined parameters). For each of the six predictors, define
#    two simple slopes: one evaluated at the male value of the gender
#    indicator (1) and one evaluated at the female value (2). The
#    general form is "label equals base coefficient plus interaction
#    coefficient times the gender value".
#
# 4. Fit the model with the sem function and inspect the parameter
#    estimates using the parameterEstimates function from lavaan. Look
#    at the calculated simple-slope parameters in particular. Repeat
#    for each of the three outcomes.
#
# Reflection: do the within-dyad SEM gender coefficients agree with the
# multilevel estimates from Section 4? If they differ in magnitude, is
# the difference large enough to be substantively meaningful?


# =============================================================================
# Section 6 — Distinguishable dyads: SEM wide format
# =============================================================================
# Reference: scripts/06_distinguishable_sem_wide.R
# Goal: fit the unconstrained, slopes-equal, and fully-constrained model
#       sequence on the wide-format data, and run the three nested
#       likelihood ratio tests.
#
# 1. For each outcome, fit three wide-format SEMs on ddw2 using the sem
#    function from lavaan:
#    a) An unconstrained model, with separate parameter labels for the
#       actor and partner paths.
#    b) A slopes-equal model, with one label per path (so the actor and
#       partner slopes share a label) but free intercepts.
#    c) A fully-constrained model, with equal slopes, equal intercepts,
#       and equal residual variances.
#
# 2. For each outcome, run the three nested likelihood ratio tests using
#    the lavTestLRT function from lavaan. The three tests are:
#    LRT 1: unconstrained versus slopes-equal (do slopes differ by
#           gender?).
#    LRT 2: slopes-equal versus fully-constrained (do intercepts
#           differ?).
#    LRT 3: unconstrained versus fully-constrained (overall
#           indistinguishability).
#
# 3. Build a fit-indices table that compares the three models for each
#    outcome. Use the fitMeasures function from lavaan to extract the
#    standard SEM fit measures (chi-square, degrees of freedom,
#    p-value, CFI, TLI, RMSEA, and SRMR) for each of the three models,
#    and arrange them side by side, rounded to four decimals. See the
#    end of scripts/06_distinguishable_sem_wide.R for the table
#    structure.
#
# Reflection: which outcome has the largest LRT 1 chi-square, and is it
# the one with the actor-sdt by gender-male interaction (engagement)?


# =============================================================================
# Section 7 — Two-intercept models
# =============================================================================
# Reference: scripts/07_two_intercept_models.R
# Goal: use the parameterisation that directly estimates separate
#       intercepts for each gender, and compare it with the SEM analogue.
#
# 1. For each outcome, fit three nested multilevel models using the lmer
#    function from lme4:
#    a) Model 1: equal intercepts and equal slopes. This is the same as
#       the apim model you fit in Section 2.
#    b) Model 2: different intercepts but equal slopes. The cleanest way
#       to specify this in lme4 is to suppress the global intercept and
#       include gender as a main effect with the plus-zero-plus-gender
#       pattern. This produces two intercepts, one for each gender, and
#       a single set of slopes for the predictors.
#    c) Model 3: different intercepts and different slopes. Suppress the
#       global intercept again, and interact every predictor with gender
#       so each gender has its own slope.
#    Save the fitted objects with descriptive names such as m1_eng,
#    m2_eng, m3_eng.
#
# 2. For each outcome, use the anova function from lme4 to compare the
#    adjacent models with likelihood ratio tests. The first test asks
#    whether the intercepts differ by gender; the second asks whether
#    the slopes differ by gender.
#
# 3. Fit the SEM analogue on ddw2 using the sem function from lavaan.
#    The model has two intercepts (one for each dyad member, which in
#    the wide format correspond to the male and female outcomes) and
#    equal slopes. Confirm that the SEM intercepts match the
#    multilevel model intercepts from Model 2.
#
# Reflection: the two-intercept approach is useful when you want to
# report absolute group means without choosing a reference group. Which
# outcome shows the most substantively interesting male versus female
# mean difference in Model 2?


# =============================================================================
# Section 8 — Moderated APIM 
# =============================================================================
# Reference: scripts/08_moderated_apim.R
# Goal: test whether the partner crossover effect on each outcome is
#       moderated by a dyad-level variable, using both multilevel
#       modelling and SEM.
#
# Per outcome, the focal interaction is:
#   engagement  is moderated by partner_job_crafting crossed with
#                live_together
#   performance is moderated by partner_sdt crossed with years_together
#   creativity  is moderated by partner_affect crossed with
#                time_spent_this_morning_together
#
# 1. For each outcome, fit a base multilevel model (no interaction
#    involving the moderator) and a moderated multilevel model with the
#    focal interaction for that outcome. The base model is the same as
#    the apim from Section 2. The moderated model adds the focal
#    partner-by-moderator interaction term. Use the lmer function from
#    lme4. Example for engagement: the base model regresses engagement
#    on the six predictors and the three moderators with a random
#    intercept for dyad; the moderated model adds an additional term
#    for partner_job_crafting crossed with live_together.
#
# 2. For each moderated model, use the sim_slopes function from the
#    interactions package to extract the simple slopes of the partner
#    predictor at low and high levels of the focal moderator. For the
#    binary moderator live_together, the default split is 0 versus 1.
#    For the continuous moderators years_together and
#    time_spent_this_morning_together, the default split is plus and
#    minus one standard deviation. Use the interact_plot function from
#    the same package to produce a visual. Run the likelihood ratio
#    test using the anova function from lme4 to compare the base and
#    moderated models.
#
# 3. For each outcome, build the wide-format SEM analogue. You will
#    need to create the product indicator manually in ddw2 by
#    multiplying the relevant partner predictor column by the relevant
#    moderator column. For example, for engagement, multiply the
#    partner-side job_crafting column by the live_together column to
#    create a new product-indicator column. Then fit the wide-format
#    model with the sem function from lavaan, including the product
#    indicator as an additional predictor, and add calculated
#    simple-slope parameters using the lavaan defined operator. Compare
#    the simple-slope estimates with the multilevel estimates from
#    step 2.
#
# Reflection: do the multilevel and SEM simple-slope estimates agree?
# Where do they differ, and is the difference larger for binary
# moderators or for continuous moderators? Why might the SEM estimate
# be more efficient (or not) for continuous moderators?


# =============================================================================
# Section 9 — Integrative exercise
# =============================================================================
# Reference: synthesis of all 8 prior sections. Use scripts/02 through
#            scripts/08 as needed for syntax.
# Goal: answer a single, fully-specified research question by combining
#       everything you have learned.
#
# 1. Pick one of the three outcomes. Creativity is suggested because its
#    focal interaction is the simplest to interpret visually, but you
#    may choose any of the three. State in a comment which outcome you
#    chose and why.
#
# 2. Build a kitchen-sink multilevel model using the lmer function from
#    lme4. The model should include all three actor predictors, all
#    three partner predictors, all three dyad-level moderators, the
#    focal crossover-by-moderator interaction for your chosen outcome,
#    and a random intercept for dyad. Save the fitted object as
#    final_mlm.
#
# 3. Build the matching wide-format SEM using the sem function from
#    lavaan. Create the manual product indicator in ddw2 by
#    multiplying the relevant columns. Fit the model and add calculated
#    simple-slope parameters at three levels of the moderator: minus
#    one standard deviation, the empirical mean, and plus one standard
#    deviation (for the binary live_together, use 0 and 1). Save the
#    fitted object as final_sem.
#
# 4. Report the following as comments after each step:
#    a. The point estimates and standard errors for the actor and
#       partner effects.
#    b. The focal interaction coefficient from both the multilevel and
#       SEM approaches.
#    c. The three simple slopes of the partner predictor at low, mean,
#       and high levels of the moderator.
#    d. The fit indices of the SEM.
#
# 5. Write a 4 to 6 sentence interpretation paragraph as a comment
#    block at the end of the section. The paragraph should cover:
#    - The substantive size and direction of the partner crossover
#      effect.
#    - Whether the moderator meaningfully changes that effect.
#    - The substantive interpretation in plain language.
#    - One limitation or follow-up question.
#
# Final reflection (as a comment): if you had to present this in a
# 5-minute conference talk, which figure and which one-sentence result
# would you lead with?
