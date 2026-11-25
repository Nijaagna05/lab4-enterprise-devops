# Evidence Checklist – Replace with your own screenshots/logs

Create an `evidence/` directory and add genuine screenshots or terminal logs.

| Lab question | Evidence to capture |
|---|---|
| Q1 Disaster Recovery | Backup file created, restore command, restored pods and health endpoint, measured RTO/RPO |
| Q2 Automated Testing | GitHub Actions workflow showing pytest pass; failed test blocking downstream job if demonstrated |
| Q3 Blue-Green | Both deployments ready, Service selector before/after, successful requests during switch, rollback |
| Q4 GitOps | Argo CD Application Synced/Healthy, Git commit changing desired state, reconciliation/drift correction |
| Q5 Report | Completed report with architecture, strategy comparison, risk analysis and actual evidence |
| Q6 Secrets | GitHub secret name/configuration or Kubernetes Secret metadata; ensure secret values are not visible |
| Q7 Canary | Stable/canary rollout stages, traffic-splitting configuration/controller metrics, rollback trigger and result |

Do not use fabricated screenshots. Redact tokens, passwords, personal access tokens, kubeconfig data, and private endpoints.
