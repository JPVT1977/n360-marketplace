---
name: app-release-testing
description: >
  Use before every App Store or Play Store submission. Provides a 19-phase
  verification protocol with priority classification (P0 release blockers
  through P3 nice-to-have). Covers API health, auth flows, emergency/critical
  paths, navigation stability, location/permissions, watch apps, email
  templates, offline resilience, data integrity, security, build consistency,
  performance, accessibility, device compatibility, disaster recovery,
  compliance, end-to-end journeys, pre-deploy checks, and post-deploy
  verification. Includes failure protocol and test metadata format.
---

# App Release Testing Protocol

**Mandatory before every App Store / Play Store submission. No exceptions.**

---

## Priority Classification

- **P0 — RELEASE BLOCKER**: If this fails, DO NOT deploy. Users depend on it.
- **P1 — CRITICAL**: Must pass before release. Fix immediately.
- **P2 — HIGH**: Should pass. Log and fix within 24 hours if not.
- **P3 — MEDIUM**: Nice to have. Log for next sprint.

---

## Phase 1: API Health & Infrastructure [P0]

### 1.1 Systems Online
- [ ] API health endpoint returns healthy (all checks pass)
- [ ] Database connected (response < 100ms)
- [ ] Cache layer connected (Redis or equivalent, response < 100ms)
- [ ] Push notification service connected (FCM/APNs)
- [ ] Email service connected and verified (send test email)
- [ ] Web portal returns 200
- [ ] Admin dashboard returns 200
- [ ] Operator dashboard returns 200 (if applicable)
- [ ] Public website returns 200
- [ ] WebSocket endpoint accepts connections (if applicable)

### 1.2 Auth Endpoints
- [ ] Register — valid data succeeds
- [ ] Register — duplicate email returns clear message (not generic error)
- [ ] Register — weak password returns clear validation message
- [ ] Register — invalid email rejected
- [ ] Register — empty optional fields accepted gracefully
- [ ] Login — correct credentials succeed
- [ ] Login — wrong password returns clear message
- [ ] Login — non-existent email returns clear message (no enumeration)
- [ ] Token refresh — valid refresh token returns new tokens
- [ ] Token refresh — expired/invalid token handled gracefully
- [ ] Forgot password — sends email for existing user
- [ ] Forgot password — returns success for non-existent email (no enumeration)
- [ ] Logout — invalidates tokens

### 1.3 Data Endpoints (authenticated)
- [ ] GET profile — returns user data
- [ ] PATCH profile — updates fields
- [ ] DELETE account — soft-deletes
- [ ] All primary data endpoints return expected shapes
- [ ] Numeric zero values stored as 0, not null (battery: 0, speed: 0, etc.)
- [ ] GET billing/subscription — returns correct tier

### 1.4 Validation Alignment [P0]
- [ ] App validation rules MATCH API validation rules exactly (password, email, phone)
- [ ] All optional fields the app can send empty are accepted by API
- [ ] API error messages (including arrays) are parseable by the app
- [ ] API returns user-friendly messages, not stack traces or error codes

---

## Phase 2: Auth & Onboarding Flow [P0]

### 2.1 Registration
- [ ] Register with valid data — account created, navigated to home
- [ ] Weak password — inline validation BEFORE submit
- [ ] Existing email — clear error shown (not "Request failed")
- [ ] Required permission dialogs appear at appropriate point in onboarding
- [ ] If permission denied, explanation dialog with "Open Settings" button
- [ ] Welcome email received with correct branding, links, images

### 2.2 Login
- [ ] Login with valid credentials — navigated to home
- [ ] Wrong password — clear error message
- [ ] Biometric login works without duplicate dialogs or navigation issues
- [ ] Background services start correctly after login

### 2.3 Password Reset
- [ ] Forgot password sends email
- [ ] Email has correct branding and working reset link
- [ ] Can set new password and login with it

### 2.4 Logout & Account Deletion
- [ ] Logout clears tokens and stops background services
- [ ] Cannot access authenticated content after logout
- [ ] Delete account requires confirmation
- [ ] Cannot login after deletion

---

## Phase 3: Critical Path / Emergency Flow [P0 — ZERO FAIL]

*Adapt this phase to your app's critical path. Examples: SOS/panic button, payment processing, order fulfilment, real-time alerts.*

### 3.1 Happy Path
- [ ] Critical action triggers correctly (required confirmation prevents accidental trigger)
- [ ] Action sends to API with current context/location
- [ ] Relevant parties notified (push, SMS, email as applicable)
- [ ] Cancel/undo works and resets to standby
- [ ] Dependent users receive notification

### 3.2 Hostile Conditions
- [ ] Critical action with permissions revoked — uses last known data + timestamp
- [ ] Critical action with no connectivity — queued locally, clear "Pending" UI, auto-fires on reconnect
- [ ] Critical action on slow network (2G/Edge) — payload under 2KB, completes within 10 seconds
- [ ] Network drop mid-action — hands off to alternative transport without user retry
- [ ] Rapid repeated trigger — debounce ensures exactly ONE API call
- [ ] Force-kill app during action — background process completes it
- [ ] Action during token refresh — critical action takes priority, token refreshes after

