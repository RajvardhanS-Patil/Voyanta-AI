# AI Architecture — Voyanta AI

This document establishes the artificial intelligence pipelines, context bounds, prompt parsing mechanics, and caching patterns for Voyanta AI.

---

## 1. High-Level AI Pipeline

Voyanta AI utilizes **Gemini 1.5/2.0 Flash** via the Google AI Studio SDK. The AI core generates structured itineraries, custom packing suggestions, and budget analytics.

```
[User Input Preferences] 
      │ (Destinations, dates, interests, budget limits)
      v
[Prompt Orchestrator] 
      │ (Injects current weather indexes, coordinate guides & system prompt)
      v
[Google Gemini API] 
      │ (Executes response with JSON Schema constraints)
      v
[Structured Output Parser]
      │
      ├── (Valid Schema) ──> [Save to Local DB & Render UI]
      └── (Invalid/Broken JSON) ──> [Automatic Retry with Error Feedback]
```

---

## 2. Structured Itinerary Generation

To prevent broken or unstructured text layouts, all Gemini generation calls require **JSON Mode** matching a strict schema. The request specifies constraints, coordinates, and timings:

### Context Injection Elements
- **Location Constraints**: The prompt orchestrator translates text destinations into bounding boxes using coordinates from a local list or geo-lookups. It forces Gemini to provide locations with `latitude` and `longitude`.
- **Weather Indexes**: Integrates real-time weather indicators from the Open-Meteo API for target travel months to tailor outdoor vs indoor activities.
- **Budget Metrics**: Provides daily spending ceilings per activity category to ensure events align with user budget profiles.

---

## 3. Conversational Memory Model

To support context-aware chat edits (e.g., "replace day 3 lunch with a vegan option"), the system designs a **Sliding Window Chat Memory**:

- **System Context Block**: Stays fixed at the head of the system prompt. Contains core guidelines.
- **Trip State Snapshot**: Appended as static JSON. Represents the current state of the itinerary database.
- **Interactive History**: Tracks the last `N` messages of the conversation. Older messages are summarized into a concise context block to optimize token counts and remain under rate-limit budgets.

---

## 4. Specific AI Engine Blocks

1. **Recommendation Engine**: Scores destinations by crossing user-indicated tags (e.g., "adventure", "relaxing") with historical reviews and seasonal trip templates.
2. **Budget Optimizer**: Scans suggested itinerary events, maps them to approximate pricing averages (lodging, transit, tickets), and flags days that exceed average budgets, suggesting cheaper local alternatives.
3. **Packing List Generator**: Crosses weather metrics (temperatures, rainfall chances) with trip activity types to output categorized equipment suggestions (e.g., rain gear for rainy seasons, trekking gear for hiking).
4. **Weather Intelligence**: Parses climate parameters to suggest morning vs afternoon swaps (e.g., scheduling indoor museums during high afternoon heat indexes).
5. **Context Manager**: Truncates prompt lengths dynamically to fit within Gemini's free-tier rate limits, prioritizing active editing contexts.
