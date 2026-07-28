# AuraStore Deployments
Kubernetes manifests managed by ArgoCD for the AuraStore microservice platform.

## Structure

```
├── base/                    # Base Kustomize manifests
│   ├── namespace.yaml       # production-retail namespace + ServiceAccounts
│   ├── infrastructure/      # PostgreSQL, Redis, Kafka, Zookeeper
│   ├── api-gateway/         # API Gateway (Spring Cloud Gateway)
│   ├── auth-service/        # Authentication service
│   ├── catalog-service/     # Catalog service + canary deployment
│   ├── order-service/       # Order processing service
│   ├── history-service/     # Order history service
│   └── storefront/          # React + Express storefront
├── overlays/
│   └── production/          # Production overlay (ingress, HPA)
├── monitoring/              # Prometheus ServiceMonitors, AlertRules, Grafana dashboard
├── istio/                   # Istio ambient mesh: waypoint, HTTPRoutes, DestinationRules, Jaeger
├── argocd/                  # ArgoCD Application resources
└── scripts/                 # Image update utilities
```

## Image Registry

Application images: `ghcr.io/ayushquasar/<service>:<tag>`

| Service | Image | Port |
|---------|-------|------|
| api-gateway | ghcr.io/ayushquasar/api-gateway | 8080 |
| auth-service | ghcr.io/ayushquasar/auth-service | 8081 |
| catalog-service | ghcr.io/ayushquasar/catalog-service | 8082 |
| order-service | ghcr.io/ayushquasar/order-service | 8083 |
| history-service | ghcr.io/ayushquasar/history-service | 8084 |
| storefront | ghcr.io/ayushquasar/storefront | 3000 |

## ArgoCD Applications

| Application | Path | Description |
|------------|------|-------------|
| aurastore-infrastructure | base/infrastructure | PostgreSQL, Redis, Kafka |
| aurastore-apps | overlays/production | All application services + ingress |
| aurastore-istio | istio | Istio mesh config, Jaeger, traffic splitting |
| aurastore-monitoring | monitoring | Prometheus scrape configs, alerts, Grafana |

## CI/CD Flow

1. Push to `main` in source repo triggers GitHub Actions
2. GitHub Actions builds changed services and pushes to ghcr.io
3. GitHub Actions updates image tags in this repo
4. ArgoCD detects changes and syncs to cluster

## Manual Image Update

```bash
./scripts/update-image.sh <service-name> <git-sha>
git add -A && git commit -m "chore: update <service>" && git push
```
