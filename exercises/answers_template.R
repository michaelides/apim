#' =============================================================================
#' Workshop Exercises — Answer Template
#' Workshop: Dyadic Data Analysis Using R (EAOHP 2026)
#' =============================================================================
#'
#' Purpose:
#'   Guided answer template. It contains ZERO executable code and ZERO R code
#'   snippets. Every instruction is a plain-prose comment telling you what
#'   analysis to perform, what to look for, and what to record. Function names
#'   appear in prose where helpful, but no syntax is shown.
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
#'         satisfaction (each section below tells you which).
#'         Use live_together in place of has_children, and also add
#'         years_together and time_spent_this_morning_together.
#'   4. Add a 1-sentence interpretation as a comment after each analysis
#'      so you articulate what you see. That articulation is the exercise.
#'
#' Section-to-script map (important — the per-section "Reference" line
#' below points to the file you should open for syntax):
#'   Section 2 -> scripts/02_indistinguishable_mlm.R
#'   Section 3 -> scripts/03_indistinguishable_sem.R
#'   Section 4 -> scripts/04_distinguishable_mlm.R
#'   Section 5 -> scripts/06_distinguishable_sem_longformat.R
#'   Section 6 -> scripts/07_distinguishable_sem_wide.R
#'   Section 7 -> scripts/05_two_intercept_models.R
#'   Section 8 -> scripts/08_moderated_apim.R
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
# 1. Clear the workspace.
#
# 2. Load the required libraries. You will need lme4 and lmerTest for
#    multilevel modelling, lavaan for structural equation modelling, dplyr
#    and tibble for data manipulation, and interactions for simple-slopes
#    analysis.
#
# 3. Load the exercise dataset. The data file is data/exercise_data.RData.
#    Loading it creates two data frames in your workspace: ddl2 (the long
#    format, 500 rows by 15 columns) and ddw2 (the wide format, 250 rows
#    by 16 columns).
#
# 4. Print the structure of both data frames and confirm the dimensions.
#
# 5. Copy the icc helper function from scripts/02_indistinguishable_mlm.R
#    into this file so you can reuse it below to extract the intra-class
#    correlation from a fitted multilevel model.


# =============================================================================
# Section 1 — Data simulation & inspection
# =============================================================================
# Reference: exercises/simulate_exercise_data.R (the DGP) and
#            scripts/02_indistinguishable_mlm.R (for the icc helper).
# Outcome: ALL THREE (engagement, performance, creativity). This is the
#          one section that exercises all three outcomes; later sections
#          pick one.
# Goal: orient yourself to the exercise dataset before any modelling.
#
# 0. Open exercises/simulate_exercise_data.R and read the header comment
#    block. Note the data-generating parameters for the three outcomes
#    and the focal moderated-crossover effects.
#
# 1. Run exercises/simulate_exercise_data.R to create or re-create
#    data/exercise_data.RData.
#
# 2. For each of the three outcomes (engagement, performance, creativity),
#    fit a null multilevel model with a random intercept for dyad and
#    compute the intra-class correlation using the icc helper. Expect
#    all three ICCs to be greater than 0.30.
#
# 3. Summarise the three dyad-level moderators. For live_together, build
#    a frequency table and convert it to proportions; expect about 85
#    percent of dyads to have value 1. For years_together, expect a mean
#    near 10 and a range from 1 to 35. For
#    time_spent_this_morning_together, expect a mean near 45 minutes
#    and a range from 0 to 150.
#
# 4. For each of the three outcomes, run a paired t-test against gender
#    using the t.test function with paired set to TRUE. Identify which
#    outcomes show statistically significant gender mean differences.
#    The DGP has alpha_m - alpha_f = +0.15 for engagement, +0.10 for
#    performance, and -0.15 for creativity, so the largest positive gap
#    is on engagement and the largest negative gap is on creativity.
#
# Reflection: which outcome has the largest absolute gender mean
# difference, and does it match the data-generating process intercept
# gap? (The DGP specifies alpha_m minus alpha_f equals plus 0.15 for
# engagement, plus 0.10 for performance, and minus 0.15 for creativity.)


