#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./common.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

init_environment

cd "$REPO_ROOT"

acore_log_section "🔍 Linting shell scripts with shellcheck..."
mapfile -t shellcheck_scripts < <(fd -e sh -t f . "$REPO_ROOT/scripts")
if [ ${#shellcheck_scripts[@]} -eq 0 ]; then
	acore_log_warning "No shell scripts found."
	exit 0
fi
shellcheck "${shellcheck_scripts[@]}"

acore_log_section "🔍 Linting markdown files with markdownlint-cli2..."
mapfile -t markdown_files < <(fd -e md -t f . "$REPO_ROOT")
if [ ${#markdown_files[@]} -eq 0 ]; then
	acore_log_warning "No markdown files found."
	exit 0
fi
bun run markdownlint-cli2 --fix "${markdown_files[@]}"

acore_log_success "✨ Linting complete!"
