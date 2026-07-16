# Project Roadmap — Voyanta AI

This document establishes the official development phases, deliverables, dependencies, and acceptance criteria for Voyanta AI.

---

## Development Phases

### Phase 1: Project Foundation (Completed)
- **Objective**: Set up code style conventions, architect guidelines, folder layout structures, git repositories, and dependencies.
- **Deliverables**: Complete documentation suite under `/docs`, root repository `README.md`, `.gitignore`, and initialized git hooks.
- **Dependencies**: None.
- **Acceptance Criteria**: All files compiled cleanly, git commits pushed to remote GitHub origin.

### Phase 2: Authentication & Onboarding (Completed)
- **Objective**: Establish secure user registration, token management, secure vaults, and password hashing loops.
- **Deliverables**: Supabase Auth client bindings, login/sign-up forms UI widgets, biometric unlock configurations.
- **Dependencies**: Phase 1 foundation modules.
- **Acceptance Criteria**: Users can register and sign in. Tokens save to secure storage. Session resumes on cold start.

### Phase 3: AI Core & Prompts Pipeline (Completed)
- **Objective**: Establish Gemini API connection and structure itinerary JSON output models.
- **Deliverables**: Gemini client service wrappers, prompt builder orchestrators, JSON schema parsing validation filters.
- **Dependencies**: Phase 2 authenticated sessions.
- **Acceptance Criteria**: App successfully calls Gemini and parses the response into valid, typed Dart objects.

### Phase 4: Trip Dashboard & Planner (Current)
- **Objective**: Develop trip rendering widgets and day-by-day itineraries.
- **Deliverables**: Trip creation wizard pages, day details dashboards, packing list generation displays.
- **Dependencies**: Phase 3 AI prompt generators.
- **Acceptance Criteria**: Users can create a trip, trigger AI itinerary generation, view days schedule, and toggle packing lists.

### Phase 5: Maps & Geo-Spatial Queries
- **Objective**: Integrate vector maps styles and display interactive itinerary pins.
- **Deliverables**: Mapbox style integrations, marker clustering logic, coordinate collection mappings.
- **Dependencies**: Phase 4 trip dashboards.
- **Acceptance Criteria**: Maps render with custom markers. Clustered badges display when pins are grouped within proximity.

### Phase 6: Expense Ledger & Budgets
- **Objective**: Develop logging panels to track travel spending.
- **Deliverables**: Expense form overlays, categories budget lists, analytics progress bars.
- **Dependencies**: Phase 2 secure databases.
- **Acceptance Criteria**: Users can log transactions. App calculations update total trip cost averages and budget alert states.

### Phase 7: Offline Capabilities & Cache Sync
- **Objective**: Establish synchronization database pipelines.
- **Deliverables**: Local Isar database storage tables, Sync Queue tables, network status listeners.
- **Dependencies**: Phase 6 expense registers.
- **Acceptance Criteria**: Data updates save to Isar when offline. Once online, Sync Manager pushes queue items automatically.

### Phase 8: Visual Polish & Performance Tuning
- **Objective**: Smooth micro-animations and performance audits.
- **Deliverables**: Glassmorphic panels, lazy list rendering setups, build bundle compression configurations.
- **Dependencies**: All preceding phases.
- **Acceptance Criteria**: App maintains stable 120 FPS during navigation transitions. Startup time is under 2 seconds.
