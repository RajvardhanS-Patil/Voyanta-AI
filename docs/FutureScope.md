# Future Scope & Expansion — Voyanta AI

This document outlines the conceptual roadmap and future feature specifications for Voyanta AI.

---

## 1. Collaborative Travel Planning

While the current architecture focuses on individual trips:
- **Shared Itineraries**: Enable multiple users to invite friends to a trip. Any member can log expenses, update days, or recommend activities.
- **Conflict Management Scaling**: Migrate local LWW strategies to a real-time **CRDT (Conflict-free Replicated Data Type)** synchronizer matching text layout states to support concurrent typing.
- **WebSocket Scaling**: Transition Supabase subscriptions to a highly clustered regional WebSocket broker system to support concurrent active connections.

---

## 2. AI Price Predictions (Flights & Accommodations)

- **Machine Learning Integrations**: Pull flight pricing aggregates from external APIs (Amadeus, Skyscanner) and feed them to time-series forecasting models (Prophet / LSTM networks).
- **Alert Triggers**: Set background cron scripts to verify price shifts daily and dispatch push alerts: "Flight prices to London are predicted to drop by 15% next week. Book now."

---

## 3. Professional Agency Portal

- **Travel Agent Dashboard**: A specialized web panel built on Next.js/Vite, allowing agents to curate itineraries for clients.
- **Client App Sync**: Created plans are pushed directly as trip items into the client's mobile app, enabling real-time feedback loops.
- **Commission Split Integration**: Track travel booking tickets and process affiliate splits dynamically.
