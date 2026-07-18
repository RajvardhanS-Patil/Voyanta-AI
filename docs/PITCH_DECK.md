# Voyanta AI - Presentation Deck Outlines

Use these slide-by-slide outlines to quickly build Keynote, PowerPoint, or Figma presentations for various audiences.

---

## Deck 1: The Investor / Startup Pitch (10 Slides)
**Goal**: Sell the vision, the market size, and the traction.

- **Slide 1: Title & Hero**: "Voyanta AI: The Offline-First Travel Concierge." (Include a high-quality mockup from `docs/assets/screenshots`).
- **Slide 2: The Problem**: Travelers use 5-7 different apps (Maps, Notes, Excel, WhatsApp, AI Chat) to manage a single trip. It's fragmented and fails when traveling internationally without data.
- **Slide 3: The Solution**: A unified dashboard that orchestrates AI itineraries, real-time budgets, and live GPS mapping.
- **Slide 4: Why Offline First?**: International data roaming is expensive and unreliable. Voyanta works 100% offline, syncing silently in the background when you reach the hotel WiFi.
- **Slide 5: Product Demo (Video)**: A 30-second embedded GIF showing the seamless transition between the Planner and the Maps.
- **Slide 6: Market Size**: The global travel tech market size. The growing trend of AI-assisted planning.
- **Slide 7: Technical Moat**: Our proprietary architecture combining Isar NoSQL for fast local reads with a FIFO sync queue to Supabase, reducing cloud compute costs by 80%.
- **Slide 8: The Business Model**: Freemium model. Free AI generations. Premium features include Live Geofenced Journeys and unlimited receipt scanning.
- **Slide 9: Roadmap**: Phase 14 completed. Next: Collaborative multi-player itineraries using CRDTs.
- **Slide 10: Call to Action**: "Join the beta at voyanta.ai."

---

## Deck 2: The Technical Deep Dive (12 Slides)
**Goal**: Showcase engineering rigor and architectural patterns.

- **Slide 1: Title**: "Architecting Voyanta AI: Flutter, Riverpod, & Offline-First Design."
- **Slide 2: The Monolith Problem**: Why we avoided a tangled state and chose Clean Architecture.
- **Slide 3: Diagram**: High-level Architecture (Show `docs/ArchitectureDiagrams.md`).
- **Slide 4: The Presentation Layer**: Flutter + Riverpod. Why AsyncNotifiers prevented memory leaks.
- **Slide 5: The Domain Layer**: Strict Entities and UseCases.
- **Slide 6: The Data Layer**: Abstracting APIs so the UI doesn't know if data comes from Isar or Supabase.
- **Slide 7: The Offline Sync Challenge**: Explaining the "Optimistic UI" pattern.
- **Slide 8: The Sync Queue Processor**: How we serialize payloads and handle connection state streams.
- **Slide 9: Mapbox Vector Integration**: Handling large tile downloads.
- **Slide 10: Gemini AI Orchestration**: Forcing LLMs to output strict JSON schemas for predictable UI rendering.
- **Slide 11: Testing Strategy**: Golden toolkits and E2E Navigation tests.
- **Slide 12: Q&A**: Link to the GitHub repository.

---

## Deck 3: The Hackathon Finalist Demo (5 Slides)
**Goal**: Wow the judges with speed, UX, and AI integration.

- **Slide 1: Title & Tagline**: "Voyanta AI."
- **Slide 2: The Pain Point**: "We've all been lost in a foreign city with no cell service and a strict budget."
- **Slide 3: The Magic (Live Demo)**: (Switch to screen mirroring. Run `main_demo.dart`. Add an offline expense, then ask the AI companion for a restaurant recommendation).
- **Slide 4: How we built it**: Flutter, Supabase, Google Gemini Flash, Mapbox.
- **Slide 5: Team & Outro**: "We are Voyanta."
