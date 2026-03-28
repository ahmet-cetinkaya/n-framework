#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./common.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

cd "$REPO_ROOT"

acore_log_section "🔧 Fixing code style violations..."

for slnx_file in $(fd -e slnx . "$REPO_ROOT"); do
	acore_log_info "📋 Formatting $(basename "$slnx_file")..."
	dotnet format "$slnx_file"
done

acore_log_section "🎨 Formatting C# code with CSharpier..."
dotnet csharpier format .

acore_log_section "✨ Formatting text files with Prettier..."
bun prettier --write "**/*.{md,json,yml,yaml,css,html,ts,js,tsx,jsx}"

acore_log_section "🐚 Formatting shell scripts with shfmt..."
fd -e sh -t f . "$REPO_ROOT/scripts" | xargs -d '\n' shfmt -w -sr -ci -ln bash

acore_log_success "✅ Formatting complete!"
