#!/usr/bin/env bash

REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ACORE_SCRIPTS="${REPO_ROOT}/packages/acore-scripts/src"

# shellcheck source=packages/acore-scripts/src/logger.sh
source "${ACORE_SCRIPTS}/logger.sh"
