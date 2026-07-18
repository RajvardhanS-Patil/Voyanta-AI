# Contributing Guidelines — Voyanta AI

This document establishes the contribution standards, pull request policies, and review guidelines for Voyanta AI.

---

## 1. Development Workflow

All contributions must follow a strict **feature branch** flow:

```
[Create Feature Branch from main] 
      │ (Naming standard: feature/trip-syncing)
      v
[Implement Increments in Atomic Commits]
      │
      v
[Run Local Tests & Code Analysis]
      │ (Command: flutter analyze; flutter test)
      v
[Create Pull Request (PR) to main]
      │
      v
[PR Peer Review & CI Verification Passed]
      │
      v
[Merge Branch (Squash & Merge)]
```

---

## 2. Local Environment Setup

Developers must meet the following configuration requirements:
- **Flutter SDK**: Stable version matching `pubspec.yaml` target parameters.
- **Dart SDK**: Configured with strict analytical checks (`analysis_options.yaml`).
- **Supabase CLI**: Local emulation docker setup configured.
- **Git Hooks**: Configure standard pre-commit scripts to format files (`flutter format .`) and execute type checking before commits are recorded.

---

## 3. Pull Request Review Checklist

Before a contribution can be merged into `main`, it must meet the following criteria:

- [ ] **Clean Compilation**: Zero compiler warning messages, static analysis errors, or formatting anomalies.
- [ ] **Tests Present**: New code must have matching unit or UI widget tests verifying functionality.
- [ ] **Security Compliance**: Row Level Security (RLS) checked. No exposed tokens or hardcoded credential variables.
- [ ] **Documentation**: Any schema changes, API endpoints, or visual tokens updated in `/docs` files before changes are submitted.
