#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../packages/acore-scripts/src/logger.sh"

acore_log_info "Running tests for all projects..."

# Find all Makefiles in src/ that have a test target (only top-level src/* projects)
for makefile in $(find src -maxdepth 2 -name 'Makefile' -type f 2>/dev/null | sort); do
	project_dir=$(dirname "$makefile")

	if grep -q '^test:' "$makefile" 2>/dev/null; then
		acore_log_section "$project_dir"
		(cd "$project_dir" && make test)
	fi
done

acore_log_success "All tests completed."
