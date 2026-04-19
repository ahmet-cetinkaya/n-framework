#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../packages/acore-scripts/src/logger.sh"

acore_log_info "🔄 Updating all submodules to main branch..."

git submodule update --init --recursive --remote

while IFS= read -r line; do
	path=$(echo "$line" | sed 's/^[a-f0-9]* //' | cut -d' ' -f1)
	if [ -n "$path" ] && [ -d "$path" ]; then
		acore_log_info "  ↪ Updating $path"
		(cd "$path" && git checkout main && git pull origin main) || true
	fi
done < <(git submodule status)

acore_log_divider
acore_log_info "📋 Submodule status:"
git submodule status
acore_log_success "✅ All submodules updated to main!"
