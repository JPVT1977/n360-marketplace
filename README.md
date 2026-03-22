# Nucleus360 — Claude Code Plugins

Production-grade engineering standards and release protocols for Claude Code. Built for teams where code quality is non-negotiable.

## Plugins

| Plugin | Description | Install |
|--------|-------------|---------|
| **[n360-engineering](plugins/n360-engineering/)** | Zero-defect engineering standard. Session discipline, TDD, investigation protocol, circuit breakers, security baselines, performance targets, rollback playbooks. | `/plugin install n360-engineering@n360-marketplace` |
| **[n360-app-release](plugins/n360-app-release/)** | 19-phase mobile app release testing protocol with priority classification, failure protocols, and post-deploy verification. | `/plugin install n360-app-release@n360-marketplace` |

## Quick Start

```bash
# In Claude Code, add the marketplace
/plugin marketplace add JPVT1977/n360-marketplace

# Install one or both plugins
/plugin install n360-engineering@n360-marketplace
/plugin install n360-app-release@n360-marketplace

# Restart Claude Code — plugins activate automatically
```

## Why These Exist

AI coding agents are fast but undisciplined. They skip tests, ignore errors, commit broken code, and lose context mid-session. These plugins fix that by enforcing the practices that experienced engineers follow instinctively.

The engineering standard was born from building platforms that protect people in emergencies. The release protocol was born from the reality that App Store rejections and production crashes are preventable — if you run the right checks in the right order.

## Philosophy

- **Rules, not suggestions.** If something matters, it's enforced, not recommended.
- **Evidence over claims.** "It should work" is not acceptable. Prove it works.
- **No wasted tokens.** Circuit breakers stop spinning. Handoffs preserve context. Sessions start where the last one left off.
- **Test before code.** TDD enforcement with built-in rebuttals for every excuse to skip it.
- **Designed for solo developers and small teams.** One person running multiple projects needs consistency more than anyone.

## Built By

[Nucleus360](https://nucleus360.com.au) — Engineering consultancy based in Melbourne, Australia. We build safety-critical platforms, mobile applications, and the tooling that keeps them reliable.

## License

MIT — Use it, fork it, adapt it. If it saves you from a production incident, that's reward enough.

## Contributing

Issues and PRs welcome. If you've found a gap in the standard or a check that should be in the release protocol, open an issue.
