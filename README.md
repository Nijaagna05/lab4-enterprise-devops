# Lab 4 – Advanced Deployment Strategies & Enterprise DevOps

**Student:** Upadhyayula Nijaagna  
**Roll No.:** 2301730196  
**Course:** ENSP461 – DevOps and Automation Lab

## Project
A small Flask service used to demonstrate automated testing, containerization, Kubernetes deployment patterns, GitOps configuration, secret handling, and disaster recovery.

> This repository contains implementation templates and reproducible procedures. Run them in the faculty-approved lab environment and add your own screenshots, logs, and observations before submission. Do not claim a deployment succeeded unless you executed and verified it.

## Architecture
- GitHub Actions: CI pipeline (lint/basic checks, unit tests, image build)
- Docker: container image
- Kubernetes: application deployment and service
- Blue-Green: two Deployments selected by a Service selector
- Canary: stable and canary Deployments with weighted traffic via ingress/controller or a documented selector-based lab simulation
- Argo CD: GitOps reconciliation
- Kubernetes Secrets / GitHub Actions secrets: credentials
- Disaster recovery: namespace resource backup/export and restore scripts

## Repository layout
```text
.
├── app/                    # Flask service
├── tests/                  # pytest tests
├── .github/workflows/      # CI pipeline
├── docker/                 # Dockerfile
├── k8s/
│   ├── base/               # common Kubernetes resources
│   ├── blue-green/         # blue/green deployments and switch scripts
│   ├── canary/              # stable/canary resources
│   └── argocd/              # Argo CD Application
├── scripts/                # backup, restore, DR verification
├── docs/                   # report template and evidence checklist
└── .env.example             # non-secret configuration example
```

## Run locally
```bash
python -m venv .venv
# Windows PowerShell: .venv\Scripts\Activate.ps1
# Linux/macOS: source .venv/bin/activate
pip install -r requirements.txt
pytest -v
python -m app.main
```
Open `http://127.0.0.1:5000/` and `http://127.0.0.1:5000/health`.

## Build container
```bash
docker build -f docker/Dockerfile -t lab4-devops-app:1.0 .
docker run --rm -p 5000:5000 lab4-devops-app:1.0
```

## Kubernetes
Use a working Kubernetes cluster and `kubectl` context approved by faculty.
```bash
kubectl apply -f k8s/base/
kubectl get deploy,svc,pods
```
Blue-Green and Canary instructions are in `docs/IMPLEMENTATION_GUIDE.md`.

## GitOps with Argo CD
Install Argo CD according to its official documentation and update `repoURL` in `k8s/argocd/application.yaml` to this repository URL. Then apply the Application manifest. Argo CD should report sync/health status after it can access the repository.

## Secrets
Never commit real credentials. Create secrets at runtime:
```bash
kubectl create secret generic lab4-app-secret \
  --from-literal=APP_API_TOKEN='replace-with-a-real-value'
```
The literal above is a placeholder. Prefer a secret manager or CI secret store. See `docs/IMPLEMENTATION_GUIDE.md`.

## Disaster recovery
See `scripts/backup.sh`, `scripts/restore.sh`, and `docs/DR_PLAN.md`. These scripts export Kubernetes namespace resources as YAML; they are a lab demonstration, not a substitute for persistent-volume/database backups.

## Before submission
- [ ] Run tests and save actual output.
- [ ] Build and run the Docker image.
- [ ] Apply manifests to the approved cluster.
- [ ] Demonstrate blue-green switch and rollback.
- [ ] Demonstrate canary rollout and rollback trigger.
- [ ] Configure Argo CD and capture sync status.
- [ ] Create a secret without committing its value.
- [ ] Run backup/restore test and record recovery time.
- [ ] Add screenshots and observations under `evidence/`.
- [ ] Replace placeholders (especially Argo CD repo URL and image registry).
