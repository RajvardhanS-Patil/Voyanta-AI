# Security Review - Voyanta AI v1.0.0-beta

*Date: July 2026*

## Overview
This document outlines the security posture of the Voyanta AI application before entering closed beta. The architecture inherently isolates sensitive data into specific layers, but careful management of external dependencies and environment variables is strictly required.

## API Keys & Environment Variables
- **Risk**: Hardcoded keys in the repository.
- **Mitigation**: The `.env` pattern has been strictly enforced. `SupabaseClientManager`, `GeminiClientManager`, and `MapboxMap` widgets ONLY load secrets via `flutter_dotenv`.
- **Action Required**: The deployment CI/CD pipelines MUST inject `GEMINI_API_KEY`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `MAPBOX_PUBLIC_TOKEN` at build time.

## Storage & Local Caching
- **Risk**: Unauthorized access to cached itineraries or offline expenses.
- **Mitigation**: Isar Database is strictly local to the device's sandboxed storage. Remote Sync Queues (`SyncQueueProcessor`) do not carry raw SQL but structured JSON payloads.
- **Action Required**: Wait for stable encryption support in Isar v4 before declaring full HIPAA/PCI compliance, but it is acceptable for a beta travel app.

## Authentication
- **Risk**: Session hijacking.
- **Mitigation**: Handled natively by Supabase Auth with secure token refresh cycles.
- **Action Required**: None. The integration is secure.

## Dependency Vulnerabilities
- **Risk**: Supply chain attacks on Flutter packages.
- **Mitigation**: `flutter analyze` runs on PRs. No outdated dependencies flagged as critical.

## Conclusion
The application is secure for beta testing. No raw secrets are stored in the codebase.
