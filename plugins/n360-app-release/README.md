# N360 App Release Testing

A comprehensive mobile app release testing protocol for Claude Code. Built by [Nucleus360](https://nucleus360.com.au) for teams shipping to the App Store and Play Store.

## What It Does

This plugin provides a structured 19-phase verification protocol that runs before every app store submission. It catches the issues that crash apps in production, fail App Store review, and erode user trust.

### Skills Included

| Skill | Trigger | Purpose |
|-------|---------|---------|
| **App Release Testing** | Before app store submissions | 19-phase verification covering API health, auth, critical paths, navigation, permissions, offline resilience, security, compliance, and more |
| **Post-Deploy Verification** | After any production deploy | Quick 15-minute checklist with rollback decision criteria |

### Priority Classification

Every check is classified so you know what blocks a release and what can ship with a known issue:

- **P0 — RELEASE BLOCKER**: If this fails, DO NOT deploy
- **P1 — CRITICAL**: Must pass before release
- **P2 — HIGH**: Fix within 24 hours
- **P3 — MEDIUM**: Next sprint

### 19 Verification Phases

1. API Health & Infrastructure
2. Auth & Onboarding Flow
3. Critical Path / Emergency Flow
4. Screen Navigation & Stability
5. Permissions
6. Companion App (watch/tablet)
7. Email Templates
8. Offline & Network Degradation
9. Data Integrity
10. Security
11. Version & Build Consistency
12. Performance
13. Accessibility
14. Device & OS Compatibility
15. Disaster Recovery
16. Compliance (GDPR/POPIA/CCPA)
17. End-to-End User Journeys
18. Pre-Deploy Checks
19. Post-Deploy Verification

### Automated vs Manual

The protocol distinguishes between checks Claude Code can run automatically (API health, secret scanning, build verification) and checks requiring a human with a physical device (permission dialogs, biometric login, watch pairing). Claude Code runs all automatable checks first, then presents the manual checklist.

## Installation

### From the Nucleus360 Marketplace

```
/plugin marketplace add JPVT1977/n360-marketplace
/plugin install n360-app-release@n360-marketplace
```

### Usage

When preparing for a release, tell Claude Code:

```
Run the app release testing protocol
```

Or reference it directly:

```
Run n360-app-release:app-release-testing for our iOS submission
```

## Who It's For

- Mobile developers shipping to App Store and Play Store
- Teams building safety-critical or compliance-sensitive apps
- Solo developers who need a senior QA engineer's checklist without hiring one
- Anyone who has had an app rejected or a production crash they could have caught

## Customisation

The protocol is designed to be adapted. Phase 3 (Critical Path) is written generically — replace the examples with your app's specific critical flow (SOS, payment, order fulfilment, real-time alerts). Phase 16 (Compliance) should be adapted to your jurisdiction.

## Works With

- **n360-engineering** — The engineering standard plugin. Use together for full coverage from development through release.
- Any Flutter, React Native, Swift, or Kotlin project
- Claude Code 2.0.13+

## License

MIT
