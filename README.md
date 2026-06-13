# PHP Demo App — GitOps with ArgoCD

A containerized PHP web application deployed using a full GitOps pipeline with **Docker**, **GitHub Actions**, and **ArgoCD** on Kubernetes.

---

## 📐 Architecture Overview

```
Developer → GitHub Push
                ↓
        GitHub Actions CI
        (Build & Push Docker Image)
                ↓
        Docker Hub / GHCR
                ↓
        ArgoCD detects new image tag
        (watches this repo's k8s/ manifests)
                ↓
        Kubernetes Cluster auto-updated
```

---

## 📁 Project Structure

```
php-demo-app/
├── .github/
│   └── workflows/
│       └── docker-publish.yml   # CI/CD pipeline
├── k8s/
│   ├── deployment.yaml          # Kubernetes Deployment
│   ├── service.yaml             # Kubernetes Service
│   └── argocd-app.yaml          # ArgoCD Application manifest
├── Dockerfile                   # Container definition
├── docker-compose.yml           # Local development setup
├── health.php                   # Health check endpoint
├── index.php                    # Main application
└── README.md
```

---

## 🚀 Running Locally

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) installed

### With Docker Compose (recommended)

```bash
# Clone the repository
git clone https://github.com/IS2022U/php-demo-app.git
cd php-demo-app

# Start the application
docker compose up -d

# Visit the app
open http://localhost:8080

# Check health endpoint
curl http://localhost:8080/health.php

# Stop the application
docker compose down
```

### With Docker only

```bash
# Build the image
docker build -t php-demo-app .

# Run the container
docker run -d -p 8080:80 --name php-demo-app php-demo-app

# Stop and remove
docker stop php-demo-app && docker rm php-demo-app
```

---

## ⚙️ CI/CD Pipeline (GitHub Actions)

The pipeline is defined in `.github/workflows/docker-publish.yml` and runs automatically on every push to `main`.

**Pipeline Steps:**
1. Checkout code
2. Log in to Docker Hub (using GitHub Secrets)
3. Build the Docker image
4. Run a smoke test (verifies the container starts and responds)
5. Push the image with both `latest` and a `sha`-based tag
6. Update the image tag in `k8s/deployment.yaml`
7. ArgoCD detects the change and syncs to the cluster

**Required GitHub Secrets:**

| Secret | Description |
|---|---|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Your Docker Hub access token |

Go to: `Settings → Secrets and variables → Actions → New repository secret`

---

## ☸️ Kubernetes Deployment

Manifests are in the `k8s/` folder and are managed by ArgoCD.

```bash
# Apply manually (optional — ArgoCD does this automatically)
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Check pod status
kubectl get pods -n default

# Check service
kubectl get svc php-demo-app
```

---

## 🔄 ArgoCD GitOps

ArgoCD watches this repository and automatically syncs any changes to `k8s/` to the cluster.

**Install ArgoCD (if not already installed):**
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

**Register the app:**
```bash
kubectl apply -f k8s/argocd-app.yaml
```

**Access the ArgoCD UI:**
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Visit: https://localhost:8080
```

---

## 🏥 Health Check

The app exposes a `/health.php` endpoint that returns JSON:

```bash
curl http://localhost:8080/health.php
# {"status":"ok","hostname":"...","time":"...","version":"2.0"}
```

---

## 📌 Versions

| Version | Description |
|---|---|
| 1.0 | Initial Docker deployment |
| 2.0 | ArgoCD GitOps automated deployment |

---

## 👤 Author

**IS2022U** 
