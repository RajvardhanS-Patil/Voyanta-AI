# Voyanta AI — AI-Powered Offline-First Travel Planner & Expense Tracker

Voyanta AI is a production-grade, AI-driven travel planning and expense management mobile application designed to work completely offline, featuring real-time Mapbox vector layouts, live climate analytics from Open-Meteo, and automated itinerary design via Google Gemini Flash models.

---

## 🌟 Key Features

- **AI Itinerary Orchestration**: Generates day-by-day travel plans customized to user interests, pacing preference, and budget levels.
- **Offline-First Capabilities**: Read, create, and update trips and expenses without network connections. Data synchronizes automatically when connection is restored.
- **Interactive Mapping**: Seamless Mapbox integration displaying custom styled marker clusters, spatial coordinates, and offline vector maps.
- **Budget Tracking**: Register expenses, calculate average costs, categorise transactions, and analyze budgets with clear visual progress indications.
- **Weather Analysis**: Injects real-time local weather forecasts into the AI prompt orchestrator to build weather-optimized itinerary suggestions.

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
├── core/                         # Shared infrastructural configurations (router, theme, etc.)
└── features/                     # Self-contained modules by functional area
    ├── auth/                     # Authentication & user onboarding
    ├── trip_planner/             # AI trip planner, itineraries, packing lists
    ├── expenses/                 # Expense ledger and budgets
    └── maps/                     # Mapbox integrations & offline tiles manager
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

2. **Boot up Local Databases**
   ```bash
   supabase init
   supabase start
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

## 🗺 Development Roadmap

- **Phase 1: Project Foundation (Done)**: Architectural guidelines and codebase specifications.
- **Phase 2: Authentication & Onboarding**: Supabase Auth client logic and secure storage hooks.
- **Phase 3: AI Prompts Pipeline**: Gemini Client integration and output schema verification.
- **Phase 4: Trip Dashboard**: Schedules, days views, and trip lists.
- **Phase 5: Mapbox Clustering**: Geo-spatial rendering and routes drawing.
- **Phase 6: Expense Tracking**: Calculators, transaction history, and budget charts.
- **Phase 7: Offline & Cache Sync**: Local Isar database storage and synchronization manager queue processing.
- **Phase 8: Visual Polish & Performance**: Micro-interactions, custom animations, and asset packaging.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