# =============================================================================
# Section 2 — Indistinguishable dyads: multilevel modelling
# =============================================================================
# Reference: scripts/02_indistinguishable_mlm.R
# Outcome: engagement
# Goal: fit the basic APIM in long format, treating dyad members as
#       exchangeable.
#
# 1. Fit the full APIM for engagement. The model includes all three actor
#    predictors (affect, sdt, job_crafting), all three partner predictors
#    (partner_affect, partner_sdt, partner_job_crafting), all three
#    dyad-level moderators (live_together, years_together,
#    time_spent_this_morning_together), and a random intercept for dyad.
#    Use the lmer function from lme4, and save the fitted object as
#    apim_eng. See the apim_mlm model in scripts/02_indistinguishable_mlm.R
#    for the syntax pattern.
#
# 2. Fit a reduced version of the same model that omits the three
#    partner predictors. Use the anova function from lme4 to compare the
#    full and reduced models with a likelihood ratio test. The test
#    tells you whether the partner block is jointly needed.
#
# 3. Compute profile-likelihood confidence intervals using the confint
#    function from lme4 with the profile method.
#
# 4. Write a two-sentence interpretation of the actor and partner
#    effects as a comment after the confint call.
#
# Reflection: is the partner block jointly significant? Does the answer
# match the data-generating process, which has non-zero partner effects
# for all three predictors on engagement?


# =============================================================================
# Section 3 — Indistinguishable dyads: SEM
# =============================================================================
# Reference: scripts/03_indistinguishable_sem.R
# Outcome: creativity
# Goal: fit three structural equation modelling paradigms for
#       indistinguishable dyads, then perform the formal
#       indistinguishability test.
#
# 1. Model A: cluster-robust standard errors model. Specify the
#    regression of creativity on all six predictors plus the three
#    moderators, then use the sem function from lavaan with the cluster
#    argument set to dyad_id. Data is ddl2.
#
# 2. Model B: two-level SEM. Place the six within-dyad predictors at the
#    within level, and the three moderators at the between level. The
#    moderators have no within-dyad variance because they take the same
#    value for both dyad members. Use the sem function with the cluster
#    argument on ddl2.
#
# 3. Model C: wide-format APIM with equality constraints. Use a single
#    parameter label per path (so the actor and partner paths for the
#    same predictor share a label), set equal intercepts across the two
#    dyad members, and set equal residual variances. Fit on ddw2.
#
# 4. Fit an unconstrained wide-format model on ddw2 (separate parameter
#    labels for the actor and partner paths). Then use the lavTestLRT
#    function from lavaan to compare the unconstrained and constrained
#    models. The DGP has equal slopes on creativity across gender, so
#    the test should fail to reject the indistinguishability null.
#
# Reflection: does the likelihood ratio test confirm indistinguishability
# for creativity? What does that imply about the actor-sdt by
# gender-male interaction — is it on engagement only, or could it also
# appear here?


# =============================================================================
# Section 4 — Distinguishable dyads: MLM moderator
# =============================================================================
# Reference: scripts/04_distinguishable_mlm.R
# Outcome: engagement
# Goal: add gender as a moderator of actor and partner effects in a
#       multilevel model.
#
# 1. Fit a baseline multilevel model for engagement with no gender
#    interactions. The structure is the same as the full APIM from
#    Section 2. Use the lmer function from lme4. Save the fitted object
#    as model_base_eng.
#
# 2. Fit the full moderator model. Wrap the six predictors in
#    parentheses and multiply by gender, so that every actor and partner
#    predictor interacts with gender. Keep the three moderators (which
#    have no within-dyad variance) as main effects only. Use the lmer
#    function. Save the fitted object as mod_eng.
#
# 3. Use the anova function from lme4 to compare the baseline model and
#    the full moderator model with a likelihood ratio test.
#
# 4. Use the sim_slopes function from the interactions package to
#    extract the simple slopes of actor_sdt separately for each gender
#    (set johnson_neyman to FALSE). The DGP has only one non-zero
#    gender interaction: actor_sdt × gender_male on engagement (value
#    0.10), so the male simple slope should be visibly steeper than the
#    female simple slope.
#
# Reflection: does the simple-slope plot for actor_sdt by gender show a
# clear male-female difference, in line with the DGP, or do other
# gender interactions appear spuriously significant?


