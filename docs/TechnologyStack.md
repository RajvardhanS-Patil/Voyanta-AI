# Technology Stack Guide — Voyanta AI

This document outlines the selected technology stack for Voyanta AI. The selections prioritize generous **free tiers** suitable for students, prototypes, and startups while maintaining clean architecture and production scalability.

---

## 1. Summary of Stack

| Component | Choice | Free Tier Details | Reason for Choice |
|---|---|---|---|
| **Frontend (Mobile)** | **Flutter (Dart)** | 100% Free / Open Source | Cross-platform compatibility (iOS, Android), native performance, rapid widget rendering, strong typed safety. |
| **Backend / Database** | **Supabase (PostgreSQL)** | 2 Free Projects, 500MB DB, 1GB Storage | Real-time listeners, PostgreSQL relational schema (needed for trips/itineraries), built-in API routing (PostgREST), Row Level Security (RLS). |
| **Authentication** | **Supabase Auth** | Up to 50,000 MAUs | Standard email/password, magic links, social oauth providers (Google, Apple, GitHub) pre-built and configured. |
| **AI Processing** | **Google Gemini Flash API** | Generous Free limits (15 RPM, 1M TPM) | Fast latency, high context windows (up to 1M tokens), native JSON structured output schema support, perfect for itinerary rendering. |
| **Map Rendering** | **Mapbox SDK & OSM** | 50,000 MAUs (Mobile) / 100k Web Map Views | Stunning vector rendering, offline map capability, interactive custom styling markers. |
| **Weather Forecasts** | **Open-Meteo API** | Free for non-commercial (no API key required) | Hourly forecasts, historical weather indicators, global locations coordinate lookup. |
| **Push Notifications**| **Firebase Cloud Messaging**| Unlimited / Free | Cross-platform push notifications, background sync triggers. |
| **Product Analytics** | **PostHog** | 1 Million free events per month | Integrated product analytics, user conversion funnels, session replay, built-in feature flags. |
| **Offline Storage** | **Isar Database** | 100% Free / Open Source | Embedded NoSQL database for Dart/Flutter, reactive query bindings, incredibly fast read/write speeds, spatial indexes. |

---

## 2. Infrastructure Justification

### Why Supabase over Firebase?
1. **Relational Model**: Travel planners require robust relational mappings (Users -> Trips -> Itineraries -> Days -> Events). Firebase (NoSQL Firestore) results in highly denormalized databases, expensive read operations, and complex multi-path queries. Supabase's PostgreSQL allows clean JOIN queries and cascading deletes.
2. **PostGIS**: PostgreSQL has native support for geographical features via the PostGIS extension. This makes searching for nearby restaurants, trip pins, and coordinates extremely efficient.
3. **Row Level Security (RLS)**: Secures data directly at the database layer based on authentication policies, reducing the volume of custom security code needed in intermediate server nodes.

### Why Gemini 1.5/2.0 Flash over OpenAI GPT-4o?
1. **Zero Cost Startup**: Google AI Studio provides high-volume, free API access to Gemini 1.5/2.0 Flash models. OpenAI does not offer a free tier API for developers.
2. **Long Context Support**: Gemini's massive context window enables passing entire multi-day itineraries, weather historical patterns, and user preferences at once without truncation or chunking issues.
3. **Fast Latency**: Gemini Flash models are optimized for real-time applications with sub-second response times.

### Why Isar over SQLite?
1. **No Boilerplate**: Isar is a modern Dart database that uses source generation. No need to write complex raw SQL schema migration strings or manually map map-to-object tables.
2. **Embedded Indexes**: Supports composite, multi-entry, and spatial coordinates indexing out of the box, matching the performance profiles of premium desktop caches.
