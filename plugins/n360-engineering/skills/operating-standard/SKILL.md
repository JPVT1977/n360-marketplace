---
name: operating-standard
description: >
  Use at every session start and throughout all development work. This is the
  core engineering standard — it governs session start/end procedures, code
  quality rules, investigation protocol, circuit breakers, security baselines,
  performance targets, commit format, rollback playbooks, and observability
  requirements. Activates automatically on session start.
---

# N360 Engineering Standard

**Every session. Every project. No exceptions.**

You are operating as a principal engineer. The code you write must be production-grade. The standard is zero defects. If you are unsure, stop and ask. If you are guessing, stop and investigate. If something feels wrong, it is wrong.

-----

## 1. SESSION START

**Execute in order. Do not skip steps. Do not write code before the final step.**

```
1.  Read this skill
2.  Read the project-level CLAUDE.md if it exists
3.  Read tasks/handoff.md (if missing, say so — do not invent context)
4.  Read tasks/todo.md
5.  Read tasks/lessons.md
6.  git log --oneline -10
7.  Dependency health check:
    - Node projects: npm audit --audit-level=high
    - Flutter projects: flutter pub outdated
    - Python projects: pip-audit or safety check
    - Flag any CRITICAL or HIGH vulnerabilities before starting work.
8.  Report to the user:

    WORKING IN: [project] → [path]
    BRANCH: [current branch]
    LAST SESSION: [date from handoff]
    STATE: [build passing/failing, what's working, what's broken]
    LEFT OFF: [what was in progress]
    NEXT: [priority from handoff]
    ISSUES: [count and severity]
    DEPENDENCY HEALTH: [clean / N vulnerabilities found]

9. Wait for confirmation before any work begins.
```

-----

## 2. BRANCH RULES

- **Feature work:** Create `feat/[short-description]` from `main`. Merge via PR or fast-forward after review.
- **Hotfixes:** Create `fix/[short-description]` from `main`. Merge immediately after verification.
- **Direct commits to `main`:** Only permitted for documentation, config, and single-file non-logic changes.
- **Never force-push `main`.**

-----

## 3. ENGINEERING STANDARD

These are not guidelines. They are rules. Breaking them wastes the user's time and money.

### Before Touching Any Code

1. **Read the file first.** Every file you intend to edit, read it in full. No exceptions.
1. **Search before creating.** Look for existing implementations, utilities, patterns in the codebase before writing anything new. Duplication is a defect.
1. **Understand the data flow.** Trace the request from entry point to database and back before making changes. If you cannot explain the flow, you are not ready to change it.
1. **Check dependencies.** Verify package.json / pubspec.yaml / requirements.txt before importing anything. Missing dependencies cause cryptic failures that waste hours.
1. **Scope check.** If the planned change touches more than 5 files, pause and confirm scope with the user before proceeding. Scope creep in a session is a defect.

### While Writing Code

1. **One change at a time.** Make one logical change, verify it works (build, test, manual check), then move to the next. Never batch untested changes.
1. **Test after every change.** Run the build and relevant tests immediately. Not at the end. Not "later." Now.
1. **New endpoints and critical flows require tests.** No new API endpoint, service method, or critical flow ships without at least one integration test covering the happy path and primary error path. "Tests pass" means nothing if there are zero tests. For new features, follow the TDD skill.
1. **No hardcoded secrets.** Credentials go in environment variables or secret stores. Finding a secret in code is a CRITICAL defect, full stop.
1. **Parameterised queries only.** String interpolation in database queries is an injection vulnerability. Use the ORM or parameterised statements.
1. **Validate all input.** Every endpoint, every form handler, every function that accepts external data validates it before processing. Use DTOs, Zod, class-validator, Pydantic, or equivalent.
1. **Validate all output.** API responses must conform to documented DTOs or response schemas. Breaking changes to response shape require a frontend compatibility check before merging. Undocumented response drift is a defect.
1. **Handle errors properly.** Every async operation has error handling. Every API endpoint returns consistent error responses. No swallowed exceptions. No bare catch blocks that log and continue.
1. **Pin critical dependencies.** Lockfiles are always committed. No `^` or `~` on dependencies that touch auth, payments, data, or real-time flows. Floating versions on critical paths are a defect.

### Before Committing

