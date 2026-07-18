# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0-beta] - 2026-07-18

### Added
- **AI Core**: Google Gemini 1.5 Flash integration for structured JSON itinerary generation.
- **Offline Sync Engine**: Isar NoSQL local database with a FIFO background sync queue.
- **Maps**: Real-time Mapbox vector integration and geospatial clustering.
- **Companion**: Context-aware AI Chat assistant.
- **Expenses**: Local budget ledger with real-time categorisation rings.
- **Journey**: Live GPS tracking and geofence-based activity completion checks.
- **Demo Mode**: Built-in mock data seeder (`main_demo.dart`) for presentations.
- **CI/CD**: GitHub Actions workflows for static analysis and Android APK generation.

### Changed
- Refactored entire codebase into a strict Feature-First Clean Architecture.
- Replaced direct Supabase API calls with the `SyncQueueProcessor` for offline resilience.

### Fixed
- Fixed Mapbox initialization stutter on cold boot by wrapping in an animated placeholder.
- Mitigated Gemini API latency by introducing the `ShimmerLoader` UX component.
