# Voyanta AI — AI-Powered Offline-First Travel Planner & Expense Tracker

![Beta Release](https://img.shields.io/badge/Release-v1.0.0--beta-blue.svg)
![Build Status](https://github.com/RajvardhanS-Patil/Voyanta-AI/actions/workflows/flutter_ci.yml/badge.svg)

Voyanta AI is a production-grade, AI-driven travel planning and expense management mobile application designed to work completely offline, featuring real-time Mapbox vector layouts, live climate analytics from Open-Meteo, and automated itinerary design via Google Gemini Flash models.

---

## 🌟 Key Features

- **AI Itinerary Orchestration**: Generates day-by-day travel plans customized to user interests, pacing preference, and budget levels.
- **Offline-First Capabilities**: Read, create, and update trips and expenses without network connections. Data synchronizes automatically when connection is restored.
- **Interactive Mapping**: Seamless Mapbox integration displaying custom styled marker clusters, spatial coordinates, and offline vector maps.
- **Budget Tracking**: Register expenses, calculate average costs, categorise transactions, and analyze budgets with clear visual progress indications.
- **Weather Analysis**: Injects real-time local weather forecasts into the AI prompt orchestrator to build weather-optimized itinerary suggestions.
- **Observability & Analytics**: Structured logging and event tracking to monitor app health and user journeys.

---

## 🛠 Technology Stack

Voyanta AI is built on a cost-effective, scalable tech stack utilizing generous free tiers:

- **Client Client**: **Flutter (Dart)** for cross-platform native iOS & Android applications.
- **Backend & Database**: **Supabase (PostgreSQL)** for secure relational storage, real-time sync, and Row Level Security.
- **AI Engine**: **Google Gemini Flash API** (via Google AI Studio) for structured JSON itinerary generation.
- **Mapping Service**: **Mapbox SDK** with **OpenStreetMap** data layers.
- **Local Storage Cache**: **Isar Database** for embedded, responsive NoSQL storage in Dart.
- **Weather Forecasting**: **Open-Meteo API** for non-commercial geographical forecast queries.

---

## 📐 Architecture Overview

The codebase is structured using **Clean Architecture** patterns separated into distinct Presentation, Domain, and Data layers, wrapped in a **Feature-First Modular** directory tree layout.

```
lib/
├── core/                         # Shared infrastructural configurations (router, theme, UX components, sync queue)
└── features/                     # Self-contained modules by functional area
    ├── auth/                     # Authentication & user onboarding
    ├── companion/                # Context-aware AI Chat Companion
    ├── expenses/                 # Expense ledger and budgets
    ├── intelligence/             # Travel Recommendation & Weather Engines
    ├── journey/                  # Live GPS tracking and active trip orchestration
    ├── maps/                     # Mapbox integrations & offline tiles manager
    └── trip_planner/             # AI trip planner, itineraries, packing lists
```

---

## 🚀 Quick Start & Installation

### Prerequisites
- Flutter SDK (Stable Channel)
- Docker (for local Supabase emulation)
- Supabase CLI

### Setup Guide

1. **Clone the Repository**
   ```bash
   git clone https://github.com/RajvardhanS-Patil/Voyanta-AI.git
   cd Voyanta-AI
   ```

2. **Environment Variables**
   Create a `.env` file at the root:
   ```env
   MAPBOX_PUBLIC_TOKEN=your_mapbox_public_token
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   GEMINI_API_KEY=your_gemini_api_key
   ```

3. **Install Client Dependencies**
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run Locally**
   ```bash
   flutter run
   ```

---

## 🗺 Development Roadmap (Completed)

Voyanta AI has completed its 12-Phase roadmap and is currently in **Closed Beta**.

- **Phase 1-3:** Foundation, Supabase Auth, and Gemini AI Prompts Pipeline.
- **Phase 4-6:** Trip Dashboard, Mapbox Clustering, and Expense Tracking.
- **Phase 7-9:** Offline Isar Sync, Live Journey Tracking, and Proactive AI Companion.
- **Phase 10-11:** Smart Travel Intelligence and Cross-Module Integration.
- **Phase 12:** Enterprise Productization, UX Unification (Stitch Design Language), and Release Candidate Polish.

### Future Scope
- Collaborative trip planning.
- iOS App Store & Google Play Store public release.
- Integration with third-party booking APIs.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