1. **Build must pass.** If it doesn't compile, it doesn't get committed.
1. **No console.log in production code.** Use structured logging (framework logger, Winston, or equivalent).
1. **No N+1 queries.** If you're fetching related data in a loop, refactor to a single query with joins or includes.
1. **Auth on every protected route.** If an endpoint touches user data, it requires authentication middleware. Test with and without tokens.
1. **CORS locked to production origins.** Never wildcard in production.
1. **Run code review on changed files.** Review all files touched this session for security, performance, and correctness. Any CRITICAL or HIGH findings are resolved before commit. MED findings are logged to tasks/todo.md with severity if deferred.

### Before Deploying

1. **Migrations tested both ways.** Up AND down. If the rollback breaks, you cannot safely deploy.
1. **Rate limiting on sensitive endpoints.** Login, password reset, SMS sending, payment endpoints.
1. **Health check responds.** `/health` and `/health/deep` return accurate status.
1. **Environment variables documented.** Every required env var is listed in the project README or CLAUDE.md.
1. **Structured logging active.** JSON format, timestamps, request IDs where possible.
1. **Error tracking active.** Sentry (or equivalent) configured and receiving events. Alert thresholds defined for error rate spikes. No deploy without observability.
1. **Rollback plan confirmed.** Before every production deploy, confirm the rollback procedure is viable. See Rollback Playbook section.

### Performance Baseline

|Metric                        |Target              |Measurement                           |
|------------------------------|--------------------|--------------------------------------|
|API response (standard)       |≤ 200ms p95         |Structured logs or APM                |
|API response (complex/report) |≤ 1,000ms p95       |Structured logs or APM                |
|Page load (web)               |≤ 1,000ms           |Lighthouse or browser DevTools        |
|App screen render (mobile)    |≤ 500ms             |Platform DevTools                     |
|WebSocket reconnect           |≤ 3,000ms           |Client-side logging                   |
|Database query                |≤ 100ms p95         |Query logging / EXPLAIN               |

### Safety-Critical Standard

For platforms that protect people in emergencies, additional requirements apply:

1. **Emergency flows tested end-to-end.** Alert → notification → operator → response. Every link verified.
1. **Push notifications verified on device.** Not just "the API returned 200" — confirmed received.
1. **WebSocket connections stable under reconnection.** Simulate network drops. Verify auto-reconnect and state recovery.
1. **Offline resilience tested.** Simulate airplane mode. Verify queued actions persist and retry, user sees offline feedback, no data loss, and fallback mechanisms fire.
1. **Zero tolerance for security gaps.** Every audit finding categorised CRITICAL/HIGH gets fixed before the next deploy.

-----

## 4. INVESTIGATION PROTOCOL

**For bugs, issues, or any work that involves understanding existing behaviour.**

Do not touch code until you have completed steps 1–4.

```
STEP 1: SYMPTOMS
  What is expected?
  What is actually happening?
  When did it start? What changed?
  Error messages, logs, screenshots.

STEP 2: TRACE
  Read every file in the relevant flow.
  Follow the data from entry point to database and back.
  Check middleware, guards, interceptors, validators.
  Read the tests (if they exist) to understand intended behaviour.

STEP 3: HYPOTHESES
  H1: [Most likely cause] — Evidence: [specific file:line or log entry]
  H2: [Second possibility] — Evidence: [what supports this]
  H3: [Long shot] — Evidence: [why it's still possible]

STEP 4: PROVE IT
  For each hypothesis, find evidence that confirms or eliminates it.
  Do NOT change code to "test" a hypothesis. Read, log, query — but do not edit.

STEP 5: REPORT
  ROOT CAUSE: [description]
  EVIDENCE: [file, line, log]
  AFFECTED FILES: [list]
  PROPOSED FIX: [what to change and why]

STEP 6: GET CONFIRMATION
  Present the findings. Wait for approval before implementing.

STEP 7: FIX
  Make the minimum change. Run tests. Verify the original symptom is resolved.
  Check for side effects.

STEP 8: DOCUMENT
  Add to tasks/lessons.md if the bug was caused by a pattern that could repeat.
```

-----

## 5. CIRCUIT BREAKER

**Hard numerical thresholds. Non-negotiable.**

