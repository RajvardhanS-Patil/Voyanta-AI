<div align="center">
  <h1>Voyanta AI</h1>
  <p><b>AI-Powered Offline-First Travel Planner & Expense Tracker</b></p>
  <br/>
  
  [![Release](https://img.shields.io/badge/Release-v1.0.0--beta-blue.svg)](https://github.com/RajvardhanS-Patil/Voyanta-AI)
  [![Build Status](https://github.com/RajvardhanS-Patil/Voyanta-AI/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/RajvardhanS-Patil/Voyanta-AI/actions)
  [![Flutter](https://img.shields.io/badge/Flutter-3.19.0-02569B?logo=flutter)](https://flutter.dev/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
</div>

<br/>

**Voyanta AI** is a production-grade travel planning and expense management mobile application designed to work completely offline. It features real-time Mapbox vector layouts, live climate analytics from Open-Meteo, and automated itinerary design via Google Gemini Flash models.

## 🌟 Key Features

- **AI Itinerary Orchestration**: Generates day-by-day travel plans customized to user interests, pacing preference, and budget levels.
- **Offline-First Architecture**: Read, create, and update trips and expenses without network connections. A FIFO sync queue automatically pushes updates when connection is restored.
- **Live Journey Engine**: Real-time GPS tracking and geofenced arrival detection.
- **Interactive Mapping**: Seamless Mapbox integration displaying custom styled marker clusters, spatial coordinates, and offline vector maps.
- **Budget Tracking**: Register expenses, calculate average costs, categorise transactions, and analyze budgets with clear visual progress indications.
- **Smart Intelligence Engines**: Injects real-time local weather forecasts and traffic data into an active recommendation stream to build weather-optimized itinerary suggestions.

## 🛠 Technology Stack

Voyanta AI is built on a cost-effective, highly scalable tech stack:

- **Client**: **Flutter (Dart)** for cross-platform native iOS & Android applications.
- **Backend**: **Supabase (PostgreSQL)** for secure relational storage, real-time sync, and Row Level Security.
- **AI Engine**: **Google Gemini 1.5 Flash API** for structured JSON itinerary generation.
- **Mapping Service**: **Mapbox SDK** with **OpenStreetMap** data layers.
- **Local Cache**: **Isar Database** for embedded, responsive NoSQL storage in Dart.
- **State Management**: **Riverpod** with immutable async notifier patterns.

## 📐 Architecture Overview

Voyanta AI implements a strict **Clean Architecture** pattern combined with **Feature-First Modular** directory layouts.

```text
lib/
├── core/                         # Shared infrastructure (router, theme, UX, sync queue)
└── features/                     # Self-contained modules by functional area
    ├── auth/                     # Authentication & onboarding
    ├── companion/                # Context-aware AI Chat Companion
    ├── expenses/                 # Expense ledger and budgets
    ├── intelligence/             # Travel Recommendation & Weather Engines
    ├── journey/                  # Live GPS tracking and active trip orchestration
    ├── maps/                     # Mapbox integrations & offline tiles manager
    └── trip_planner/             # AI trip planner, itineraries, packing lists
```

For a deep dive into the architecture, view our [Architecture Diagrams Guide](docs/ArchitectureDiagrams.md).

## 🚀 Quick Start & Installation

### 1. Clone the Repository
```bash
git clone https://github.com/RajvardhanS-Patil/Voyanta-AI.git
cd Voyanta-AI
```

### 2. Configure Environment Variables
You must provide API keys to compile the application. Create `.env.dev` and `.env.prod` files in the root directory:

```bash
MAPBOX_PUBLIC_TOKEN=your_mapbox_public_token
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=your_local_anon_key
GEMINI_API_KEY=your_gemini_api_studio_key
```

### 3. Run the App
```bash
# Get Dart packages
flutter pub get

# Generate local database models (Isar mappings)
flutter pub run build_runner build --delete-conflicting-outputs

# Boot up the Development Flavor
flutter run -t lib/main_dev.dart
```

### 4. Demo Mode (For Presentations)
If you are presenting the app and want to immediately seed the local Isar database with a mock Paris Trip, expenses, and AI Chat history:
```bash
flutter run -t lib/main_demo.dart
```

## 🧪 Testing

We enforce strict test coverage thresholds covering UI Widgets, Golden Image diffs, and Integration End-to-End paths.

```bash
# Static Analysis
flutter analyze

# Unit & Golden Tests
flutter test --update-goldens test/golden_test.dart
flutter test

# End-to-End Integration Tests
flutter test integration_test/app_test.dart
```

## 📚 Documentation
- [Developer Guide](docs/DeveloperGuide.md)
- [Architecture & Modules](docs/Architecture.md)
- [Project Roadmap](docs/Roadmap.md)
- [Case Study & Engineering Post-Mortem](docs/CASE_STUDY.md)
- [Screenshots Guide](docs/SCREENSHOTS_GUIDE.md)

## 🤝 Contributing
Please read [Contributing.md](docs/Contributing.md) for details on our code of conduct, and the process for submitting pull requests to us.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
