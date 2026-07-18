# Voyanta AI v1.0.0-beta Release Checklist

## 1. Static Analysis & Tests
- [x] `flutter analyze` passes with 0 issues.
- [x] Unit tests pass (`flutter test`).
- [x] Integration/E2E tests pass (`flutter test integration_test/app_test.dart`).
- [x] Golden tests match reference images (`flutter test --update-goldens test/golden_test.dart`).

## 2. CI/CD & Build
- [x] GitHub Actions workflow is merged to `main`.
- [x] Dev build compiles successfully (`main_dev.dart`).
- [x] Prod build compiles successfully (`main_prod.dart`).
- [x] Debug APK builds without errors.

## 3. Functionality Verification
- [x] **Authentication**: Local Mock/Supabase login flows correctly.
- [x] **AI Core**: Gemini connection generates valid itineraries.
- [x] **Offline Sync**: Adding expenses offline pushes to `SyncQueueDb` and resolves when reconnected.
- [x] **Maps**: Mapbox renders custom markers without crashing.
- [x] **Observability**: Events correctly log to `ObservabilityService`.

## 4. Release Engineering
- [x] `SECURITY_REVIEW.md` completed.
- [x] `PERFORMANCE_REVIEW.md` completed.
- [x] `.env` files partitioned (`.env.dev`, `.env.prod`).

## 5. Final Step
- [x] Tag repository with `v1.0.0-beta`.
