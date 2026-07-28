#!/bin/bash
# update-image.sh — Updates image tag in Kustomize manifests for a given service
# Usage: ./scripts/update-image.sh <service-name> <new-tag>
# Example: ./scripts/update-image.sh api-gateway abc123f

set -euo pipefail

SERVICE="$1"
TAG="${2:-latest}"
DEPLOY_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BASE_DIR="${DEPLOY_DIR}/base/${SERVICE}"

if [ ! -f "${BASE_DIR}/kustomization.yaml" ]; then
    echo "ERROR: No kustomization.yaml found at ${BASE_DIR}/kustomization.yaml"
    exit 1
fi

echo "Updating ${SERVICE} image tag to ${TAG}..."

cd "${BASE_DIR}"
kustomize edit set image "ghcr.io/ayushquasar/${SERVICE}=ghcr.io/ayushquasar/${SERVICE}:${TAG}"

echo "Done. Updated ${SERVICE} -> ghcr.io/ayushquasar/${SERVICE}:${TAG}"
