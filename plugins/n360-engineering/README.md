# N360 Engineering Standard

A zero-defect engineering standard for Claude Code. Built by [Nucleus360](https://nucleus360.com.au) for teams where code quality is non-negotiable.

## What It Does

This plugin enforces disciplined software development practices across every Claude Code session. It's not a suggestion framework — it's a set of rules that prevent the most common failures in AI-assisted development.

### Skills Included

| Skill | Trigger | Purpose |
|-------|---------|---------|
| **Operating Standard** | Every session (auto) | Session start/end procedures, code quality rules, investigation protocol, circuit breakers, security baselines, performance targets, rollback playbooks, observability |
| **TDD** | New features, endpoints, services | Strict RED-GREEN-REFACTOR enforcement with anti-rationalisation guard |
| **Large Feature** | Changes touching 5+ files | Structured decomposition with design-first, task breakdown, review gates every 3 tasks |

### Key Features

- **Session discipline** — Structured start (read state, check dependencies, report) and end (handoff with 7-factor quality gate) procedures
- **Circuit breakers** — Hard stop after 5 repeated errors or no progress. Prevents token burn on unsolvable problems
- **Investigation protocol** — 8-step evidence-based debugging. No guessing, no random fixes
- **Security baseline** — 16-point checklist run on first session with any codebase
- **Performance targets** — Concrete numbers (200ms API, 100ms DB, 1s page load) not vague "fast enough"
- **TDD enforcement** — Tests before code, one at a time, with a table of pre-built rebuttals for every excuse Claude uses to skip testing
- **Rollback playbook** — Decision tree, post-rollback checklist, and "never hotfix under panic" rule

## Installation

### From the Nucleus360 Marketplace

```
/plugin marketplace add JPVT1977/n360-marketplace
/plugin install n360-engineering@n360-marketplace
```

### Verify

Restart Claude Code and start a session. You should see the session start checklist execute automatically.

## Who It's For

- Solo developers managing multiple projects who need consistency across codebases
- Small teams that want senior-engineer discipline without hiring one
- Anyone building safety-critical, medical, financial, or compliance-sensitive applications
- Developers who are tired of AI coding agents skipping tests, ignoring errors, and committing broken code

## Philosophy

This standard was born from building platforms that protect people in emergencies. The rules exist because every shortcut has a cost, and in safety-critical systems, that cost can be measured in lives. Even if your project isn't life-safety, the discipline transfers: fewer bugs, faster debugging, cleaner handoffs, and code you can trust.

## Compatibility

- Claude Code 2.0.13+
- Works alongside other plugins (tested with MCP servers, deployment tools)
- Stack-agnostic: Node.js, Flutter, Python, Go, or anything else

## Contributing

Issues and PRs welcome at [github.com/JPVT1977/n360-marketplace](https://github.com/JPVT1977/n360-marketplace).

## License

MIT