### 3.3 State Recovery
- [ ] App crash during active critical flow — reopening app shows correct state
- [ ] Network returns after offline action — queued action delivered within 5 seconds
- [ ] API returns 500 — exponential backoff retry (1s, 2s, 4s, 8s), not infinite loop

---

## Phase 4: Screen Navigation & Stability [P1]

### 4.1 Navigation
- [ ] Switch between ALL tabs rapidly 20+ times — no crashes, no logouts
- [ ] Each tab loads data correctly on first and subsequent visits
- [ ] No memory leaks after extended navigation (check with platform DevTools)
- [ ] Back navigation works correctly from all screens
- [ ] Deep links open correct screens

### 4.2 Core Screens
For EACH primary screen:
- [ ] Data loads correctly
- [ ] Pull-to-refresh works
- [ ] Auto-refresh works without UI glitch
- [ ] Empty state displays correctly
- [ ] Error state displays correctly with actionable message

### 4.3 Error States [P1]
- [ ] Network offline — appropriate messages on every screen
- [ ] API 500 — user-friendly error, not stack trace
- [ ] API validation error — actual message shown (handle arrays and objects)
- [ ] Loading states on every data-fetching screen
- [ ] Empty states with appropriate messages and action buttons

---

## Phase 5: Permissions [P0]

### 5.1 Permission Flow
- [ ] Permission requested at appropriate onboarding stage
- [ ] If partially granted — dialog explains need for full access
- [ ] If denied — dialog with "Open Settings" button
- [ ] Permission state checked before every permission-dependent operation

### 5.2 Background Operations
- [ ] Background processes continue when app minimised
- [ ] Offline data queued and batch-processed on reconnect

### 5.3 Push Notifications
- [ ] Permission requested
- [ ] Token registered with backend
- [ ] Critical alerts received as push
- [ ] Tapping notification opens correct screen

---

## Phase 6: Companion App [P1] (if applicable)

*Watch, tablet, widget, or secondary device.*

### 6.1 Pairing & Auth
- [ ] Companion pairs successfully
- [ ] Auth tokens transferred securely
- [ ] Companion authenticates independently after pairing

### 6.2 Functionality
- [ ] Core features work on companion
- [ ] Critical actions work from companion
- [ ] Data syncs correctly between primary and companion

### 6.3 Version Consistency
- [ ] Companion version matches primary app version
- [ ] Build number matches

---

## Phase 7: Email Templates [P1]

For EACH transactional email template:
- [ ] Subject line correct and branded
- [ ] Logo renders (not broken image)
- [ ] All links return 200
- [ ] Branding matches website (colours, fonts)
- [ ] User name correctly personalised and HTML-escaped
- [ ] Plain text version readable
- [ ] Actually received when triggered (send test of every template)

---

## Phase 8: Offline & Network Degradation [P0]

- [ ] Slow connection — critical actions complete within 10 seconds
- [ ] WiFi drops mid-request — app hands off to cellular
- [ ] Airplane mode — critical actions queued, clear "Pending" UI, auto-fires on reconnect
- [ ] WebSocket disconnect — falls back to REST polling without crash
- [ ] Network flapping (on/off rapidly) — no duplicate actions, no crash
- [ ] App functions offline for viewing cached data

---

## Phase 9: Data Integrity [P1]

- [ ] Precision maintained through entire pipeline (API → DB → cache → client)
- [ ] Timestamps handled correctly (server UTC used as authority)
- [ ] Stale data shows age indicator, not frozen display
- [ ] Concurrent updates from multiple sources don't overwrite incorrectly
- [ ] Source/origin correctly attributed per data point

---

## Phase 10: Security [P0]

- [ ] No hardcoded secrets in source code
- [ ] .env files in .gitignore
- [ ] Auth required on all data endpoints
- [ ] Input validated on all endpoints
- [ ] User input HTML-escaped in email templates
- [ ] Certificate pinning active in RELEASE builds (if applicable)
- [ ] CORS configured (no wildcards in production)
- [ ] Rate limiting on auth endpoints
- [ ] Passwords hashed (bcrypt or equivalent)
- [ ] Tokens stored in secure storage (Keychain/EncryptedSharedPreferences)
- [ ] No plain-text secrets, tokens, or sensitive data in logs
- [ ] Account deletion scrubs PII from database

---

## Phase 11: Version & Build Consistency [P0]

- [ ] App version matches planned release
- [ ] Companion app version matches (if applicable)
- [ ] In-app version display matches build config
- [ ] Store version train is OPEN (not closed)
- [ ] Build number higher than any previous submission
- [ ] Database migration run on production BEFORE code deploy (if new schema)

---

