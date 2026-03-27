#!/usr/bin/env bash
# Prepare the development environment.
# Ensures submodules, tool availability, dotfile sync, and npm deps.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./common.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

ensure_submodules
ensure_dotfiles
ensure_tools

acore_log_success "✨ Dev environment ready!"
