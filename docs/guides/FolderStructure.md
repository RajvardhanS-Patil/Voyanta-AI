# Folder Structure Guide — Voyanta AI

This document establishes the project's folder layout. It utilizes a **Feature-First Modular** directory architecture inside a Clean Architecture approach.

---

## 1. Directory Tree Map

```
lib/
├── core/                         # Shared infrastructural configurations
│   ├── theme/                    # Color tokens, typography, visual constraints
│   ├── router/                   # App navigation definition and deep links
│   ├── network/                  # Network state monitors, API clients (Supabase)
│   ├── database/                 # Local Isar configuration & initializers
│   ├── error/                    # Custom failure objects & error catchers
│   └── utils/                    # Global utility functions and helpers
├── features/                     # Self-contained modules by functional area
│   ├── auth/                     # Authentication & onboarding flow
│   ├── trip_planner/             # AI trip planner, itinerary generation, packing lists
│   ├── expenses/                 # Expense tracking, offline sync queue, split shares
│   ├── maps/                     # Mapbox cluster layers, offline region manager
│   └── settings/                 # App configurations (units, theme preference)
└── main.dart                     # Application entry point & service bootstrap
```

---

## 2. Inner Feature Modules

Inside every subdirectory in `/features/<feature_name>/`, the folder layout conforms strictly to Clean Architecture layers:

```
features/<feature_name>/
├── domain/                       # Core Business Layer
│   ├── entities/                 # Data contracts (e.g., trip.dart, expense.dart)
│   ├── usecases/                 # Single task execution logic (e.g., create_trip.dart)
│   └── repositories/             # Abstract interfaces defining data functions
├── data/                         # Data Provider Layer
│   ├── models/                   # Serialized JSON representations of entities
│   ├── datasources/              # Database querying (local) and API fetches (remote)
│   └── repositories/             # Conrete implementations of domain repo contracts
└── presentation/                 # User Interface Layer
    ├── controllers/              # State controllers (Riverpod providers/Bloc managers)
    ├── screens/                  # Full-page screens (e.g., trip_dashboard_screen.dart)
    └── widgets/                  # Reusable local layout items (e.g., expense_row.dart)
```

---

## 3. Organizational Rationale

1. **High Cohesion & Low Coupling**: Code for a specific feature is grouped together. If a developer needs to modify trip planning features, they work exclusively within `/features/trip_planner/`.
2. **Easy Deletability**: Features can be added or deleted clean from the application simply by removing their directory, with minimal adjustments required in the rest of the project (typically just route configurations).
3. **No Monolithic Overlaps**: Shared helpers live strictly under `/core/`. Features are forbidden from depending directly on other feature UI widgets; if layout elements must be shared, they are promoted to `/core/widgets/`.
