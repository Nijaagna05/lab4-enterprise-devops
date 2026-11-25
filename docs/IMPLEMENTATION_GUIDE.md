# Implementation Guide

## 1. Local test and container
```bash
pip install -r requirements.txt
pytest -v
docker build -f docker/Dockerfile -t lab4-devops-app:1.0 .
docker run --rm -p 5000:5000 lab4-devops-app:1.0
```
Capture your own terminal output and browser/API response.

## 2. Kubernetes base deployment
Build/load or push the image so the cluster can pull it. The sample image name is local and may need changing to a registry path.
```bash
kubectl apply -f k8s/base/namespace.yaml
kubectl create secret generic lab4-app-secret -n lab4 --from-literal=APP_API_TOKEN='your-test-token'
kubectl apply -f k8s/base/deployment.yaml
kubectl rollout status deployment/lab4-app -n lab4
kubectl get pods,svc -n lab4
```

## 3. Blue-Green
The example uses two separate Deployments and one Service. Ensure both images are available to the cluster.
```bash
kubectl apply -f k8s/base/namespace.yaml
kubectl apply -f k8s/blue-green/blue.yaml
kubectl apply -f k8s/blue-green/green.yaml
kubectl rollout status deployment/app-blue -n lab4
kubectl rollout status deployment/app-green -n lab4
bash scripts/blue-green-switch.sh lab4 green
# Roll back traffic:
bash scripts/blue-green-switch.sh lab4 blue
```
This switches the Service selector after the target Deployment is ready. Demonstrate zero-downtime by repeatedly requesting the Service during the switch and recording results. A local cluster may require port-forwarding or an Ingress to reach the Service.

## 4. Canary
The included stable/canary Deployment ratio (9:1) illustrates a 10% canary *pod share*, not guaranteed 10% user traffic. Kubernetes Service routing is not a precise weighted traffic controller. For real weighted traffic, install an Ingress/service-mesh controller that supports traffic weights (for example, an approved NGINX canary Ingress, Argo Rollouts, or service mesh) and configure 90/10, then 50/50, then 0/100 after observing metrics.
```bash
kubectl apply -f k8s/canary/
kubectl get pods -n lab4 -l app=lab4-canary-demo
```
Rollback by scaling canary to zero:
```bash
kubectl scale deployment app-canary -n lab4 --replicas=0
```
Example rollback triggers to document: elevated 5xx rate, latency above agreed SLO, failed readiness probes, or crash-looping pods.

## 5. GitOps / Argo CD
1. Install Argo CD in the cluster using the official installation instructions.
2. Replace the repository URL placeholder in `k8s/argocd/application.yaml`.
3. Ensure `k8s/base` contains the desired state and the repo is reachable by Argo CD.
4. Apply the Application manifest:
```bash
kubectl apply -f k8s/argocd/application.yaml
kubectl get applications -n argocd
```
Change a replica count or image tag in Git, commit and push, then observe Argo CD sync/reconcile. With automated self-heal enabled, manually drift a live resource and observe it return to Git state. Capture actual sync status.

## 6. Secret management
- Store CI credentials in GitHub repository Settings → Secrets and variables → Actions.
- Reference them in workflow steps via `${{ secrets.SECRET_NAME }}`; never echo them.
- Create Kubernetes Secret at runtime as shown above, or integrate an approved vault/external-secrets operator.
- Do not commit real secret values, `.env` files, kubeconfig files, or tokens.
- Kubernetes Secrets are base64-encoded by default, not encrypted merely by being stored as Secret objects. Enable encryption at rest and restrict RBAC in a real deployment.

## 7. Disaster recovery
Run `bash scripts/backup.sh lab4`, verify the YAML file exists, then perform a controlled test in a disposable namespace/cluster. Restore with `bash scripts/restore.sh <backup-file>`. Record RPO, RTO, backup time, restore time, and validation results in `docs/DR_PLAN.md`.
