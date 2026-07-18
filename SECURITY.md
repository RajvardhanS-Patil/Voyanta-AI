# Security Policy

## Supported Versions
Security updates are only applied to the latest stable release.

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability within Voyanta AI, please do **NOT** open a public issue. 
Instead, please send an e-mail to the maintainers at `security@voyanta.ai`. All security vulnerabilities will be promptly addressed.

### Secret Management
Voyanta AI requires several API keys (Supabase, Gemini, Mapbox). 
**Never** commit your `.env`, `.env.dev`, or `.env.prod` files to the repository. The `.gitignore` is already configured to ignore these files. If you discover a leaked secret in the commit history, please report it immediately.

### Dependency Policy
We run `flutter pub outdated` and audit our dependencies weekly. Pull requests that introduce new dependencies will face strict scrutiny. We prefer to rely on established, heavily maintained packages (e.g., `flutter_riverpod`, `isar`, `supabase_flutter`) to minimize supply chain attack vectors.
