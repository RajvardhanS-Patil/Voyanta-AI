# Case Study: Architecting Voyanta AI

**Author**: Lead Engineer, Voyanta AI
**Date**: July 2026

## The Problem

Modern travelers face a highly fragmented ecosystem. Planning a multi-city vacation requires stitching together Google Maps for routing, an Excel spreadsheet for budget tracking, TripAdvisor for recommendations, and ChatGPT for itinerary generation. 

Furthermore, traveling internationally introduces a massive technical constraint: **Unreliable Cellular Data**. Cloud-dependent applications become useless exactly when the user needs them most—navigating a foreign subway or tracking a cash expense at a remote market.

## The Solution

We built **Voyanta AI**: A unified, offline-first travel planner and real-time journey tracker. 

Voyanta AI orchestrates Google Gemini for initial itinerary generation but relies on a robust local caching architecture to ensure the app remains 100% functional when disconnected from the internet.

## Engineering Challenges & Architectural Decisions

### Challenge 1: The Offline-First Conundrum
We needed users to be able to add expenses and modify itineraries while on airplane mode, without losing data when the app closed.

**Decision**: We adopted the **Optimistic UI pattern backed by Isar NoSQL and a FIFO Sync Queue**.
Instead of writing directly to Supabase, all UI actions (`addExpense`, `updateJourney`) write immediately to a local Isar database. This guarantees a 0ms perceived latency for the user. 
Simultaneously, the action is serialized into a JSON payload and appended to an Isar `SyncQueueDb`. A background `SyncQueueProcessor` listens to device connectivity streams. The moment WiFi is restored, the queue flushes the payloads to Supabase sequentially.

**Trade-off**: This approach introduces a "Last-Write-Wins" conflict scenario if a user modifies the same itinerary on two different devices while offline. For a beta consumer travel app, this trade-off is acceptable over the immense complexity of implementing Operational Transformation (OT) or CRDTs.

### Challenge 2: AI Hallucinations in the UI
Large Language Models output unstructured text. We needed Gemini to generate a complex, multi-day itinerary that could be rendered as interactive Flutter widgets, complete with geospatial coordinates for Mapbox.

**Decision**: We implemented strict **JSON Schema Enforcement via Prompt Engineering**.
The `PromptBuilderEngine` wraps the user's request with a massive system instruction forcing Gemini to output exactly `{"days": [{"activities": [{"name": "", "lat": 0.0, "lng": 0.0}]}]}`. 

**Trade-off**: Forcing strict JSON generation increases the Gemini Flash processing time to ~4-5 seconds. We mitigated this UX hit by designing a beautiful `ShimmerLoader` animation, shifting the user's perception of "waiting" to "anticipating."

### Challenge 3: State Management Spagetti
With real-time GPS tracking, offline syncing, and complex UI animations, the application state could easily become unmanageable.

**Decision**: We strictly adhered to **Feature-First Clean Architecture and Riverpod AsyncNotifiers**.
The UI layer is completely decoupled from the data layer. `JourneyController` does not know if its data comes from Isar or Supabase; it only talks to `JourneyRepository`. Riverpod manages the widget rebuilding efficiently, ensuring we maintain 60-120fps even when rendering complex Mapbox vector layers.

## Lessons Learned
1. **Abstraction Pays Off**: Building `ObservabilityService` early allowed us to swap out our basic logging for full production analytics in under an hour during the Release Engineering phase.
2. **Local DBs are the Future**: Isar proved that mobile devices have more than enough compute power to handle complex relational queries locally, drastically reducing our cloud dependency and Supabase bandwidth costs.

## Future Roadmap
While the offline-first architecture handles single-user scenarios perfectly, Phase 15 will introduce **Multi-player Collaborative Itineraries**. We plan to research Conflict-free Replicated Data Types (CRDTs) to allow families to edit a trip simultaneously without stepping on each other's data payloads.
