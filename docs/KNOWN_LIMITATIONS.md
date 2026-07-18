# Known Limitations & Issues - Voyanta AI v1.0.0-beta

## Core Limitations
1. **Mapbox Overhead**: The application currently loads the entire Mapbox engine on the `LiveJourneyScreen` which can cause a 1-second UI stutter on older Android devices during cold boot.
2. **AI Latency**: Gemini 1.5 Flash is incredibly fast, but generating a full 3-day complex JSON itinerary structure can still take up to 5 seconds. The UI masks this with a shimmer loader, but the delay is noticeable.
3. **Multi-device Syncing**: While offline local sync works perfectly via Isar, conflict resolution between two separate devices editing the same itinerary simultaneously is governed by a simple "Last-Write-Wins" algorithm. True Operational Transformation (OT) or CRDTs are not yet implemented.

## Minor Bugs (Will not fix for Beta)
- Tapping extremely rapidly on the bottom navigation bar can occasionally desynchronize the GoRouter state animation.
- The Expense pie chart animation skips frames if the list contains more than 50 uniquely categorized items on initial render.
- Rotating the device to Landscape mode forces a suboptimal UI layout on the Trip Planner view. (App is locked to Portrait for Beta).
