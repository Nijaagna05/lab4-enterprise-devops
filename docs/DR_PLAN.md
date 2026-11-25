# Disaster Recovery Plan

## Scope
Recovery of Kubernetes application resources in namespace `lab4`. This sample export covers Kubernetes API resources; it does not independently back up persistent-volume data, databases, object storage, or cluster control-plane state.

## Recovery objectives (targets to validate)
- **RPO target:** 24 hours for configuration backup (maximum acceptable configuration data loss).
- **RTO target:** 30 minutes to restore application resources in an available cluster.
- **Availability:** Keep a second ready deployment where practical; use a tested traffic switch for failover.

These are proposed lab targets, not measured results. Replace them with measured values after running the drill.

## Procedure
1. Run `bash scripts/backup.sh lab4`.
2. Store the generated YAML in a protected backup location and commit only sanitized manifests.
3. For a recovery drill, use a disposable namespace/cluster.
4. Apply the backup using `bash scripts/restore.sh <backup-file>`.
5. Verify deployments, pods, services, endpoints, `/health`, and application behavior.
6. Record start/end timestamps and calculate RTO. Compare the backup timestamp with recovery point to estimate RPO.
7. If the primary environment is unavailable, deploy to the approved secondary cluster and update DNS/Ingress/traffic routing after health checks.

## Evidence log (fill after execution)
| Metric | Actual observation |
|---|---|
| Backup timestamp | To be recorded |
| Backup file | To be recorded |
| Restore start/end | To be recorded |
| Measured RTO | To be calculated |
| Measured RPO | To be calculated |
| Health check after restore | Pass/Fail + output |
| Issues and corrective action | To be recorded |

## Limitations
A `kubectl get` export is not a full disaster-recovery solution. Production recovery must include persistent data snapshots, database-consistent backups, encryption, off-site/immutable copies, access-control recovery, tested infrastructure recreation, and periodic restore drills.
