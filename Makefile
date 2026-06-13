# Makefile for the EAOHP 2026 APIM Workshop website
# ----------------------------------------------
#
# Usage:
#   make preview    - Live-reload local preview (opens in browser)
#   make site       - Build the static site into docs/
#   make clean      - Remove build artefacts and freeze cache
#   make deps       - Install the R packages required by the scripts
#   make data       - (Re)generate the simulated datasets
#   make bundle     - Build the offline workshop bundle (delegates to bundle_workshop.sh)
#
# All targets run from the repository root.

.PHONY: help preview site clean deps data bundle

# Path to the Quarto project (the website lives in docs/)
QUARTO_DIR := docs

help:
	@echo "EAOHP 2026 APIM Workshop — make targets"
	@echo ""
	@echo "  make preview   Live-reload local preview"
	@echo "  make site      Build the static site into $(QUARTO_DIR)/"
	@echo "  make clean     Remove build artefacts and freeze cache"
	@echo "  make deps      Install the R packages required by the scripts"
	@echo "  make data      (Re)generate the simulated datasets"
	@echo "  make bundle    Build the offline workshop bundle"
	@echo ""

preview:
	quarto preview $(QUARTO_DIR)

site:
	quarto render $(QUARTO_DIR)

clean:
	rm -rf $(QUARTO_DIR)/_freeze
	rm -rf $(QUARTO_DIR)/_site
	find $(QUARTO_DIR) -name "*.html" -not -path "*/index.qmd" -delete 2>/dev/null || true
	@echo "Cleaned freeze cache and rendered HTML in $(QUARTO_DIR)/"

deps:
	Rscript -e 'install.packages(c("lme4","lmerTest","lavaan","dplyr","interactions","semPlot","knitr","rmarkdown"), repos = "https://cloud.r-project.org")'

data:
	Rscript scripts/01_simulate_data.R
	Rscript exercises/simulate_exercise_data.R

bundle:
	./bundle_workshop.sh
