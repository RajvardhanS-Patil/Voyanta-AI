# Coding Standards — Voyanta AI

This document establishes the official coding standards, formatting guidelines, and architectural rules to be maintained throughout the Voyanta AI codebase.

---

## 1. Naming Conventions

### File Naming
- Use `snake_case` for all source files, directories, assets, and folders.
- Examples: `trip_repository.dart`, `create_trip_usecase.dart`, `auth_controller.dart`.

### Class Naming
- Use `PascalCase` for all classes, mixins, extension names, and enums.
- Examples: `TripModel`, `ExpenseController`, `OfflineSyncStatus`.

### Variable & Function Naming
- Use `camelCase` for all variables, properties, methods, arguments, and local functions.
- Examples: `tripId`, `calculateTotalBudget()`, `fetchUserItineraries()`.

### Constant Naming
- Use `camelCase` for final/constant properties within classes, and `kCamelCase` for global constant file variables.
- Examples: `static const maxAllowedDays = 30;`, `const kDefaultAnimationDuration = Duration(milliseconds: 300);`.

---

## 2. Code Organization & Imports

- **Absolute Directory Imports**: Do not use relative imports (`../../core/`). Always use absolute package imports to prevent import breakage during feature refactoring.
  - Example: `import 'package:voyanta_ai/core/theme/color_tokens.dart';`
- **Import Ordering Grouping**:
  1. Core Flutter/Dart framework packages
  2. External third-party package dependencies (e.g., `riverpod`, `supabase`)
  3. Internal workspace absolute package imports

---

## 3. Error Handling and Logging

- **Functional Error Returns**: Avoid throwing unhandled runtime exceptions. Use structured wrapper objects like `Either<Failure, Success>` to force explicit handling of API errors in UI widgets.
- **Failures Definition**: Define standard failure types in `/core/error/failures.dart`:
  - `NetworkFailure` (No connection or server time-outs)
  - `ServerFailure` (Supabase returning 500 error code)
  - `DatabaseFailure` (Local storage database access read/write blocks)
  - `AuthFailure` (Invalid session or credentials)
  - `AIFailure` (Gemini API returning errors or structured JSON mismatch)
- **Logging Rule**: Do not use raw `print()` statements in production code. Use a structured logger (`logger` package or a custom wrapper) to filter info logs in release mode.

---

## 4. Git Branching & Commit Discipline

Follow the **Git Workflow and Versioning** standard:
- **Branch Naming**:
  - `feature/<short-description>`: Adding new functionality (e.g., `feature/trip-sharing`).
  - `fix/<short-description>`: Bug fixing tasks (e.g., `fix/sync-duplicate-expenses`).
  - `chore/<short-description>`: Infrastructure edits or dependency updates.
  - `refactor/<short-description>`: Code simplification and cleanup.
- **Commit Messages**: Format commit messages as:
  `<type>: <description>`
  - Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.
  - Example: `feat: add budget progress charts in trip overview`
