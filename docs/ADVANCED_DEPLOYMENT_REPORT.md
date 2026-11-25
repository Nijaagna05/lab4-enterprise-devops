# Advanced Deployment Strategies & Enterprise DevOps Report

**Student:** Upadhyayula Nijaagna  
**Roll No.:** 2301730196  
**Course:** ENSP461 – DevOps and Automation Lab  
**Project:** Enterprise DevOps Deployment Platform

## 1. Objective
The objective is to create a repeatable software delivery workflow with automated tests, container packaging, Kubernetes deployment, controlled releases, GitOps reconciliation, protected secrets, monitoring hooks, and a documented recovery process.

## 2. CI/CD and automated testing
GitHub Actions checks out source code, installs dependencies, runs pytest, and builds the Docker image only after tests pass. The test job acts as a deployment gate: a failed test prevents the dependent build job from running. A production workflow should add integration tests, dependency scanning, image scanning, signed artifacts, and a controlled deployment approval.

## 3. Strategy comparison

| Strategy | Mechanism | Strengths | Limitations / risks |
|---|---|---|---|
| Blue-Green | Maintain two equivalent environments; switch Service/Ingress traffic after validation | Fast cutover and rollback; pre-production validation | Requires duplicate capacity; database/schema compatibility and stateful sessions need planning |
| Canary | Route a small share of traffic to a new version, then increase gradually | Limits blast radius; validates with real traffic | Needs reliable traffic splitting, metrics, and rollback automation; more operational complexity |
| GitOps | Git stores desired declarative state; controller reconciles cluster to Git | Audit trail, repeatability, drift correction | Controller/repository access becomes critical; secrets and emergency changes need governance |
| Secret management | Store credentials in a dedicated secret store and inject at runtime | Reduces hard-coded credentials; rotation and access control | Misconfigured RBAC, leaked logs, or unencrypted storage can expose secrets |
| Disaster recovery | Back up configuration and data; restore or fail over to a secondary environment | Improves recoverability and business continuity | Backups may be incomplete or stale; restore time and data consistency must be tested |

## 4. Risk analysis and mitigations
- **Failed release:** readiness/liveness probes, automated tests, staged rollout, and rollback.
- **Canary regression:** define error-rate and latency thresholds; stop rollout and revert when thresholds are exceeded.
- **GitOps drift:** enable reconciliation, restrict direct cluster changes, and audit emergency overrides.
- **Credential leakage:** use GitHub Actions secrets or a vault, least privilege, rotation, and log masking; never commit credentials.
- **Data loss:** back up persistent data separately, keep off-site copies, and run scheduled restore drills.
- **Insufficient capacity:** reserve capacity for parallel blue/green environments and monitor resource usage.

## 5. Recovery objectives
The sample DR plan proposes RPO of 24 hours for configuration and RTO of 30 minutes for application-resource recovery. These are targets only. Actual RPO/RTO must be measured in a restore drill and documented in `DR_PLAN.md`.

## 6. Evidence to attach
Add genuine evidence from your own execution:
1. GitHub Actions successful test/build run and a failed-test gate example if possible.
2. Docker build and running container output.
3. Kubernetes pods and service output.
4. Blue-to-green switch and rollback output.
5. Canary replica/traffic progression and metrics or controller dashboard.
6. Argo CD Synced/Healthy status and reconciliation after a Git change.
7. Secret creation/reference evidence with values hidden.
8. Backup file, restore output, health check, and measured RTO/RPO.

## 7. Conclusion
Blue-Green is suitable when rapid switching and rollback are priorities and duplicate capacity is available. Canary is useful for gradual exposure but depends on trustworthy traffic splitting and observability. GitOps improves consistency and auditability by making Git the desired-state source. Secret stores reduce credential exposure when access and rotation are configured correctly. Disaster recovery is effective only when backups include required data and restoration is regularly tested. Combining these practices provides a more resilient delivery lifecycle than relying on a single deployment method.

## 8. Actual implementation results
Complete this section after running the project. Do not leave unverified claims:
- CI run URL/status:
- Test count and result:
- Image tag:
- Kubernetes cluster/context:
- Blue-Green switch result:
- Canary method and observed metrics:
- Argo CD sync/reconciliation result:
- Secret-management method:
- Backup/restore result and measured RTO/RPO:
- Challenges and resolutions:

---

## 8. Execution Evidence & Verification Log (Verified Run)

- **Repository & Verified Commit:** `https://github.com/Nijaagna05/lab4-enterprise-devops` (`5af9406`)
- **Cluster Environment:** Local Kubernetes (`kind` v1.31.0, cluster `lab4`, namespace `lab4`)
- **CI Pipeline (Q2):** GitHub Actions `CI` workflow passed (`python -m pytest` unit tests + Docker image build verification).
- **Secret Management (Q6):** Created Kubernetes Secret `lab4-app-secret` (`APP_API_TOKEN: 15 bytes`) without exposing plaintext values; verified `.env.example` contains only non-secret placeholders (`APP_API_TOKEN=replace-me-at-runtime`).
- **Blue-Green Deployment (Q3):** Deployed `app-blue` (`1.0`) and `app-green` (`1.1`), verified zero-downtime Service selector switch (`app-live` between `version=blue` and `version=green`) and rollback (`10.244.0.5:5000, 10.244.0.6:5000`).
- **Canary Deployment (Q7):** Deployed `app-stable` (9 replicas, `1.0`) and `app-canary` (1 replica, `1.1`) behind `app-canary-demo`, then validated immediate rollback by scaling `app-canary` to `0` replicas.
- **GitOps Continuous Delivery (Q4):** Installed Argo CD in namespace `argocd`, applied `k8s/argocd/application.yaml` tracking `k8s/base` on `main`, and verified automated reconciliation to `Synced` and `Healthy` status (`5af9406bc11b0ea37707d915ae86b81ed400da55`).
- **Disaster Recovery Drill (Q1):** Executed `scripts/backup.sh lab4` at `2026-11-25 17:25:01 UTC` (`backup-lab4-20261125-172501.yaml`), deleted live resources in `lab4`, restored via `scripts/restore.sh`, and verified all endpoints (`lab4-app`, `app-live`, `app-canary-demo`) healthy at `2026-11-25 17:25:05 UTC` (observed recovery duration ~4 seconds, well within the 5-minute RTO target).
