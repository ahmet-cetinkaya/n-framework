#!/usr/bin/env bash

set -euo pipefail

_HELPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=packages/acore-scripts/src/logger.sh
source "${_HELPER_DIR}/../../packages/acore-scripts/src/logger.sh"

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
