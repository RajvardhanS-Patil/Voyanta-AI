# Voyanta AI v1.0.0-beta Release Notes

**Release Date:** July 2026  
**Status:** Closed Beta

We are thrilled to announce the first official closed beta release of **Voyanta AI**. Over the past 14 development phases, Voyanta has evolved from a simple travel planner into a full-fledged offline-first travel concierge engine.

## 🌟 What's Included in this Beta

### 1. Offline-First Architecture
You can now take Voyanta AI on the subway, on a plane, or to remote areas.
- **Optimistic UI**: Adding expenses or modifying your itinerary happens instantly without a loading spinner.
- **Sync Queue**: Actions taken while offline are safely stored locally and automatically pushed to the cloud the moment your connection is restored.

### 2. AI Itinerary Generation
Powered by Google Gemini 1.5 Flash.
- Provide a destination, a budget, and a pacing preference, and Voyanta AI generates a complete day-by-day JSON-structured itinerary.
- Integration with Open-Meteo ensures the AI knows if it's going to rain, prioritizing indoor museums accordingly.

### 3. Context-Aware AI Companion
- The new Chat Companion is fully aware of your current active itinerary and budget.
- Ask questions like "Where can I eat near my next activity for under $20?" and receive contextual, highly specific answers.

### 4. The Live Journey Engine
- Your generated itinerary maps directly to Mapbox vector tiles.
- Track your real-time GPS location via an animated pulse dot.
- Geofencing automatically marks itinerary activities as "Complete" when you arrive at the location.

### 5. Expense Ledger
- A beautiful, fluid interface to log daily spending.
- Real-time budget progress rings update instantly with every added transaction.

## ⚠️ Known Limitations
As this is a beta release, there are a few rough edges:
- **Mapbox Cold Start**: Opening the Live Journey map may cause a 1-second stutter on older Android devices while the map engine initializes.
- **AI Latency**: Complex 3+ day itineraries may take up to 5 seconds to generate. A shimmer loading screen mitigates this UX hit.
- **Conflict Resolution**: Modifying the same offline trip on two different devices simultaneously currently defaults to "Last-Write-Wins."

## 🚀 Upcoming Roadmap (v1.1.0 and beyond)
- **Multiplayer Trips**: True collaborative itinerary editing using CRDTs.
- **Photo Receipts**: Scan receipts via the camera to auto-categorize expenses.
- **Flight & Hotel Integrations**: Automatic parsing of confirmation emails.

Thank you to all our early testers and open-source contributors! We can't wait to see where Voyanta AI takes you.