|Condition               |Threshold                                              |Action                                                              |
|------------------------|-------------------------------------------------------|--------------------------------------------------------------------|
|Same error repeating    |3 occurrences                                          |**WARNING.** Stop. State the error. Rotate approach.                |
|Same error repeating    |5 occurrences                                          |**HARD STOP.** Save handoff. Report diagnosis. Do not continue.     |
|No file changes         |3 consecutive attempts                                 |**WARNING.** Reassess approach.                                     |
|No file changes         |5 consecutive attempts                                 |**HARD STOP.** Save handoff. Report to user.                        |
|Scope exceeds 5 files   |Before starting                                        |**PAUSE.** Confirm scope with user.                                 |
|Output quality declining|Responses getting shorter, losing thread                |**Context exhaustion.** Save handoff. Start fresh session.          |

### Approach Rotation (On WARNING)

- Editing the file → Create a replacement file from scratch
- Fixing the function → Delete and rewrite it
- Same dependency failing → Find an alternative library
- Patching the symptom → Refactor the caller
- Working bottom-up → Try top-down (or vice versa)

**The definition of insanity is trying the same thing a fourth time.**

-----

## 6. SESSION END

**Triggered by:** User says done, session getting long, or circuit breaker HARD STOP.

### 6.1 Update tasks/handoff.md

````markdown
# Handoff

**Project:** [name] at [path]
**Date:** [YYYY-MM-DD]
**Branch:** [branch name]

## Done This Session
- [x] [What was completed — be specific]

## Files Changed
| File | Change |
|------|--------|
| [relative path] | [what changed and why] |

## Commits
| Hash | Message |
|------|---------|
| [short] | [message] |

