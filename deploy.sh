#!/bin/bash

# Exit on error, undefined vars, and pipe failures
set -euo pipefail

# Get the directory where the script is located
DEPLOY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_BRANCH="${1:-main}"

echo "========================================="
echo " Global-Proxy — Manual Deployment"
echo " Branch  : ${DEPLOY_BRANCH}"
echo " $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo "========================================="

# ── Checkout the requested branch on VPS ──────────────────────────
echo ">>> Fetching and checking out '${DEPLOY_BRANCH}'..."
cd "${DEPLOY_DIR}"
git fetch origin
git checkout "${DEPLOY_BRANCH}"
git pull origin "${DEPLOY_BRANCH}"

# ── Restart the proxy ──────────────────────────────────────────────
echo ">>> Updating and restarting Caddy..."
docker compose up -d --remove-orphans

echo ">>> Container status:"
docker compose ps

echo ""
echo ">>> Deployment complete!"
