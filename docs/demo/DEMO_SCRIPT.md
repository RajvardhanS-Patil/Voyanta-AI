# Voyanta AI - Demo Scripts

Use these scripts during live presentations, hackathons, or investor pitches. Always run the app in Demo Mode (`flutter run -t lib/main_demo.dart`) before starting.

---

## 1. The 90-Second Elevator Pitch
**Target Audience**: Quick startup pitches, general public.

> "Have you ever tried to plan a vacation with 5 different tabs open? Google Maps, a spreadsheet for your budget, TripAdvisor, and a messy WhatsApp group? It’s exhausting. 
> 
> Meet Voyanta AI. 
>
> *(Hold up the app showing the Trip Dashboard)*
>
> Voyanta AI is an offline-first travel planner that completely orchestrates your trip. It uses Google Gemini to generate day-by-day itineraries tailored to your budget and pacing. But we didn't just build a planner. We built a real-time journey engine. 
>
> *(Tap into the Live Journey Map)*
>
> As you walk through Paris, Voyanta tracks your location via Mapbox and geofences your activities. When you arrive at the Louvre, it knows, marks it complete, and suggests where to eat next based on local weather and your remaining budget. 
> 
> Best of all? It works 100% offline. If you lose cellular data in the subway, Voyanta doesn't crash. It queues your expenses locally and syncs them automatically when you reconnect. Voyanta isn't just an app; it's your personal travel concierge."

---

## 2. The 5-Minute Feature Showcase
**Target Audience**: Judges, recruiters, product managers.

### 0:00 - The Problem
- *Action*: Open the app.
- *Script*: Talk about the fragmented travel tool ecosystem.

### 1:00 - The AI Planner
- *Action*: Show the Paris Itinerary.
- *Script*: Explain how Gemini Flash parses unstructured prompts into a strict JSON layout, generating the visual timeline you see on screen.

### 2:00 - The AI Companion
- *Action*: Tap the Companion tab. Show the pre-seeded conversation.
- *Script*: Highlight that this isn't a generic ChatGPT wrapper. The companion has *context*. It knows your budget is $500, it knows it's raining outside, and it knows you are near the Eiffel Tower. 

### 3:30 - Offline Persistence
- *Action*: Put the phone in Airplane mode. Go to the Expenses tab. Add a $15 expense.
- *Script*: "Watch the top of the screen. That orange banner means we're offline. But notice how the UI updated instantly? Our Isar local database handles optimistic UI updates. When I turn WiFi back on... *[Turn on WiFi]*... the background sync queue automatically resolves the payload to Supabase."

### 4:30 - Conclusion
- *Action*: Return to the dashboard.
- *Script*: Summarize the tech stack: Flutter, Riverpod, Supabase, Isar, Gemini, and Mapbox.

---

## 3. The 15-Minute Technical Walkthrough
**Target Audience**: Engineering managers, technical co-founders.

*(Follow the 5-Minute script, but inject the following deep-dives)*

- **Deep Dive 1: Clean Architecture**: Open Android Studio and show the `lib/features` and `lib/core` split. Explain how UI never talks to data directly, but uses Riverpod UseCases.
- **Deep Dive 2: Sync Queue Resolution**: Show `sync_queue_processor.dart`. Explain how you avoid raw SQL injection by serializing payloads to JSON and relying on a First-In-First-Out (FIFO) queue.
- **Deep Dive 3: Observability**: Show `observability_service.dart`. Explain how you abstracted the analytics layer so you can swap out standard `logger` for `FirebaseAnalytics` without touching the UI controllers.