# =============================================================================
# Section 5 — Distinguishable dyads: SEM (two-level with moderation)
# =============================================================================
# Reference: scripts/06_distinguishable_sem_longformat.R
# Outcome: performance
# Goal: mirror the multilevel moderator approach in SEM with calculated
#       simple slopes.
#
# 1. Create a numeric gender indicator in ddl2 by applying the
#    as.numeric function to the gender factor. The result takes value 1
#    for males and value 2 for females. Then create manual interaction
#    columns in ddl2 by multiplying each of the six predictors (the
#    three actor and three partner predictors) by the numeric gender
#    indicator. See scripts/06_distinguishable_sem_longformat.R for the
#    column-naming convention.
#
# 2. For performance, specify a two-level SEM using the sem function
#    from lavaan. Place the gender interactions and the gender main
#    effect at the within level, and the three moderators at the
#    between level. Use named labels on the path coefficients so you
#    can refer to them in the next step.
#
# 3. Add calculated simple-slope parameters using the lavaan defined
#    operator (:=). For each of the six predictors, define two simple
#    slopes: one evaluated at the male value of the gender indicator
#    (1) and one evaluated at the female value (2). The general form
#    is "label := base coefficient + interaction coefficient * gender
#    value".
#
# 4. Fit the model with the sem function and inspect the parameter
#    estimates using the parameterEstimates function from lavaan. The
#    DGP has no gender interactions on performance, so the gender
#    block should be small.
#
# 5. (Optional comparison) Fit a quick MLM for performance with gender
#    interactions using lmer and compare the gender coefficients to
#    those from the SEM.
#
# Reflection: do the SEM gender coefficients agree with the optional
# MLM re-fit on performance? Where do they differ, and is the
# difference substantively meaningful?


# =============================================================================
# Section 6 — Distinguishable dyads: SEM wide format
# =============================================================================
# Reference: scripts/07_distinguishable_sem_wide.R
# Outcome: engagement
# Goal: fit the unconstrained, slopes-equal, and fully-constrained
#       model sequence on the wide-format data, and run the three
#       nested likelihood ratio tests.
#
# 1. For engagement, fit three wide-format SEMs on ddw2 using the sem
#    function from lavaan:
#    a) An unconstrained model, with separate parameter labels for the
#       actor and partner paths.
#    b) A slopes-equal model, with one label per path (so the actor and
#       partner slopes share a label) but free intercepts.
#    c) A fully-constrained model, with equal slopes, equal intercepts,
#       and equal residual variances.
#
# 2. Run the three nested likelihood ratio tests using the lavTestLRT
#    function from lavaan. The three tests are:
#    LRT 1: unconstrained vs slopes-equal (do slopes differ by gender?)
#    LRT 2: slopes-equal vs fully-constrained (do intercepts differ?)
#    LRT 3: unconstrained vs fully-constrained (overall
#           indistinguishability)
#    Report each p-value as a comment.
#
# Reflection: which of the three LRTs is most decisive? Does the
# slope-equality test pick up the actor_sdt × gender_male DGP effect
# in the wide-format SEM?


