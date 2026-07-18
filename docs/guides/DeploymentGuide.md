# Deployment & CI/CD Guide — Voyanta AI

This document details the automated deployment pipelines, build scripts, app store distribution, and database migrations for Voyanta AI.

---

## 1. Automated CI/CD (GitHub Actions)

We run compilation tests on every push and pull request to the `main` branch.

### Workflow Configuration: `.github/workflows/ci.yml`
```yaml
name: Voyanta AI CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build_and_test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      # Flutter/Dart compilation setup
      - name: Set up Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Run code analyzer
        run: flutter analyze

      - name: Run unit and widget tests
        run: flutter test --coverage
```

---

## 2. Fastlane Pipelines (App Store Distribution)

We use **Fastlane** to automate beta test distributions (Google Play Console internal tracks, TestFlight on iOS).

- **Android Setup**: Fastlane compiles the app bundle (`.aab`), signs it using credentials stored in GitHub Secrets, and uploads it to the Play Console.
- **iOS Setup**: Fastlane triggers Match to retrieve provisioning profiles, signs the iOS archive, and distributes it to TestFlight.
- **Secrets Management**: Keystore passwords, profile keys, and client credentials reside securely as encrypted GitHub Secrets.

---

## 3. Remote Database Migrations (Supabase CLI)

- **Local Development**: Developers use the **Supabase CLI** to run local instances of the DB and test modifications locally:
  ```bash
  # Start local Supabase emulation
  supabase start
  
  # Create a new database migration script
  supabase migration new add_event_categories
  ```
- **Deployment Pipeline**: Supabase database updates are pushed via GitHub Actions using the Supabase CLI:
  ```bash
  # Apply migrations to production database instance
  supabase db push --db-url "postgresql://postgres:$PROD_DB_PASSWORD@$PROD_DB_HOST:5432/postgres"
  ```
- **Rule**: Handwrite all migrations; direct manual manipulation of schema tables inside the online Supabase web UI is forbidden.
