# Dyadic Data Analysis in R

> Learn how to model two-person data correctly — when the people in your study are not independent.

🌐 **Live site:** <https://michaelides.github.io/apim/>

## About

The Actor–Partner Interdependence Model (APIM) is the standard framework for analysing data in which two people's responses are inherently linked — romantic partners, parent–child dyads, coworkers, doctor–patient encounters, even dyadic experiments. This site is a complete, hands-on guide to estimating, interpreting, and reporting APIMs in R, using both multilevel models (with `lme4`) and structural equation models (with `lavaan`).

It separates two kinds of effects:

- **Actor effects** — the effect of *my* characteristic on *my* outcome.
- **Partner effects** — the effect of *my* characteristic on *my partner's* outcome.

The materials were originally developed for the EAOHP 2026 conference workshop *Dyadic Data Analysis Using R*.

## What's in this repo

- `docs/` — the Quarto website (foundations, tutorials, exercises, data, references)
- `scripts/` — 8 R scripts covering simulation and analysis: `01_simulate_data.R` through `08_moderated_apim.R`
- `data/` — pre-generated simulated datasets (`dyad_data.RData`, `exercise_data.RData`)
- `exercises/` — exercise problem set, simulation script, and answer template
- `Makefile` — convenience targets for installing packages, building, and bundling the site

## Prerequisites

- Familiarity with multilevel (random-effects) models
- Familiarity with structural equation models
- Basic working knowledge of `lme4` and `lavaan` in R

## Quick start

```bash
make deps      # install R packages
make preview   # live-reload preview at http://localhost:4200
```

To build the static site (output goes to `docs/` for GitHub Pages):

```bash
make site
```

The site is published from the `docs/` directory of this repository to <https://michaelides.github.io/apim/>.

## Citing

If you use these materials in your teaching or research, please cite the site as:

> Michaelides, G. (2026). *Dyadic Data Analysis in R.* Online at <https://michaelides.github.io/apim/>. CC BY 4.0.

## License

- Written material: CC BY 4.0 — see [LICENSE](LICENSE)
- R code: MIT — see [LICENSE-MIT](LICENSE-MIT)

## Author

George Michaelides. The simulation data structures emulate Hahn, Binnewies, & Dormann (2014). See the [References](https://michaelides.github.io/apim/references/) page on the live site for the full reading list.
