#!/usr/bin/env bash

set -euo pipefail

_HELPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=packages/acore-scripts/src/logger.sh
source "${_HELPER_DIR}/../../packages/acore-scripts/src/logger.sh"

REPO_ROOT="$(cd "${_HELPER_DIR}/../.." && pwd)"

ensure_submodules() {
	if [ ! -f "${REPO_ROOT}/.gitmodules" ]; then
		acore_log_success "✅ No submodules to initialize."
		return 0
	fi

	if git -C "${REPO_ROOT}" submodule status --recursive 2> /dev/null | grep -q '^[-+]'; then
		acore_log_section "📦 Initializing git submodules..."
		git -C "${REPO_ROOT}" submodule update --init --recursive --quiet
	else
		acore_log_success "✅ Submodules already initialized."
	fi
}
