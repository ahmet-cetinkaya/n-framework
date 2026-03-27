#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ACORE_SCRIPTS="${REPO_ROOT}/packages/acore-scripts/src"

# shellcheck source=../packages/acore-scripts/src/logger.sh
# shellcheck disable=SC1091
source "${ACORE_SCRIPTS}/logger.sh"

ensure_submodules() {
	acore_log_section "📦 Initializing git submodules..."
	git -C "${REPO_ROOT}" submodule update --init --recursive --quiet
	acore_log_success "✅ Submodules ready."
}

ensure_tools() {
	acore_log_section "🔧 Checking required tools..."

	local missing=()

	if ! command -v dotnet &> /dev/null; then
		missing+=("dotnet (.NET SDK) - for .NET development and tool restore")
	fi
	if ! command -v cargo &> /dev/null; then
		missing+=("cargo (Rust) - for Rust project development and building")
	fi
	if ! command -v go &> /dev/null; then
		missing+=("go - for Go project development and building")
	fi
	if ! command -v bun &> /dev/null; then
		missing+=("bun - for npm dependency management")
	fi
	if ! command -v fd &> /dev/null; then
		missing+=("fd - for fast file finding with respect gitignore in scripts")
	fi
	if ! command -v shfmt &> /dev/null; then
		missing+=("shfmt - for shell script formatting")
	fi
	if ! command -v shellcheck &> /dev/null; then
		missing+=("shellcheck - for shell script linting")
	fi

	if [ ${#missing[@]} -gt 0 ]; then
		acore_log_error "❌ Missing required tools:"
		for tool in "${missing[@]}"; do
			acore_log_error "   - $tool"
		done
		return 1
	fi

	acore_log_info "⬇️ Restoring .NET tools..."
	dotnet tool restore --verbosity quiet

	acore_log_info "📦 Installing npm dependencies..."
	bun install --silent

	acore_log_success "✅ Tools ready."
}

ensure_dotfiles() {
	local src_dir="${REPO_ROOT}/src"

	if [ ! -d "$src_dir" ]; then
		return 0
	fi

	acore_log_section "📄 Syncing dotfiles to src/ subprojects..."

	for project in "$src_dir"/*/; do
		[ -d "$project" ] || continue
		local name
		name="$(basename "$project")"

		if [ -f "${REPO_ROOT}/LICENSE" ]; then
			if [ ! -f "${project}LICENSE" ] || ! cmp -s "${REPO_ROOT}/LICENSE" "${project}LICENSE"; then
				cp "${REPO_ROOT}/LICENSE" "${project}LICENSE"
				acore_log_success "✅ LICENSE → ${name}"
			fi
		fi

		local is_csharp=false
		if fd -e csproj -d 4 -1 . "$project" &> /dev/null; then
			is_csharp=true
		fi

		if [ "$is_csharp" = true ]; then
			for file in .csharpierrc .editorconfig; do
				if [ -f "${REPO_ROOT}/${file}" ]; then
					if [ ! -f "${project}${file}" ] || ! cmp -s "${REPO_ROOT}/${file}" "${project}${file}"; then
						cp "${REPO_ROOT}/${file}" "${project}${file}"
						acore_log_success "✅ ${file} → ${name}"
					fi
				fi
			done
		fi
	done
}

init_environment() {
	ensure_submodules
	ensure_dotfiles
	ensure_tools
}
