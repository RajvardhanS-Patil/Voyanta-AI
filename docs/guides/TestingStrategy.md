# Testing Strategy — Voyanta AI

This document establishes the testing topology, mocking standards, and automated verification requirements for Voyanta AI.

---

## 1. Testing Pyramid Mappings

We apply a structured testing hierarchy to ensure high reliability across iterations:

```
    / \
   /   \      E2E Integration (5%): Verify end-to-end sync flows
  /-----\
 /       \    Widget / UI (25%): Verify card layouts, triggers, shimmers
/---------\
/         \   Unit Tests (70%): Validate business use cases, math calculations, schema mapping
-----------
```

- **Target Coverage**: Core domain use cases, parsing functions, and validation systems require a minimum of **80%** test coverage.

---

## 2. Unit Testing & Use Cases

- **Scope**: Focus on mathematical processes (expense sum counters, budget conversions) and data mapping functions.
- **Repository Mocking**: The Domain layer use cases are tested by passing mock implementations of repositories (`MockTripRepository` via packages like `mockito` or `mocktail`).
- **State Logic**: State controllers are tested in isolation. Test cases verify if calling controller actions transitions the state model correctly (e.g., transitions from `Loading` to `Success`).

---

## 3. Widget & UI Layout Testing

- **Layout Verification**: Test files verify that widgets display correctly in different display states:
  - Verify that when `isLoading` is true, the widget renders skeleton shimmers.
  - Verify that when an error message is populated, an error card component displays.
- **Interactions**: Simulate user interactions (e.g., typing in a text field, tapping the "Log Expense" button) and assert that the correct controllers are invoked.

---

## 4. End-to-End (E2E) Integration Tests

- **Flow Verification**: Integration tests run the application on real simulators/devices to verify full paths (e.g., Authenticating -> Creating Trip -> Adding Expense -> Going Offline -> Editing Expense -> Reconnecting -> Asserting Supabase Database update).
- **API Mocking Rule**: E2E test suites connect to a local **Supabase local emulator instance** or mock server, preventing testing pipelines from hitting remote production services or exceeding free-tier limits.
- **Run Command**: Integration tests are run via command lines:
  - Flutter: `flutter test integration_test/app_test.dart`
  - Web: `npx playwright test`
