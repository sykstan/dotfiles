#!/usr/bin/env bash

# NOTE: Assumes github repo name and folder name are the same
# typical usage:
# ./clone_all_repos.sh ~/repos
# ./clone_all_repos.sh ~/localfiles
set -euo pipefail

# Add repos here as the list grows
REPOS=(
    https://github.com/sykstan/dotfiles.git
    https://github.com/Bunnings-Data-and-Analytics/edp-airflow-dags.git
    https://github.com/Bunnings-Data-and-Analytics/edp-dbt.git
    https://github.com/Bunnings-Data-and-Analytics/edp-snowflake.git
    https://github.com/Bunnings-Data-and-Analytics/ao-merchandising-mdo-backend.git
    https://github.com/Bunnings-Data-and-Analytics/ds-merchandising-mdo-frontend.git
    https://github.com/Bunnings-Data-and-Analytics/ao-consumer-flybuys-rfm-segmentation.git
    https://github.com/Bunnings-Data-and-Analytics/ao-merchandising-weather-model.git
    https://github.com/Bunnings-Data-and-Analytics/ao-commercial-quotes-intelligence-tool.git
    https://github.com/Bunnings-Data-and-Analytics/ao-attribute-pipeline.git
    https://github.com/Bunnings-Data-and-Analytics/ao-consumer-flybuys-demographic-models.git
    https://github.com/Bunnings-Data-and-Analytics/ds-all-seeing-eye.git
    https://github.com/Bunnings-Data-and-Analytics/ds-census-upload.git
    https://github.com/Bunnings-Data-and-Analytics/ao-dynadaily-tactical-migration.git
    https://github.com/Bunnings-Data-and-Analytics/dna-terraform-modules.git
)

# CLONE_DIR="${1:-$HOME/repos}"
# default to AML names
CLONE_DIR="${1:-$HOME/localfiles/}"
mkdir -p "$CLONE_DIR"

for repo in "${REPOS[@]}"; do
    name="${repo##*/}"  # strip everything before last /
    name="${name%.git}" # strip .git suffix
    dest="$CLONE_DIR/$name"

    if [[ -d "$dest" ]]; then
        echo "[skip] $name already exists"
    else
        echo "[clone] $name"
        git clone "$repo" "$dest"
    fi
done

# clone personal skills repo (if not already present)
if [[ -d "$HOME/.agents/.git" ]]; then
    echo "[skip] .agents already exists"
else
    echo "[clone] skagcon → ~/.agents"
    git clone https://github.com/sykstan/skagcon.git "$HOME/.agents"
fi

# setup the repo (idempotent — safe to re-run)
bash "$HOME/.agents/scripts/setup.sh"
