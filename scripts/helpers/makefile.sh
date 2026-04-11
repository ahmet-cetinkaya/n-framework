#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../packages/acore-scripts/src/logger.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../../packages/acore-scripts/src/logger.sh"

REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

ensure_project_scripts() {
	local project_dir="$1"
	local project_name
	project_name="$(basename "${project_dir}")"

	mkdir -p "${project_dir}scripts"

	for script in setup build test; do
		local script_path="${project_dir}scripts/${script}.sh"
		if [[ ! -f "${script_path}" ]]; then
			cat > "${script_path}" << EOF
#!/usr/bin/env bash
set -euo pipefail
echo "Error: ${script} not implemented yet" >&2
exit 1
EOF
			chmod +x "${script_path}"
			acore_log_info "Created ${script}.sh for ${project_name}"
		fi
	done
}

ensure_project_makefiles() {
	for project_dir in "${REPO_ROOT}"/src/*/; do
		local project_name
		project_name="$(basename "${project_dir}")"
		local project_makefile="${project_dir}Makefile"

		ensure_project_scripts "${project_dir}"

		if [[ ! -f "${project_makefile}" ]]; then
			cat > "${project_makefile}" << EOF
SHELL := bash

.PHONY: setup format lint test build help

setup:
	./scripts/setup.sh

format:
	./scripts/format.sh

lint:
	./scripts/lint.sh

test:
	./scripts/test.sh

build:
	./scripts/build.sh

help:
	@echo "Available targets:"
	@echo "  make setup   - Setup development environment"
	@echo "  make format - Format code"
	@echo "  make lint   - Run linter"
	@echo "  make test   - Run tests"
	@echo "  make build  - Build project"
	@echo "  make help   - Show this help message"
EOF
			acore_log_info "Created Makefile for ${project_name}"
		fi
	done
}
