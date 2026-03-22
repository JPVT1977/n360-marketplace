---
name: large-feature
description: >
  Use when a feature touches 5+ files, involves multiple layers (API + DB +
  frontend), or will take more than one session to complete. Enforces structured
  decomposition with design-first, task breakdown, review gates, and integration
  verification. Prevents context drift during long implementation sessions.
---

# Large Feature Protocol

Long implementation sessions cause context drift. By the time you're editing file 12, the decisions you made in file 1 are fuzzy. Errors compound. Quality degrades. This protocol prevents that through structured decomposition.

## Phase 1: Design Before Code

Before writing any implementation:

1. **State the goal in one sentence.** If you cannot, the feature is not defined well enough to build.
1. **Identify every file that will be created or changed.** List them. If the list exceeds 10 files, consider splitting the feature.
1. **Define the data flow.** Entry point → validation → business logic → persistence → response.
1. **Identify the riskiest part.** What is most likely to break? That gets built and tested first.

Present this to the user. Get approval before writing any code.

## Phase 2: Task Decomposition

Break the feature into tasks. Each task must be:

- **Completable in one step** (one logical change, testable independently)
- **Specific about files** (exact file paths, not "update the frontend")
- **Ordered by dependency** (build the foundation before the walls)
- **Individually verifiable** (clear pass/fail criteria per task)

Format:

```
TASK 1: Create DTO for [endpoint] — src/dto/feature.dto.ts
  Verify: Build passes, DTO validates correct/incorrect input

TASK 2: Create service method — src/services/feature.service.ts
  Verify: Unit test passes (RED/GREEN from TDD skill)
  Depends on: Task 1

TASK 3: Create controller endpoint — src/controllers/feature.controller.ts
  Verify: Integration test passes, auth required, returns correct DTO
  Depends on: Task 1, 2
```

## Phase 3: Execute With Review Gates

1. **Work through tasks in order.** Complete one, verify it, commit it, then move to the next.
1. **Review gate every 3 tasks.** After every third task, pause and review:
   - Are the completed tasks consistent with each other?
   - Has scope crept beyond the original plan?
   - Are tests covering the right behaviours?
   - Is the code review clean?
1. **Report progress to the user** at each review gate. Do not wait until the end.
1. **If the plan needs changing,** update the task list and get user approval before continuing.

## Phase 4: Integration Verification

Once all tasks are complete:

1. Run the full test suite, not just the new tests.
1. Verify the feature end-to-end (entry point to response).
1. Check for regressions in adjacent features.
1. Run the security baseline checks on all new files.

## Context Exhaustion During Large Features

If context is running low mid-feature:

1. Save handoff immediately.
1. In the handoff, include the full task list with completion status.
1. Mark exactly which task was in progress and what state it was in.
1. The next session picks up from the task list, not from memory.
