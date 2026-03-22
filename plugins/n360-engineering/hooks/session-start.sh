#!/bin/bash
# N360 Engineering Standard — Session Start Hook
# Ensures the operating standard is loaded at the beginning of every session.

SKILL_DIR="$(dirname "$(dirname "$0")")/skills/operating-standard"

if [ -f "$SKILL_DIR/SKILL.md" ]; then
  echo "<session-start-hook>"
  echo "You are running the N360 Engineering Standard."
  echo "Read and follow: $SKILL_DIR/SKILL.md"
  echo "Available skills: operating-standard, tdd, large-feature"
  echo "Use the TDD skill for new features. Use the large-feature skill for 5+ file changes."
  echo "</session-start-hook>"
fi
