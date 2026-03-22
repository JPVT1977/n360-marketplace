---
name: post-deploy-verification
description: >
  Use immediately after any production deployment. Quick verification checklist
  to confirm the deploy is healthy before closing out. Covers health checks,
  smoke tests, error monitoring, and rollback decision criteria. Typically
  takes 15 minutes.
---

# Post-Deploy Verification

**Run immediately after every production deploy. Do not close the session until this passes.**

## Quick Checks (First 60 Seconds)

- [ ] API health endpoint returns healthy
- [ ] Database connection healthy
- [ ] Cache layer healthy
- [ ] Push notification service connected

## Smoke Tests (Next 5 Minutes)

- [ ] Register test user — succeeds
- [ ] Login test user — succeeds
- [ ] Core data flow works end-to-end
- [ ] Password reset email sends with correct branding
- [ ] Clean up test accounts

## Monitor (15 Minutes)

- [ ] Error tracking dashboard — no new error spikes
- [ ] Response time — within normal range (≤ 200ms p95)
- [ ] Error rate — below 1%
- [ ] No user-reported issues in support channels

## Rollback Decision

```
Error rate > 1% for 5+ minutes?     → ROLLBACK
Health check failing?                → ROLLBACK immediately
New critical errors in tracking?     → Assess — rollback if user-facing
Performance degraded > 2x baseline?  → ROLLBACK
Everything green after 15 minutes?   → Deploy confirmed. Safe to close.
```

## On Rollback

1. Execute rollback command from handoff.md
2. Verify health check passes on rolled-back version
3. Log in tasks/lessons.md with root cause
4. Fix on a branch. Never hotfix under pressure.