# =============================================================================
# Section 7 — Two-intercept models
# =============================================================================
# Reference: scripts/05_two_intercept_models.R
# Outcome: creativity
# Goal: use the parameterisation that directly estimates separate
#       intercepts for each gender, and compare it with the SEM
#       analogue.
#
# 1. For creativity, fit three nested multilevel models using the lmer
#    function from lme4:
#    a) Model 1: equal intercepts and equal slopes. This is the same as
#       the full APIM for creativity (six predictors + three moderators
#       + random intercept).
#    b) Model 2: different intercepts but equal slopes. Suppress the
#       global intercept and include gender as a main effect with the
#       0 + gender pattern. This produces two intercepts, one for each
#       gender, and a single set of slopes for the predictors.
#    c) Model 3: different intercepts and different slopes. Suppress the
#       global intercept again, and interact every predictor with gender
#       so each gender has its own slope.
#    Save the fitted objects as m1_creat, m2_creat, m3_creat.
#
# 2. Use the anova function from lme4 to compare the adjacent models
#    with likelihood ratio tests. The first test asks whether the
#    intercepts differ by gender; the second asks whether the slopes
#    differ by gender.
#
# 3. Fit the SEM analogue on ddw2 using the sem function from lavaan.
#    The model has two intercepts (one for each dyad member) and equal
#    slopes. Confirm that the SEM intercepts match the multilevel model
#    intercepts from Model 2. The DGP has alpha_cm = 4.80 and
#    alpha_cf = 4.95 on creativity, so the female intercept should be
#    visibly higher than the male intercept.
#
# Reflection: the two-intercept approach is useful when you want to
# report absolute group means without choosing a reference group. Does
# the creativity model show a substantively interesting mean reversal
# between males and females?


# =============================================================================
# Section 8 — Moderated APIM
# =============================================================================
# Reference: scripts/08_moderated_apim.R
# Outcome: engagement
# Focal interaction: partner_job_crafting x live_together (DGP value 0.15)
# Goal: test whether the partner crossover effect on engagement is
#       moderated by live_together, using both MLM and SEM.
#
# 1. Fit a base multilevel model for engagement (six predictors + three
#    moderators + random intercept, no interaction involving the
#    moderator) and a moderated multilevel model that adds the focal
#    partner_job_crafting x live_together interaction. Use the lmer
#    function from lme4. Save the fitted objects as model_base and
#    model_mod.
#
# 2. For the moderated model, use the sim_slopes function from the
#    interactions package to extract the simple slopes of
#    partner_job_crafting at the two levels of live_together (0 and 1).
#    Use the interact_plot function from the same package to produce a
#    visual. Run the likelihood ratio test using the anova function
#    from lme4 to compare the base and moderated models.
#
# 3. Build the wide-format SEM analogue. Create the product indicator
#    manually in ddw2 by multiplying the relevant partner-side
#    job_crafting column by the live_together column. Then fit the
#    wide-format model with the sem function from lavaan, including the
#    product indicator as an additional predictor, and add calculated
#    simple-slope parameters using the lavaan := operator. Compare the
#    simple-slope estimates with the multilevel estimates from step 2.
#
# Reflection: do the multilevel and SEM simple-slope estimates agree?
# Where do they differ, and is the difference larger for the binary
# moderator (live_together) than you would expect for a continuous
# moderator?


# =============================================================================
# Section 9 — Integrative exercise
# =============================================================================
# Reference: synthesis of sections 2 through 8. Use scripts/02 through
#            scripts/08 as needed for syntax.
# Outcome: YOUR CHOICE (one of engagement, performance, creativity).
#          State in a comment which outcome you chose and why.
# Goal: answer a single, fully-specified research question by combining
#       everything you have learned.
#
# 1. State which outcome you chose as a comment.
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
#    multiplying the relevant columns. Fit the model and add
#    calculated simple-slope parameters at three levels of the
#    moderator: minus one standard deviation, the empirical mean, and
#    plus one standard deviation (for the binary live_together, use 0
#    and 1). Save the fitted object as final_sem.
#
# 4. Report the following as comments after each step:
#    a. The point estimates and standard errors for the actor and
#       partner effects.
#    b. The focal interaction coefficient from both the multilevel and
#       SEM approaches.
#    c. The three simple slopes of the partner predictor at low, mean,
#       and high levels of the moderator.
#    d. The fit indices of the SEM (use the fitMeasures function from
#       lavaan).
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
