---
name: tdd
description: >
  Use when implementing any new feature, endpoint, service method, or critical
  flow. Enforces strict RED-GREEN-REFACTOR cycles where tests must fail before
  implementation exists. Does NOT trigger for quick bug fixes, config changes,
  documentation, single-line patches, or UI tweaks with no logic.
---

# TDD Protocol — Red / Green / Refactor

The default behaviour of AI coding agents is to write implementation first and tests after. This produces tautological tests that confirm the code works as written, not as intended. This protocol prevents that.

## The Cycle

```
RED:     Write ONE failing test that defines the expected behaviour.
         Run it. Confirm it FAILS for the right reason (missing feature, not syntax error).
         If it passes immediately → the test is wrong. Delete it and try again.

GREEN:   Write the MINIMUM code to make that one test pass.
         No speculative code. No "while I'm here" additions. Just enough to go green.
         Run the test. Confirm it passes.

REFACTOR: With the test green, clean up.
         Extract helpers, improve naming, remove duplication.
         Run the test after every change. It must stay green.

REPEAT:  Next behaviour → next failing test → next minimal implementation.
```

## Enforcement Rules

1. **No production code before a failing test.** If implementation is written before a test exists for it, delete the implementation and start with the test. This is not a suggestion.
1. **One test at a time.** Do not write a batch of 10 tests and then implement. Write one, fail it, pass it, refactor, then write the next. Each test is a conversation with the code.
1. **Tests define behaviour, not implementation.** A test should survive a complete rewrite of the function it covers. If renaming an internal variable breaks a test, the test is testing implementation — fix the test.
1. **Run tests after every file edit.** No exceptions.

## Anti-Rationalisation Guard

Claude will attempt to skip TDD with seemingly reasonable excuses. These are the common ones and the correct response to each:

|Excuse|Response|
|------|--------|
|"This is too simple to need a test"|Simple code is the easiest to test. Write the test. It takes 30 seconds.|
|"I'll write the tests after"|No. Tests written after implementation confirm what you built, not what was needed. That defeats the purpose.|
|"I already tested it manually"|Manual testing is not repeatable. Write the automated test.|
|"The existing code has no tests so TDD doesn't apply"|Write the test for your change. You are not responsible for legacy gaps, but you do not add to them.|
|"This is just a refactor, no new behaviour"|If there's no new behaviour, there should be existing tests that stay green. If there are no existing tests, write one for the current behaviour before refactoring.|
|"It's faster to write it all at once"|Faster to write, slower to debug. The cycle is non-negotiable for features.|

## When to Scale Down

Not everything needs full TDD ceremony. Use judgement:

|Change Type|TDD Level|
|-----------|---------|
|New feature / endpoint / service method|Full RED-GREEN-REFACTOR cycle|
|Bug fix|Write a test that reproduces the bug (RED), then fix it (GREEN)|
|Refactor with existing test coverage|Run existing tests after every change (REFACTOR only)|
|Config, docs, copy changes|No TDD required|
|UI-only with no logic|No TDD required, but snapshot/visual test encouraged|
|Safety-critical flow|Full TDD + end-to-end test. No exceptions.|

## Red Flags — Start Over If Any Occur

- Code was written before a test existed for it
- A test passed immediately without failing first
- You cannot explain why the test initially failed
- Tests are being rewritten to match the implementation (instead of fixing the implementation)
- More than 3 tests written before any implementation