## Phase 12: Performance [P2]

- [ ] API response times under 200ms p95 for standard endpoints
- [ ] Critical action trigger-to-delivery under 3 seconds on 4G
- [ ] App cold start under 4 seconds on minimum supported device
- [ ] Background processes use less than 5% battery over 12 hours
- [ ] Core screen RAM stays flat over 1 hour (no memory leak)
- [ ] Auto-refresh doesn't cause UI jank

---

## Phase 13: Accessibility [P2]

- [ ] Screen reader announces critical actions correctly
- [ ] Dynamic text scaling — critical UI remains readable at max size
- [ ] Colour contrast meets WCAG AA (4.5:1) on all critical UI
- [ ] Touch targets minimum 44x44 points on all buttons
- [ ] No information conveyed by colour alone

---

## Phase 14: Device & OS Compatibility [P2]

- [ ] Minimum iOS version supported — app installs and runs
- [ ] Minimum Android version supported — app installs and runs
- [ ] Small screen — critical UI prominent, no overflow
- [ ] Large screen — layout doesn't break
- [ ] Battery saver / Low Power Mode — background processes still work

---

## Phase 15: Disaster Recovery [P2]

- [ ] API down — app shows clear offline state, queues critical actions
- [ ] Cache layer down — API degrades gracefully (no crash)
- [ ] Database connection lost — health check returns unhealthy, alerts fire
- [ ] SSL cert expires — monitoring catches before expiry
- [ ] Hosting provider outage — traffic routes to backup (if configured)
- [ ] Rollback procedure documented and tested

---

## Phase 16: Compliance [P1]

*Adapt to your jurisdiction: GDPR, POPIA, CCPA, HIPAA, etc.*

- [ ] Privacy policy accessible from app and website
- [ ] Terms & conditions accessible
- [ ] Consent obtained before data collection
- [ ] Account deletion removes PII
- [ ] Data retention policy documented
- [ ] No user data shared with third parties without consent
- [ ] Sensitive data anonymised after retention period

---

## Phase 17: End-to-End User Journeys [P1]

- [ ] **New User Journey**: Install → Register → Grant permissions → See core functionality → Complete primary action
- [ ] **Critical Path Journey**: User triggers critical action → Relevant parties notified → Action resolved/cancelled
- [ ] **Returning User Journey**: Open app → Authenticate (biometric) → Access data → Navigate all sections → Logout
- [ ] **Recovery Journey**: Forgot password → Receive email → Reset → Login with new password

---

## Phase 18: Pre-Deploy Checks [P0]

- [ ] All unit tests pass
- [ ] Type checking passes (tsc --noEmit, or equivalent)
- [ ] API tests pass
- [ ] Web portal builds successfully
- [ ] iOS archive builds successfully
- [ ] Android build succeeds (AAB for Play Store)
- [ ] Migrations run on production BEFORE code deploy (if applicable)
- [ ] Email service verified and sending
- [ ] All hosting secrets up to date
- [ ] No TODO/FIXME/HACK comments in changed files

---

## Phase 19: Post-Deploy Verification [P0]

- [ ] API health check passes
- [ ] Register test user — succeeds
- [ ] Login test user — succeeds
- [ ] Password reset email received with correct branding
- [ ] Primary data flow works end-to-end
- [ ] Clean up test accounts
- [ ] Monitor error tracking for 15 minutes
- [ ] Confirm app version in store listing

---

## Failure Protocol

If ANY P0 check fails:
1. **STOP** — do not deploy
2. **Document** — which check failed and why
3. **Fix** — root cause, not symptom
4. **Re-run** — entire phase that failed
5. **Only proceed** when ALL P0 checks pass

If ANY P1 check fails:
1. **Log** — document the failure
2. **Assess** — can it be fixed before deploy?
3. **If yes** — fix, re-test, deploy
4. **If no** — deploy with known issue logged, fix within 24 hours

---

## Test Metadata Format

For each test run, record:

```
| Check | Status | Device/OS | Tested By | Notes |
|-------|--------|-----------|-----------|-------|
| [description] | PASS/FAIL | [device + OS version] | [name] | — |
```

---

## Automatable vs Manual Checks

Checks marked `[AUTO]` can be scripted and run by Claude Code. Checks marked `[MANUAL]` require a human with a physical device or browser.

**AUTO**: Phase 1 (API health, auth endpoints, data endpoints), Phase 10 (secret scanning, .gitignore, CORS check), Phase 11 (version matching), Phase 18 (build, tests, type checking), Phase 19 (API health, test user registration)

**MANUAL**: Phase 3 (critical path on real device), Phase 4 (navigation stress testing), Phase 5 (permission dialogs), Phase 6 (companion pairing), Phase 7 (email rendering), Phase 13 (accessibility on real device), Phase 14 (device compatibility)

When running this protocol, Claude Code should execute all AUTO checks first, report results, then present the MANUAL checklist for the user to complete.