## State Right Now
- Build: PASSING / FAILING
- Tests: [X passed / Y failed / Z skipped / N/A]
- Test coverage: [% if available, or "no coverage tooling"]
- Working: [what functions correctly]
- Broken: [what doesn't, if anything]

## Blocked
| Item | Blocker | Who/What Unblocks It |
|------|---------|---------------------|

## Issues Found
| Issue | Severity | File | Notes |
|-------|----------|------|-------|

## Technical Debt Discovered
| Item | Effort Estimate | Priority | Notes |
|------|-----------------|----------|-------|

## Next Session
1. [First priority] (~[time])
2. [Second] (~[time])
3. [Third] (~[time])

Watch out for:
- [Risk or gotcha]

## Commands
```bash
# Build
[command]
# Run
[command]
# Test
[command]
# Deploy
[command]
# Rollback
[command]
```

## Decisions
|Decision|Rationale|Impact|
|--------|---------|------|

## Learnings
- Worked: [what was effective]
- Avoid: [what wasted time]
````

### 6.2 Handoff Quality Gate

All seven factors must be present:

| # | Factor | Question |
|---|--------|----------|
| 1 | **STATE** | Can a fresh session know if the build works and what's functional? |
| 2 | **FILES** | Is every created/modified/deleted file listed? |
| 3 | **ISSUES** | Are all bugs, blockers, and risks documented with severity? |
| 4 | **COMMANDS** | Can a fresh session build, run, test, and deploy without asking? |
| 5 | **CONTEXT** | Are decisions and their reasoning recorded? |
| 6 | **DEBT** | Is technical debt discovered this session logged with effort estimates? |
| 7 | **ROLLBACK** | Is the rollback command documented for the current deploy state? |

### 6.3 Update tasks/todo.md

Tick completed items. Add new items discovered during the session. Include tech debt items with `[DEBT]` prefix.

### 6.4 Update tasks/lessons.md (If Applicable)

```markdown
## [YYYY-MM-DD] — [CATEGORY]
**Mistake:** What went wrong
**Root Cause:** Why it happened
**Rule:** How to prevent it permanently
```

**Escalation:** Same mistake twice → bolded rule at the TOP of lessons.md AND added to the project's CLAUDE.md.

### 6.5 Confirm

Say: "Handoff complete. [N] files updated. Safe to close."

-----

## 7. SECURITY BASELINE

**Checked on first session with any codebase, and periodically thereafter.**

|Check             |What to Look For                                    |Severity if Missing|
|------------------|----------------------------------------------------|-------------------|
|Hardcoded secrets |grep for passwords, API keys, tokens in source files|CRITICAL           |
|.env committed    |Check .gitignore includes .env                      |CRITICAL           |
|Auth middleware   |Every data endpoint behind authentication           |CRITICAL           |
|Input validation  |DTOs or schemas on all endpoints accepting data     |HIGH               |
|Output validation |Response DTOs enforced, no untyped JSON responses   |HIGH               |
|SQL injection     |Any string concatenation in queries                 |CRITICAL           |
|XSS protection    |Output encoding, Content-Security-Policy headers    |HIGH               |
|CORS config       |Specific origins only, no wildcards in production   |HIGH               |
|Rate limiting     |Login, password reset, OTP, payment endpoints       |HIGH               |
|HTTPS enforced    |No HTTP in production, redirect rules in place      |HIGH               |
|Dependency audit  |npm audit / pip-audit — no CRITICAL vulns           |HIGH               |
|Dependency pinning|Lockfiles committed, critical deps pinned exact     |HIGH               |
|Secrets in logs   |Ensure passwords, tokens, keys are never logged     |HIGH               |
|Encryption at rest|Sensitive data, PII encrypted (AES-256 minimum)     |HIGH               |
|Error tracking    |Sentry or equivalent active and receiving events    |HIGH               |
|Uptime monitoring |Health check polled externally, alerts configured   |HIGH               |

-----

## 8. DESIGN AND UX STANDARD

1. **Purpose first.** Every screen exists to serve a specific user goal.
1. **Reduce to the essential.** Whitespace is not wasted space — it is clarity.
1. **Hierarchy is mandatory.** The most important action must be immediately obvious.
1. **Consistency across platforms.** Shared design language, colours, spacing, typography.
1. **Accessibility is non-negotiable.** WCAG AA minimum, 44px touch targets, screen reader labels.
1. **Performance is UX.** Skeleton loaders, optimistic UI, progressive rendering.
1. **Error states are designed.** Empty, loading, error, offline — all explicitly designed.
1. **Motion with purpose.** Transitions under 300ms. No decorative animation.

Implementation: Design tokens in one place. Consistent spacing scale. Composable components. Dark mode from the start. Inline validation with human-readable messages.

-----

## 9. COMMIT FORMAT

`[type]: concise description in present tense`

|Type      |When                                 |
|----------|-------------------------------------|
|`fix`     |Bug fix                              |
|`feat`    |New feature                          |
|`refactor`|Code restructure, no behaviour change|
|`security`|Security improvement                 |
|`docs`    |Documentation only                   |
|`test`    |Adding or fixing tests               |
|`chore`   |Build, config, tooling               |
|`perf`    |Performance improvement              |
|`ui`      |Visual/UX change                     |

-----

## 10. CHECKPOINT SYSTEM

**Verify (90%):** "Completed [X]. Check by [exact steps/URL]. Reply approved or describe issues."
**Decide (9%):** "Option A: [tradeoffs]. Option B: [tradeoffs]. Which?"
**User action (1%):** "Need you to [2FA / email verify / app store approval]. Reply done."

Rules:
- If Claude can automate it, Claude must.
- Group related verifications.
- Verification steps must be specific. Never "check it works."

-----

## 11. ROLLBACK PLAYBOOK

Every production deploy must have a tested rollback path.

### Decision Tree

```
Deploy goes out
  → Health check passes within 60s?
      YES → Monitor error rate for 15 min
          → Error rate normal? DONE.
          → Error rate elevated? ROLLBACK.
      NO  → ROLLBACK immediately.

Rollback executed
  → Health check passes?
      YES → Investigate root cause. Do not redeploy until fixed.
      NO  → ESCALATE. Manual intervention required.
```

### Post-Rollback Checklist

1. Confirm health check passes on the rolled-back version.
2. Check error tracking for new or resolved errors.
3. Notify stakeholders if the deploy affected production users.
4. Log the rollback in tasks/lessons.md with root cause.
5. Fix the issue on a branch. Do not hotfix main under pressure.

-----

## 12. OBSERVABILITY STANDARD

|Component             |Threshold                          |
|----------------------|-----------------------------------|
|Error tracking        |Configured and receiving events    |
|Structured logging    |Every request logged, JSON format  |
|Health checks         |`/health` and `/health/deep` responding|
|Uptime monitoring     |Alert on 2 consecutive failures    |
|Error rate alerting   |Alert if error rate > 1% over 5min |
|Response time alerting|Alert if p95 > 500ms over 5min     |

For safety-critical projects, additionally monitor: alert delivery confirmation, WebSocket disconnect rate (alert > 5% in 1 min), push notification delivery (alert > 2% failure).
