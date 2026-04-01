#!/usr/bin/env bash
# Prepare the development environment.
# Ensures submodules, tool availability, dotfile sync, and npm deps.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../packages/acore-scripts/src/logger.sh"

# shellcheck source=./helpers/submodules.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/helpers/submodules.sh"

# shellcheck source=./helpers/dotfiles.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/helpers/dotfiles.sh"

# shellcheck source=./helpers/tools.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/helpers/tools.sh"

# shellcheck source=./helpers/sync.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/helpers/sync.sh"

ensure_submodules
sync_dotfiles
ensure_tools
sync_scripts

acore_log_success "✨ Dev environment ready!"
