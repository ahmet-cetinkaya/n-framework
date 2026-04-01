#!/usr/bin/env bash

set -euo pipefail

_HELPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=packages/acore-scripts/src/logger.sh
source "${_HELPER_DIR}/../../packages/acore-scripts/src/logger.sh"

REPO_ROOT="$(cd "${_HELPER_DIR}/../.." && pwd)"

sync_dotfiles() {
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
		local has_shell=false
		local has_markdown=false

		if [ -n "$(fd -e csproj -d 4 . "$project" 2> /dev/null)" ]; then
			is_csharp=true
		fi
		if fd -e sh -t f . "$project" &> /dev/null; then
			has_shell=true
		fi
		if fd -e md -t f . "$project" &> /dev/null; then
			has_markdown=true
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

		if [ "$has_shell" = true ]; then
			if [ -f "${REPO_ROOT}/.shellcheckrc" ]; then
				if [ ! -f "${project}.shellcheckrc" ] || ! cmp -s "${REPO_ROOT}/.shellcheckrc" "${project}.shellcheckrc"; then
					cp "${REPO_ROOT}/.shellcheckrc" "${project}.shellcheckrc"
					acore_log_success "✅ .shellcheckrc → ${name}"
				fi
			fi
		fi

		if [ "$has_markdown" = true ]; then
			for file in .markdownlint-cli2.jsonc .prettierrc .prettierignore; do
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
